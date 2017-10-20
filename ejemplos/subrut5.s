.data
var1:   .asciz  "%d\n"

.text
.global main

/* Salvo registros */
main:   push    {r4, lr}

/* Introduzco los 4 primeros parámetros vía registros */
        mov     r0, #1
        mov     r1, #2
        mov     r2, #3
        mov     r3, #4

/* Introduzco el 5º parámetro por pila */
        mov     r4, #5
        push    {r4}

/* Llamada a función poly3(1, 2, 3, 4, 5) */
        bl      poly3

/* Equilibro la pila (debido al 5º parámetro) */
        add     sp, #4

/* Paso resultado de la función a r1, cadena a
   imprimir a r0 y llamo a la función */
        mov     r1, r0
        ldr     r0, =var1
        bl      printf

/* Segunda llamada, esta vez poly3(1, -1, 1, -1, 8) */
        mov     r0, #1
        mov     r1, #-1
        mov     r2, #1
        mov     r3, #-1
        mov     r4, #8
        push    {r4}
        bl      poly3
        add     sp, #4

/* Imprimo resultado de segunda llamada */
        mov     r1, r0
        ldr     r0, =var1
        bl      printf

/* Llamo e imprimo poly3(2, 0, 0, 0, 8) */
        mov     r0, #2
        mov     r1, #0
        mov     r2, #0
        mov     r3, #0
        mov     r4, #8
        push    {r4}
        bl      poly3
        add     sp, #4
        mov     r1, r0
        ldr     r0, =var1
        bl      printf

/* Recupero registros y salgo de main */
        pop     {r4, lr}
        bx      lr

        .equ    param5,   4*1  /* r4 */

poly3:  push    {r4}              @ salvaguarda r4
        ldr     r4, [sp, #param5] @ leo r4 de pila
        smlabb  r3, r2, r4, r3    @ r3= c*x + d
        smulbb  r2, r4, r4        @ r2= x*x
        smlabb  r3, r1, r2, r3    @ r3= b*(x*x) + (c*x + d)
        smulbb  r2, r2, r4        @ r2= x*(x*x)
        smlabb  r0, r0, r2, r3    @ r0= a*x*x*x + b*x*x + c*x + d
        pop     {r4}              @ recupero r4
        bx      lr                @ salgo de la función
