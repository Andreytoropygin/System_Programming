format ELF64

public _start

include 'file.asm' 

section '.bss' writable
    input: times 3 db ?
    positive db "Yes"
    negative db "No"
    neutral db "Equal"

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
    load_fixed_print neutral, 5
    jmp .finish
    @@:
    jl @f
    load_fixed_print positive, 3
    jmp .finish
    @@:
    load_fixed_print negative, 2
    .finish:
        call print_str_fixed
        call new_line
        call exit