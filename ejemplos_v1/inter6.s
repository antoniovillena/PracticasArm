        .include  "inter.inc"
.text
/* Agrego vectores de interrupción */
        ADDEXC  0x18, irq_handler
        ADDEXC  0x1c, fiq_handler

/* Inicializo la pila en modos FIQ, IRQ y SVC */
        mov     r0, #0b11010001   @ Modo FIQ, FIQ&IRQ desact
        msr     cpsr_c, r0
        mov     sp, #0x4000
        mov     r0, #0b11010010   @ Modo IRQ, FIQ&IRQ desact
        msr     cpsr_c, r0
        mov     sp, #0x8000
        mov     r0, #0b11010011   @ Modo SVC, FIQ&IRQ desact
        msr     cpsr_c, r0
        mov     sp, #0x8000000

/* Configuro GPIOs 0, 1, 2, 3, 4, 10, 11, 17 y 22 como salida */
        ldr     r0, =GPBASE
        ldr     r1, =0b00000000000000000001001001001001
        str     r1, [r0, #GPFSEL0]
/* guia bits           xx999888777666555444333222111000*/
        ldr     r1, =0b00000000001000000000000000001001
        str     r1, [r0, #GPFSEL1]
        mov     r1, #0b00000000000000000000000001000000
        str     r1, [r0, #GPFSEL2]

/* Enciendo LEDs       21098765432109876543210*/
        mov     r1, #0b00000000000000000000101
        str     r1, [r0, #GPSET0]
        mov     r1, #2
        str     r1, [r0, #GPPUD]
        bl      wait
/* Pongo pullups y habilito pines GPIO 9, 21 y 27 (botones) para interrupciones*/
        ldr     r1, =0b00001000001000000000001000000000
        str     r1, [r0, #GPPUDCLK0]
        bl      wait
        mov     r2, #0
        str     r2, [r0, #GPPUD]
        str     r1, [r0, #GPFEN0]

/* Programo C1 para dentro de 2 microsegundos */
        ldr     r0, =STBASE
        ldr     r1, [r0, #STCLO]
        add     r1, #2
        str     r1, [r0, #STC1]

/* Habilito GPIO para IRQ */
        ldr     r0, =INTBASE
/* guia bits           10987654321098765432109876543210*/
        mov     r1, #0b00000000000100000000000000000000
        str     r1, [r0, #INTENIRQ2]

/* Habilito C1 para FIQ */
        mov     r1, #0b10000001
        str     r1, [r0, #INTFIQCON]

/* Habilito interrupciones globalmente */
        mov     r0, #0b00010011   @modo SVC, FIQ&IRQ activo
        msr     cpsr_c, r0

/* Repetir para siempre */
bucle:  b       bucle

wait:   mov     r2, #50
wait1:  subs    r2, #1
        bne     wait1
        bx      lr

/* Rutina de tratamiento de interrupción FIQ */
fiq_handler:
        ldr     r8, =GPBASE
        ldr     r9, =bitson

/* Hago sonar altavoz invirtiendo estado de bitson */
        ldr     r10, [r9]
        eors    r10, #1
        str     r10, [r9], #4

/* Leo cuenta y luego elemento correspondiente en secuen */
        ldr     r10, [r9]
        ldr     r9, [r9, +r10, LSL #3]

/* Pongo estado altavoz según variable bitson */
        mov     r10, #0b10000     @ GPIO 4 (altavoz)
        streq   r10, [r8, #GPSET0]
        strne   r10, [r8, #GPCLR0]

/* Reseteo estado interrupción de C1 */
        ldr     r8, =STBASE
        mov     r10, #0b0010
        str     r10, [r8, #STCS]

/* Programo retardo según valor leído en array */
        ldr     r10, [r8, #STCLO]
        add     r10, r9
        str     r10, [r8, #STC1]

/* Salgo de la RTI */
        subs    pc, lr, #4

/* Rutina de tratamiento de interrupción IRQ */
irq_handler:
        push    {r0, r1, r2}
        ldr     r0, =GPBASE
        ldr     r1, =cuenta

/* Apago todos LEDs    10987654321098765432109876543210*/
        ldr     r2, =0b00000000010000100000110000001111
        str     r2, [r0, #GPCLR0]

/* Leo botón pulsado */
        ldr     r2, [r0, #GPEDS0]
        ands    r2, #0b00000000000000000000001000000000
        beq     incre

/* Si es botón izquierdo, decrementar */
        str     r2, [r0, #GPEDS0] @ Reseteo flag b. izq
        ldr     r2, [r1]          @ Leo variable cuenta
        subs    r2, #1            @ Decremento
        moveq   r2, #6            @ Si es 0, volver a 6
        b       conti             @ Salto a conti

/* Si es botón derecho, incrementar */
incre:  mov     r2, #0b00001000001000000000000000000000
        str     r2, [r0, #GPEDS0] @ Reseteo flag b. der
        ldr     r2, [r1]          @ Leo variable cuenta
        add     r2, #1            @ Incremento
        cmp     r2, #7            @ Comparo si llego a 7
        moveq   r2, #1            @ Si es 7, volver a 1

/* Actualizo variable, enciendo LED y salgo */
/* Actualizo variable, enciendo LED y salgo */
conti:  str     r2, [r1], #-4     @ Escribo variable cuenta
        ldr     r2, [r1, +r2, LSL #3] @ Leo secuencia
        str     r2, [r0, #GPSET0] @ Escribo secuencia en LEDs
        pop     {r0, r1, r2}      @ Recupero registros
        subs    pc, lr, #4        @ Salgo RTI

bitson: .word   0             @ Bit 0 = Estado del altavoz
cuenta: .word   6             @ Entre 1 y 6, LED a encender
secuen: .word   0b00000000000100000000000
        .word   716           @ Retardo para nota 6
        .word   0b00000000000010000000000
        .word   758           @ Retardo para nota 5
/* guia bits      21098765432109876543210*/
        .word   0b10000000000000000000000
        .word   851           @ Retardo para nota 4
        .word   0b00000100000000000000000
        .word   956           @ Retardo para nota 3
/* guia bits      21098765432109876543210*/
        .word   0b00000000000000000001010
        .word   1012          @ Retardo para nota 2
        .word   0b00000000000000000000101
        .word   1136          @ Retardo para nota 1
