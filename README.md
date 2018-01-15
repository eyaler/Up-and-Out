Up-and-Out: A script for running experiments on EC2

"We are habermans in the flesh. We are cut apart, brain and flesh. We are ready to go to the up-and-out."

Features:
1. Launch a new EC2 instance
2. Sync changed files
3. In a detached tmux session:
    a. Run experiment
    b. Email output
    c. Stop instance when done/failed
4. Terminate instance if tmux did not start, and check whether termination was successful

Usage:
1. Prepare an AMI with your work environment
2. Locally requires: bash, rsync
3. Replace placeholders in config.sh.template and save as config.sh
4. Gotcha: don't use ~ in remote paths

Todo:
1. Allow using spot instances
2. Write output to remote DB
3. Freeze local files until copied
