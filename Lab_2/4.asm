format ELF64

public _start
public exit
public print_symb

section '.bss' writable
  number dq 4693338485
  summary dq 0
  place db 0
  
section '.text' executable
  _start:
    mov rax, [number]
    mov rbx, 10
    .iter1:
      xor rdx, rdx
      div rbx
      add [summary], rdx
      cmp rax, 0
      jne .iter1
    mov rax, [summary]
    xor rcx, rcx
    .iter2:
      xor rdx, rdx
      div ebx
      add dl, '0'
      push rdx
      inc cl
      cmp rax, 0
      jne .iter2
    .iter3:
      pop rdx
      push rcx
      call print_symb
      pop rcx
      dec cl
      cmp cl, 0
      jne .iter3
    mov [place], 0xA
    mov rsi, place
    mov dl, 1
    syscall
    call exit

print_symb:
  mov al, 1
  mov di, 1
  mov [place], dl
  mov rsi, place
  mov dl, 1
  syscall
  ret
    
exit:
  mov al, 60
  xor di, di
  syscall