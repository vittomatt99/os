CC = gcc
TARGET = os-image
C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)
OBJS = ${C_SOURCES:.c=.o}

# Build all
all: $(TARGET) $(TARGET).iso

# Run
run: all
	qemu-system-x86_64 -fda $(TARGET) -boot a

$(TARGET): boot/boot_sect.bin kernel/kernel.bin
	cat $^ > $(TARGET)

$(TARGET).iso: $(TARGET)
	grub-mkrescue iso --output=$(TARGET).iso

kernel/kernel.bin: kernel/kernel_entry.o ${OBJS}
	ld -m elf_i386 -Ttext 0x1000 $^ --oformat binary -o $@

%.o: %.c ${HEADERS}
	$(CC) -m32 -ffreestanding -fno-pie -nodefaultlibs -T boot/linker/linker.ld -c $< -o $@

%.o: %.asm
	nasm $< -f elf -o $@

%.bin: %.asm
	nasm $< -f bin -o $@

clean:
	rm -fr *.bin *.o $(TARGET) $(TARGET).iso
	rm -fr kernel/*.o kernel/*.bin boot/*.bin drivers/*.o