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

/* Configuro los 6 LEDs y el altavoz como salida */
        mov     r1, #OUTPUT
        mov     r0, #L1
        bl      gpio_fsel
        mov     r0, #L2
        bl      gpio_fsel
        mov     r0, #L3
        bl      gpio_fsel
        mov     r0, #L4
        bl      gpio_fsel
        mov     r0, #L5
        bl      gpio_fsel
        mov     r0, #L6
        bl      gpio_fsel
        mov     r0, #ALT
        bl      gpio_fsel

/* Programo C1 y C3 para dentro de 2 microsegundos */
        mov     r0, #2
        mov     r1, #1
        bl      systim_add
        mov     r1, #3
        bl      systim_add

/* Habilito interrupciones, local y globalmente */
        mov     r0, #C1INT
        bl      irq_enable
        mov     r0, #C3INT
        bl      irq_enable
        mov     r0, #IRQ
        bl      int_globalenable

/* Repetir para siempre */
bucle:  b       bucle

/* Rutina de tratamiento de interrupción */
irq_handler:
        push    {r0, r1, r2, r3, r4, lr}

/* Leo origen de la interrupción */
        mov     r0, #1
        bl      systim_tst
        beq     sonido

/* Si es C1, ejecuto secuencia de LEDs */
        mov     r0, #L1
        bl      gpio_clr
        mov     r0, #L2
        bl      gpio_clr
        mov     r0, #L3
        bl      gpio_clr
        mov     r0, #L4
        bl      gpio_clr
        mov     r0, #L5
        bl      gpio_clr
        mov     r0, #L6
        bl      gpio_clr
        ldr     r0, =cuenta
        ldrb    r1, [r0]          @ Leo variable cuenta
        subs    r1, #1            @ Decremento
        moveq   r1, #6            @ Si es 0, volver a 6
        strb    r1, [r0]          @ Escribo cuenta
        ldrb    r0, [r0, +r1]     @ Leo secuencia
        bl      gpio_set

/* Reseteo estado interrupción de C1 */
        mov     r0, #1
        bl      systim_clearmatch

/* Programo siguiente interrupción en 200ms */
        ldr     r0, =200000
        mov     r1, #1
        bl      systim_add

/* ¿Hay interrupción pendiente en C3? */
        mov     r0, #3
        bl      systim_tst
        beq     final             @ Si no, salgo

/* Si es C3, hago sonar el altavoz */
sonido: ldr     r0, =bitson
        ldrb    r1, [r0]
        eors    r1, #1            @ Invierto estado
        strb    r1, [r0]
        mov     r0, #ALT
        beq     so1
        bl      gpio_clr
        b       so2
so1:    bl      gpio_set

/* Reseteo estado interrupción de C3 */
so2:    mov     r0, #3
        bl      systim_clearmatch

/* Programo interrupción para sonido de 440 Hz */
        ldr     r0, =1136         @ Contador para 440 Hz
        mov     r1, #3
        bl      systim_add

/* Recupero registros y salgo */
final:  pop     {r0, r1, r2, r3, r4, lr}
        subs    pc, lr, #4

bitson: .byte   0             @ Bit 0 = Estado del altavoz
cuenta: .byte   1             @ Entre 1 y 6, LED a encender
secuen: .byte   L6
        .byte   L5
        .byte   L4
        .byte   L3
        .byte   L2
        .byte   L1
