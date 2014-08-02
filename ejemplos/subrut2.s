.data

var1:   .asciz  "%d\n"
seed:   .word   1
const1: .word   1103515245
const2: .word   12345

.text

.global main
main:   push    {r4, r5}
        mov     r0, #42
        bl      mysrand
        mov     r4, #5
bucle:  bl      myrand
        mov     r1, r0
        ldr     r0, =var1
        bl      printf
        subs    r4, r4, #1
        bne     bucle
        pop     {r4, r5}
        bx      lr

myrand: ldr     r1, =seed
        ldr     r0, [r1]
        ldr     r2, [r1, #4]
        mul     r3, r0, r2
        ldr     r0, [r1, #8]
        add     r0, r0, r3
        str     r0, [r1]
        mov     r0, r0, LSL #1
        mov     r0, r0, LSR #17
        bx      lr

mysrand:ldr     r1, =seed
        str     r0, [r1]
        bx      lr
