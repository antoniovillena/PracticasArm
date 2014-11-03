        .set    GPBASE,   0x20200000
        .set    GPFSEL0,  0x00
        .set    GPSET0,   0x1c
.text
        ldr     r0, =GPBASE
        ldr     r1, =0b00000000000000000000001001001001
/* guia bits 20..18    xx999888777666555444333222111000*/
        str     r1, [r0, #GPFSEL0]
/* guia bits 16 a 1    10987654321098765432109876543210*/
        mov     r1, #0b00000000000000000000000000000101
        str     r1, [r0, #GPSET0]
infi:   b       infi
