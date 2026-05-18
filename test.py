import time
import random
import requests
from datetime import datetime, timedelta
def _post_request(path, data, headers=None):
    """
    通用 POST 请求封装
    """
    url = f"http://101.43.13.55:6666{path}"
    if headers is None:
        headers = {'Content-Type': 'application/x-www-form-urlencoded'}
    
    try:
        response = requests.post(url, data=data, headers=headers, timeout=10)
        response.encoding = 'gbk' 
        response.raise_for_status() # 检查 HTTP 错误
        return response.text
    except requests.exceptions.RequestException as e:
        raise Exception(f"网络请求失败: {str(e)}")
    

def card_login(card_pwd):
    """! @brief 使用卡密进行登录验证。

    @param card_pwd 卡密字符串。
    @return 登录结果字典。
    """
    if not card_pwd:
        return {
            "status": "error",
            "message": "卡密不能为空"
        }

    try:
        payload = {
            "CardPwd": card_pwd,
            "Mac": "5f20c06006983512a2d433c452bc0869",
            "LgCity": "None"
        }

        # 发送请求
        raw_data = _post_request("/5x9m4o7k3q5e1n7x", payload)

        if not raw_data:
            return {
                "status": "error",
                "message": "接口返回为空"
            }

        raw_data = raw_data.strip()

        # 返回格式：Expire|||Token|||RemoteData|||Timestamp|||Sign
        parts = raw_data.split("|||")

        if len(parts) != 5:
            return {
                "status": "error",
                "message": "返回数据格式不正确",
                "raw_data": raw_data
            }

        token = parts[1]
        print(f"Token：{token}")
    except Exception as error:
        return {
            "status": "error",
            "message": f"登录异常：{error}",
            "card_pwd": card_pwd
        }


def loop_card_login():
    """! @brief 无限循环登录两个卡密。

    两个卡密全部登录完成后，再随机等待 30 分钟到 60 分钟。
    """
    card_pwd_list = [
        "00991L6G5L0U9J4H5M5V",
        "00998H4Z5U7F0M1U3D8Y"
    ]

    while True:
        print("=" * 60)
        print("开始新一轮卡密登录")
        finish_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        print(f"当前时间：{finish_time}")
        for card_pwd in card_pwd_list:
            print(f"开始登录卡密：{card_pwd}")
            result = card_login(card_pwd)
        wait_seconds = random.randint(30 * 60, 60 * 60)
        time.sleep(wait_seconds)


if __name__ == "__main__":
    loop_card_login()