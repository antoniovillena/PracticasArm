      .macro    ADDEXC  par1, par2
        ldr     r1, =(\par2-\par1+0xA7FFFFFB)
        ror     r1, #2
        str     r1, [r0, #\par1]
      .endm
        .set    GPBASE,   0x20200000
        .set    GPFSEL0,        0x00
        .set    GPFSEL1,        0x04
        .set    GPFSEL2,        0x08
        .set    GPSET0,         0x1c
        .set    GPCLR0,         0x28
        .set    STBASE,   0x20003000
        .set    STCS,           0x00
        .set    STCLO,          0x04
        .set    STC1,           0x10
        .set    STC3,           0x18
        .set    INTBASE,  0x2000b000
        .set    INTENIRQ1,     0x210
.text
        mov     r0, #0        @apunto tabla excepciones
        ADDEXC  0x18, irq_handler
        mov     r0, #0xd2     @IRQ mode, FIQ&IRQ disable
        msr     cpsr_c, r0
        mov     sp, #0x8000
        mov     r0, #0xd3     @SVC mode, FIQ&IRQ disable
        msr     cpsr_c, r0
        mov     sp, #0x8000000
        ldr     r0, =GPBASE
        ldr     r1, =0b00000000000000000001001001001001
        str     r1, [r0, #GPFSEL0]
        ldr     r1, =0b00000000001000000000000000001001
        str     r1, [r0, #GPFSEL1]
        mov     r1, #0b00000000000000000000000001000000
        str     r1, [r0, #GPFSEL2]
        ldr     r0, =STBASE
        ldr     r1, [r0, #STCLO]
        add     r1, #2
        str     r1, [r0, #STC1]
        str     r1, [r0, #STC3]
        ldr     r0, =INTBASE
        mov     r1, #0b1010
        str     r1, [r0, #INTENIRQ1]
        mov     r0, #0x53     @SVC mode, IRQ enable
        msr     cpsr_c, r0
bucle:  b       bucle

irq_handler:
        push    {r0, r1, r2, r3}
        ldr     r0, =STBASE
        ldr     r1, =GPBASE
        ldr     r2, [r0, #STCS]
        ands    r2, #0b0010
        beq     sonido
        ldr     r2, =cuenta
        ldr     r3, =0b00000000010000100000110000001111
        str     r3, [r1, #GPCLR0]
        ldr     r3, [r2]          @cuenta
        subs    r3, #1
        movmi   r3, #5
        str     r3, [r2], #4      @cuenta
        ldr     r3, [r2, +r3, LSL #2]
        str     r3, [r1, #GPSET0]
        mov     r3, #0b0010
        str     r3, [r0, #STCS]
        ldr     r3, [r0, #STCLO]
        ldr     r2, =200000       @5 Hz
        add     r3, r2
        str     r3, [r0, #STC1]
        ldr     r3, [r0, #STCS]
        ands    r3, #0b0100
        beq     final
sonido: ldr     r2, =bitson
        ldr     r3, [r2]
        eors    r3, #1
        str     r3, [r2]
        mov     r3, #0b10000      @altavoz
        streq   r3, [r1, #GPSET0]
        strne   r3, [r1, #GPCLR0]
        mov     r3, #0b1000
        str     r3, [r0, #STCS]
        ldr     r3, [r0, #STCLO]
        ldr     r2, =1136         @440 Hz
        add     r3, r2
        str     r3, [r0, #STC3]
final:  pop     {r0, r1, r2, r3}
        subs    pc, lr, #4

bitson: .word   0
cuenta: .word   0
secuen: .word   0b00000000000100000000000
        .word   0b00000000000010000000000
        .word   0b10000000000000000000000
        .word   0b00000100000000000000000
        .word   0b00000000000000000001010
        .word   0b00000000000000000000101
