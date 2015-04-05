#include  "const.h"

int notmain( void ){
  gpio_fsel(L1, OUTPUT);
  while(1)
    usleep(500000),
    gpio_set(L1),
    usleep(500000),
    gpio_clr(L1);
}