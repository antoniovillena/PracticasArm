.data
var1:   .asciz  "%d\012"

.text
.global main
main:   push    {r4, lr}
        mov     r4, #0
.L2:    mov     r1, r4
        ldr     r0, =var1
        add     r4, r4, #1
        bl      printf
        cmp     r4, #5
        bne     .L2
        pop     {r4, pc}
