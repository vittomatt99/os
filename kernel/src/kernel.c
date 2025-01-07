#include "tty/include/tty.h"

void kernel_early(void) { terminal_initialize(); }

__attribute__((noreturn)) int main(void) {
    printf("Hello world\n");

    while (1) {
    }

    return 0;
}