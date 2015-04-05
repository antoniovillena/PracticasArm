        .include  "const.inc"
.text
/* Agrego vector interrupción */
        mov     r0, #IRQVECT
        ldr     r1, =irq_handler
        bl      addexc

/* Inicializo la pila en modos IRQ y SVC */
        mov     r0, #IRQMODE
        mov     r1, #0x8000
        bl      putsp
        mov     r0, #SVCMODE
        mov     r1, #0x8000000
        bl      putsp

/* Configuro los 2 LEDs rojos como salida */
        mov     r1, #OUTPUT
        mov     r0, #L1
        bl      gpio_fsel
        mov     r0, #L2
        bl      gpio_fsel

/* Enciendo LEDs */
        mov     r0, #L1
        bl      gpio_set
        mov     r0, #L2
        bl      gpio_set

/* Habilito botones S1 y S2 para interrupciones*/
        mov     r0, #S1
        bl      gpio_fen
        mov     r0, #S2
        bl      gpio_fen

/* Habilito interrupciones, local y globalmente */
        mov     r0, #GPIOINT
        bl      int_enable
        mov     r0, #IRQ
        bl      int_setglobalmask

/* Repetir para siempre */
bucle:  b       bucle

/* Rutina de tratamiento de interrupción */
irq_handler:
        push    {r0, r1, r2, lr}

/* Apago LEDs */
        mov     r0, #L1
        bl      gpio_clr
        mov     r0, #L2
        bl      gpio_clr

/* Consulto si se ha pulsado el botón S1 */
        mov     r0, #S1
        bl      gpio_eds_tst

/* Sí: Activo L1; No: Activo L2 */
        movne   r0, #L1
        moveq   r0, #L2
        bl      gpio_set

/* Desactivo los dos flags GPIO pendientes de atención */
        mov     r0, #S1
        bl      gpio_eds_set
        mov     r0, #S2
        bl      gpio_eds_set
        pop     {r0, r1, r2, lr}
        subs    pc, lr, #4
