format ELF64

public _start
public func

include 'file.asm' 

section '.bss' writable
    input: times 10 db ?
    number dq ?

section '.text' executable
_start:
    mov rsi, input
    mov rdx, 10
    call read
    call str_number
    inc rax
    mov [number], rax
    mov rcx, 1
    xor rbx, rbx
    xor rdx, rdx
    .sum_loop:
        call func
        cmp rdx, 0
        jne .add
            sub rbx, rax
            inc rdx
            jmp @f
        .add:
            add rbx, rax
            dec rdx
            jmp @f
        @@:
        inc rcx
        cmp rcx, [number]
        jne .sum_loop
    mov rax, rbx
    call print_num
    call new_line
    call exit

;input - rcx = k , output - rax
;rax = k * (k + 1) * (3k + 1) * (3k + 2)
func:
    push rcx
    push rdx
    ; k
    mov rax, rcx
    ; k + 1
    inc rcx
    mul rcx
    ; 3k + 1
    dec rcx
    mul2 rcx, 3
    inc rcx
    mul rcx
    ; 3k + 2
    inc rcx
    mul rcx
    pop rdx
    pop rcx
    ret

    