        .set    GPBASE,   0x20200000
        .set    GPFSEL0,        0x00
        .set    GPFSEL1,        0x04
        .set    GPFSEL2,        0x08
        .set    GPSET0,         0x1c
        .set    GPCLR0,         0x28
        .set    GPEDS0,         0x40
        .set    GPREN0,         0x58
        .set    GPPUD,          0x94
        .set    GPPUDCLK0,      0x98
        .set    STBASE,   0x20003000
        .set    STCS,           0x00
        .set    STCLO,          0x04
        .set    STC1,           0x10
        .set    STC3,           0x18
        .set    INTBASE,  0x2000b000
        .set    INTFIQCON,     0x20c
        .set    INTENIRQ2,     0x214
.text
        mov     r0, #0x18     @IRQ vector
        ldr     r1, =irq_handler
        bl      add_exception
        mov     r0, #0x1c     @FIQ vector
        ldr     r1, =fiq_handler
        bl      add_exception
        mov     r0, #0xd1     @FIQ mode, FIQ&IRQ disable
        msr     cpsr_c, r0
        mov     sp, #0x4000
        mov     r0, #0xd2     @IRQ mode, FIQ&IRQ disable
        msr     cpsr_c, r0
        mov     sp, #0x8000
        mov     r0, #0xd3     @SVC mode, FIQ&IRQ disable
        msr     cpsr_c, r0
        mov     sp, #0x8000000
        ldr     r0, =GPBASE
        mov     r1, #0b00000000000000000001001001000000
        str     r1, [r0, #GPFSEL0]
        ldr     r1, =0b00000000001000000000000000001001
        str     r1, [r0, #GPFSEL1]
        mov     r1, #0b00000000000000000000000001000000
        str     r1, [r0, #GPFSEL2]
        mov     r1, #0b00000000000000000000100
        str     r1, [r0, #GPSET0]
        mov     r1, #2
        str     r1, [r0, #GPPUD]
        bl      wait
        ldr     r1, =0b00001000000000000000001000000000
        str     r1, [r0, #GPPUDCLK0]
        bl      wait
        mov     r2, #0
        str     r2, [r0, #GPPUD]
        str     r1, [r0, #GPREN0]
        ldr     r0, =STBASE
        ldr     r1, [r0, #STCLO]
        add     r1, #2
        str     r1, [r0, #STC1]
        ldr     r0, =INTBASE
        mov     r1, #0b00000000000100000000000000000000
        str     r1, [r0, #INTENIRQ2]
        mov     r1, #0x80 | 1
        str     r1, [r0, #INTFIQCON]
        mov     r0, #0x13     @SVC mode, FIQ&IRQ enable
        msr     cpsr_c, r0
bucle:  b       bucle

wait:   mov     r2, #50
wait1:  subs    r2, #1
        bne     wait1
        bx      lr

add_exception:
        sub     r1, r0
        lsr     r1, #2
        sub     r1, #2
        orr     r1, #0xea000000
        str     r1, [r0]
        bx      lr

fiq_handler:
        ldr     r8, =GPBASE
        ldr     r9, =bitson
        ldr     r10, [r9]
        eors    r10, #1
        str     r10, [r9], #4
        ldr     r10, [r9], #8
        ldr     r9, [r9, +r10, LSL #3]
        mov     r10, #0b10000   @altavoz
        streq   r10, [r8, #GPSET0]
        strne   r10, [r8, #GPCLR0]
        ldr     r8, =STBASE
        mov     r10, #0b0010
        str     r10, [r8, #STCS]
        ldr     r10, [r8, #STCLO]
        add     r10, r9
        str     r10, [r8, #STC1]
        subs    pc, lr, #4

irq_handler:
        push    {r0, r1, r2}
        ldr     r0, =GPBASE
        ldr     r1, =cuenta
        ldr     r2, =0b00000000010000100000110000001100
        str     r2, [r0, #GPCLR0]
        ldr     r2, [r0, #GPEDS0]
        ands    r2, #0b00000000000000000000001000000000
        beq     incre
        str     r2, [r0, #GPEDS0]
        ldr     r2, [r1]        @cuenta
        subs    r2, #1
        movmi   r2, #5
        b       conti
incre:  mov     r2, #0b00001000000000000000000000000000
        str     r2, [r0, #GPEDS0]
        ldr     r2, [r1]        @cuenta
        add     r2, #1
        cmp     r2, #6
        moveq   r2, #0
conti:  str     r2, [r1], #4    @cuenta
        ldr     r2, [r1, +r2, LSL #3]
        str     r2, [r0, #GPSET0]
        pop     {r0, r1, r2}
        subs    pc, lr, #4

bitson: .word   0
cuenta: .word   0
secuen: .word   0b00000000000100000000000
        .word   716
        .word   0b00000000000010000000000
        .word   758
        .word   0b10000000000000000000000
        .word   851
        .word   0b00000100000000000000000
        .word   956
        .word   0b00000000000000000001000
        .word   1012
        .word   0b00000000000000000000100
        .word   1136
