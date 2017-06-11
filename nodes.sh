NAME=$1
NUM=$2

for i in `seq 0 $NUM`; do

   M=$NAME$i

   echo $M
   kubectl describe node $M | tail -n 2
   
done
