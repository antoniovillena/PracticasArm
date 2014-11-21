        .include  "inter.inc"
.text
        mov     r0, #0        @apunto tabla excepciones
        ADDEXC  0x18, irq_handler

        mov     r0, #0b11010010   @modo IRQ, FIQ&IRQ desact
        msr     cpsr_c, r0
        mov     sp, #0x8000
        mov     r0, #0b11010011   @modo SVC, FIQ&IRQ desact
        msr     cpsr_c, r0
        mov     sp, #0x8000000

        ldr     r0, =GPBASE
        ldr     r1, =0b00000000000000000000001001000000
        str     r1, [r0, #GPFSEL0]
        
        bl      pullup

/* Configura GPIO 9 y 27 para que provoquen int. flanco subida*/
        ldr     r0, =GPBASE
/* guia bits           10987654321098765432109876543210*/       
        ldr     r1, =0b00001000000000000000001000000000
        str     r1, [r0, #GPREN0]

        ldr     r0, =INTBASE
/* guia bits           10987654321098765432109876543210*/               
        mov     r1, #0b00000000000100000000000000000000
        str     r1, [r0, #INTENIRQ2]

        mov     r0, #0b01010011     @modo SVC, IRQ activo
        msr     cpsr_c, r0
bucle:  b       bucle


pullup:
        push    {lr}
/* Configura resistencias Pull-up en GPIO 9 y 27 */
        ldr     r0, =GPBASE
        mov     r1, #2
        str     r1, [r0, #GPPUD]

        bl      wait150ck 
/* guia bits           10987654321098765432109876543210*/       
        ldr     r1, =0b00001000000000000000001000000000
        str     r1, [r0, #GPPUDCLK0]
        bl      wait150ck

        mov     r1, #0
        str     r1, [r0, #GPPUD]
        pop     {pc}

wait150ck:
        mov     r1, #50
wait1:  subs    r1, #1
        bne     wait1
        bx      lr

irq_handler:
        push    {r0, r1, r2}
        ldr     r0, =GPBASE

/*Apaga los dos leds rojos*/
        ldr     r2, =0b0000000000000000000000000001100
        str     r2, [r0, #GPCLR0]
/*Consulta si se ha pulsado el boton GPIO9*/
        ldr     r2, [r0, #GPEDS0]  @GPIO Status reg
        ands    r2, #0b00000000000000000000001000000000
/*Si: Activa GPIO2; No: Activa GPIO3 */
        ldrne   r1, =0b0000000000000000000000000000100
        ldreq   r1, =0b0000000000000000000000000001000
        str     r1, [r0, #GPSET0]

/*Desactivo los dos flag GPIO pendientes de atencion*/
/* guia bits           10987654321098765432109876543210*/       
        ldr     r2, =0b00001000000000000000001000000000
        str     r2, [r0, #GPEDS0]
        pop     {r0, r1, r2}
        subs    pc, lr, #4
