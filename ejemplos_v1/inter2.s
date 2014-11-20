        .include  "inter.inc"
.text
        mov     r0, #0        @apunto tabla excepciones
        ADDEXC  0x18, irq_handler
        mov     r0, #0xd2     @modo IRQ, FIQ&IRQ desact
        msr     cpsr_c, r0
        mov     sp, #0x8000
        mov     r0, #0xd3     @modo SVC, FIQ&IRQ desact
        msr     cpsr_c, r0
        mov     sp, #0x8000000
        ldr     r0, =GPBASE
        ldr     r1, =0b00000000000000000000001001001001
        str     r1, [r0, #GPFSEL0]
        ldr     r1, =0b00000000001000000000000000001001
        str     r1, [r0, #GPFSEL1]
        mov     r1, #0b00000000000000000000000001000000
        str     r1, [r0, #GPFSEL2]
        ldr     r0, =STBASE
        ldr     r1, [r0, #STCLO]
        add     r1, #2
        str     r1, [r0, #STC1]
        ldr     r0, =INTBASE
        mov     r1, #0b0010
        str     r1, [r0, #INTENIRQ1]
        mov     r0, #0x53     @modo SVC, IRQ activo
        msr     cpsr_c, r0
bucle:  b       bucle

irq_handler:
        push    {r0, r1, r2}
        ldr     r0, =ledst
        ldr     r1, [r0]
        eors    r1, #1
        str     r1, [r0]
        ldr     r0, =GPBASE
        ldr     r1, =0b00000000010000100000110000001111
        streq   r1, [r0, #GPSET0]
        strne   r1, [r0, #GPCLR0]
        ldr     r0, =STBASE
        mov     r1, #0b0010
        str     r1, [r0, #STCS]
        ldr     r1, [r0, #STCLO]
        ldr     r2, =500000       @1 Hz
        add     r1, r2
        str     r1, [r0, #STC1]
        pop     {r0, r1, r2}
        subs    pc, lr, #4

ledst:  .word   0
