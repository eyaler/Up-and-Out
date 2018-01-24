Up-and-Out: A script for running experiments on EC2

"We are habermans in the flesh. We are cut apart, brain and flesh. We are ready to go to the up-and-out."

Features:
1. Launch a new EC2 instance
2. Sync changed files
3. In a detached tmux session:
    1. Run experiment
    2. Email output
    3. Stop instance when done/failed
4. Terminate instance if tmux did not start, and check whether termination was successful

Usage:
1. Prepare an AMI with your work environment
2. Locally requires: bash, rsync
3. Replace placeholders in config.sh.template and save as config.sh
4. Gotcha: don't use ~ in remote paths
5. You may want to set a filter in your email client to "never send to spam" for messages with titles "EC2 run finished", "EC2 NOT stopped"

Todo:
1. Allow using spot instances
2. Write output to remote DB
3. Freeze local files until copied
