#include  "const.h"

void irq_handler();
void fiq_handler();
int i, cuenta, bitson;
unsigned char leds[6]= {L1,L2,L3,L4,L5,L6};
unsigned short freq[6]= {1136, 1012, 956, 851, 758, 716};

int notmain(){
  initex();
  addexc(IRQVECT, irq_handler);
  addexc(FIQVECT, fiq_handler);
  putsp(FIQMODE, 0x4000);
  putsp(IRQMODE, 0x8000);
  putsp(SVCMODE, 0x8000000);
  for ( i= 0; i<6; i++ )
    gpio_fsel(leds[i], OUTPUT);
  gpio_fsel(ALT, OUTPUT);
  systim_add(2, 1);
  systim_add(2, 3);
  irq_enable(C1INT);
  fiq_enable(C3INT);
  cuenta= 5;
  int_globalenable(IRQ+FIQ);
  while(1);
}

void __attribute__((interrupt("IRQ"))) irq_handler(){
  gpio_clr(leds[cuenta++]);
  if( cuenta==6 )
    cuenta= 0;
  gpio_set(leds[cuenta]);
  systim_clearmatch(1);
  systim_add(500000, 1);
}

void __attribute__((interrupt("FIQ"))) fiq_handler(){
  if( bitson++&1 )
    gpio_set(ALT);
  else
    gpio_clr(ALT);
  systim_clearmatch(3);
  systim_add(freq[cuenta], 3);
}
