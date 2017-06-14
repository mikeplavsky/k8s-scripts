SLACK_URL=$1
INTERVAL=$2
export TZ=Europe/Moscow

NAME=$(sudo cat /etc/kubernetes/azure.json |
       awk '/resourceGroup/{print $2}' | 
       sed s/\",// | sed s/\"//)

echo $NAME

while true; do 

date

KUBE=$(kubectl get node && kubectl top node && etcdctl cluster-health)
STATUS=":red_circle:"
NOTIFICATION='<!channel> '

BAD=$(echo $KUBE | grep -E "NotReady|unhealthy")
if [ ${#BAD} -eq 0 ];then
    STATUS=":green_apple:"
    NOTIFICATION=''
fi

RES=$(date && echo ${NOTIFICATION}$STATUS" "*$NAME* && echo "${KUBE}")
curl -XPOST $SLACK_URL -d "{\"text\":\"$RES\"}";

sleep $INTERVAL

done
