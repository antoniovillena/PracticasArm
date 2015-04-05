        .set    INPUT,      0b000
        .set    OUTPUT,     0b001
        .set    ALT0,       0b100
        .set    ALT1,       0b101
        .set    ALT2,       0b110
        .set    ALT3,       0b111
        .set    ALT4,       0b011
        .set    ALT5,       0b010
        .set    MASK,       0b111
        .set    GPBASE,     0x20200000
        .set    AUXBASE,    0x20215000
        .set    AMENABLES,  0x04
        .set    AMIOREG,    0x40
        .set    AMLCRREG,   0x4C
        .set    AMLSRREG,   0x54
        .set    AMBAUDREG,  0x68
.text
start:  bl      uart_init

bucle:  ldr     r0, =hello
        bl      uart_send_string
        bl      delay
        b       bucle

delay:  ldr     r2, =7000000
delay1: subs    r2, #1
        bne     delay1
        bx      lr

uart_send_string: @ void uart_send_string(char * string)
        push    {r4, lr}
        mov     r4, r0
uss1:   ldrb    r0, [r4], #1
        tst     r0, r0
        popeq   {r4, pc}
        bl      uart_send
        b       uss1

uart_send: @ void uart_send(int value)
        ldr     r1, =AUXBASE
us1:    ldr     r2, [r1, #AMLSRREG]
        tst     r2, #0x20
        beq     us1
        str     r0, [r1, #AMIOREG]
        bx      lr

uart_init: @ void uart_init()
        ldr     r0, =AUXBASE
        mov     r1, #1
        str     r1, [r0, #AMENABLES]
        mov     r1, #0x03
        str     r1, [r0, #AMLCRREG]
        ldr     r1, =270
        str     r1, [r0, #AMBAUDREG]
        mov     r0, #14
        mov     r1, #ALT5
        push    {r4, lr}
        bl      gpio_fsel
        pop     {r4, lr}
        mov     r0, #15

gpio_fsel: @ void gpio_fsel(int pin, int mode)
        ldr     r12, =GPBASE
gf1:    sub     r0, #10
        addcc   r12, #4
        bcc     gf1
        add     r0, #10
        add     r0, r0, lsl #1
        mov     r3, #MASK
        ldr     r2, [r12]
        bic     r2, r3, lsl r0
        orr     r2, r1, lsl r0
        str     r2, [r12]
        bx      lr

hello:  .asciz  "Hello World!\r\n"
