        .include  "inter.inc"
.text
        ldr     r0, =GPBASE
/* guia bits           xx999888777666555444333222111000*/
        mov     r1, #0b00000000000001000000000000000000
        str     r1, [r0, #GPFSEL1]
/* guia bits           xx999888777666555444333222111000*/
        mov     r1, #0b00000000001000000000000000000000
        str     r1, [r0, #GPFSEL4]
        mov     r1, #2
        str     r1, [r0, #GPPUD]
        bl      wait
/* guia bits           10987654321098765432109876543210*/
        mov     r1, #0b00000000000001000000000000000100
        str     r1, [r0, #GPPUDCLK0]
        bl      wait
        mov     r1, #0
        str     r1, [r0, #GPPUD]
        str     r1, [r0, #GPPUDCLK0]
/* guia bits           10987654321098765432109876543210*/
        mov     r2, #0b00000000000000010000000000000000
/* guia bits           32109876543210987654321098765432*/
        mov     r3, #0b00000000000000001000000000000000
bucle:  str     r2, [r0, #GPCLR0]   @ apago GPIO 16
        str     r3, [r0, #GPCLR1]   @ apago GPIO 47
        ldr     r1, [r0, #GPLEV0]
/* guia bits           10987654321098765432109876543210*/
        tst     r1, #0b00000000000001000000000000000100
        streq   r2, [r0, #GPSET0]   @ enciendo GPIO 16
        streq   r3, [r0, #GPSET1]   @ enciendo GPIO 47
        b       bucle

wait:   mov     r1, #50
wait1:  subs    r1, #1
        bne     wait1
        bx      lr
