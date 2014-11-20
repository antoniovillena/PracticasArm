        .include  "inter.inc"
.text
        mov     r0, #0        @apunto tabla excepciones
        ADDEXC  0x18, irq_handler
        ldr     r0, =GPBASE
        ldr     r1, =0b00000000000000000000001001001001
        str     r1, [r0, #GPFSEL0]
        ldr     r0, =STBASE
        ldr     r1, [r0, #STCLO]
        add     r1, #0x400000   @4,19 segundos
        str     r1, [r0, #STC1]
        ldr     r0, =INTBASE
        mov     r1, #0b0010
        str     r1, [r0, #INTENIRQ1]
        mov     r0, #0x53     @modo SVC, IRQ activo
        msr     cpsr_c, r0
bucle:  b       bucle

irq_handler:
        push    {r0, r1}
        ldr     r0, =GPBASE
        mov     r1, #0b00000000000000000000000000000101
        str     r1, [r0, #GPSET0]
        pop     {r0, r1}
        subs    pc, lr, #4
