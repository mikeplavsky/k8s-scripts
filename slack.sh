SLACK_URL=$1
INTERVAL=$2
export TZ=Europe/Moscow

NAME=$(sudo cat /etc/kubernetes/azure.json |
       awk '/resourceGroup/{print $2}' | 
       sed s/\",// | sed s/\"//)

echo $NAME

while true; do 

date

KUBE=$(kubectl get node && etcdctl cluster-health)
STATUS=":red_circle:"

BAD=$(echo $KUBE | grep -E "Unready|unhealthy")
if [ ${#BAD} -eq 0 ];then
    STATUS=":green_apple:"
fi

RES=$(date && echo $STATUS" "*$NAME* && echo "${KUBE}")
curl -XPOST $SLACK_URL -d "{\"text\":\"$RES\"}";

sleep $INTERVAL

done
