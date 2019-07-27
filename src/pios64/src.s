.section .init
.globl _start
_start:
ldr x0,=0x3f200000

// Select LED as output
mov w1, #1
lsl w1, w1, #27
str w1, [x0, #8]

// Turn LED on
mov w1, #1
lsl w1, w1, #29
str w1, [x0, #0x28]

// Loop forever, flash LED
loop:
bl delay
str w1, [x0, #0x1c]
bl delay
str w1, [x0, #0x28]
b loop

// Delay for 500,000 cycles
delay:
ldr w2,=2000000
delay_lp:
subs w2, w2, #1
b.gt delay_lp
ret

