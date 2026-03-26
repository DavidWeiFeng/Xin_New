def format_hex_dump(data: bytes, title: str) -> str:
    """
    Converts bytes to a formatted hex dump string.
    """
    length = len(data)
    output = [f"\n--- [{title}] Length: {length} ---"]
    
    width = 16
    for i in range(0, length, width):
        chunk = data[i:i + width]
        
        # Hex part
        hex_part = ' '.join(f"{b:02X}" for b in chunk)
        # Padding if chunk is shorter than width
        hex_part = hex_part.ljust(width * 3 - 1)
        
        # ASCII part
        ascii_part = ''.join(
            chr(b) if 32 <= b <= 126 else '.' for b in chunk
        )
        
        output.append(f"{i:04X}  {hex_part}  |{ascii_part}|")
        
    return '\n'.join(output)
