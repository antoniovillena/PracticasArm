.data

var1:   .asciz  "La suma es %lld\n"
var2:   .word   1600000000, -100, 800000000, -50, 200

.text
.global main

main:   push    {r4, r5, r6, lr}
        mov     r5, #5
        mov     r2, #0
        mov     r3, #0
        ldr     r4, =var2
bucle:  ldr     r0, [r4], #4
        mov     r1, r0, ASR #31
        adds    r2, r2, r0
        adc     r3, r3, r1
        subs    r5, r5, #1
        bne     bucle
        ldr     r0, =var1
        bl      printf
        pop     {r4, r5, r6, lr}
        bx      lr
