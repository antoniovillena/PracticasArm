#include <stdio.h>

int vect[]= {8, 10, -3, 4, -5, 50, 2, 3};

int minimo(int* v, int len){
  int i, min;

  min= v[0];
  for ( i= 1; i<len; i++ )
    if( v[i]<min )
      min= v[i];
  return min;
}

void main(void){
  printf("%d\n", minimo(vect, 8));
}

