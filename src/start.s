.section .init
.globl _start
_start:
mov sp, #0xff0000
bl main
loop:
b loop
