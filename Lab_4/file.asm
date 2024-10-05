;Function exit 
exit:
    mov rax,1
    mov rbx,0
    int 0x80

;The function finds the length of a string
;input rax - place of memory of begin string
;output rax - length of the string
len_str:
  push rdx
  mov rdx, rax
  .iter:
      cmp byte [rax], 0
      je .next
      inc rax
      jmp .iter
  .next:
     sub rax, rdx
     pop rdx
     ret


;The function makes new line
new_line:
   push rax
   push rdi
   push rsi
   push rdx
   push rcx
   mov rax, 0xA
   push rax
   mov rdi, 1
   mov rsi, rsp
   mov rdx, 1
   mov rax, 1
   syscall
   pop rax
   pop rcx
   pop rdx
   pop rsi
   pop rdi
   pop rax
   ret

;The function prints minus
print_minus:
   push rax
   push rdi
   push rsi
   push rdx
   push rcx
   mov rax, '-'
   push rax
   mov rdi, 1
   mov rsi, rsp
   mov rdx, 1
   mov rax, 1
   syscall
   pop rax
   pop rcx
   pop rdx
   pop rsi
   pop rdi
   pop rax
   ret

;Function converting the string to the number
;input rsi - place of memory of begin string
;output rax - the number from the string
str_number:
    push rcx
    push rbx
    xor rcx,rcx
    xor r8, r8
    cmp byte [rsi], '-'
    jne     .loop
    mov     r8, 1
    inc     rcx
.loop:
    xor     rbx, rbx
    mov     bl, byte [rsi+rcx]
    cmp     bl, 48
    jl      .finished
    cmp     bl, 57
    jg      .finished

    sub     bl, 48
    add     rax, rbx
    mov     rbx, 10
    mul     rbx
    inc     rcx
    jmp     .loop

.finished:
    cmp     rcx, 0
    je .restore
    mov     rbx, 10
    div     rbx
    
.restore:
    pop rbx
    pop rcx
    cmp r8, 1
    jne .end
    neg rax
.end:
ret

;Function printing of string
;input rsi - place of memory of begin string
print_str:
    push rax
    push rdi
    push rdx
    push rcx
    push rbx
    mov rax, rsi
    call len_str
    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    syscall
    pop rbx
    pop rcx	
    pop rdx
    pop rdi
    pop rax
    ret

;Function printing of char
;input rax - char
print_char:
    push rdi
    push rsi
    push rdx
    push rcx
    push rbx
    push rax
    mov rsi, rsp
    mov rdx, 1
    mov rax, 1
    mov rdi, 1
    syscall
    pop rax
    pop rbx
    pop rcx	
    pop rdx
    pop rsi
    pop rdi
    ret

;Function printing of number
;input rax - place of memory of number
print_num:
    push rsi
    push rdi
    push rdx
    push rcx
    push rbx
    push rax
    cmp rax, 0
    jnl @f
    call print_minus
    neg rax
    @@:
    xor rbx, rbx
    mov rbx, 10
    xor rcx, rcx
    .div_loop:
        xor rdx, rdx
        div rbx
        add rdx, '0'
        push rdx
        inc rcx
        cmp rax, 0
        jne .div_loop
    .print_loop:
        xor rax, rax
        pop rax
        call print_char
        dec rcx
        cmp rcx, 0
        jne .print_loop
    pop rax
    pop rbx
    pop rcx	
    pop rdx
    pop rdi
    pop rsi
    ret

;Function reading of string
;input rsi - place of memory to place string, rdx - length
;output rsi
read:
    push rax
    push rdi
    push rdx
    push rcx
    push rbx
    mov rax, 0
    mov rdi, 0
    syscall
    pop rbx
    pop rcx	
    pop rdx
    pop rdi
    pop rax
    ret


;multiplication for 2 operands
macro mul2 op1, op2
{
    push rax
    push rbx
    mov rax, op1
    mov rbx, op2
    mul rbx
    mov op1, rax
    pop rbx
    pop rax
}