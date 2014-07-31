.data

matriz: .hword    0,    1,    2,    3,    4,    5
        .hword 0x10, 0x11, 0x12, 0x13, 0x14, 0x15
        .hword 0x20, 0x21, 0x22, 0x23, 0x24, 0x25
        .hword 0x30, 0x31, 0x32, 0x33, 0x34, 0x35
suma:   .hword 0
var1:   .asciz  "La suma es %d\n"

.text
.global main

main:   push    {r4, r5, r6, lr}

        /* comienza el ejemplo de código */

        mov     r1, #0
        ldr     r2, =matriz

        ...

        ldr     r0, =var1
        ldr     r1, =suma
        bl      printf
        pop     {r4, r5, r6, lr}
        bx      lr
