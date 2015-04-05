        .include  "const.inc"
.text
        mov     r0, #L1
        mov     r1, #OUTPUT
        bl      gpio_fsel

bucle:  ldr     r0, =500000
        bl      usleep
        mov     r0, #L1
        bl      gpio_set
        ldr     r0, =500000
        bl      usleep
        mov     r0, #L1
        bl      gpio_clr
        b       bucle
