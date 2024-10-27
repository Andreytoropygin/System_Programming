format ELF64


public create_queue
public delete_queue
public mypush
public mypop
public fill_random
public count_even
public count_simple
public count_1_ended

MAXSIZE = 1000


section '.bss' writable
    head rq 1   ;начало очереди
    tail rq 1   ;конец очереди
    minaddr rq 1    ;начало выделенной области
    maxaddr rq 1    ;конец выделенной области
    size rq 1   ;длина очереди
    place rb 1

    f db "/dev/random", 0

section '.text' executable

; создает пустую очередь
create_queue:
    mov rax, 9
    mov rdi, 0      ;начальный адрес выберет сама ОС
	mov rsi, MAXSIZE    ;задаем размер области памяти
	mov rdx, 0x3    ;совмещаем флаги PROT_READ | PROT_WRITE
	mov r10,0x22    ;задаем режим MAP_ANONYMOUS|MAP_PRIVATE
	mov r8, -1      ;указываем файловый дескриптор null
	mov r9, 0       ;задаем нулевое смещение
    syscall
    mov [head], rax
    mov [tail], rax
    mov [minaddr], rax

    mov [maxaddr], rax
    mov rax, 8
    mov rbx, MAXSIZE
    mul rbx
    add [maxaddr], rax

    mov [size], 0
    ret

; освобождает память
delete_queue:
    mov rax, 11
    mov rsi, MAXSIZE
    syscall
    mov [head], 0
    mov [tail], 0
    ret
    

; кладет число (rdi) в конец очереди
mypush:
    cmp [size], MAXSIZE
    je @f
    cmp [tail], 0
    je @f
    mov rsi, [tail]
    mov [rsi], rdi
    add [tail], 8
    inc [size]

    cmp [tail], maxaddr
    jne @f
    mov rsi, minaddr
    mov [tail], rsi

    @@:
    ret

; достает число из начала очереди
mypop:
    xor rax, rax
    cmp [size], 0
    je @f
    cmp [head], 0
    je @f
    mov rsi, [head]
    mov rax, [rsi]
    add [head], 8
    dec [size]

    cmp [head], maxaddr
    jne @f
    mov rsi, minaddr
    mov [head], rsi
    
    @@:
    ret

; кладет rdi случайных чисел в очередь
fill_random:
    mov r8, rdi
    push r8
    call delete_queue
    call create_queue
    pop r8

    mov rax, 2
    mov rdi, f
    mov rsi, 0o
    syscall 
    mov r9, rax

    .loop:
        cmp r8, [size]
        je .end

        mov rax, 0
        mov rdi, r9
        mov rsi, place
        mov rdx, 1
        syscall

        xor rax, rax
        xor rdi, rdi
        mov al, byte[rsi]
        add rdi, rax
        call mypush
        
        jmp .loop

    .end:
    mov rax, 3
    mov rdi, r9
    syscall
    ret

; считает количество четных чисел в очереди
count_even:
    xor rcx, rcx
    mov rsi, [head]
    
    .loop:
        cmp rsi, [tail]
        je .end

        xor rdx, rdx
        mov rax, [rsi]
        mov rbx, 2
        div rbx

        cmp rdx, 0
        jne @f
        inc rcx

        @@:
        add rsi, 8
        cmp rsi, [maxaddr]
        jne @f
        mov rsi, [minaddr]

        @@:
        jmp .loop

    .end:
    mov rax, rcx
    ret

; считает количество простых чисел в очереди
count_simple:
    xor rcx, rcx
    mov rsi, [head]
    
    .loop:
        cmp rsi, [tail]
        je .end

        mov rax, [rsi]
        call simple_check ; если в rax не простое число, то в rdx будет 0
        cmp rdx, 0
        je @f
        inc rcx

        @@:
        add rsi, 8
        cmp rsi, [maxaddr]
        jne @f
        mov rsi, [minaddr]

        @@:
        jmp .loop

    .end:
    mov rax, rcx
    ret

; проверяет rax на простоту, в rdx 0, если не простое
simple_check:
    cmp rax, 2
    jnl @f
    xor rdx, rdx
    jmp .end

    @@:
    mov r8, 2
    mov r9, rax

    .loop:
        cmp r8, r9
        je .end

        xor rdx, rdx
        push rax
        div r8
        pop rax
        cmp rdx, 0
        je .end

        inc r8
        jmp .loop
    
    .end:
    ret

; считает количество чисел в очереди, которые оканчиваются на 1
count_1_ended:
    xor rcx, rcx
    mov rsi, [head]
    
    .loop:
        cmp rsi, [tail]
        je .end

        xor rdx, rdx
        mov rax, [rsi]
        mov rbx, 10
        div rbx

        cmp rdx, 1
        jne @f
        inc rcx

        @@:
        add rsi, 8
        cmp rsi, [maxaddr]
        jne @f
        mov rsi, [minaddr]

        @@:
        jmp .loop

    .end:
    mov rax, rcx
    ret
