C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)

OBJ = ${C_SOURCES:.c=.o}

# Build all
all: os-image

# Run
run: all
	qemu-system-x86_64 -fda os-image -boot a

os-image: boot/boot_sect.bin kernel/kernel.bin
	cat $^ > os-image

kernel/kernel.bin: kernel/kernel_entry.o ${OBJ}
	ld -m elf_i386 -Ttext 0x1000 $^ --oformat binary -o $@

%.o: %.c ${HEADERS}
	gcc -m32 -ffreestanding -fno-pie -c $< -o $@

%.o: %.asm
	nasm $< -f elf -o $@

%.bin: %.asm
	nasm $< -f bin -o $@

clean:
	rm -fr *.bin *.o os-image
	rm -fr kernel/*.o kernel/*.bin boot/*.bin drivers/*.o