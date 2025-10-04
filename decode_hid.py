#!/usr/bin/env python3
"""
decode_hid.py

Simple USB HID keyboard-report decoder for exported Wireshark packet hex dumps.

Usage:
  python3 decode_hid.py hid_packets.txt > keyslogfile.txt

Behavior:
- Scans input for hex byte pairs and groups them into 8-byte HID reports
  (modifier, reserved, k1..k6).
- Maps HID usage IDs to ASCII characters (US layout) with shift handling.
- Outputs the concatenated keystrokes (no line breaks by default).
"""
import sys
import re

# Basic HID usage id -> char maps (USB HID usage IDs)
no_shift = {
    0x04: 'a',0x05:'b',0x06:'c',0x07:'d',0x08:'e',0x09:'f',0x0a:'g',0x0b:'h',
    0x0c:'i',0x0d:'j',0x0e:'k',0x0f:'l',0x10:'m',0x11:'n',0x12:'o',0x13:'p',
    0x14:'q',0x15:'r',0x16:'s',0x17:'t',0x18:'u',0x19:'v',0x1a:'w',0x1b:'x',
    0x1c:'y',0x1d:'z',
    0x1e:'1',0x1f:'2',0x20:'3',0x21:'4',0x22:'5',0x23:'6',0x24:'7',0x25:'8',
    0x26:'9',0x27:'0',
    0x28:'\n',   # Enter
    0x2c:' ',    # Space
    0x2d:'-',0x2e:'=',0x2f:'[',0x30:']',0x31:'\\',0x33:';',0x34:"'",0x35:'`',0x36:',',0x37:'.',0x38:'/',
    0x2b:'\t',   # Tab
}

shift = {
    0x04: 'A',0x05:'B',0x06:'C',0x07:'D',0x08:'E',0x09:'F',0x0a:'G',0x0b:'H',
    0x0c:'I',0x0d:'J',0x0e:'K',0x0f:'L',0x10:'M',0x11:'N',0x12:'O',0x13:'P',
    0x14:'Q',0x15:'R',0x16:'S',0x17:'T',0x18:'U',0x19:'V',0x1a:'W',0x1b:'X',
    0x1c:'Y',0x1d:'Z',
    0x1e:'!',0x1f:'@',0x20:'#',0x21:'$',0x22:'%',0x23:'^',0x24:'&',0x25:'*',
    0x26:'(',0x27:')',
    0x28:'\n',
    0x2c:' ',
    0x2d:'_',0x2e:'+',0x2f:'{',0x30:'}',0x31:'|',0x33:':',0x34:'"',0x35:'~',0x36:'<',0x37:'>',0x38:'?',
    0x2b:'\t',
}

def extract_hex_pairs(text):
    # find all 2-digit hex tokens (00..FF)
    return re.findall(r'\b[0-9a-fA-F]{2}\b', text)

def groups_of_n(lst, n):
    for i in range(0, len(lst), n):
        yield lst[i:i+n]

def main():
    if len(sys.argv) != 2:
        print("Usage: python3 decode_hid.py hid_packets.txt", file=sys.stderr)
        sys.exit(1)

    path = sys.argv[1]
    data = open(path, 'rb').read().decode('utf-8', errors='ignore')
    hex_pairs = extract_hex_pairs(data)
    if not hex_pairs:
        print("", end="")
        return

    # convert to int bytes
    bytes_list = [int(x,16) for x in hex_pairs]

    # Try grouping by 8 (standard HID report length)
    output_chars = []
    for group in groups_of_n(bytes_list, 8):
        if len(group) < 8:
            break
        modifier = group[0]
        # reserved = group[1]
        keys = group[2:8]
        shift_active = bool(modifier & (0x02 | 0x20))  # LeftShift or RightShift
        for k in keys:
            if k == 0:
                continue
            ch = None
            if shift_active:
                ch = shift.get(k)
            if ch is None:
                ch = no_shift.get(k)
            if ch is None:
                # unknown: represent as [0x..]
                ch = "[0x%02x]" % k
            output_chars.append(ch)

    # Print with no extra newline (so the caller can redirect)
    sys.stdout.write(''.join(output_chars))

if __name__ == '__main__':
    main()
