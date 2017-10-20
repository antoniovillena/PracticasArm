        .include  "const.inc"
.text
/* Agrego vector interrupción */
        bl      initex
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

/* Configuro los 6 LEDs como salida */
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

/* Programo contador C1 para dentro de 2 microsegundos */
        mov     r0, #2
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
        push    {r0, r1, r2, lr}

/* Conmuto variable de estado del LED */
        ldr     r0, =ledst    @ Leo puntero a v. ledst
        ldr     r1, [r0]      @ Leo variable
        eors    r1, #1        @ Invierto bit 0, act. flag Z
        str     r1, [r0]      @ Escribo variable
        bne     apago

        mov     r0, #L1
        bl      gpio_set
        mov     r0, #L2
        bl      gpio_set
        mov     r0, #L3
        bl      gpio_set
        mov     r0, #L4
        bl      gpio_set
        mov     r0, #L5
        bl      gpio_set
        mov     r0, #L6
        bl      gpio_set
        b       salgo

apago:  mov     r0, #L1
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

/* Reseteo estado interrupción de C1 */
salgo:  mov     r0, #1
        bl      systim_clearmatch

/* Programo siguiente interrupción medio segundo después */
        ldr     r0, =500000
        mov     r1, #1
        bl      systim_add

/* Recupero registros y salgo */
        pop     {r0, r1, r2, lr}
        subs    pc, lr, #4

/* Ubicación de la variable ledst */
ledst:  .word   0
