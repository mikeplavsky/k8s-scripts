NODES=`kubectl get nodes --no-headers | awk '{print $1}'`

for n in $NODES;do
   echo $n
   kubectl describe node $n | tail -n 2
done

