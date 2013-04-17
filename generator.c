#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

double fRand(double fMin, double fMax)
{
    double f = (double)rand() / RAND_MAX;
    return fMin + f * (fMax - fMin);
}

int main(int argc, char** argv)
{
	int i, j, n;
	double **mat, x, y;
	FILE *f = fopen(argv[2], "wb");
	srand(time(NULL));

	n = atoi(argv[1]);
	mat = malloc(sizeof(double*) * n);
	for(i = 0; i < n; ++i){
		mat[i] = malloc(sizeof(double) * n);
	}

	for(i = 0; i < n; ++i){
		for(j = 0; j < i+1; ++j){
			mat[i][j] = mat[j][i] = i * j + 1;
		}
	}
	for(i = 0; i <n; ++i){
		fwrite(mat[i], sizeof(double), n, f);
	}

	for(i = 0; i < n; ++i){
		x = fRand(0.0, 10.0);
		fwrite(&x, sizeof(double), 1, f);
		
		y = fRand(0.0, 10.0);
		fwrite(&y, sizeof(double), 1, f);
	}

	for(i = 0; i < n; ++i){
		free(mat[i]);
	}
	free(mat);
	fclose(f);
}
