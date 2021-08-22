#!/bin/bash

# 1. Creating a GKE Cluster name app-01
echo "Creating GKE Cluster app-01"

gcloud container clusters create app-01 \
--project=$DEVSHELL_PROJECT_ID --zone=us-west1-a --machine-type n1-standard-4 \
--cluster-version=1.19.12 --release-channel=stable --image-type ubuntu \
--num-nodes 1 --enable-stackdriver-kubernetes \
--subnetwork "projects/$DEVSHELL_PROJECT_ID/regions/us-west1/subnetworks/default"

read -p "Please wait. Verify Cluster is created & press any key... "$'\n' -n1 -s  



#---------------------------------------------------------------------------
# 2. Install Migrate for Anthos
echo "==Starting Migrate for Anthos=="$'\n'

# 2.1 Create a service account : tcb-m4a-install
echo "> 2.1 Creating service account : tcb-m4a-install"

gcloud iam service-accounts create tcb-m4a-install --project=$DEVSHELL_PROJECT_ID

read -p "Please wait. Press any key... "$'\n' -n1 -s 

# 2.2 Assigning storage.admin role to tcb-m4a-install
echo "> 2.2 Assigning storage.admin role tcb-m4a-install"

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member="serviceAccount:tcb-m4a-install@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com" --role="roles/storage.admin"

read -p "Please wait. Press any key... "$'\n' -n1 -s 


# 3. Creating and downloading the serviceaccount tcb-m4a-install key
echo "Creating and downloading the serviceaccount tcb-m4a-install key"
gcloud iam service-accounts keys create tcb-m4a-install.json --iam-account=tcb-m4a-install@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --project=$DEVSHELL_PROJECT_ID

read -p "Please wait. Press any key... "$'\n' -n1 -s 

# 4. Connecting to K8s cluster
echo "Connecting to K8s cluster : app-01"

gcloud container clusters get-credentials app-01 --zone us-west1-a --project $DEVSHELL_PROJECT_ID

read -p "Please wait. Press any key... "$'\n' -n1 -s 



#----------------------------------------------------------------------------
# 5. Setting up the Migrate for Anthos components in GKE cluster app-01 
echo "Setting up the Migrate for Anthos components in GKE cluster app-01"

migctl setup install --json-key=tcb-m4a-install.json

read -p "Please wait. Press any key... "$'\n' -n1 -s 


# 6. Validate the Migrate for Anthos installation:
echo "Verfy Migration.."
migctl doctor

read -p "Please wait. Press any key... "$'\n' -n1 -s 