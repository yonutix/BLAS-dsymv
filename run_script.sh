SIZE=$1
DATA="rand_data.in"
USR=`echo ${USER} | head -c 10` 
ulimit -s unlimited
#I will generate a max number of numbers that will be used
gcc -o ~/asc2/gen ~/asc2/generator.c
echo "Generator compiled..."
qsub -S /bin/bash -q ibm-quad.q ~/asc2/run_generator.sh $SIZE
NUM=`qstat | grep "${USR}" | wc -l`

while [ "$NUM" -eq "1" ]
do
	sleep 1
	echo -n "."
	NUM=`qstat | grep "${USR}" | wc -l`
done
echo "."
echo "numbers generated"

qsub -S /bin/bash -q ibm-quad.q ~/asc2/run_script_on_quad.sh

NUM=`qstat | grep "${USR}" | wc -l`

while [ "$NUM" -eq "1" ]
do
	sleep 1
	echo -n "."
	NUM=`qstat | grep "${USR}" | wc -l`
done
echo "."
qsub -S /bin/bash -q ibm-opteron.q ~/asc2/run_script_on_opteron.sh

NUM=`qstat | grep "${USR}" | wc -l`

while [ "$NUM" -eq "1" ]
do
	sleep 1
	echo -n "."
	NUM=`qstat | grep "${USR}" | wc -l`
done
echo "."
qsub -S /bin/bash -q ibm-nehalem.q ~/asc2/run_script_on_nehalem.sh

NUM=`qstat | grep "${USR}" | wc -l`

while [ "$NUM" -eq "1" ]
do
	sleep 1
	echo -n "."
	NUM=`qstat | grep "${USR}" | wc -l`
done
echo "."

gcc -o diff diff.c
./diff quad_out quad_opt_out $SIZE
if [ "$?" -eq "-1" ]; then echo "Files differ"; fi
./diff quad_blas_out opteron_out $SIZE
if [ "$?" -eq "-1" ]; then echo "Files differ"; fi
./diff opteron_opt_out opteron_blas_out $SIZE
if [ "$?" -eq "-1" ]; then echo "Files differ"; fi
./diff nehalem_out nehalem_opt_out $SIZE
if [ "$?" -eq "-1" ]; then echo "Files differ"; fi
./diff nehalem_blas_out nehalem_out $SIZE
if [ "$?" -eq "-1" ]; then echo "Files differ"; fi
rm *out*

join quad_results.txt quad_h_results.txt > q_h.txt
join quad_o_results.txt opteron_results.txt >q_o_o.txt
join opteron_h_results.txt opteron_o_results.txt >o_h_o.txt
join nehalem_results.txt nehalem_h_results.txt >n_h.txt

join q_h.txt q_o_o.txt >q.txt
join o_h_o.txt n_h.txt >o.txt

join q.txt o.txt >q_o.txt

join q_o.txt nehalem_o_results.txt >quad_opteron_nehalem.txt

rm *results*
rm q_h.txt
rm q_o_o.txt
rm o_h_o.txt
rm n_h.txt
rm q.txt
rm o.txt
rm q_o.txt

