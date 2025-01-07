CC = gcc
TARGET = os
C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
C_FLAGS = -m32 -ffreestanding -nostdlib -nostartfiles -nodefaultlibs -fno-pie
HEADERS = $(wildcard kernel/*.h drivers/*.h)
OBJS = ${C_SOURCES:.c=.o}

# Build all
all: floppy iso

# Run for floppy
run-floppy: floppy
	qemu-system-x86_64 -boot a -fda $(TARGET)

# Run for ISO
run-iso: iso
	qemu-system-x86_64 -cdrom $(TARGET).iso

# Build floppy binary
floppy: $(TARGET)

$(TARGET): boot/boot_sect.bin kernel/kernel-floppy.bin
	cat $^ > $(TARGET)

kernel/kernel-floppy.bin: kernel/kernel_entry.o ${OBJS}
	ld -m elf_i386 -Ttext 0x1000 $^ --oformat binary -o $@

# Build ISO
iso: $(TARGET).iso

$(TARGET).iso: kernel/kernel-iso.bin
	cp $< ./iso/boot/$(TARGET)
	grub-mkrescue iso --output=$(TARGET).iso
	rm -f ./iso/boot/$(TARGET)

kernel/kernel-iso.bin: kernel/kernel_entry.o ${OBJS}
	ld -m elf_i386 -T boot/linker/linker.ld $^ -o $@

# Object files for C source files
%.o: %.c ${HEADERS}
	$(CC) $(C_FLAGS) -T boot/linker/linker.ld -c $< -o $@

# Object files for assembly files
%.o: %.asm
	nasm $< -f elf -o $@

# Binary files for assembly files
%.bin: %.asm
	nasm $< -f bin -o $@

clean:
	rm -fr *.bin *.o
	rm -fr $(TARGET) $(TARGET).iso iso/boot/$(TARGET)
	rm -fr kernel/*.o kernel/*.bin boot/*.bin drivers/*.o