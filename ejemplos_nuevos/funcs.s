        .globl  gpio_fsel
        .globl  gpio_set
        .globl  gpio_clr
        .globl  gpio_fen
        .globl  gpio_tst
        .globl  gpio_eds_tst
        .globl  gpio_eds_set
        .globl  usleep
        .globl  initex
        .globl  addexc
        .globl  putsp
        .globl  systim_add
        .globl  systim_tst
        .globl  systim_clearmatch
        .globl  irq_enable
        .globl  fiq_enable
        .globl  int_globalenable

        .include  "const.inc"

gpio_fsel: @ void gpio_fsel(int pin, int mode)
        ldr     r12, =GPBASE
gf1:    add     r12, #4
        subs    r0, #10
        bcs     gf1
        sub     r0, r0, lsl #2
        add     r0, #2
        mov     r3, #MASK
        ldr     r2, [r12, #-4]
        bic     r2, r3, ror r0
        orr     r2, r1, ror r0
        str     r2, [r12, #-4]
        bx      lr

gpio_set: @ void gpio_set(int pin)
        ldr     r1, =GPBASE+GPSET0
gs1:    mov     r2, #0x80000000
        rsbs    r0, #31
        ror     r2, r0
        strcs   r2, [r1, #0]
        strcc   r2, [r1, #4]
        bx      lr

gpio_clr: @ void gpio_clr(int pin)
        ldr     r1, =GPBASE+GPCLR0
        b       gs1

gpio_fen: @ void gpio_fen(int pin)
        ldr     r1, =GPBASE
        mov     r2, #0x80000000
        rsbs    r0, #31
        ror     r2, r0
        ldrcs   r0, [r1, #GPFEN0]
        ldrcc   r0, [r1, #GPFEN1]
        orr     r0, r2
        strcs   r0, [r1, #GPFEN0]
        strcc   r0, [r1, #GPFEN1]
        bx      lr

gpio_tst: @ void gpio_tst(int pin)
        ldr     r1, =GPBASE+GPLEV0
        b       get
      
gpio_eds_tst: @ int gpio_eds_tst(int pin)
        ldr     r1, =GPBASE+GPEDS0
get:    mov     r2, #0x80000000
        rsbs    r0, #31
        ror     r2, r0
        ldrcs   r0, [r1, #0]
        ldrcc   r0, [r1, #4]
        ands    r0, r2
        bx      lr

gpio_eds_set: @ void gpio_eds_set(int pin)
        ldr     r1, =GPBASE+GPEDS0
        b       gs1

usleep: @ void usleep(int usecs)
        ldr     r1, =STBASE
        ldr     r2, [r1, #STCLO]
        add     r0, r2
es1:    ldr     r2, [r1, #STCLO]
        cmp     r0, r2
        bne     es1
        bx      lr

initex: @ void initex(void)
        mov     r0, #0
        mcr     p15, 0, r0, c12, c0, 0
        bx      lr

addexc: @ void addexc(int vector, int dirRTI)
        ldr     r2, =0xe9fffffe
        add     r2, r1, lsr #2
        sub     r2, r0, lsr #2
        str     r2, [r0]
        bx      lr

putsp: @ void putsp(int mode, int value)
        mrs     r2, cpsr
        eor     r0, r2
        and     r0, #0b11111
        eor     r0, r2
        msr     cpsr_c, r0
        mov     sp, r1
        msr     cpsr_c, r2
        bx      lr

systim_add: @ void systim_add(int value, int counter)
        ldr     r2, =STBASE+STC0
        ldr     r3, [r2, #STCLO-STC0]
        add     r3, r0
        str     r3, [r2, r1, lsl #2]
        bx      lr

systim_tst: @ int systim_tst(int pin)
        mov     r1, #1
        lsl     r1, r0
        ldr     r0, =STBASE
        ldr     r0, [r0]
        ands    r0, r1
        bx      lr

systim_clearmatch: @ void systim_add(int counter)
        mov     r1, #1
        lsl     r1, r0
        ldr     r0, =STBASE
        str     r1, [r0]
        bx      lr

irq_enable: @ void irq_enable(int number)
        ldr     r1, =INTBASE+INTENIRQ1
        b       gs1

fiq_enable: @ void fiq_enable(int number)
        ldr     r1, =INTBASE+INTENIRQ1
        orr     r0, #0b10000000
        str     r0, [r1, #INTFIQCON-INTENIRQ1]
        bx      lr

int_globalenable: @ void int_globalenable(int mask)
        mrs     r1, cpsr
        orr     r1, #0b11000000
        eor     r1, r0, lsl #6
        msr     cpsr_c, r1
        bx      lr
