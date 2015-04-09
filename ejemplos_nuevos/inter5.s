        .include  "const.inc"
.text
/* Agrego vectores de interrupción */
        mov     r0, #IRQVECT
        ldr     r1, =irq_handler
        bl      addexc
        mov     r0, #FIQVECT
        ldr     r1, =fiq_handler
        bl      addexc

/* Inicializo la pila en modos FIQ, IRQ y SVC */
        mov     r0, #FIQMODE
        mov     r1, #0x4000
        bl      putsp
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

/* Habilito C1 para IRQ */
        mov     r0, #C1INT
        bl      irq_enable

/* Habilito C3 para FIQ */
        mov     r0, #C3INT
        bl      fiq_enable

/* Habilito interrupciones globalmente */
        mov     r0, #IRQ+FIQ
        bl      int_globalenable

/* Repetir para siempre */
bucle:  b       bucle

/* Rutina de tratamiento de interrupción FIQ */
fiq_handler:
        push    {r0, r1, r2, r3, lr}

/* Hago sonar altavoz invirtiendo estado de bitson */
        ldr     r8, =bitson
        ldrb    r9, [r8]
        eors    r9, #1
        strb    r9, [r8]

/* Leo cuenta y luego elemento correspondiente en secuen */
        ldrb    r9, [r8, #1]
        ldr     r9, [r8, +r9, LSL #2]

/* Pongo estado altavoz según variable bitson */
        mov     r0, #ALT
        beq     fh1
        bl      gpio_clr
        b       fh2
fh1:    bl      gpio_set

/* Reseteo estado interrupción de C3 */
fh2:    mov     r0, #3
        bl      systim_clearmatch

/* Programo retardo según valor leído en array */
        bic     r0, r9, #0x00ff0000
        mov     r1, #3
        bl      systim_add

/* Salgo de la RTI */
        pop     {r0, r1, r2, r3, lr}
        subs    pc, lr, #4

/* Rutina de tratamiento de interrupción IRQ */
irq_handler:
        push    {r0, r1, r2, lr}

/* Ejecuto secuencia de LEDs */
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
        strb    r1, [r0], #-3     @ Escribo cuenta
        ldrb    r0, [r0, +r1, LSL #2] @ Leo secuencia
        bl      gpio_set

/* Reseteo estado interrupción de C1 */
        mov     r0, #1
        bl      systim_clearmatch

/* Programo siguiente interrupción en 500ms */
        ldr     r0, =500000
        mov     r1, #1
        bl      systim_add

/* Recupero registros y salgo */
        pop     {r0, r1, r2, lr}
        subs    pc, lr, #4

bitson: .byte   0             @ Bit 0 = Estado del altavoz
cuenta: .byte   1             @ Entre 1 y 6, LED a encender
secuen: .short  L6
        .short  716           @ Retardo para nota 6
        .short  L5
        .short  758           @ Retardo para nota 5
        .short  L4
        .short  851           @ Retardo para nota 4
        .short  L3
        .short  956           @ Retardo para nota 3
        .short  L2
        .short  1012          @ Retardo para nota 2
        .short  L1
        .short  1136          @ Retardo para nota 1
