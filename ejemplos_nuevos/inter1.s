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

/* Configuro LED 1 (rojo) como salida */
        mov     r0, #L1
        mov     r1, #OUTPUT
        bl      gpio_fsel

/* Programo contador C1 para futura interrupción */
        ldr     r0, =4000000
        mov     r1, #1
        bl      systim_add

/* Habilito interrupciones, local y globalmente */
        mov     r0, #C1INT
        bl      irq_enable
        mov     r0, #IRQ
        bl      int_globalenable

/* Repetir para siempre */
bucle:  b       bucle

/* Rutina de tratamiento de interrupción */
irq_handler:
        push    {r0, r1}          @ Salvo registros

        mov     r0, #L1
        bl      gpio_set

        pop     {r0, r1}          @ Recupero registros
        subs    pc, lr, #4        @ Salgo de la RTI
