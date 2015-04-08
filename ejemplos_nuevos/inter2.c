#include  "const.h"

void irq_handler();
int ledst;

int notmain(){
  addexc(IRQVECT, irq_handler);
  putsp(IRQMODE, 0x8000);
  putsp(SVCMODE, 0x8000000);
  gpio_fsel(L1, OUTPUT);
  gpio_fsel(L2, OUTPUT);
  gpio_fsel(L3, OUTPUT);
  gpio_fsel(L4, OUTPUT);
  gpio_fsel(L5, OUTPUT);
  gpio_fsel(L6, OUTPUT);
  systim_add(2, 1);
  irq_enable(C1INT);
  int_setglobalmask(IRQ);
  while(1);
}

void __attribute__((interrupt("IRQ"))) irq_handler(){
  if( ledst++&1 )
    gpio_set(L1),
    gpio_set(L2),
    gpio_set(L3),
    gpio_set(L4),
    gpio_set(L5),
    gpio_set(L6);
  else
    gpio_clr(L1),
    gpio_clr(L2),
    gpio_clr(L3),
    gpio_clr(L4),
    gpio_clr(L5),
    gpio_clr(L6);
  systim_clearmatch(1);
  systim_add(500000, 1);
}
