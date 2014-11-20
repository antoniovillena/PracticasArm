#include <stdio.h>

void main(void){

  int i;
  long long suma;
  int vector[5]= {1600000000, -100, 800000000, -50, 200};

  for ( suma= i= 0; i<5; i++ ){
    suma+= (long long) vector[i];
  }
  printf("La suma es %d\n", suma);

}
