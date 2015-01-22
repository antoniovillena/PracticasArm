        .include  "wiringPi.inc"
.text
.global main
 
main:   bl      wiringPiSetup

        mov     r0, #L1
        mov     r1, #OUTPUT
        bl      pinMode

bucle:  mov     r0, #L1
        mov     r1, #HIGH
        bl      digitalWrite

        mov     r0, #500
        bl      delay

        mov     r0, #L1
        mov     r1, #LOW
        bl      digitalWrite

        mov     r0, #500
        bl      delay

        b       bucle
