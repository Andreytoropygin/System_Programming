format ELF64

public _start

include 'file.asm' 

section '.bss' writable
    input db ?

section '.text' executable
_start:

    mov rax, 2
    mov rdi, [rsp+16]
    mov rsi, 0o
    mov rdx, 777o
    syscall
    mov r8, rax

    mov rax, 2
    mov rdi, [rsp+24]
    mov rsi, 1101o
    mov rdx, 777o
    syscall
    mov r9, rax

    mov rax, 8
    mov rdi, r8
    mov rsi, 0
    mov rdx, 2
    syscall
    mov r10, rax

    .loop:

        xor rbx, rbx
        .read_loop:

            mov rax, 0
            mov rdi, r8
            mov rsi, input
            mov rdx, 1
            syscall
            
            cmp byte[rsi], 0xA
            je .next

            cmp byte[rsi], 0
            je @f
            cmp byte[rsi], 0x03
            je @f

            mov cl, byte[rsi]
            push rcx
            inc rbx

            @@:
            cmp r10, 0
            je .next
            
            dec r10
            mov rax, 8
            mov rdi, r8
            mov rsi, r10
            mov rdx, 0
            syscall
            jmp .read_loop

        .next:  
        
        mov rax, 1
        mov rdi, r9
        mov rsi, input
        mov rdx, 1

        .print_loop:
            cmp rbx, 0
            je .check

            pop rcx
            mov byte[rsi], cl
            syscall
            
            dec rbx
            jmp .print_loop
    
        .check:
            cmp r10, 0
            je .finish
            call new_line
            dec r10
            mov rax, 8
            mov rdi, r8
            mov rsi, r10
            mov rdx, 0
            syscall
            jmp .loop

    .finish:
        call exit
