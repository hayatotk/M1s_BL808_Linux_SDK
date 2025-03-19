#!/usr/bin/env bash
#
#well so, to make the build process via the GNUmake simplier (at least -- by not using pyhton as linker), the python linker should be generated before in-script usage (still necessary for build.sh)
#
set -eu

mkdir -p out
if [ -z "${debug+x}" ]; then
    debug=0
fi
if [ "$debug" -eq 1 ]; then
    echo "[debug] makepy.sh Starting generating out/merge_7_5Mbin.py"
else
    true
fi
cat <<EOF > out/merge_7_5Mbin.py
import os

def bl_create_flash_default_data(length):
    return bytearray([0xFF] * length)

def bl_gen_linux_flash_bin():
    whole_img_data = bl_create_flash_default_data((7680*1024)-335872)
    
    files = {
        "dtb": ("./out/hw.dtb.5M", 0x0),
        "opensbi": ("./out/fw_jump.bin", 0x10000),
        "kernel": ("./out/Image.lz4", 0x20000),
        "rootfs": ("./out/squashfs_test.img", 0x480000)
    }

    for name, (filename, offset) in files.items():
        if os.path.exists(filename):
            with open(filename, "rb") as f:
                data = f.read()
                whole_img_data[offset:offset+len(data)] = data
            print(f"{name} ({filename}) added at offset {hex(offset)}")
        else:
            print(f"Warning: {name} ({filename}) not found, skipping.")

    output_file = "./out/whole_img_linux.bin"
    with open(output_file, "wb") as f:
        f.write(whole_img_data)
    
    print(f"Generated {output_file}")

if __name__ == "__main__":
    print("Generating flash binary...")
    bl_gen_linux_flash_bin()
    print("Done!")
EOF
if [ "$debug" -eq 1 ]; then
    echo "[debug] makepy.sh Generated out/merge_7_5Mbin.py"
    exit 0
else
    exit 0
fi

