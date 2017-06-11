NODE=$1

res=$(kubectl describe node $NODE | 
    grep rest | 
    tail -n 1)
 
if [ ${#res} -eq 0 ];then
    echo "Nothing to re-schedule."
    exit -1
fi

namespace=$(echo $res | 
    awk '{print $1}') 

deployment=$(echo $res | 
    awk '{print $2}' | 
    sed "s/\(.*\)-\(.*\)$/\1 /")

echo $namespace
echo $deployment

kubectl scale deployment \
    --replicas=0 $deployment --namespace=$namespace

NUM=1
while [ $NUM -gt 0 ];do

    NUM=$(kubectl get \
        deployment $deployment --namespace $namespace --no-headers | 
        awk '{print $5}')

    sleep 1
    echo "Pods $NUM"

done;


kubectl scale deployment \
    --replicas=1 $deployment --namespace=$namespace

while [ $NUM -eq 0 ];do

    NUM=$(kubectl get \
        deployment $deployment --namespace $namespace --no-headers | 
        awk '{print $5}')

    sleep 1
    echo "Pods $NUM"

done;


