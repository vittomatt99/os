[bits 16]

switch_to_pm:
    cli ; disable interrupts

    lgdt [gdt_descriptor] ; load gdt descriptor

    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    jmp CODE_SEG:init_pm

[bits 32]

init_pm:
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000
    mov esp, ebp

    call begin_pm

begin_pm:
    mov ebx, MSG_PROT_MODE  ; Use our 32-bit print routine to
    call print_string_pm    ; announce we are in protected mode

    call KERNEL_OFFSET      ; Now jump to the address of our loaded
                            ; kernel code, assume the brace position,
                            ; and cross your fingers. Here we go!

    jmp $                   ; Hang.