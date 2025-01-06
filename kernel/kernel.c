#define VIDEO_MEMORY 0xB8000
#define SCREEN_WIDTH 80
#define SCREEN_HEIGHT 25
#define WHITE_ON_BLACK 0x07

void clear_screen() {
    unsigned short *video_memory = (unsigned short *) VIDEO_MEMORY;
    for (int i = 0; i < SCREEN_WIDTH * SCREEN_HEIGHT; i++) {
        video_memory[i] = (WHITE_ON_BLACK << 8) | ' ';
    }
}

void print_char(char c, int row, int col, char attribute) {
    if (row >= SCREEN_HEIGHT || col >= SCREEN_WIDTH) {
        return;
    }

    unsigned short *video_memory = (unsigned short *) VIDEO_MEMORY;
    int index = row * SCREEN_WIDTH + col;
    video_memory[index] = (attribute << 8) | c;
}

void print_string(char* str) {
    unsigned int string_position = 0;
    unsigned int buffer_position = 0;

    while(str[string_position] != '\0') {
        char* video_memory = (unsigned char*) VIDEO_MEMORY;
        video_memory[buffer_position] = (char) str[string_position];
        video_memory[buffer_position + 1] = WHITE_ON_BLACK;
        string_position++;
        buffer_position = buffer_position + 2;
    }
}

void kernel_early() {}

int main() {
    clear_screen();
    //print_char('X', 0, 0, WHITE_ON_BLACK);
    char* str = "Hello World!";
    print_string(str);
    while (1) {}
}

