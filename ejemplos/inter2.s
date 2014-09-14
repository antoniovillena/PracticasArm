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
        .set    GPLEV0,         0x34
        .set    GPPUD,          0x94
        .set    GPPUDCLK0,      0x98
 
        ldr     r0, =GPBASE
        ldr     r1, =0b00000000000000000001000000001001
        str     r1, [r0, #GPFSEL0]
        ldr     r1, =0b00000000001000000000000000001001
        str     r1, [r0, #GPFSEL1]
        mov     r1, #0b00000000000000000000000001000000
        str     r1, [r0, #GPFSEL2]

        mov     r1, #2
        str     r1, [r0, #GPPUD]
        ldr     r1, =0b00000000001000000000001000000000
        str     r1, [r0, #GPPUDCLK0]

bucle:  ldr     r1, =0b00000000010000100000110000000011
        str     r1, [r0, #GPCLR0]
        ldr     r1, [r0, #GPLEV0]
        mov     r3, #0
        tst     r1, #0b00000000000000000000001000000000
        orrne   r3, #1
        tst     r1, #0b00000000001000000000000000000000
        orrne   r3, #2
        str     r3, [r0, #GPSET0]
        bl      cyc150
        b       bucle

cyc150: mov     r12, #50
cyc151: subs    r12, #1
        bne     cyc151
        bx      lr
