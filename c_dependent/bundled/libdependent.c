#include <stdlib.h>
#include <string.h>
#include <stdio.h>

int my_add(int x, int y);

int my_mult(int x, int y) {
    int summand = 0;
    for (int i=0; i<y; i++) {
        summand = my_add(summand, x);
    }
    return summand;
}

int do_exec(int x, int y) {
    char cmd[128];
    sprintf(&cmd[0], "c_simple %d %d", x, y);
    FILE * fd = popen(cmd, "r");
    if (fd == NULL) {
        printf("ERROR: Unable to run `c_simple`!\n");
        exit(1);
    }

    char result[128];
    fgets(result, sizeof(result)-1, fd);
    pclose(fd);

    // Skip up to, then past the `==`:
    int idx = 0;
    while (result[idx] != '=' && idx < sizeof(result) - 1)
        idx++;

    return atoi(&result[idx+2]);
}

int my_exec_mult(int x, int y) {
    int summand = 0;
    for (int i=0; i<y; i++) {
        summand = do_exec(summand, x);
    }
    return summand;
}
