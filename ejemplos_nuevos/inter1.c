#include  "const.h"

void irq_handler();

int notmain(){
  initex();
  addexc(IRQVECT, irq_handler);
  putsp(IRQMODE, 0x8000);
  putsp(SVCMODE, 0x8000000);
  gpio_fsel(L1, OUTPUT);
  systim_add(4000000, 1);
  irq_enable(C1INT);
  int_globalenable(IRQ);
  while(1);
}

void __attribute__((interrupt("IRQ"))) irq_handler(){
  gpio_set(L1);
}
