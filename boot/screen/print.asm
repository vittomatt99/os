[bits 16]

print_string:
    mov al, [bx]

    cmp al, 0
    je end

    mov ah, 0x0e
    int 0x10

    inc bx
    jmp print_string

end:
    ret