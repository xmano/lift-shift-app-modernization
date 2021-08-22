#!/bin/bash

#---------------------------------------------------------------------------
# Starting VM Migration
echo "==Starting VM Migration=="$'\n'

# 1. Create a service account : tcb-m4a-ce-src
echo "> 1 Creating service account : tcb-m4a-ce-src"

gcloud iam service-accounts create tcb-m4a-ce-src --project=$DEVSHELL_PROJECT_ID

read -p "Please wait. Press any key... "$'\n' -n1 -s 

# 2 Assigning compute.viewer role to tcb-m4a-ce-src
echo "> 2 Assigning compute.viewer role tcb-m4a-ce-src"

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member="serviceAccount:tcb-m4a-ce-src@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com" --role="roles/compute.viewer"

read -p "Please wait. Press any key... "$'\n' -n1 -s 


# 3 Assigning compute.storageAdmin role to tcb-m4a-ce-src
echo "> 3 Assigning compute.storageAdmin role tcb-m4a-ce-src"

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member="serviceAccount:tcb-m4a-ce-src@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com" --role="roles/compute.storageAdmin"

read -p "Please wait. Press any key... "$'\n' -n1 -s 


# 4. Creating and downloading theservice account tcb-m4a-ce-src key
echo "Creating and downloading the service account tcb-m4a-ce-src key"

gcloud iam service-accounts keys create tcb-m4a-ce-src.json --iam-account=tcb-m4a-ce-src@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --project=$DEVSHELL_PROJECT_ID

read -p "Please wait. Press any key... "$'\n' -n1 -s 

# 5. Defining the Compute Engine Source 
echo "Defining the Compute Engine Source"

migctl source create ce app-01-source --project $DEVSHELL_PROJECT_ID --json-key=tcb-m4a-ce-src.json

read -p "Please wait. Press any key... "$'\n' -n1 -s 



#----------------------------------------------------------------------------
# 6. Create the migration plan 
echo "Create the migration plan : my-migration for app-01-source"

migctl migration create my-migration --source app-01-source --vm-id app-01 --intent Image

read -p "Please wait. Press any key... "$'\n' -n1 -s 


# 7. Check the migration status
echo "Check the migration status:"
migctl migration status my-migration

read -p "Please wait. Press any key... "$'\n' -n1 -s 


# 8. Download the migration plan
echo "(Optional) Download the migration plan:"
migctl migration get my-migration

read -p "Please wait. Press any key... "$'\n' -n1 -s 


# 9. Optional step : modify my-migration plan
echo "(Optional) Modify the migration plan by editing my-migration.yaml:"

read -p "Open a new terminal and run the command below if anything changed... "$'\n' -n1 -s 
echo "migctl migration update my-migration --file my-migration.yaml"

read -p "Did migration update successfully? After confirming press key to continue.."$'\n' -n1 -s 

read -p "Ok to Proceed?. Press any key... "$'\n' -n1 -s 


# 8. Execute the VM migration plan
echo "Begin the VM migration: (Note this may take upto 10min)"
migctl migration generate-artifacts my-migration

echo "Check the migration status:"
migctl migration status my-migration
read -p "Please wait. Press any key... "$'\n' -n1 -s 

echo "Check the migration status:"
migctl migration status my-migration

read -p "Please wait for migration to complete. Press any key... "$'\n' -n1 -s 

#-----------------------------------------------------------------------------------
# Final step: Deployment
echo "-----------------------------------------------------"
echo "Proceeding towards deployment...."

