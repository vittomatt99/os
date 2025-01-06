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

int main() {
    clear_screen();
    print_char('X', SCREEN_HEIGHT / 2, SCREEN_WIDTH / 2, WHITE_ON_BLACK);
    while (1) {}
}

