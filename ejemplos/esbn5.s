        .set    GPBASE,   0x20200000
        .set    GPFSEL1,        0x04
        .set    GPSET0,         0x1c
        .set    GPCLR0,         0x28
        .set    TIMERBASE,0x2000B400
        .set    TIMER_CTL,      0x08
        .set    TIMER_CNT,      0x20

        ldr     r0, =GPBASE
        ldr     r1, [r0, #GPFSEL1]
        bic     r1, #0b00000000000111000000000000000000
        orr     r1, #0b00000000000001000000000000000000
        str     r1, [r0, #GPFSEL1]
        mov     r1, #0b00000000000000010000000000000000
        ldr     r2, =TIMERBASE
        ldr     r3, =0x00f90200
        str     r3, [r2, #TIMER_CTL]
bucle:  bl      espera
        str     r1, [r0, #GPSET0]
        bl      espera
        str     r1, [r0, #GPCLR0]
        b       bucle

/* rutina que espera medio segundo */
espera: ldr     r3, [r2, #TIMER_CNT]
        ldr     r4, =500000
        add     r4, r3
ret1:   ldr     r3, [r2, #TIMER_CNT]
        cmp     r3, r4
        bne     ret1
        bx      lr
