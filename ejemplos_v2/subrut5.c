#include <stdio.h>

int poly3(int a, int b, int c, int d, int x){
  return a*x*x*x + b*x*x + c*x + d;
}

void main(void){
  printf("%d\n%d\n%d\n",
          poly3(1, 2, 3, 4, 5), 
          poly3(1, -1, 1, -1, 8), 
          poly3(2, 0, 0, 0, 8));
}
