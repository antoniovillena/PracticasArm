.data

var1:   .word   0x80000000

.text
.global main
 
main:   ldr     r0, =var1         /* r0 <- &var1        */
        ldr     r1, [r0]          /* r1 <- *r0          */
        lsrs    r1, r1, #1        /* r1 <- r1 lsr #1    */
        lsrs    r1, r1, #3        /* r1 <- r1 lsr #3    */
        ldr     r2, [r0]          /* r2 <- *r0          */
        asrs    r2, r2, #1        /* r2 <- r2 asr #1    */
        asrs    r2, r2, #3        /* r2 <- r2 asr #3    */
        ldr     r3, [r0]          /* r3 <- *r0          */
        rors    r3, r3, #31       /* r3 <- r3 rol #1    */
        rors    r3, r3, #31       /* r3 <- r3 rol #1    */
        rors    r3, r3, #24       /* r3 <- r3 rol #8    */
        ldr     r4, [r0]          /* r4 <- *r0          */
        msr     cpsr_f, #0        /* C=0                */
        adcs    r4, r4, r4        /* rotar izda carry   */
        adcs    r4, r4, r4        /* rotar izda carry   */
        adcs    r4, r4, r4        /* rotar izda carry   */
        msr     cpsr_f, #0x20000000 /* C=1              */
        adcs    r4, r4, r4        /* rotar izda carry   */
        bx      lr
