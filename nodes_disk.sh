NODES=`kubectl get nodes --no-headers | awk '{print $1}'`  

for n in $NODES;do
   echo $n
   ssh $n df -h | grep sda
   ssh $n df -i | grep sda
done

