#include <stdio.h>

int main(void) {
    int number;
    printf("請輸入一個數字: ");
    scanf("%d", &number); // 讀取整數輸入
    printf("你輸入的數字是: %d\n", number);
    return 0;
}