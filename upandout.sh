setup () {(
    set -e
    echo launching instance $instance_id
    aws ec2 wait instance-status-ok --instance-ids $instance_id
    public_ip=$(aws ec2 describe-instances --instance-ids $instance_id --output text --query Reservations[*].Instances[*].PublicIpAddress)
    echo got ip $public_ip
    for ((i=0; i < ${#copy_src[@]}; i++))
    do
        echo copying ${copy_src[$i]} to ${copy_dst[$i]}:
        rsync -e "ssh -o StrictHostKeyChecking=no -i $key_file" --stats --delete -zzurh --compress-level=9 ${copy_src[$i]} $username@$public_ip:${copy_dst[$i]}
    done
    run_script="source .bashrc; $command_line |& tee output.txt; mail -s 'EC2 run finished' -r $instance_id@$public_ip $email < output.txt; sudo shutdown -h now; mail -s 'EC2 NOT stopped' -r $instance_id@$public_ip $email"
    ssh -o StrictHostKeyChecking=no -i $key_file $username@$public_ip "echo '$run_script'>run.sh; tmux new -d bash -i run.sh; tmux ls"
)}

launch () {
    set -e
    local instance_id
    instance_id=$(aws ec2 run-instances --image-id $image_id --instance-type $instance_type --key-name $key_name --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value='${tag_name-Up-and-Out}'}]" --output text --query Instances[*].InstanceId)
    set +e
    local state=running
    setup
    if [ $? != 0 ]
    then
        echo trying to terminate due to error
        aws ec2 terminate-instances --instance-ids $instance_id
        aws ec2 wait instance-terminated --instance-ids $instance_id
        state=$(aws ec2 describe-instances --instance-id $instance_id --output text --query Reservations[*].Instances[*].State.Name)
        if [ $state != "terminated" ]
        then
            state="NOT terminated"
        fi
    fi
    local public_ip=$(aws ec2 describe-instances --instance-ids $instance_id --output text --query Reservations[*].Instances[*].PublicIpAddress)
    echo instance $instance_id@$public_ip $state
}

source config.sh
launch |& tee -a upandout.log
