#include <stdio.h>

int vect[]= {8, 10, -3, 4, -5, 50, 2, 3};

void ordena(int* v, int len){
  int i, j, aux;

  for ( i= 1; i<len; i++ )
    for ( j= 0; j<len-i; j++ )
      if( v[j] > v[j+1] )
        aux= v[j],
        v[j]= v[j+1],
        v[j+1]= aux;
}

void main(void){
  int i;

  ordena(vect, 8);
  for ( i= 0; i<8; i++ )
    printf("%d\n", vect[i]);
}
