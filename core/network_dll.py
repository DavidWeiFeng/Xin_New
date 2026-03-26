import datetime
import hashlib
import random
import subprocess
from urllib import response
import urllib.parse
import uuid
import time
import os
import json
import sys
import threading
import requests
from config.config import Auth
from config.app_config import app_config
# ---------------------- 配置常量 ----------------------
class SecretConfig:
    _HOST = "101.43.13.55"
    _PORT = 6666
    
    _SECRET_ENC = [85, 87, 82, 87, 83]
    
    @staticmethod
    def d(data):
        return "".join([chr(c ^ 0x66) for c in data])

    @classmethod
    def get_base_url(cls):
        return f"http://{cls._HOST}:{cls._PORT}"
    
    @classmethod
    def gs(cls):
        return cls.d(cls._SECRET_ENC)

# ---------------------- 机器码获取模块 ----------------------
def get_machine_code():
    """兼容物理机/虚拟机"""
    try:
        # 优先级1：获取主板序列号
        cmd = 'wmic baseboard get serialnumber'
        output = subprocess.check_output(cmd, shell=True, stderr=subprocess.DEVNULL, timeout=5)
        serial = output.decode('gbk', errors='ignore').strip().split('\n')[-1]
        if serial and len(serial) > 3:
            return serial
        
        # 优先级2：获取磁盘序列号
        cmd = 'wmic diskdrive get serialnumber'
        output = subprocess.check_output(cmd, shell=True, stderr=subprocess.DEVNULL, timeout=5)
        serial = output.decode('gbk', errors='ignore').strip().split('\n')[-1]
        if serial and len(serial) > 3:
            return serial
        
        # 回退方案：生成混合硬件特征码
        return str(uuid.getnode()) + '-' + str(uuid.getnode())
    
    except Exception:
        return "DEFAULT_MAC_001"

def encrypt_machine_code(raw_code):
    """SHA-256加密并截取32位"""
    encrypt_machine_code=hashlib.sha256(raw_code.encode()).hexdigest()[:32]
    return encrypt_machine_code

def get_final_hwid_():
    raw_mac = get_machine_code()
    encrypted_code=encrypt_machine_code(raw_mac)
    # 取最后 8 位进行转换即可
    Auth.MAC = int(encrypted_code[-8:], 16)
    return int(encrypted_code[-8:], 16)

# ---------------------- 核心验证逻辑 ----------------------

def _generate_sign(expire, status_code, remote_data, timestamp):
    """
    计算签名: MD5(expire + status_code + remote_data + timestamp + secret)
    """
    secret = SecretConfig.gs()
    raw_str = f"{expire}{status_code}{remote_data}{timestamp}{secret}"
    return hashlib.md5(raw_str.encode('utf-8')).hexdigest()

def _post_request(path, data, headers=None):
    """
    通用 POST 请求封装
    """
    url = f"{SecretConfig.get_base_url()}{path}"
    if headers is None:
        headers = {'Content-Type': 'application/x-www-form-urlencoded'}
    
    try:
        response = requests.post(url, data=data, headers=headers, timeout=10)
        response.encoding = 'gbk' 
        response.raise_for_status() # 检查 HTTP 错误
        return response.text
    except requests.exceptions.RequestException as e:
        raise Exception(f"网络请求失败: {str(e)}")

# ---------------------- 接口实现 (替代 DLL) ----------------------


def card_login(card_pwd):
    """
    卡密登录验证 - Python 原生实现
    """
    if not card_pwd:
        return {"status": "error", "message": "卡密不能为空"}

    try:
        raw_mac = get_machine_code()
        mac_code = encrypt_machine_code(raw_mac)
        
        # 构造请求体
        payload = {
            "CardPwd": card_pwd,
            "Mac": mac_code,
            "LgCity": "None"
        }
        # 发送请求
        raw_data = _post_request("/5x9m4o7k3q5e1n7x", payload)
        raw_data.strip()
        # 解析返回数据: Expire|||Token|||RemoteData|||Timestamp|||Sign
        parts = raw_data.split("|||")
        
        if len(parts) == 5:
            expire = parts[0]
            status_code = parts[1] # Token
            remote_data = parts[2]
            timestamp = parts[3]
            server_sign = parts[4]
            
            # 1. 本地计算签名验证
            client_sign = _generate_sign(expire, status_code, remote_data, timestamp)
            
            if client_sign != server_sign:
                # 签名不匹配，可能是伪造的服务器
                block_card(card_pwd) # 尝试封禁（虽然如果服务器是伪造的这个也没用）
                os._exit(1) # 直接退出程序，防止继续运行
                return {"status": "error", "message": "验证失败1"}
            
            raw_res = get_rm(card_pwd, status_code)
            Auth.RM = int(raw_res)
            Auth.CARD=card_pwd
            Auth.TOKEN=status_code
            
            # 支持多个 IP，以逗号分隔
            if "," in remote_data:
                 Auth.REMOTE_IP = [ip.strip() for ip in remote_data.split(",")]
            else:
                 Auth.REMOTE_IP = remote_data

            if not Auth.RM or Auth.RM == -9999:
                return {"status": "error", "message": "验证失败4"}
                # print(f"授权成功！同步服务器时间盐为: {Auth.SAVE_TIME} 分")
            return {
                "status": "success",
                "card": card_pwd, # 方便后续使用
                "expire": expire,
                "token": status_code,
                "remote": remote_data,
                "timestamp": timestamp,
            }
        else:
            # 格式不对，可能是错误信息
            return {"status": "error", "message": "验证失败3"}

    except Exception as e:
        return {"status": "error", "message": str(e)}

