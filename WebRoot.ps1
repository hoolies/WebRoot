# Prerequisites: WebRoot API activation, Parent KeyCode and GLobal Admin Account
# This script will check all the sites of the management console and export a csv with all the endpoints of each site
# Invoke-RestMode is the curl equivalent. We set first the parameters, then we run a POST to creat a Access Token, then we run a GET to get all the sites, finally we run a GET to get all the endpoints per site.

# Creates spreadsheets' folder if it does not exist
$path = Read-Host "Enter the path where the output will be saved"
If(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path
}


# Provide the API credentials to connect to Webroot
$APIClientID = Read-Host "Enter your API client ID"
$APIPassword = Read-Host "Enter your API client passowrd"

# Provide a Webroot Global Admin Account
$WebrootUser = Read-Host "Enter your WebRoot Global Admin Accountt"
$WebRootPassword = Read-Host "Enter your WebRoot Global Account Password"

# This is the Parent KeyCode
$Keycode = Read-Host "Emter you Parent KeyCode"

# Specify the URL we will connect to initially to obtain a token that will be used for future connections
$TokenURL = 'https://unityapi.webrootcloudav.com/auth/token'

# Once we have the token, this is where we will pull the desired endpoint data from
$MainURL = "https://unityapi.webrootcloudav.com/service/api/console/gsm/$KeyCode/sites"

# The REST API requires that the credentials are based as a base 64 string
$Credentials = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($APIClientID+":"+$APIPassword ))

# Obtain the Access token
$Params = @{
"ErrorAction" = "Stop"
"URI" = $TokenURL
"Headers" = @{"Authorization" = "Basic "+ $Credentials}
"Body" = @{
"username" = $WebrootUser
"password" = $WebrootPassword
"grant_type" = 'password'
"scope" = '*'
}
"Method" = 'post'
"ContentType" = 'application/x-www-form-urlencoded'
}

# Set the Access token
$AccessToken = (Invoke-RestMethod @Params).access_token
Write-Output   "Obtained the access token"

# Obtain the Site ID for the provided keycode 
$Params = @{
"ErrorAction" = "Stop"
"URI" = $MainURL
"ContentType" = "application/json"
"Headers" = @{"Authorization" = "Bearer "+ $AccessToken}
"Method" = "Get"
}

# Set an array with all sites' information
$Companies = (Invoke-RestMethod @Params).Sites

# Export the list with all the site Names and IDs
$Companies | Select-Object -Property SiteName,SiteID | Export-Csv C:\Temp\Webroot\00Sites.csv

# A loop to search recursivly all the sites
ForEach ($Company in $Companies){
    # Set the Site ID
    $SiteID = ($Company | ForEach-Object {$_.SiteID})
    # Set the Site Name
    $SiteName = ($Company | ForEach-Object {$_.SiteName})
    Write-Output "Generating list of active Endpoints for $SiteName"
    # Set the endpoint URL of the specific Site ID
    $EndpointURL = "https://unityapi.webrootcloudav.com/service/api/console/gsm/$KeyCode/sites/$SiteID" +'/endpoints?PageSize=1000'

    # Set the parameters in order to fetch the endpoints
    $Params = @{
    "ErrorAction" = "Stop"
    "URI" = $EndpointURL
    "ContentType" = "application/json"
    "Headers" = @{"Authorization" = "Bearer "+ $AccessToken}
    "Method" = "Get"
    }

    # Connect to Webroot console and get a list of all active endpoints
    $AllEndpoints = (Invoke-RestMethod @Params)
    
    # Export the list in a spreadshit with the name of the site
    $Allendpoints.Endpoints | Export-Csv -Path $path/$Company.csv
}
# If you see this message the script run successfully
Write-Output "The Script has run successfully!"
