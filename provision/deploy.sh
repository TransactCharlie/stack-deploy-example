#!/bin/bash

BUILD_DIR="build$1"
KEY="$2"
JUMP_HOST="$3"
JUMP_PORT=2222
JUMPBOX="ec2-user@$JUMP_HOST"
SSH_FLAGS="-i `pwd`/keys/$KEY -p $JUMP_PORT -o StrictHostKeyChecking=no -o CheckHostIP=no"

#Limiting Srync bandwidth is very useful at home.... otherwise you may max out your pipe!
# RSYNCH_BANDWIDTH_LIMIT=175

# change key permissions
chmod 0600 keys/$KEY
chmod 0700 keys

# make build directory
ssh $SSH_FLAGS $JUMPBOX "mkdir ~/$BUILD_DIR"

# rsync files to jumpbox
rsync -avz --bwlimit=$RSYNCH_BANDWIDTH_LIMIT --progress -e "ssh $SSH_FLAGS" . $JUMPBOX:~/$BUILD_DIR

# make inventory executable
ssh $SSH_FLAGS $JUMPBOX "chmod +x ~/$BUILD_DIR/aws_inventory/ec2*"

# change permissions of key file
ssh $SSH_FLAGS $JUMPBOX "chmod 0600 ~/$BUILD_DIR/keys/*; chmod 0700 ~/$BUILD_DIR/keys;"

# run playbook on jumpbox
ssh -i keys/$KEY -p $JUMP_PORT $JUMPBOX "cd ~/$BUILD_DIR; ansible-playbook webserver.yml -i aws_inventory/ --private-key=keys/$KEY"

# ssh to jumpbox
ssh $SSH_FLAGS $JUMPBOX
