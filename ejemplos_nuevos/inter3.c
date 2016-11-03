#include  "const.h"

void irq_handler();

int notmain(){
  initex();
  addexc(IRQVECT, irq_handler);
  putsp(IRQMODE, 0x8000);
  putsp(SVCMODE, 0x8000000);
  gpio_fsel(L1, OUTPUT);
  gpio_fsel(L2, OUTPUT);
  gpio_set(L1);
  gpio_set(L2);
  gpio_fen(S1);
  gpio_fen(S2);
  irq_enable(GPIOINT);
  int_globalenable(IRQ);
  while(1);
}

void __attribute__((interrupt("IRQ"))) irq_handler(){
  gpio_clr(L1);
  gpio_clr(L2);
  if( gpio_eds_tst(S1) )
    gpio_set(L1);
  else
    gpio_set(L2);
  gpio_eds_set(S1);
  gpio_eds_set(S2);
}
