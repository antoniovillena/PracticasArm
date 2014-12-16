.data
var1:   .asciz  "%d\n"

.text
.global main

/* Salvo registros */
main:   push    {r4, lr}

/* Inicializo contador del bucle a 0 en r4 */
        mov     r4, #0

/* Bucle que imprime los 10 primeros valores */
bucle:  mov     r0, r4      @ tomo contador como parámetro
        bl      fibo        @ llamo a la función
        mov     r1, r0      @ paso resultado a r1
        ldr     r0, =var1   @ pongo cadena en r0
        bl      printf      @ llamo a función printf
        add     r4, r4, #1  @ incremento contador de bucle
        cmp     r4, #10     @ comparo si es menor de 10
        bne     bucle       @ si llegamos a 10 salgo de bucle

/* Recupero registros y salgo de main */
        pop     {r4, lr}
        bx      lr

        .equ    local1,   0
        .equ    local2,   4+local1
        .equ    local3,   4+local2
        .equ    length,   4+local3

fibo:   cmp     r0, #2            @ if n<2
        movlo   r0, #1            @ return 1
        bxlo    lr                @ salgo de la función

        push    {lr}              @ salvaguarda lr
        sub     sp, #length       @ hago espacio para v. locales
        sub     r0, #1            @ r0= n-1
        str     r0, [sp, #local1] @ salvo n-1 en [sp]
        bl      fibo              @ fibonacci(n-1)
        str     r0, [sp, #local2] @ salvo salida de fib.(n-1)
        ldr     r0, [sp, #local1] @ recupero de la pila n-1
        sub     r0, #1            @ calculo n-2
        bl      fibo              @ fibonacci(n-2)
        ldr     r1, [sp, #local2] @ recupero salida de fib.(n-1)
        add     r0, r1            @ lo sumo a fib.(n-1)

        add     sp, #length       @ libero espacio de v. locales
        pop     {lr}              @ recupero registros (sólo lr)
        bx      lr                @ salgo de la función
