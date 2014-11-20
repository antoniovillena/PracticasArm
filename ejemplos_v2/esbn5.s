        .set    GPBASE,   0x20200000
        .set    GPFSEL0,        0x00
        .set    GPSET0,         0x1c
        .set    GPCLR0,         0x28
        .set    STBASE,   0x20003000
        .set    STCLO,          0x04
.text
        ldr     r0, =GPBASE
/* guia bits           xx999888777666555444333222111000*/
        mov     r1, #0b00001000000000000000000000000000
        str     r1, [r0, #GPFSEL0]
/* guia bits           10987654321098765432109876543210*/
        mov     r1, #0b00000000000000000000001000000000
        ldr     r2, =STBASE
bucle:  bl      espera
        str     r1, [r0, #GPSET0]
        bl      espera
        str     r1, [r0, #GPCLR0]
        b       bucle

/* rutina que espera medio segundo */
espera: ldr     r3, [r2, #STCLO]
        ldr     r4, =500000
        add     r4, r3
ret1:   ldr     r3, [r2, #STCLO]
        cmp     r3, r4
        bne     ret1
        bx      lr
