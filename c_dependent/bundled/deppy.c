#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int my_mult(int x, int y);
int my_exec_mult(int x, int y);

int main(int argc, char ** argv) {
    if (argc != 3 && argc != 4) {
        printf("Usage: deppy --exec <x> <y>\n");
        return 1;
    }

    int optidx = 1;
    char exec = 0;
    if (strcmp(argv[1], "--exec") == 0) {
        optidx += 1;
        exec = 1;
    }

    int x = atoi(argv[optidx+0]);
    int y = atoi(argv[optidx+1]);

    int z = 0;
    if (exec)
        z = my_exec_mult(x, y);
    else
        z = my_mult(x, y);
    printf("%d * %d == %d\n", x, y, z);
    return 0;
}
