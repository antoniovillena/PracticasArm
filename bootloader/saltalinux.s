        .set    GPBASE,     0x20200000
        .set    GPFSEL1,    0x04
.text
inicio: mov     r4, #0x8100
inici1: ldr     r3, [r4], #-4
        str     r3, [r4, #4-0x100]
        cmp     r4, #0x8000
        bne     inici1
        b       start-0x100
start:  ldr     r3, [r4, #296]
        str     r3, [r4], #4
        cmp     r4, #0x330000
        bne     start
        ldr     r3, =GPBASE
        str     r11, [r3, #GPFSEL1]
        b       inicio+0x100
