NODES=`kubectl get nodes --no-headers | 
    awk '{print $1}' | 
    grep agent`

for n in $NODES;do
   echo $n
   kubectl describe node $n | tail -n 2
done

