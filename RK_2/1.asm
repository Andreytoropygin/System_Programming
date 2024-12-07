format ELF64

include 'func.asm'
public _start

extrn initscr
extrn start_color
extrn init_pair
extrn getmaxx
extrn getmaxy
extrn raw
extrn noecho
extrn keypad
extrn stdscr
extrn move
extrn getch
extrn addch
extrn refresh
extrn endwin
extrn timeout
extrn usleep
extrn printw
extrn insch
extrn delch

section '.bss' writable
    xmax dq 1
	ymax dq 1
	palette dq 1
    delay dq ?
    buffer db ?
    f db "/dev/random", 0
    rand dq ?

section '.text' executable
_start:

    call initscr
    xor rdi, rdi
	mov rdi, [stdscr]
	call getmaxx
    dec rax
	mov [xmax], rax
	call getmaxy
    dec rax
	mov [ymax], rax

    call start_color

    ; COLOR_BLUE
    mov rdi, 1
    mov rsi, 4
    mov rdx, 4
    call init_pair

    ; COLOR_MAGENTA
    mov rdi, 2
    mov rsi, 5
    mov rdx, 5
    call init_pair

    call refresh
	call noecho

    mov rax, ' '
    or rax, 0x100
    mov [palette], rax

    mov rax, 2
    mov rdi, f
    mov rsi, 0
    syscall
    mov [rand], rax

    ;xor r9, r9
    ;xor r10, r10
    mov rbx, 2
    mov rax, [xmax]
    div rbx
    mov r9, rax
    mov rax, [ymax]
    div rbx
    mov r10, rax

    .loop:
        
        mov rdi, r10
        mov rsi, r9
        push r9
        push r10
        call move
        call refresh
        
        mov rax, 0 
        mov rdi, [rand]
        mov rsi, buffer
        mov rdx, 1
        syscall

        pop r10
        pop r9
        xor rax, rax
        xor rbx, rbx
        xor rdx, rdx
        mov al, [buffer]
        mov rbx, 3
        div rbx
        sub rdx, 1
        add r9, rdx
        xor rdx, rdx
        div rbx
        sub rdx, 1
        add r10, rdx

        cmp r9, 0
        jnl @f
        inc r9

        @@:
        cmp r9, [xmax]
        jle @f
        dec r9

        @@:
        cmp r10, 0
        jnl @f
        inc r10

        @@:
        cmp r10, [ymax]
        jle @f
        dec r10

        @@:
        push r10
        push r9
        mov rdi, 100000
        call usleep
        pop r9
        pop r10
        
        jmp .loop

