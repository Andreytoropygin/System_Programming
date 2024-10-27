asm: myqueue.asm
		fasm myqueue.asm

c: asm test.c
		gcc -no-pie test.c myqueue.o -o myprog

run: c myprog
		./myprog
