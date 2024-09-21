format ELF64

public _start
public exit
public print_symb

section '.bss' writable
  string db 'dKGuxAlwQQtuoxTSEQhjxGKc'
  place db 1
  
section '.text' executable
  _start:
    mov cl, 23
    .iter:
      mov al, [string+rcx]
      push rcx
      call print_symb
      pop rcx
      dec cl
      cmp cl, -1
      jne .iter
    call exit

print_symb:
  push rax
  mov al, 1
  mov di, 1
  pop rdx
  mov [place], dl
  mov rsi, place
  mov dl, 1
  syscall
  ret
    
exit:
  mov al, 60
  xor di, di
  syscall