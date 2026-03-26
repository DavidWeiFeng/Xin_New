from dataclasses import dataclass
from typing import List
from proxy.utils.byte_buffer import ByteBuffer
import struct

@dataclass
class PetGlowFilter:
    color: int
    alpha: float
    blur_x: int
    blur_y: int
    strength: int
    quality: int
    inner: int  # uint8 (bool)
    knockout: int # uint8 (bool)
    matrix: List[float]
    level: int

    @classmethod
    def parse(cls, buffer: ByteBuffer) -> 'PetGlowFilter':
        """
        Parses the 98-byte PetGlowFilter (ShinyInfo) structure.
        """
        color = buffer.read_uint32()
        
        # Alpha is a float (4 bytes)
        alpha_bytes = buffer.read_bytes(4)
        alpha = struct.unpack(">f", alpha_bytes)[0]
        
        blur_x = buffer.read_uint8()
        blur_y = buffer.read_uint8()
        strength = buffer.read_uint8()
        quality = buffer.read_int32()
        inner = buffer.read_uint8()
        knockout = buffer.read_uint8()
        
        # Matrix: 20 floats (80 bytes)
        matrix = []
        for _ in range(20):
            val_bytes = buffer.read_bytes(4)
            val = struct.unpack(">f", val_bytes)[0]
            matrix.append(val)
            
        level = buffer.read_uint8()
        
        return cls(
            color=color,
            alpha=alpha,
            blur_x=blur_x,
            blur_y=blur_y,
            strength=strength,
            quality=quality,
            inner=inner,
            knockout=knockout,
            matrix=matrix,
            level=level
        )

    def __str__(self):
        return f"[SHINY] (Color: 0x{self.color:06X}, Lvl: {self.level})"
