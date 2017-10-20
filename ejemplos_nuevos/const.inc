        .if 1     // 0 for RPi1, 1 for RPi2 or RPi3
          .set    BASE,       0x3f000000
        .else
          .set    BASE,       0x20000000
        .endif
        .if 1
          .set    L1,              9
          .set    L2,             10
          .set    L3,             11
          .set    L4,             17
          .set    L5,             22
          .set    L6,             27
          .set    ALT,             4
          .set    S1,              2
          .set    S2,              3
        .else
          .set    L1,             19
          .set    L2,             16
          .set    L3,             12
          .set    L4,             13
          .set    L5,             20
          .set    L6,             21
          .set    ALT,            26
          .set    S1,              6
          .set    S2,              5
        .endif

        .set    GPBASE,         BASE+0x200000
        .set    STBASE,         BASE+0x003000
        .set    INTBASE,        BASE+0x00b000
        .set    GPSET0,         0x1c
        .set    GPCLR0,         0x28
        .set    GPLEV0,         0x34
        .set    GPEDS0,         0x40
        .set    GPEDS1,         0x44
        .set    GPFEN0,         0x58
        .set    GPFEN1,         0x5c
        .set    GPPUD,          0x94
        .set    GPPUDCLK0,      0x98
        .set    STCLO,          0x04
        .set    STC0,           0x0c
        .set    INTFIQCON,     0x20c
        .set    INTENIRQ1,     0x210

        .set    MASK,          0b111
        .set    INPUT,         0b000
        .set    OUTPUT,        0b001
        .set    FIQMODE,          17
        .set    IRQMODE,          18
        .set    SVCMODE,          19
        .set    IRQVECT,        0x18
        .set    FIQVECT,        0x1c
        .set    C1INT,             1
        .set    C3INT,             3
        .set    GPIOINT,          52
        .set    FIQ,               1
        .set    IRQ,               2
