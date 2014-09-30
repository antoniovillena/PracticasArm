        .set    GPBASE,   0x20200000
        .set    GPFSEL1,  0x04
        .set    GPSET0,   0x1c
        .set    GPCLR0,   0x28
.text
        ldr     r0, =GPBASE
        ldr     r1, [r0, #GPFSEL1]
        bic     r1, #0b00000000000111000000000000000000
        orr     r1, #0b00000000000001000000000000000000
        str     r1, [r0, #GPFSEL1]
        mov     r1, #0b00000000000000010000000000000000
bucle:  ldr     r2, =375000000/2
ret1:   subs    r2, #1
        bne     ret1
        str     r1, [r0, #GPSET0]
        ldr     r2, =375000000/2
ret2:   subs    r2, #1
        bne     ret2
        str     r1, [r0, #GPCLR0]
        b       bucle
