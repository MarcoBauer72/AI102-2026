# Set values for your storage account
$subscriptionId = "ce3ee0e4-0788-44be-a61c-9232dad526dc"
$azureStorageAccount = "azstgacctbauer102"
$azureStorageKey = "ImPFKctebKcETqlrG1aSpGnJlwUYDFW9XgsdKsY3cdX7tZOI9LVrn9eMbVsvP9JMY5LzhFFQnpBj+AStnbJ0lg=="


# Set the context for the subscription
Write-Host "Setting Azure context..."
Set-AzContext -SubscriptionId $subscriptionId

$storageContext = (New-AzStorageContext -StorageAccountName $azureStorageAccount -StorageAccountKey $azureStorageKey)
$containerName = "margies"

# Create the storage container
Write-Host "Creating container..."
New-AzStorageContainer -Name $containerName -Context $storageContext | Out-Null

# Upload files to the container
Write-Host "Uploading files..."
# Recursively get all files in the local folder
$files = Get-ChildItem -Path "./data" -Recurse -File

# Upload each file to the blob container
foreach ($file in $files) {
    # Determine the relative path for the blob
    $relativePath = $file.FullName.Substring($localFolderPath.Length + 1).Replace("\", "/")
    
    # Upload the file
    Set-AzStorageBlobContent -File $file.FullName -Container $containerName -Blob $relativePath -Context $storageContext
    Write-Host "Uploaded: $relativePath"
}

Write-Host "All files uploaded successfully!"