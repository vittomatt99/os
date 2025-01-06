[bits 16]

; load_kernel
load_kernel:
    mov bx, MSG_LOAD_KERNEL ; Print a message to say we are loading the kernel
    call print_string

    ;mov bx, 0x0000           ; Segmento base (ES = 0x0000)
    ;mov es, bx               ; Carga ES con el segmento 0x0000
    mov bx, KERNEL_OFFSET   ; Set-up parameters for our disk_load routine, so
    mov dh, 15              ; that we load the first 15 sectors (excluding
    mov dl, [BOOT_DRIVE]    ; the boot sector) from the boot disk (i.e. our
    call disk_load          ; kernel code) to address KERNEL_OFFSET
    ret