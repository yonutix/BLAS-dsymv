#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cblas.h>
#include <time.h>

int main(int argc, char** argv)
{
	double *a;
	double *x;
	double *y;
	int i, j, n;
	char input_name[100];
	char output_name[100];
	strcpy(input_name, "");
	strcpy(output_name, "");

	for(i = 1; i < argc; ++i){
		if(strcmp(argv[i], "-i") == 0){
			strcpy(input_name, argv[i+1]);
		}
		
		if(strcmp(argv[i], "-o") == 0){
			strcpy(output_name, argv[i+1]);
		}
		
		if(strcmp(argv[i], "-s") == 0){
			n = atoi(argv[i+1]);
		}
	}
	if(n == 0 || strlen(input_name) == 0){
		printf("usage: ./exec -i <input file> -o <output file> -s <size>\n");
		return -1;
	}
	FILE *f = fopen(input_name, "rb");
	FILE *g;
	if(strlen(output_name) > 0){
		g = fopen(output_name, "wb");
	}
	
	a = malloc(sizeof(double) * n * n);
	x = malloc(sizeof(double) * n);
	y = malloc(sizeof(double) * n);

	for(i = 0; i < n; ++i){
		for(j = 0; j < n; ++j){
			fread(&a[i * n + j], sizeof(double), 1, f);
		}
	}

	for(i = 0; i < n; ++i){
		fread(&x[i], sizeof(double), 1, f);
		fread(&y[i], sizeof(double), 1, f);
	}
	clock_t t;
	t = clock();
	cblas_dsymv(CblasRowMajor, (int)121, n , (double)1.0, a, n , x, (int)1, (double)1.0, y, (int)1); 
	t = clock() - t;
	printf(" %f\n", (float)t/CLOCKS_PER_SEC);
	if(strlen(output_name) > 0) {
		for(i = 0; i < n; ++i){
			fprintf(g, "%.4lf ", y[i]);
		}
		fprintf(g, "\n");
	}
	free(x);
	free(y);
	free(a);
	fclose(f);
	if(strlen(output_name) > 0){
		fclose(g);
	}
	return 0;
}
