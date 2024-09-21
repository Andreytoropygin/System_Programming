#include <stdio.h>

int main(){
    long N = 4693338485;
    char sum = 0;
    for(; N > 0; N /= 10) sum += N % 10;
    printf("%d\n", sum);
    return 0;
}