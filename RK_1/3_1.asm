format ELF64

include 'file.asm'

public _start

section '.bss' writable
    buffer rq 1
    filename: times 10 db ?
    path: times 100 db ?
    f db "/dev/random", 0

section '.text' executable
_start:
    mov rsi, [rsp+16]
    xor rcx, rcx
    xor rbx, rbx
    .read_path:
        mov bl, byte[rsi+rcx]
        mov byte[path+rcx], bl
        cmp byte[rsi+rcx], 0
        je @f
        inc rcx
        jmp .read_path
    
    @@:
    mov r9, rcx ; сохранили длину пути
    mov rsi, [rsp+24]
    call str_number
    mov r8, rax
    .loop:
        cmp r8, 0
        je .finish

        mov rsi, filename
        mov rax, 9
        call random_str

        mov byte[path+r9], "/"
        inc r9
        xor rcx, rcx
        xor rbx, rbx
        .fill_path:
            mov bl, byte[rsi+rcx]
            mov byte[path+rcx+r9], bl
            cmp byte[rsi+rcx], 0
            je @f
            inc rcx
            jmp .fill_path

        @@:
        mov rax, 0x55
        mov rdi, path
        mov rsi, 777o
        syscall

        dec r8
        jmp .loop

    .finish:
        call exit


;input: rsi - place of memory to place string, rax - length
;output rsi - string, rax - length
random_str:
    push r8
    push r9
    push r10    
    push rdx
    push rcx
    push rbx
    push rax

    mov r9, rax

    push rsi
    mov rdi, f
    mov rax, 2 
    mov rsi, 0o
    syscall 
    mov r8, rax
    pop rsi

    mov bl, 26
    mov bh, 97
    xor rdx, rdx
    .loop:
        cmp rdx, r9
        je .end
        push rdx
        push rsi
        mov rax, 0
        mov rdi, r8
        mov rsi, buffer
        mov rdx, 1
        syscall
        pop rsi

        mov rax, [buffer]
        div bl
        add ah, bh
        pop rdx
        mov byte[rsi+rdx], ah
        inc rdx
        jmp .loop
    
    .end:
    mov byte[rsi+rdx], 0

    pop rax
    pop rbx
    pop rcx
    pop rdx
    pop r10
    pop r9
    pop r8
    ret