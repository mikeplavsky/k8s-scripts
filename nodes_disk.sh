NODES=`kubectl get nodes --no-headers | awk '{print $1}'`  

for n in $NODES;do
   echo $n
   ssh -oStrictHostKeyChecking=no $n df -h | grep sda
   ssh -oStrictHostKeyChecking=no $n df -i | grep sda
done

