format ELF64

public _start

include 'file.asm' 

_start:
mov rsi, [rsp+16]
mov al, byte [rsi]
mov bl, 10
xor rcx, rcx
.iter:
    xor ah, ah
    div bl
    add ah, '0'
    mov dl, ah
    push rdx
    inc cl
    cmp al, 0
    jne .iter
.iter2:
    pop rax
    call print_char
    dec cl
    cmp cl, 0
    jne .iter2
call new_line
call exit