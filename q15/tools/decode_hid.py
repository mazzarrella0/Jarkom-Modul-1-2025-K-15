import re

def parse_hex(h):
    h = h.replace(':','').replace(' ','').strip()
    try:
        return [int(h[i:i+2],16) for i in range(0,len(h),2)]
    except:
        return []

usage = {
  0x04:'a',0x05:'b',0x06:'c',0x07:'d',0x08:'e',0x09:'f',0x0a:'g',0x0b:'h',0x0c:'i',0x0d:'j',
  0x0e:'k',0x0f:'l',0x10:'m',0x11:'n',0x12:'o',0x13:'p',0x14:'q',0x15:'r',0x16:'s',0x17:'t',
  0x18:'u',0x19:'v',0x1a:'w',0x1b:'x',0x1c:'y',0x1d:'z',
  0x1e:'1',0x1f:'2',0x20:'3',0x21:'4',0x22:'5',0x23:'6',0x24:'7',0x25:'8',0x26:'9',0x27:'0',
  0x28:'\n',0x2c:' ',0x2d:'-',0x2e:'=',0x2f:'[',0x30:']',0x31:'\\',0x33:';',0x34:"'",
  0x36:',',0x37:'.',0x38:'/'
}

usage_shift = {k:v.upper() for k,v in usage.items()}
usage_shift.update({
  0x1e:'!',0x1f:'@',0x20:'#',0x21:'$',0x22:'%',0x23:'^',0x24:'&',0x25:'*',0x26:'(',0x27:')',
  0x2d:'_',0x2e:'+',0x2f:'{',0x30:'}',0x31:'|',0x33:':',0x34:'"',0x36:'<',0x37:'>',0x38:'?'
})

out = []
with open('output/usb_hid_raw_variantB.txt','r',errors='ignore') as f:
    for line in f:
        parts = line.strip().split()
        if not parts:
            continue
        raw = parts[-1]  # kolom hex
        bytes_ = parse_hex(raw)
        if len(bytes_) < 3:
            continue
        modifier = bytes_[0]
        is_shift = (modifier & 0x22) != 0
        for b in bytes_[2:]:
            if b == 0:
                continue
            if is_shift and b in usage_shift:
                out.append(usage_shift[b])
            elif b in usage:
                out.append(usage[b])
            else:
                out.append('?')

msg = ''.join(out)
with open('output/usb_hid_decoded.txt','w') as fw:
    fw.write(msg)

print("\nDecoded ke: output/usb_hid_decoded.txt")
print("Preview 200 char pertama:")
print(msg[:200])
