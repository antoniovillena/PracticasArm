.data

var1:   .asciz  "%d\012"
var2:   .word   128, 32, 100, -30, 124

.text
.global main
 
main:   push    {r4, lr}
        ldr     lr, =var2
        ldmia   lr, {r0, r1, r2, r3, r4}
        add     r1, r0, r1
        add     r1, r1, r2
        add     r1, r1, r3
        add     r1, r1, r4
        ldr     r0, =var1
        pop     {r4, lr}
        b       printf
