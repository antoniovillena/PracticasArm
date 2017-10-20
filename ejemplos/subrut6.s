.data
var1:   .asciz  "%d\n"

.text
.global main
main:   push    {r4, lr}

/* Primera llamada poly3(1, 2, 3, 4, 5) */
        mov     r0, #1
        mov     r1, #2
        mov     r2, #3
        mov     r3, #4
        mov     r4, #5
        push    {r4}
        bl      poly3
        add     sp, #4
        mov     r1, r0
        ldr     r0, =var1
        bl      printf

/* Segunda llamada poly3(1, -1, 1, -1, 8) */
        mov     r0, #1
        mov     r1, #-1
        mov     r2, #1
        mov     r3, #-1
        mov     r4, #8
        push    {r4}
        bl      poly3
        add     sp, #4
        mov     r1, r0
        ldr     r0, =var1
        bl      printf

/* Tercera llamada poly3(2, 0, 0, 0, 8) */
        mov     r0, #2
        mov     r1, #0
        mov     r2, #0
        mov     r3, #0
        mov     r4, #8
        push    {r4}
        bl      poly3
        add     sp, #4
        mov     r1, r0
        ldr     r0, =var1
        bl      printf
        pop     {r4, lr}
        bx      lr

        .equ    param5,   4*1  /* r4 */

poly3:  sub     sp, #4
        ldr     r12, [sp, #param5]
        smlabb  r3, r2, r12, r3
        smulbb  r2, r12, r12
        smlabb  r3, r1, r2, r3
        smulbb  r2, r2, r12
        smlabb  r0, r0, r2, r3
        add     sp, #4
        bx      lr
