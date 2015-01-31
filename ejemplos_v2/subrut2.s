.data

var1:   .asciz  "%d\n"
seed:   .word   1
const1: .word   1103515245
const2: .word   12345

.text

.global main

/* Salvamos registros */
main:   push    {r4, lr}

/* Llamamos a mysrand con parámetro 42 */
        mov     r0, #42
        bl      mysrand

/* Inicializamos contador de bucle en r4 */
        mov     r4, #5

/* Bucle que imprime 5 números aleatorios */
bucle:  bl      myrand      @ leo número aleatorio
        mov     r1, r0      @ paso valor a r1
        ldr     r0, =var1   @ pongo cadena en r0
        bl      printf      @ llamo a función printf
        subs    r4, r4, #1  @ decremento contador
        bne     bucle       @ salgo si llego a cero

/* Recuperamos registros y salimos */
        pop     {r4, lr}
        bx      lr

myrand: ldr     r1, =seed
        ldr     r0, [r1]
        ldr     r2, [r1, #4]
        mul     r3, r0, r2
        ldr     r0, [r1, #8]
        add     r0, r0, r3
        str     r0, [r1]
        mov     r0, r0, LSL #1
        mov     r0, r0, LSR #17
        bx      lr

mysrand:ldr     r1, =seed
        str     r0, [r1]
        bx      lr
