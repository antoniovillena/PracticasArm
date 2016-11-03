        .include  "inter.inc"
.text
/* Agrego vector interrupción */
        ADDEXC  0x18, irq_handler

/* Inicializo la pila en modos IRQ y SVC */
        mov     r0, #0b11010010   @ Modo IRQ, FIQ&IRQ desact
        msr     cpsr_c, r0
        mov     sp, #0x8000
        mov     r0, #0b11010011   @ Modo SVC, FIQ&IRQ desact
        msr     cpsr_c, r0
        mov     sp, #0x8000000

/* Configuro GPIOs 2 y 3 como salida */
        ldr     r0, =GPBASE
/* guia bits           xx999888777666555444333222111000*/
        ldr     r1, =0b00000000000000000000001001000000
        str     r1, [r0, #GPFSEL0]

/* Enciendo LEDs       10987654321098765432109876543210*/
        mov     r1, #0b00000000000000000000000000001100
        str     r1, [r0, #GPSET0]

        bl      pullup

/* Habilito pines GPIO 9 y 27 (botones) para interrupciones*/
        ldr     r0, =GPBASE
/* guia bits           10987654321098765432109876543210*/       
        ldr     r1, =0b00001000000000000000001000000000
        str     r1, [r0, #GPFEN0]

/* Habilito interrupciones, local y globalmente */
        ldr     r0, =INTBASE
/* guia bits           10987654321098765432109876543210*/               
        mov     r1, #0b00000000000100000000000000000000
        str     r1, [r0, #INTENIRQ2]
        mov     r0, #0b01010011     @modo SVC, IRQ activo
        msr     cpsr_c, r0

/* Repetir para siempre */
bucle:  b       bucle


/* Rutina de configuración de pullups */
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

/* Rutina de tratamiento de interrupción */
irq_handler:
        push    {r0, r1}
        ldr     r0, =GPBASE
/* Apago los dos LEDs rojos  54321098765432109876543210*/
        ldr     r1, =0b0000000000000000000000000001100
        str     r1, [r0, #GPCLR0]
/* Consulto si se ha pulsado el botón GPIO9 */
        ldr     r1, [r0, #GPEDS0]  @GPIO Status reg
        ands    r1, #0b00000000000000000000001000000000
/* Sí: Activo GPIO 2; No: Activo GPIO 3 */
        ldrne   r1, =0b0000000000000000000000000000100
        ldreq   r1, =0b0000000000000000000000000001000
        str     r1, [r0, #GPSET0]
/* Desactivo los dos flags GPIO pendientes de atención
   guia bits                 54321098765432109876543210*/
        ldr     r1, =0b00001000000000000000001000000000
        str     r1, [r0, #GPEDS0]
        pop     {r0, r1}
        subs    pc, lr, #4
