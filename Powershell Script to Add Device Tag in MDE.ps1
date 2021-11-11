##############################################
# The Script will Add tags to MDE using API  #
##############################################
#Paste your tenant ID,app ID,app keys
#This will create and Store auth token for future use
$tenantId = ‘’ #Paste Your Tenant ID
$appId = ‘’    #paste Your App ID
$appSecret = ‘’  #paste your App Key
$resourceAppIdUri = 'https://api.securitycenter.microsoft.com'
$oAuthUri = "https://login.microsoftonline.com/$tenantId/oauth2/token"
$authBody = [Ordered] @{
   resource = “$resourceAppIdUri”
    client_id = “$appId”
    client_secret = “$appSecret”
    grant_type = ‘client_credentials’
}
$authResponse = Invoke-RestMethod -Method Post -Uri $oAuthUri -Body $authBody -ErrorAction Stop
$token = $authResponse.access_token
$headers = @{
        ‘Content-Type’ = ‘application/json’
        Accept = ‘application/json’
        Authorization = “Bearer $token”
    }
# Clean variables
$Data = @();
$MachineName = $null;
$MachineTag = $null;
$MachineId = $null;
$Data = Import-Csv -Path C:\Users\anandp\Desktop\test_tag.csv #provide your File Location 
# Add Tag as per the input file  
$Data | foreach {
    $MachineName = $($_.Name);
    $MachineTag = $($_.Tag);
    $url = “https://api.securitycenter.microsoft.com/api/machines/$MachineName" 
    $webResponse = Invoke-RestMethod -Method Get -Uri $url -Headers $headers -ErrorAction Stop
    $MachineId = $webResponse.id;
    $body = @{
      “Value”=$MachineTag;
      “Action”=”Add”;
    }
    $url = “https://api.securitycenter.microsoft.com/api/machines/$MachineId/tags” 
    $webResponse = Invoke-WebRequest -Method Post -Uri $url -Headers $headers -Body ($body|ConvertTo-Json) -ContentType “application/json” -ErrorAction Stop
    # Clean variables 
    $MachineName = $null;
    $MachineTag = $null;
    $MachineId = $null;
}
