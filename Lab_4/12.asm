format ELF64

public _start

include 'file.asm' 

section '.bss' writable
    input: times 10 db ?
    positive db "True"
    negative db "False"

section '.text' executable
_start:
    mov rsi, input
    mov rdx, 10
    call read
    call str_number
    xor rbx, rbx
    mov rbx, 10
    xor rcx, rcx
    .div_loop:
        xor rdx, rdx
        div rbx
        push rdx
        inc rcx
        cmp rax, 0
        jne .div_loop
    pop rax
    jmp @f
    .cmp_loop:
        mov rdx, rax
        pop rax
        cmp rax, rdx
        jnl @f
        load_fixed_print negative, 5
        jmp .finish
        @@:
        dec rcx
        cmp rcx, 0
        jne .cmp_loop
        load_fixed_print positive, 4
    .finish:
        call print_str_fixed
        call new_line
        call exit