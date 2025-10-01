import sys
inp = "output/ftp_raw/stream_${S}.raw"
out = "output/extracted/knr_from_stream.exe"
with open(inp, "rb") as f:
    data = f.read()
# find end of header: CRLF CRLF
sep = b'\r\n\r\n'
i = data.find(sep)
if i != -1:
    body = data[i+len(sep):]
    with open(out, "wb") as o:
        o.write(body)
    print("Wrote", out, "size:", len(body))
else:
    # if no CRLF CRLF found, try to find first 'MZ' (PE header)
    mz = data.find(b"MZ")
    if mz != -1:
        with open(out, "wb") as o:
            o.write(data[mz:])
        print("No HTTP header marker; extracted from first MZ at", mz)
    else:
        print("No HTTP header or MZ found; wrote entire raw file to", out)
        with open(out, "wb") as o:
            o.write(data)
