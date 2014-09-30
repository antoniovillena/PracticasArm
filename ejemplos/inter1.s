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
        .set    INTBASE,  0x2000b000
        .set    INTENIRQ1,     0x210
.text
        mov     r0, #0x18     @IRQ vector
        ldr     r1, =irq_handler
        bl      add_exception
        mov     r0, #0xd2     @IRQ mode, FIQ&IRQ disable
        msr     cpsr_c, r0
        mov     sp, #0x8000
        mov     r0, #0xd3     @SVC mode, FIQ&IRQ disable
        msr     cpsr_c, r0
        mov     sp, #0x8000000
        ldr     r0, =GPBASE
        mov     r1, #0b00000000000000000000001001000000
        str     r1, [r0, #GPFSEL0]
        ldr     r1, =0b00000000001000000000000000001001
        str     r1, [r0, #GPFSEL1]
        mov     r1, #0b00000000000000000000000001000000
        str     r1, [r0, #GPFSEL2]


        ldr     r0, =STBASE
        ldr     r1, [r0, #STCLO]
        add     r1, #1
        str     r1, [r0, #STC1]

        ldr     r0, =INTBASE
        mov     r1, #0b0010
        str     r1, [r0, #INTENIRQ1]
        mov     r0, #0x53     @SVC mode, IRQ enable
        msr     cpsr_c, r0
bucle:  b       bucle

add_exception:
        sub     r1, r0
        lsr     r1, #2
        sub     r1, #2
        orr     r1, #0xea000000
        str     r1, [r0]
        bx      lr

irq_handler:
        push    {r0, r1, r2}
        ldr     r0, =ledst
        ldr     r1, [r0]
        eors    r1, #1
        str     r1, [r0]
        ldr     r0, =GPBASE
        ldr     r1, =0b00000000010000100000110000001100
        streq   r1, [r0, #GPSET0]
        strne   r1, [r0, #GPCLR0]
        ldr     r0, =STBASE
        ldr     r1, [r0, #STCLO]
        ldr     r2, =500000       @1 Hz
        add     r1, r2
        str     r1, [r0, #STC1]
        mov     r1, #0b0010
        str     r1, [r0, #STCS]
        pop     {r0, r1, r2}
        subs    pc, lr, #4

ledst:  .word   0
