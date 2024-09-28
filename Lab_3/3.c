#include <stdio.h>
#include <stdlib.h>

int main (int argc, char* argv[]){
    int a = strtol(argv[1], NULL, 10);
    int b = strtol(argv[2], NULL, 10);
    int c = strtol(argv[3], NULL, 10);

    // (c+b-b+a)/b-a
    int result = 0;
    result += c + b - b + a;
    result /= b;
    result -= a;
    printf("%d\n", result);
    return 0; 
}