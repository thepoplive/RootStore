#!/usr/bin/env python3
"""Generate RootStore app icons (pure Python, no PIL).

Artwork: MD3 rounded square with indigo-violet vertical gradient
and a white shopping-bag glyph. Supersampled for anti-aliasing.
Output: Resources/AppIcon.png (60) and Resources/AppIcon@2x.png (120).
"""
import os
import struct
import zlib

TOP = (137, 120, 245)    # gradient top (indigo-violet)
BOT = (84, 66, 198)      # gradient bottom
GLYPH = (255, 255, 255, 255)
SS = 3                   # supersampling factor


def write_png(path, w, h, rgba):
    def chunk(tag, data):
        return (struct.pack(">I", len(data)) + tag + data +
                struct.pack(">I", zlib.crc32(tag + data) & 0xffffffff))

    raw = b"".join(b"\x00" + bytes(rgba[y * w * 4:(y + 1) * w * 4])
                   for y in range(h))
    with open(path, "wb") as f:
        f.write(b"\x89PNG\r\n\x1a\n")
        f.write(chunk(b"IHDR", struct.pack(">IIBBBBB", w, h, 8, 6, 0, 0, 0)))
        f.write(chunk(b"IDAT", zlib.compress(raw, 9)))
        f.write(chunk(b"IEND", b""))


def in_round_rect(x, y, x0, y0, x1, y1, r):
    if x < x0 or x > x1 or y < y0 or y > y1:
        return False
    cx = min(max(x, x0 + r), x1 - r)
    cy = min(max(y, y0 + r), y1 - r)
    dx, dy = x - cx, y - cy
    return dx * dx + dy * dy <= r * r


def lerp(a, b, t):
    return tuple(int(round(a[i] + (b[i] - a[i]) * t)) for i in range(3))


def sample(s, x, y):
    """Color at exact point (x, y) in icon of size s, or None if transparent."""
    r_rect = 0.225 * s                      # MD3 corner radius
    if not in_round_rect(x, y, 0, 0, s, s, r_rect):
        return None

    t = min(max(y / s, 0.0), 1.0)
    rgb = lerp(TOP, BOT, t)

    # Shopping bag: handle annulus first, body on top.
    bag_w, bag_h = 0.46 * s, 0.36 * s
    margin = 0.17 * s
    bx0 = (s - bag_w) / 2.0
    bx1 = bx0 + bag_w
    by1 = s - margin
    by0 = by1 - bag_h

    hx, hy = s / 2.0, by0                   # handle center = bag top edge
    outer = 0.115 * s
    inner = outer - 0.05 * s
    dx, dy = x - hx, y - hy
    dist = (dx * dx + dy * dy) ** 0.5
    if inner <= dist <= outer:
        return GLYPH

    if in_round_rect(x, y, bx0, by0, bx1, by1, 0.05 * s):
        return GLYPH
    return rgb


def render(s):
    out = bytearray(s * s * 4)
    for py in range(s):
        for px in range(s):
            acc = [0, 0, 0, 0]
            for sy in range(SS):
                for sx in range(SS):
                    x = px + (sx + 0.5) / SS
                    y = py + (sy + 0.5) / SS
                    c = sample(s, x, y)
                    if c is None:
                        continue
                    acc[0] += c[0]
                    acc[1] += c[1]
                    acc[2] += c[2]
                    acc[3] += 255
            n = SS * SS
            idx = (py * s + px) * 4
            if acc[3] == 0:
                continue
            covered = acc[3] // 255
            out[idx] = acc[0] // covered
            out[idx + 1] = acc[1] // covered
            out[idx + 2] = acc[2] // covered
            out[idx + 3] = int(round(255.0 * covered / n))
    return out


def main():
    here = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    res = os.path.join(here, "Resources")
    for name, size in (("AppIcon.png", 60), ("AppIcon@2x.png", 120)):
        path = os.path.join(res, name)
        write_png(path, size, size, render(size))
        print("wrote", path, size, "x", size)


if __name__ == "__main__":
    main()
