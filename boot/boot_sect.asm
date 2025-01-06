; A boot sector that boots a C kernel in 32-bit protected mode
[org 0x7c00]
KERNEL_OFFSET equ 0x1000 ; This is the memory offset to which we will load our kernel

mov [BOOT_DRIVE], dl ; BIOS stores our boot drive in DL, so it’s
                     ; best to remember this for later.

mov bp, 0x9000       ; Set-up the stack.
mov sp, bp

mov bx, MSG_REAL_MODE ; Announce that we are starting

call print_string     ; booting from 16-bit real mode

call load_kernel      ; Load our kernel

call switch_to_pm     ; Switch to protected mode, from which
                      ; we will not return

jmp $  ; Hang in case of failure

; Include our useful, hard-earned routines
%include "boot/screen/print.asm"
%include "boot/screen/print_pm.asm"
%include "boot/disk/disk_load.asm"
%include "boot/disk/kernel_load.asm"
%include "boot/switch_pm.asm"
%include "boot/gdt.asm"

; Global variables
BOOT_DRIVE      db 0
MSG_REAL_MODE   db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE   db "Successfully landed in 32-bit Protected Mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory.", 0

; Bootsector padding
times 510-($-$$) db 0
dw 0xaa55