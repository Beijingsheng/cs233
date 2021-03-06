#include "declarations.h"

#ifdef SCALAR
#pragma auto_inline(off)
void
t4(float **M1, float **M2, float **M3) {
    for (int nl = 0; nl < ntimes / (10 * LEN4); nl ++) {
        for (int i = 0; i < LEN4; i ++) {
            for (int j = 0; j < LEN4; j ++) {
                for (int k = 0; k < LEN4; k ++) {
                    M3[i][j] += M1[i][k] * M2[k][j];
                }
            }
        }
        M3[0][0] ++;
    }
}
#endif

int
main() {
    float **M1 = (float **) memalign(16, LEN4 * sizeof(float *));
    float **M2 = (float **) memalign(16, LEN4 * sizeof(float *));
    float **M3 = (float **) memalign(16, LEN4 * sizeof(float *));
    for (int i = 0; i < LEN4; i ++) {
        M1[i] = (float *) memalign(16, LEN4 * sizeof(float));
        M2[i] = (float *) memalign(16, LEN4 * sizeof(float));
        M3[i] = (float *) memalign(16, LEN4 * sizeof(float));
    }

    for (int i = 0; i < LEN4; i ++) {
        for (int j = 0; j < LEN4; j ++) {
            M1[i][j] = (float) (i + j) / (float) LEN4;
            M2[i][j] = (float) (i + j + 1) / (float) LEN4;
            M3[i][j] = (float) (0);
        }
    }

    unsigned long long start_c, end_c, diff_c;
    start_c = _rdtsc();

    t4(M1, M2, M3);

    end_c = _rdtsc();
    diff_c = end_c - start_c;
    float giga_cycle = diff_c / 1000000000.0;
    float ttt = (float) 0.;
    for (int i = 0; i < LEN4; i ++) {
        for (int j = 0; j < LEN4; j ++) {
            ttt += M3[i][j];
        }
    }
    printf("t4 took %f giga cycles and the result is: %f\n", giga_cycle, ttt);
}
