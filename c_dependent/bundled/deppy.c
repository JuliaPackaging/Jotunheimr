#include <stdio.h>
#include <stdlib.h>

int my_mult(int x, int y);

int main(int argc, char ** argv) {
    if (argc != 3) {
        printf("Usage: deppy <x> <y>\n");
        return 1;
    }

    int x = atoi(argv[1]);
    int y = atoi(argv[2]);
    int z = my_mult(x, y);
    printf("%d + %d == %d\n", x, y, z);
    return 0;
}
