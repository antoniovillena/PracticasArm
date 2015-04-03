@        .set    INPUT,      0b000
@        .set    OUTPUT,     0b001
@        .set    ALT0,       0b100
@        .set    ALT1,       0b101
@        .set    ALT2,       0b110
@        .set    ALT3,       0b111
@        .set    ALT4,       0b011
        .set    ALT5,       0b010
        .set    MASK,       0b111
        .set    GPBASE,     0x20200000
        .set    AUXBASE,    0x20215000
        .set    AMENABLES,  0x04
        .set    AMIOREG,    0x40
        .set    AMLCRREG,   0x4C
        .set    AMLSRREG,   0x54
        .set    AMBAUDREG,  0x68
        .set    MBOXBASE,   0x2000B880
        .set    MBOXREAD,   0x00
        .set    MBOXSTATUS, 0x18
        .set    MBOXWRITE,  0x20
        .set    MBOX_PROP,  8
        .set    EMMC_BASE,            0x20300000
@        .set    EMMC_ARG2,            0x00
@        .set    EMMC_BLKSIZECNT,      0x04
@        .set    EMMC_ARG1,            0x08
@        .set    EMMC_CMDTM,           0x0C
@        .set    EMMC_RESP0,           0x10
@        .set    EMMC_RESP1,           0x14
@        .set    EMMC_RESP2,           0x18
@        .set    EMMC_RESP3,           0x1C
@        .set    EMMC_DATA,            0x20
@        .set    EMMC_STATUS,          0x24
@        .set    EMMC_CONTROL0,        0x28
@        .set    EMMC_CONTROL1,        0x2C
@        .set    EMMC_INTERRUPT,       0x30
@        .set    EMMC_IRPT_MASK,       0x34
@        .set    EMMC_IRPT_EN,         0x38
@        .set    EMMC_CONTROL2,        0x3C
@        .set    EMMC_CAPABILITIES_0,  0x40
@        .set    EMMC_CAPABILITIES_1,  0x44
@        .set    EMMC_FORCE_IRPT,      0x50
@        .set    EMMC_BOOT_TIMEOUT,    0x70
@        .set    EMMC_DBG_SEL,         0x74
@        .set    EMMC_EXRDFIFO_CFG,    0x80
@        .set    EMMC_EXRDFIFO_EN,     0x84
@        .set    EMMC_TUNE_STEP,       0x88
@        .set    EMMC_TUNE_STEPS_STD,  0x8C
@        .set    EMMC_TUNE_STEPS_DDR,  0x90
@        .set    EMMC_SPI_INT_SPT,     0xF0
        .set    EMMC_SLOTISR_VER,     0xFC

.text
start:  bl      uart_init
        bl      delay

        ldr     r0, =powon+MBOX_PROP
        mov     r1, #MBOX_PROP
        bl      mbox_write_read
        ldr     r1, [r0, #1*4-MBOX_PROP]
        cmp     r1, #0x80000000       @ MBOX_SUCCESS
        bne     error
        ldr     r1, [r0, #5*4-MBOX_PROP]
        tst     r1, r1                @ valid device id
        bne     error
        ldr     r1, [r0, #6*4-MBOX_PROP]
        cmp     r1, #1                @ power on
        bne     error
        ldr     r0, =EMMC_BASE
        ldr     r0, [r0, #EMMC_SLOTISR_VER]
        tst     r0, #0x00fe0000
        beq     error

        mov     r1, #4
        bl      uart_send_hex
        bl      uart_send_cr_lf
        mov     r0, #105
        bl      uart_send_hex_byte
        b       bucle

error:  ldr     r0, =0xe5505
        mov     r1, #4
        bl      uart_send_hex

bucle:  b       bucle

mbox_write_read: @ int mbox_write_read(int value, int compare)
        ldr     r2, =MBOXBASE
mbox:   ldr     r3, [r2, #MBOXSTATUS]
        tst     r3, #0x80000000       @ MBOX_FULL
        bne     mbox
        str     r0, [r2, #MBOXWRITE]
mbox1:  ldr     r3, [r2, #MBOXSTATUS]
        tst     r3, #0x40000000       @ MBOX_EMPTY
        bne     mbox1
        ldr     r3, [r2, #MBOXREAD]
        and     r3, #0x0000000f
        cmp     r3, r1
        bne     mbox1
        bx      lr

uart_send_hex_byte: @ void uart_send_hex_byte(int value)
        mov     r1, #1
uart_send_hex: @ void uart_send_hex(int value, int bytes)
        push    {r4, lr}
        mov     r3, r0
        mov     r4, r1, lsl #3
ush1:   mov     r0, r3, ror r4
        lsr     r0, #28
        cmp     r0, #10
        addcs   r0, #7
        add     r0, #'0'
        bl      uart_send
        subs    r4, #4
        bne     ush1
        pop     {r4, pc}

delay:  ldr     r2, =7000000
delay1: subs    r2, #1
        bne     delay1
        bx      lr

uart_send_cr_lf:
        mov     r0, #13
        mov     r3, lr
        bl      uart_send
        mov     lr, r3
        mov     r0, #10

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

        .balign 16

powon:  .word   8*4         @ size of this message
        .word   0           @ this is a request
        .word   0x00028001  @ set power state tag
        .word   8           @ value buffer size
        .word   8           @ is a request, value length = 8
        .word   0           @ device id and device id also returned here
        .word   3           @ set power on, wait for stable and returns state
        .word   0           @ closing tag
