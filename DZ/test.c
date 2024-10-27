#include "stdio.h"


long * create_queue();

void delete_queue();

void mypush(long num);

long mypop();

void fill_random(long size);

long count_even();

long count_simple();

long count_1_ended();


int main(){
    long * myq = create_queue();

    fill_random(10);
    long el = 999;
    for (; el < 1004; el++) mypush(el);

    long even = count_even(), simple = count_simple(), end_with_1 = count_1_ended();
    printf("четных: %ld, простых: %ld, оканчиваются на 1: %ld\n", even, simple, end_with_1);
    
    for (int i = 0; i < 15; i++){
        el = mypop();
        printf("%ld\n", el);
    }

    delete_queue(myq);
    return 0;    
}