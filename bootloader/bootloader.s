        .set    AUXBASE,    0x20215000
        .set    AMENABLES,  0x04
        .set    AMIOREG,    0x40
        .set    AMLCRREG,   0x4C
        .set    AMLSRREG,   0x54
        .set    AMBAUDREG,  0x68
        .set    GPBASE,     0x20200000
        .set    GPFSEL1,    0x04
        .set    GPLEV0,     0x34
        .set    GPPUD,      0x94
        .set    GPPUDCLK0,  0x98
        state   .req    r0
        recv    .req    r1
        send    .req    r1
        gpbas   .req    r2
        auxbas  .req    r2
        block   .req    r3
        addr    .req    r4
        crc     .req    r5
.text
inicio: mov     addr, #0x8200
        push    {r0-r2}
inici1: ldr     r1, [addr], #-4
        str     r1, [addr, #-4092]
        cmp     addr, #0x8000
        bne     inici1
        b       start-0x1000
start:  ldr     gpbas, tGPBAS
        mov     r1, #0b00000000000000010010000000000000
        str     r1, [gpbas, #GPFSEL1]
        mov     r1, #2
        str     r1, [gpbas, #GPPUD]
        bl      wait
        mov     r1, #0b0000000000010000
        str     r1, [gpbas, #GPPUDCLK0]
        bl      wait
        str     r0, [gpbas, #GPPUD]
        str     r0, [gpbas, #GPPUDCLK0]
        bl      wait
        mov     r1, #0b1100000000000000
        str     r1, [gpbas, #GPPUDCLK0]
        bl      wait
        str     r0, [gpbas, #GPPUDCLK0]
        ldr     r1, [gpbas, #GPLEV0]
        tst     r1, #0b00000010000
        beq     star2
star1:  ldr     r1, [addr, #final-inicio]
        str     r1, [addr], #4
        cmp     addr, #0x330000
        bne     star1
        b       star4
star2:  add     auxbas, #AUXBASE-GPBASE
        mov     block, #1
        str     block, [auxbas, #AMENABLES]
        mov     r1, #0x23
        str     r1, [auxbas, #AMLCRREG]
        add     r1, #270-0x23
        str     r1, [auxbas, #AMBAUDREG]
star3:  ldr     r1, [auxbas, #AMLSRREG]
        tst     r1, #1
        beq     star3
        ldr     recv, [auxbas, #AMIOREG]
        cmp     state, #1
        bcs     star5
        cmp     recv, #0x01
        moveq   crc, #0
        beq     stard
        cmp     recv, #0x04
        bne     star7
        mov     send, #0x06
        str     send, [auxbas, #AMIOREG]
star4:  subs    addr, #1
        bne     star4
        pop     {r0-r2}
        b       inicio+0x1000
star5:  bne     stara
        cmp     recv, block
star6:  beq     stard
star7:  mov     send, #0x15
star8:  mov     state, #0
star9:  ldr     r6, [auxbas, #AMLSRREG]
        tst     r6, #0x20
        beq     star9
        str     send, [auxbas, #AMIOREG]
        b       star3
stara:  cmp     state, #2
        bne     starb
        eor     lr, block, #0xff
        cmp     recv, lr
        b       star6
starb:  cmp     state, #131
        bne     starc
        cmp     recv, crc
        bne     star7
        mov     r1, #1
        uadd8   block, block, r1
        mov     send, #0x06
        b       star8
starc:  uadd8   crc, crc, recv
        strb    recv, [addr], #1
stard:  add     state, #1
        b       star3
wait:   mov     r1, #50
wait1:  subs    r1, #1
        bne     wait1
        bx      lr
tGPBAS: .word   GPBASE
final:
