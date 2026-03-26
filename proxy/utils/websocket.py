import struct

def decode_websocket(data: bytes) -> bytes | None:
    """
    Simple WebSocket Frame Decoder
    Handles: Binary/Text frames, Masking, 7-bit/16-bit/64-bit lengths
    Returns: Decoded payload (bytes) or None if invalid/incomplete
    """
    try:
        if len(data) < 2: return None
        
        first_byte = data[0]
        opcode = first_byte & 0x0F
        # We only care about Text(1) or Binary(2) for game data
        if opcode not in [1, 2]: return None 

        second_byte = data[1]
        is_masked = (second_byte >> 7) & 1
        payload_len = second_byte & 0x7F

        offset = 2
        
        if payload_len == 126:
            if len(data) < 4: return None
            payload_len = struct.unpack(">H", data[2:4])[0]
            offset += 2
        elif payload_len == 127:
            if len(data) < 10: return None
            payload_len = struct.unpack(">Q", data[2:10])[0]
            offset += 8

        mask_key = None
        if is_masked:
            if len(data) < offset + 4: return None
            mask_key = data[offset:offset+4]
            offset += 4

        # Check if we have the full payload
        if len(data) < offset + payload_len:
            return None 

        content = bytearray(data[offset : offset + payload_len])

        if is_masked and mask_key:
            for i in range(len(content)):
                content[i] ^= mask_key[i % 4]

        return bytes(content)

    except Exception:
        return None

import struct

def try_decode_frame(data: bytes, is_from_client: bool) -> tuple[bytes | None, int]:
    """
    Attempts to decode a single WebSocket frame with strict validation.
    """
    try:
        if len(data) < 2:
            return None, 0
        
        first_byte = data[0]
        opcode = first_byte & 0x0F
        
        # 1. Opcode 校验 (0,1,2,8,9,10 是合法值)
        if opcode not in [0, 1, 2, 8, 9, 10]:
            return None, 1

        second_byte = data[1]
        is_masked = (second_byte >> 7) & 1
        
        # 2. Mask 状态严格校验 (WebSocket 标准：客户端发往服务端必须带掩码，反之必须不带) H (0x48) -> Opcode 是 8
        if is_from_client and not is_masked:
            return None, 1 # 错位了，跳过 1 字节
        if not is_from_client and is_masked:
            return None, 1 # 错位了，跳过 1 字节

        payload_len = second_byte & 0x7F
        offset = 2
        
        if payload_len == 126:
            if len(data) < 4: return None, 0
            payload_len = struct.unpack(">H", data[2:4])[0]
            offset += 2
        elif payload_len == 127:
            if len(data) < 10: return None, 0
            payload_len = struct.unpack(">Q", data[2:10])[0]
            offset += 8

        # 3. 长度合理性校验 (防止因错位导致解析出天文数字长度)
        if payload_len > 1_000_000:
            return None, 1

        if is_masked:
            offset += 4

        total_len = offset + payload_len
        
        if len(data) < total_len:
            return None, 0

        # 解码数据
        curr = 2
        if data[1] & 0x7F == 126: curr += 2
        elif data[1] & 0x7F == 127: curr += 8
        
        mask_key = None
        if is_masked:
            mask_key = data[curr : curr+4]
            curr += 4
            
        content = bytearray(data[curr : curr + payload_len])
        if is_masked and mask_key:
            for i in range(len(content)):
                content[i] ^= mask_key[i % 4]
                
        if opcode in [1, 2]:
            return bytes(content), total_len
        else:
            return None, total_len

    except Exception:
        return None, 1

def encode_websocket(payload: bytes, is_binary: bool = True, mask: bool = True) -> bytes:
    """
    Encodes payload into a WebSocket frame.
    """
    import random
    
    # 1. Header (FIN=1, Opcode)
    # Binary=2, Text=1
    opcode = 2 if is_binary else 1
    header = bytearray([0x80 | opcode])
    
    # 2. Length & Mask bit
    mask_bit = 0x80 if mask else 0x00
    length = len(payload)
    
    if length < 126:
        header.append(mask_bit | length)
    elif length < 65536:
        header.append(mask_bit | 126)
        header.extend(struct.pack(">H", length))
    else:
        header.append(mask_bit | 127)
        header.extend(struct.pack(">Q", length))
        
    # 3. Mask Key & Payload
    if mask:
        # Generate random 4-byte mask
        mask_key = bytes([random.randint(0, 255) for _ in range(4)])
        header.extend(mask_key)
        
        # Mask the payload
        masked_payload = bytearray(payload)
        for i in range(len(masked_payload)):
            masked_payload[i] ^= mask_key[i % 4]
        header.extend(masked_payload)
    else:
        header.extend(payload)
        
    return bytes(header)
