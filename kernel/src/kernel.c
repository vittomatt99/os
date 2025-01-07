#include <stdbool.h>

#include "io/include/io.h"
#include "io/include/kbd.h"
#include "libc/include/string.h"
#include "tty/include/tty.h"

void kernel_early(void) { terminal_initialize(); }

int main(void) {
    bool COMPILE_FLOPPY = false;

    return COMPILE_FLOPPY ? floppy() : iso();
}

int floppy() {
    printf("Hello world\n");
    while (1) {
    }
    return 0;
}

int iso() {
    char *buffer;
    strcpy(&buffer[strlen(buffer)], "");
    print_prompt();

    while (1) {
        uint8_t byte_read;
        while (byte_read = scan()) {
            if (byte_read == 0x1c) {
                if (strlen(buffer) > 0 && strcmp(buffer, "exit") == 0) {
                    printf("\nGoodbye!");
                }
                print_prompt();
                memset(&buffer[0], 0, sizeof(buffer));
                move_cursor(get_terminal_row(), get_terminal_col());
                break;
            }

            char c = normalmap[byte_read];
            char *s;
            s = ctos(s, c);
            printf("%s", s);
            strcpy(&buffer[strlen(buffer)], s);
            move_cursor(get_terminal_row(), get_terminal_col());
        }
    }

    return 0;
}