NODES=`kubectl get nodes --no-headers | awk '{print $1}'`  

for n in $NODES;do
   echo $n
   ssh -oServerAliveInterval=5 -oConnectTimeout=10 -oConnectionAttempts=1 -oStrictHostKeyChecking=no $n df -h | grep sda
   ssh -oServerAliveInterval=5 -oConnectTimeout=10 -oConnectionAttempts=1 -oStrictHostKeyChecking=no $n df -i | grep sda
done

