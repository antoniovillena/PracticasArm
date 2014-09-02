        .set    GPBASE,   0x20200000
        .set    GPFSEL1,  0x04
        .set    GPSET0,   0x1c
        .set    GPCLR0,   0x28

        ldr     r0, =GPBASE
        ldr     r1, [r0, #GPFSEL1]
        bic     r1, #0b00000000000111000000000000000000
/* guia bits 20..18    xx999888777666555444333222111000*/
        orr     r1, #0b00000000000001000000000000000000
        str     r1, [r0, #GPFSEL1]
/* guia bits 16 a 1    10987654321098765432109876543210*/
        mov     r1, #0b00000000000000010000000000000000
        str     r1, [r0, #GPCLR0]
infi:   b       infi
