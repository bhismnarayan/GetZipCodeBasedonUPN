 function GetAccessToken()
{
$tenantid="f2d60021-0711-4ff3-b3f6-572c056aee04"
 $clientid="ce85d218-fee0-430d-a6c9-c1875888382b"
 $clientsecret="nZYoRca7bqINFivoiimPAZQO/thab7LLyHaPpR/eDws="
 $tokenRoute = "https://login.microsoftonline.com/${tenantid}/oauth2/token";

    $creds = @{
         client_id= $clientid
        client_secret = $clientsecret
        grant_type = "client_credentials"
        resource="https://graph.microsoft.com/"
    }  
   
    $token = ""

    $response = Invoke-RestMethod $tokenRoute -Method Post -Body $creds
    $token = $response.access_token;
    return $token
    }

    function GetUserZipCode(){
    Try
{
    $token=$(GetAccessToken)
    $userprincipal = Read-Host -Prompt 'Enter User UPN';
#$userprincipal="ceae348c-776b-443d-94ad-0730a08e4727"

$Url = "https://graph.microsoft.com/v1.0/users/${userprincipal}?`$select=displayName,givenName,postalCode"
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"    
$headers.Add("Authorization", "Bearer $token")
Try{
$response1=Invoke-RestMethod -Method 'Get' -Uri $url -Headers $headers 
return $response1.postalCode
}Catch{
return  $_.Exception.Response.StatusDescription

}
}
Catch{
return "Error occured in finding users"
}
}

$(GetUserZipCode)
