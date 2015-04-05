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
        .set    EMMC_STATUS,          0x24
@        .set    EMMC_CONTROL0,        0x28
        .set    EMMC_CONTROL1,        0x2C
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

        mrc     p15, 0, r0, c1, c0, 2
        orr     r0, #0x300000             @ single precision
        mcr     p15, 0, r0, c1, c0, 2
        mov     r0, #0x40000000
        fmxr    fpexc, r0

        ldr     r0, =powon+MBOX_PROP
        mov     r1, #MBOX_PROP
        bl      mbox_write_read
        ldr     r4, [r0, #1*4-MBOX_PROP]
        cmp     r4, #0x80000000       @ MBOX_SUCCESS
        bne     error
        ldr     r4, [r0, #5*4-MBOX_PROP]
        tst     r4, r4                @ valid device id
        bne     error
        ldr     r4, [r0, #6*4-MBOX_PROP]
        cmp     r4, #1                @ power on
        bne     error
        ldr     r5, =EMMC_BASE
        ldr     r4, [r5, #EMMC_SLOTISR_VER]
        tst     r4, #0x00fe0000                         @ check version>=2
        beq     error
        mov     r4, #0b00000001000000000000000000000000 @ reset controller
        str     r4, [r5, #EMMC_CONTROL1]
        bl      delay
        ldr     r4, [r5, #EMMC_CONTROL1]
        tst     r4, #0b00000111000000000000000000000000 @ controller did not reset properly
        bne     error
        ldr     r4, [r5, #EMMC_STATUS]
        tst     r4, #0b00000000000000010000000000000000 @ checking for an inserted card
        beq     error
@        mov     r4, #0                                  @ Clear control2
@        str     r4, [r5, #EMMC_CONTROL2]
        ldr     r0, =bclock+MBOX_PROP
        bl      mbox_write_read
        ldr     r4, [r0, #1*4-MBOX_PROP]
        cmp     r4, #0x80000000       @ MBOX_SUCCESS
        bne     error
        ldr     r4, [r0, #5*4-MBOX_PROP]
        cmp     r4, #1                @ valid device id
        bne     error
        ldr     r0, [r0, #6*4-MBOX_PROP]
        ldr     r1, =400000
        vmov    s0, r0            @ s0 <- r0 (bit copy)
        vmov    s1, r1            @ s1 <- r1 (bit copy)
        vcvt.f32.s32 s0, s0       @ s0 <- (float)s0
        vcvt.f32.s32 s1, s1       @ s1 <- (float)s1
        vdiv.f32 s0, s0, s1       @ s0 <- s0 / s1
        vcvt.s32.f32 s0, s0       @ s0 <- (int)s0
        vmov    r0, s0            @ r0 <- s0 (bit copy). Now r0 is Q
        mov     r1, #31
star1:  sub     r1, #1
        lsls    r0, #1
        bcc     star1
        addne   r1, #1
        mov     r0, #1
        lsl     r0, r1
        and     r1, r0, #0xff
        lsr     r0, #8
        add     r0, r1, lsl #2
        ldr     r1, =0x00070001
        add     r1, r0, lsl #6
        str     r1, [r5, #EMMC_CONTROL1]
        bl      delay
        ldr     r0, [r5, #EMMC_CONTROL1]
        tst     r0, #0b10
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

bclock: .word   8*4         @ size of this message
        .word   0           @ this is a request
        .word   0x00030002  @ get clock rate tag
        .word   8           @ value buffer size
        .word   4           @ is a request, value length = 4
        .word   1           @ clock id + space to return clock id
brate:  .word   0           @ space to return rate (in Hz)
        .word   0           @ closing tag
