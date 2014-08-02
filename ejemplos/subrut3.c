#include <stdio.h>

int fibonacci(int n){
  if( n < 2 )
    return 1;
  else
    return fibonacci(n-1) + fibonacci(n-2);
}

void main(void){
  int i;

  for ( i= 0; i<10; i++ )
    printf("%d\n", fibonacci(i));
}
