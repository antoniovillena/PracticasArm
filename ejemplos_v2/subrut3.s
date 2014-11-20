.data
var1:   .asciz  "%d\n"

.text
.global main
main:   push    {r4, lr}
        mov     r4, #0
bucle:  mov     r0, r4
        bl      fibo
        mov     r1, r0
        ldr     r0, =var1
        bl      printf
        add     r4, r4, #1
        cmp     r4, #10
        bne     bucle
        pop     {r4, lr}
        bx      lr

        .equ    local1,   0
        .equ    local2,   4+local1
        .equ    local3,   4+local2
        .equ    length,   4+local3

fibo:   push    {lr}
        sub     sp, #length
        cmp     r0, #2
        movlo   r0, #1
        blo     fib1
        sub     r0, #1
        str     r0, [sp, #local1]
        bl      fibo
        str     r0, [sp, #local2]
        ldr     r0, [sp, #local1]
        sub     r0, #1
        bl      fibo
        ldr     r1, [sp, #local2]
        add     r0, r1
fib1:   add     sp, #length
        pop     {lr}
        bx      lr
