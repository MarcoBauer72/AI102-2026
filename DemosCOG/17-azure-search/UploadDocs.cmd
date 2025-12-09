@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

rem Set values for your storage account
set subscription_id=ce3ee0e4-0788-44be-a61c-9232dad526dc
set azure_storage_account=azstgacctbauer102
set azure_storage_key=ImPFKctebKcETqlrG1aSpGnJlwUYDFW9XgsdKsY3cdX7tZOI9LVrn9eMbVsvP9JMY5LzhFFQnpBj+AStnbJ0lg==


echo Creating container...
call az storage container create --account-name !azure_storage_account! --subscription !subscription_id! --name margies --auth-mode key --account-key !azure_storage_key! --output none

echo Uploading files...
call az storage blob upload-batch -d margies -s data --account-name !azure_storage_account! --auth-mode key --account-key !azure_storage_key!  --output none