def send_heartbeat(card, token):
    """
    发送心跳包
    """
    card=Auth.CARD
    token=Auth.TOKEN
    if not card or not token:
        return {"status": "error", "message": "参数不能为空"}
    
    try:
        # 参数是 CardPwd 和 Token
        payload = {
            "CardPwd": card,
            "Token": token
        }
        res_body = _post_request("/6i7z9o6n7u5i8a9a", payload)
        
        # 返回体通常是 "1" 表示成功，或者错误信息
        return {"status": "ok", "message": res_body}
        
    except Exception as e:
        return {"status": "error", "message": str(e)}

def block_card(card_pwd):
    """
    封禁卡密
    """
    if not card_pwd:
        return {"status": "error", "message": "卡密不能为空"}
    
    try:
        payload = {"CardPwd": card_pwd}
        res_body = _post_request("/0v2r6u1i0d1p6l8o", payload)
        return {"status": "ok", "message": res_body}
    except Exception as e:
        return {"status": "error", "message": str(e)}
    
def get_rm(UserName, Token):
    if not UserName or not Token:
        return {"status": "error", "message": "参数不能为空"}
    
    # 增强：生成一个随机数，防止包重放
    nonce = random.randint(100000, 999999)
    Auth.Nonce=nonce
    # 将 Nonce 发给服务器
    temp=nonce-666
    payload = f"UserName={UserName}&Token={Token}&Ycjsys=GetRemotePatch,{temp}"

    try:
        res_body = _post_request("/2m1h1w0z8j2q4p3l", payload)
        server_patch = res_body.strip()
        local_calc = (((4338959 << 1) | 1)^nonce) & 0xFFFFFFFF
        if local_calc == int(server_patch):
            is_valid = True
        if not is_valid:
            # 验证失败：可能是重放攻击或 Mock 服务器
            return -9999
        
        return local_calc
    except Exception as e:
        return -9999
def send_exit(card, token):
    """
    发送退出信号
    """
    try:
        payload = {"UserName": card, "Token": token}
        res_body = _post_request("/5v5g0m4i5a9s3k8b", payload)
        return {"status": "ok", "message": res_body}
    except Exception as e:
        return {"status": "error", "message": str(e)}

def unbind_card(card):
    """
    解绑卡密
    """
    if not card:
        return {"status": "error", "message": "卡密不能为空"}
    
    try:
        raw_mac = get_machine_code()
        mac_code = encrypt_machine_code(raw_mac)
        
        payload = {"CardPwd": card, "Mac": mac_code}
        res_body = _post_request("/7x0x0e1e4z9s1n3b", payload)
        return {"status": "ok", "message": res_body}
    except Exception as e:
        return {"status": "error", "message": str(e)}

def cleanup():
    """
    清理资源，发送退出信号
    """
    if not Auth.CARD or not Auth.TOKEN:
        return
    try:
        ret = send_exit(Auth.CARD, Auth.TOKEN)
        print(f"退出结果: {ret}")
    except Exception as e:
        print(f"退出时出错: {e}")

def heartbeat_check():
    """
    后台心跳检查线程函数
    """
    # 稍微延迟启动，避免刚登录就心跳冲突
    time.sleep(5)
    
    while True:
        # 心跳间隔 1800 秒 (30分钟)
        time.sleep(1800)
        card=Auth.CARD
        token=Auth.TOKEN
        if not card or not token:
            print("心跳参数丢失，退出")
            os._exit(1)
            break
            
        try:
            ret = send_heartbeat(card, token)
            print(f"心跳结果: {ret}")
            
            # 如果返回值不是 "1"，说明验证失效（过期或被挤下线）
            if ret.get("message") != "1":
                print("心跳验证失败，强制退出")
                os._exit(1) # 强制终止进程
                break
                
        except Exception as e:
            print(f"心跳网络异常: {e}")
            # 网络异常可以选择重试或者直接退出，这里为了安全选择退出
            os._exit(1)
            break