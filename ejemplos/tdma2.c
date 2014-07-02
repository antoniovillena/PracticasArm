#include <stdio.h>

void main(void){

  int i, suma;
  int vector[5]= {128, 32, 100, -30, 124};

  for ( suma= i= 0; i<5; i++ ){
    suma+= vector[i];
  }
  printf("%d\n", suma);

}
