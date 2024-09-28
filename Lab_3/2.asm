format ELF64

public _start

include 'file.asm' 

section '.bss' writable
a dq ?
b dq ?
c dq ?

section '.text' executable
_start:
    xor rax, rax
    mov rsi, [rsp+16]
    call str_number
    mov [a], rax
    xor rax, rax
    mov rsi, [rsp+24]
    call str_number
    mov [b], rax
    xor rax, rax
    mov rsi, [rsp+32]
    call str_number
    mov [c], rax

    ;(c+b-b+a)/b-a
    xor rax, rax
    mov rax, [c]
    add rax, [b]
    sub rax, [b]
    add rax, [a]
    cqo
    idiv [b]
    sub rax, [a]
    call print_num
    call new_line
    call exit
