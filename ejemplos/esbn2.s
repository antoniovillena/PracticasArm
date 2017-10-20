      .if 1     // 0 for RPi1, 1 for RPi2 or RPi3
        .set    BASE,       0x3f000000
      .else
        .set    BASE,       0x20000000
      .endif
        .set    GPBASE,     BASE+0x200000
        .set    GPFSEL0,    0x00
        .set    GPSET0,     0x1c
.text
        ldr     r0, =GPBASE
/* guia bits           xx999888777666555444333222111000*/
        mov     r1, #0b00001000000000000000000000000000
        str     r1, [r0, #GPFSEL0]  @ Configura GPIO 9
/* guia bits           10987654321098765432109876543210*/
        mov     r1, #0b00000000000000000000001000000000
        str     r1, [r0, #GPSET0]   @ Enciende GPIO 9
infi:   b       infi