# gpio0  led1
# gpio1  led2
# gpio17 led3
# gpio22 led4
# gpio10 led5
# gpio11 led6
# gpio4  buzzer
# gpio21 button1
# gpio9  button2

        .set    GPBASE,   0x20200000
        .set    GPFSEL0,        0x00
        .set    GPFSEL1,        0x04
        .set    GPFSEL2,        0x08
        .set    GPSET0,         0x1c
        .set    GPCLR0,         0x28
        .set    TIMERBASE,0x2000B400
        .set    TIMER_CTL,      0x08
        .set    TIMER_CNT,      0x20

        ldr     r0, =GPBASE
        ldr     r1, =0b00000000000000000001000000001001
        str     r1, [r0, #GPFSEL0]
        ldr     r1, =0b00000000001000000000000000001001
        str     r1, [r0, #GPFSEL1]
        mov     r1, #0b00000000000000000000000001000000
        str     r1, [r0, #GPFSEL2]
        ldr     r2, =TIMERBASE
        ldr     r3, =0x00f90200
        str     r3, [r2, #TIMER_CTL]

bucle:  ldr     r1, =0b00000000000000000000001
        bl      secuen
        ldr     r1, =0b00000000000000000000010
        bl      secuen
        ldr     r1, =0b00000100000000000000000
        bl      secuen
        ldr     r1, =0b10000000000000000000000
        bl      secuen
        ldr     r1, =0b00000000000010000000000
        bl      secuen
        ldr     r1, =0b00000000000100000000000
        bl      secuen
        b       bucle

secuen: str     r1, [r0, #GPSET0]
        ldr     r3, [r2, #TIMER_CNT]
        ldr     r4, =200000
        add     r4, r3
ret1:   ldr     r3, [r2, #TIMER_CNT]
        cmp     r3, r4
        bne     ret1
        ldr     r1, =0b00000000010000100000110000000011
        str     r1, [r0, #GPCLR0]
        bx      lr
