NS=$1
DEPL=$2
RS=$3

kubectl get deployment --namespace=$NS \
    --no-headers |
    awk '{print $1}' |
    grep $DEPL |
    xargs kubectl scale deployment --replicas=$RS --namespace=$NS
