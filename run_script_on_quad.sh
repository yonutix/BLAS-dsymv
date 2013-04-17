DATA="rand_data.in"

ulimit -s unlimited

gcc -o ~/asc2/main_hand ~/asc2/main_hand.c
for i in {1..20}
do	
	echo -n $i >>~/asc2/quad_h_results.txt
	~/asc2/main_hand -i ~/asc2/$DATA -o ~/asc2/quad_out -s $(($i * 1000)) >>~/asc2/quad_h_results.txt
done

gcc -O3 -o ~/asc2/main_optim ~/asc2/main_opt.c
for i in {1..20}
do	
	echo -n $i >>~/asc2/quad_o_results.txt
	~/asc2/main_optim -i ~/asc2/$DATA -o ~/asc2/quad_opt_out -s $(($i * 1000)) >>~/asc2/quad_o_results.txt
done


gcc -O3 -o ~/asc2/main_blas ~/asc2/main_blas.c -lcblas -latlas -L/opt/tools/libraries/atlas/3.10.1-quad-gcc-4.4.6/lib -I/opt/tools/libraries/atlas/3.10.1-quad-gcc-4.4.6/include

for i in {1..20}
do
	echo -n $i >>~/asc2/quad_results.txt
	~/asc2/main_blas -i ~/asc2/$DATA -o ~/asc2/quad_blas_out -s $(($i* 1000)) >>~/asc2/quad_results.txt
done
