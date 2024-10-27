format ELF64

include 'file.asm'

public _start
public reverse

section '.text' executable
_start:
    mov rsi, [rsp+16]
    call str_number
    mov r8, rax
    cmp r8, 1
    jl .finish
    xor r9, r9
    .sum_loop:
        cmp r8, 0
        je @f
        mov rax, r8
        call reverse
        add r9, rax
        dec r8
        jmp .sum_loop
    
    @@:
    mov rax, r9
    mov rdi, 1
    call print_num
    call new_line
    .finish:
        call exit

        

; input: rax - number
; output: rax - reversed number
reverse:
    mov rbx, 10
    xor rcx, rcx
    .div_loop:
        cmp rax, 0
        je .end
        mul2 rcx, rbx
        xor rdx, rdx
        div rbx
        add rcx, rdx
        jmp .div_loop
    .end:
    mov rax, rcx
    ret

