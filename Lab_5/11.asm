format ELF64

public _start

include 'file.asm' 

section '.bss' writable
    input: times 20 db ?
    filename1: times 20 db ?
    filename2: times 20 db ?

section '.text' executable
_start:
    ; читаем название первого файла
    mov rdi, 0
    mov rsi, filename1
    mov rdx, 20
    call read

    ; открываем первый файл
    mov rax, 2
    mov rdi, filename1
    mov rsi, 1102o
    mov rdx, 777o
    syscall
    mov r8, rax

    ; читаем название второго файла
    mov rdi, 0
    mov rsi, filename2
    mov rdx, 20
    call read

    ; открываем второй файл
    mov rax, 2
    mov rdi, filename2
    mov rsi, 1101o
    mov rdx, 777o
    syscall
    mov r9, rax

    ; читаем n
    mov rdi, 0
    mov rsi, input
    mov rdx, 20
    call read
    xor rax, rax
    mov rsi, input
    call str_number
    mov rbx, rax
    inc rbx
    mov rcx, 2
    .loop1:

        push rbx
        push rdx
        mov rdi, r8
        mov rbx, 2
        .check_loop:    ; проверка на простое
            cmp rbx, rcx
            je .print
            mov rax, rcx
            xor rdx, rdx
            div rbx
            cmp rdx, 0
            je @f
            inc rbx
            cmp rbx, rcx
            jne .check_loop
        .print:
        mov rax, rcx
        call print_num
        call new_line

        @@:
        pop rdx
        pop rbx

        inc rcx
        cmp rcx, rbx
        jne .loop1

    mov rax, 8
    mov rdi, r8
    mov rsi, 0
    mov rdx, 0
    syscall

    ; пишем во второй файл числа из первого, которые заканчиваются на 1
    mov rsi, input
    .loop2:
        mov rdi, r8
        call readline
        cmp rax, 0
        je .finish
        cmp byte[input+rax-1], '1'
        jne .loop2
        
        mov rdi, r9
        call print_str
        call new_line
        jmp .loop2

    .finish:
        call exit
