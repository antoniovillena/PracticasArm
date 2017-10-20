      .if 1     // 0 for RPi1, 1 for RPi2 or RPi3
        .set    BASE,       0x3f000000
      .else
        .set    BASE,       0x20000000
      .endif
      .macro    ADDEXC  vector, dirRTI
        ldr     r1, =(\dirRTI-\vector+0xa7fffffb)
        ror     r1, #2
        str     r1, [r0, #\vector]
      .endm
        .set    GPBASE,         BASE+0x200000
        .set    STBASE,         BASE+0x003000
        .set    INTBASE,        BASE+0x00b000
        .set    GPFSEL0,        0x00
        .set    GPFSEL1,        0x04
        .set    GPFSEL2,        0x08
        .set    GPFSEL3,        0x0c
        .set    GPFSEL4,        0x10
        .set    GPFSEL5,        0x14
        .set    GPFSEL6,        0x18
        .set    GPSET0,         0x1c
        .set    GPSET1,         0x20
        .set    GPCLR0,         0x28
        .set    GPCLR1,         0x2c
        .set    GPLEV0,         0x34
        .set    GPLEV1,         0x38
        .set    GPEDS0,         0x40
        .set    GPEDS1,         0x44
        .set    GPFEN0,         0x58
        .set    GPFEN1,         0x5c
        .set    GPPUD,          0x94
        .set    GPPUDCLK0,      0x98
        .set    STCS,           0x00
        .set    STCLO,          0x04
        .set    STC1,           0x10
        .set    STC3,           0x18
        .set    INTFIQCON,     0x20c
        .set    INTENIRQ1,     0x210
        .set    INTENIRQ2,     0x214
      .if BASE==0x3f000000
        mov     r0, #0b11010011
        msr     spsr_cxsf, r0
        add     r0, pc, #4
        msr     elr_hyp, r0
        eret
      .endif
        mov     r0, #0
        mcr     p15, 0, r0, c12, c0, 0
