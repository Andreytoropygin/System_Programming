format ELF64

public _start

include 'file.asm' 

section '.bss' writable
    input: times 3 db ?
    positive db "Yes", 0
    negative db "No", 0
    neutral db "Equal", 0

section '.text' executable
_start:
    mov rsi, input
    mov rdx, 4
    call read
    call str_number
    xor rcx, rcx
    mov rcx, rax
    xor rbx, rbx
    mov rdx, 2
    .count_loop:
        call read
        inc rbx
        cmp byte [rsi], '0'
        jne @f
        sub rbx, 2
        @@:
        dec rcx
        cmp rcx, 0
        jne .count_loop
    cmp rbx, 0
    jne @f
    mov rsi, neutral
    jmp .finish
    @@:
    jl @f
    mov rsi, positive
    jmp .finish
    @@:
    mov rsi, negative
    .finish:
        call print_str
        call new_line
        call exit