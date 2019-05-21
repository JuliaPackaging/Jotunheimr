int my_add(int x, int y);

int my_mult(int x, int y) {
    int summand = 0;
    for( int i=0; i<y; i++ ) {
        summand = my_add(summand, x);
    }
    return summand;
}
