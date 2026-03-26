import struct

class ByteBuffer:
    def __init__(self, data: bytes = b""):
        self.data = bytearray(data)
        self.reader_index = 0

    # --- Write Methods ---
    def write_uint8(self, value: int):
        self.data.extend(struct.pack(">B", value))

    def write_uint16(self, value: int):
        self.data.extend(struct.pack(">H", value))

    def write_uint32(self, value: int):
        self.data.extend(struct.pack(">I", value))

    def write_string(self, value: str, length: int = 0):
        """
        Write string. If length > 0, pad with nulls or truncate to fit fixed size.
        """
        encoded = value.encode('utf-8')
        if length > 0:
            if len(encoded) > length:
                self.data.extend(encoded[:length])
            else:
                self.data.extend(encoded)
                padding = length - len(encoded)
                self.data.extend(b'\x00' * padding)
        else:
            self.data.extend(encoded)

    def write_bytes(self, value: bytes):
        self.data.extend(value)

    # --- Read Methods ---
    def read_uint8(self) -> int:
        value = struct.unpack_from(">B", self.data, self.reader_index)[0]
        self.reader_index += 1
        return value

    def read_uint16(self) -> int:
        value = struct.unpack_from(">H", self.data, self.reader_index)[0]
        self.reader_index += 2
        return value

    def read_uint32(self) -> int:
        value = struct.unpack_from(">I", self.data, self.reader_index)[0]
        self.reader_index += 4
        return value

    def read_int32(self) -> int:
        """Read signed 32-bit integer"""
        value = struct.unpack_from(">i", self.data, self.reader_index)[0]
        self.reader_index += 4
        return value

    def read_string(self, length: int) -> str:
        """Read fixed length string and strip nulls"""
        raw = self.data[self.reader_index : self.reader_index + length]
        self.reader_index += length
        try:
            # First split by null byte to stop reading garbage after null terminator
            valid_part = raw.split(b'\x00')[0]
            return valid_part.decode('utf-8')
        except:
            # Fallback for weird encodings
            return raw.decode('latin-1').rstrip('\x00')

    def read_bytes(self, length: int) -> bytes:
        val = self.data[self.reader_index : self.reader_index + length]
        self.reader_index += length
        return bytes(val)

    def available(self) -> int:
        """Returns number of bytes remaining to be read"""
        return len(self.data) - self.reader_index

    def seek(self, position: int):
        """Set the reader position"""
        self.reader_index = max(0, min(position, len(self.data)))

    @property
    def position(self) -> int:
        """Get current reader position"""
        return self.reader_index

    def get_bytes(self) -> bytes:
        return bytes(self.data)
