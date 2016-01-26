all:
	@echo "Compiling to flat bin file"
	nasm -f bin boot_shell.asm -o boot_shell.bin

floppy:all
	dd if=/dev/zero of=floppy.img bs=512 count=2800
	dd if=boot_shell.bin of=floppy.img

qemu:floppy
	qemu-system-i386 floppy.img
