format ELF64

public _start
public exit
public print_symb

section '.bss' writable
  array db '&', 0xA
  place db 1
  
section '.text' executable
  _start:
     mov cl, 0
    .iter1:
      mov ch, -1
      .iter2:
        mov al, [array]
        push rcx
        call print_symb
        pop rcx
        inc ch
        cmp ch, cl
        jne .iter2
      mov al, [array+1]
      push rcx
      call print_symb
      pop rcx
      inc cl
      cmp cl, 17
      jne .iter1
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