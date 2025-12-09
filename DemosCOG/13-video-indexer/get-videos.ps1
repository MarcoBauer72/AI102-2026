$account_id="74b23ef4-b1a7-431f-8da3-4460e4379524"
$api_key="3b77edd38dbd4cc8ad31150328dce60a"
$location="trial"

# Clear the console window
cls

# Call the AccessToken method with the API key in the header to get an access token
$token = Invoke-RestMethod -Method "Get" -Uri "https://api.videoindexer.ai/auth/$location/Accounts/$account_id/AccessToken" -Headers @{'Ocp-Apim-Subscription-Key' = $api_key}

# Use the access token to make an authenticated call to the Videos method to get a list of videos in the account
Invoke-RestMethod -Method "Get" -Uri "https://api.videoindexer.ai/$location/Accounts/$account_id/Videos?accessToken=$token" | ConvertTo-Json -Depth 6
