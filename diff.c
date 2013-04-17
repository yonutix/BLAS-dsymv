#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>



int main(int argc, char** argv)
{
	FILE *f = fopen(argv[1], "rb");
	FILE *g = fopen(argv[2], "rb");
	int n = atoi(argv[3]);
	int i;
	double x, y;
	if(!f){
		printf("%s file does not exists!\n", argv[1]);
	}
	if(!g){
		printf("%s file does not exists!\n", argv[2]);
	}
	for(i = 0; i < n; ++i){
		fread(&x, sizeof(double), 1, f);
		fread(&y, sizeof(double), 1, g);
		if(fabs(x - y) > 0.01){
			printf("Files differs\n");
			fclose(f);
			fclose(g);
			return -1;
		}
	}

	fclose(f);
	fclose(g);
	return 0;
}
