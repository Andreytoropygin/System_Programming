format elf64

public _start

extrn printf
extrn scanf
extrn atof

section '.data' writable
    input db "%lf", 0
    ftype db "%lf", 0xa, 0
    output db "%-10d%-10d%-10lf%-10lf", 0xa, 0
    header db "number    multiples cos       composition", 0xa, 0
    two dq 2.0

section '.bss' writable
    const rq 1
    cos rq 1
    composition rq 1
    precesion rq 1
    diff rq 1
    number rq 1
    count rq 1
    tttt rq 1

section '.text' executable
_start:
    
    finit  ;;инициализируем мат. сопроцессор
    fldpi  ;;загружаем pi в st0
    fld [two]
    fdiv st0, st1
    fstp [const] ;;выгружаем значение в ячейку памяти

    mov rdi, input
    mov rsi, precesion
    movq xmm0, rsi
    mov rax, 1
    call scanf

    mov rdi, header
    call printf

    mov [number], 1
    .loop:
        cmp [number], 6
        jg .end
        
        finit
        fild [number]
        fcos
        fstp [cos]

        mov [count], 0
        finit
        fld1
        fstp [composition]
        .loop2:
           ;;Загружаем данные в стековые регистры, выполняем вычитание
            finit
            fld [composition]
            fld [cos]
            fsub st0, st1
            fabs

            fstp [diff]

            finit
            fld [diff]
            fld [precesion]
            fcomip st0, st1     ;;сравнение разност с точностью
            ja .next

            inc [count]
            
            finit
            fild [count]
            fld [two]
            fmul st0, st1       ;;2n
        
            fld1
            fxch st1
            fsub st0, st1       ;;2n-1
        
            fild [number]
            fdiv st0, st1       ;;x/(2n-1)
        
            fld [const]
            fmul st0, st1       ;;2x/(2n-1)pi
        
            fld st0
            fmul st0, st1       ;; (2x/(2n-1)pi)^2

            fld1
            fsub st0, st1       ;; 1 - (2x/(2n-1)pi)^2
            
            fld [composition]
            fmul st0, st1
            fstp [composition]  ;; домножили

            jmp .loop2
  
        .next:
        mov rdi, output
        mov rsi, [number]
        mov rdx, [count]
        mov rax, 2
        movq xmm0, [cos]
        movq xmm1, [composition]
        call printf

        inc [number]
        jmp .loop


    .end:
    mov rax, 60
    syscall
