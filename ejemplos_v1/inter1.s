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

/* Configuro GPIO 0,1,2 y 3 como salida */
        ldr     r0, =GPBASE
/* guia bits           xx999888777666555444333222111000*/
        ldr     r1, =0b00000000000000000000001001001001
        str     r1, [r0, #GPFSEL0]

/* Programo contador C1 para futura interrupción */
        ldr     r0, =STBASE
        ldr     r1, [r0, #STCLO]
        add     r1, #0x400000     @4,19 segundos
        str     r1, [r0, #STC1]

/* Habilito interrupciones, local y globalmente */
        ldr     r0, =INTBASE
        mov     r1, #0b0010
        str     r1, [r0, #INTENIRQ1]
        mov     r0, #0b01010011   @ Modo SVC, IRQ activo
        msr     cpsr_c, r0

/* Repetir para siempre */
bucle:  b       bucle

/* Rutina de tratamiento de interrupción */
irq_handler:
        push    {r0, r1}          @ Salvo registros

        ldr     r0, =GPBASE
/* guia bits           10987654321098765432109876543210*/
        mov     r1, #0b00000000000000000000000000000101
        str     r1, [r0, #GPSET0] @ Enciendo LED

        pop     {r0, r1}          @ Recupero registros
        subs    pc, lr, #4        @ Salgo de la RTI
