#!/bin/bash
#
#  v 1.0 (mano@xkanda.com)
#  This script implements the lift and shift solution
#----------------------------------------------------------------------


# Pre-requisities
#   Ensure Billing is enabled for the project in account management
#   Enable following API inside the project
#     o Cloud Resource Manager API
#     o Compute Engine API
#     o Kubernetes Engine API
#   Ensure you are inside the correct cloud shell project

# A. Set project in GCP Console if not already set 
#   gcloud config set project project_name

# B. Set up compute zone
#   gcloud config set compute/zone us-west1-a
#   How to get current compute zone?

# 1. Add Firewall rules to allow traffic on HTTP & SSH ports 
echo "Creating allow http firewall-rule (Port 80)"$'\n'
gcloud compute firewall-rules create allow-http --network default --allow tcp:80 --source-ranges 0.0.0.0/0

echo "Creating allow ssh firewall-rule (Port 22)"$'\n'
gcloud compute firewall-rules create allow-ssh --network default --allow tcp:22 --source-ranges 0.0.0.0/0


#2. Create a VM instance app-01:
echo "Creating compute instance app-01"$'\n'
gcloud compute instances create app-01 --project=$DEVSHELL_PROJECT_ID \
  --zone=us-west1-a --machine-type=n1-standard-1 --subnet=default \
  --scopes="cloud-platform" --tags=http-server,https-server \
  --image=ubuntu-minimal-1604-xenial-v20210119a --image-project=ubuntu-os-cloud \
  --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=app-01

read -p "Please wait for instance to be created. Press any key after completed... "$'\n' -n1 -s 


#3. Generatingkeypairandsettingupthepermissions.
echo "Generate ssh key with right permissions"$'\n'
ssh-keygen -t rsa -f ~/.ssh/app-key -C xkandacloud

chmod 400 ~/.ssh/app-key

read -p "Press any key when ready..!"$'\n' -n1 -s 


#4. Checking the changes permission:
echo "Generate ssh key with right permissions - read"$'\n'

ls -l ~/.ssh | grep app-key 

read -p "Press any key when ready..!"$'\n' -n1 -s 


#5. Importing the key pair generated to GoogleCloud:
echo "Generate ssh key with right permissions"$'\n'

gcloud compute config-ssh --ssh-key-file=~/.ssh/app-key

read -p "Verify key permissions. Press any key when ready..!"$'\n' -n1 -s 


#6. Lift & Shift the web app (portal) to VM Instance
#   That is to say we zip the app files and then move that to the
#   Final instructions
#   sudo curl -O https://storage.googleapis.com/bootcamp-gcp-en/hands-on-compute-website-files-en.zip
echo "Update the VM & libs"$'\n'
echo "SSH to the VM and run these commands:"$'\n'
echo "sudo apt-get update && sudo apt-get install apache2 unzip -y"$'\n'
echo "cp the app zip to web home & apply right access permissions"$'\n'
echo "chmod 644 *"$'\n'

#8. To check if our webserver is functioning properly
echo "Navigate to external IP address of VM on browser and check the talent website"$'\n'
  
read -p "Run the above commands. If all well, you will see the web page! Press any key..."$'\n' -n1 -s 
