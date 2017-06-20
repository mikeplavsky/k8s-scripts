#it assumes there is a deployment for pod
NODE=$1
PATTERN=$2

res=$(kubectl describe node $NODE | 
    grep $PATTERN | 
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

NUM=1

function get_pods_num {

    NUM=$(kubectl get \
          deployment $deployment --namespace \
          $namespace --no-headers | awk '{print $5}')

    echo `date`" Pods $NUM"

} 

kubectl scale deployment \
    --replicas=0 $deployment --namespace=$namespace

while [ $NUM -gt 0 ];do

    get_pods_num
    sleep 1

done;

kubectl scale deployment \
    --replicas=1 $deployment --namespace=$namespace

while [ $NUM -eq 0 ];do

    get_pods_num
    sleep 5

done;


