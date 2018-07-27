$requestBody = Get-Content $req -Raw | ConvertFrom-Json
$upn = $requestBody.upn

if ($req_query_upn) 
{
    $upn = $req_query_upn
}
else{
	$zipcode= "Please pass a name on the query string or in the request body"
}
$tenantid= $env:tenantid
 $clientid=$env:clientid
 $clientsecret=$env:clientsecret
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
	$userprincipal = $upn;
#$userprincipal="ceae348c-776b-443d-94ad-0730a08e4727"

Try{
$Url = "https://graph.microsoft.com/v1.0/users/${userprincipal}?`$select=displayName,givenName,postalCode"
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"    
$headers.Add("Authorization", "Bearer $token")
Try{
$response1=Invoke-RestMethod -Method 'Get' -Uri $url -Headers $headers 
$zipcode= $response1.postalCode
}Catch{
$zipcode=  $_.Exception.Response.StatusDescription

}
}
Catch{
$zipcode= "Error occured in finding users"
}

Out-File -Encoding Ascii -FilePath $res -inputObject "$zipcode"




