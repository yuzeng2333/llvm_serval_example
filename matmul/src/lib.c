#include <stdlib.h>

int and_int(int a, int b) {
  int r = a & b;
  return r;
}


int and_int_buggy(int a, int b) {
  if( a == 0x13 && b == 0x37 ) a -= 1;
  int r = a & b;
  return r;
}



int main() {
  and_int(1, 2);
  return 0;
}
