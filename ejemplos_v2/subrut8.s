      .macro  abs
        tst     r0, r0
        negmi   r0, r0
      .endm

.data
var1:   .asciz  "%d\n"

.text
.global main
main:   push    {r4, lr}
        mov     r0, #1
        bl      abs
        mov     r1, r0
        ldr     r0, =var1
        bl      printf

        mov     r0, #-2
        bl      abs
        mov     r1, r0
        ldr     r0, =var1
        bl      printf

        mov     r0, #3
        bl      abs
        mov     r1, r0
        ldr     r0, =var1
        bl      printf

        mov     r0, #-4
        bl      abs
        mov     r1, r0
        ldr     r0, =var1
        bl      printf
        pop     {r4, lr}
        bx      lr

abs:    tst     r0, r0
        negmi   r0, r0
        bx      lr
