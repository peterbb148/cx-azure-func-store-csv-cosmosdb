using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
# Interact with the body of the request.
$req = $Request.Body
if (-not $req) {
    $status = [HttpStatusCode]::InternalServerError    
    $msg = $status + "Please pass JSON data in the request body."
}
else {
    $status = [HttpStatusCode]::OK
    $timestamp = Get-date -Format "yyyy-MM-ddTHH:mm:ssZ"
    $partition = Get-date -Format "yyyy-MM-dd"
    $body = $req.ToString()
    Write-host $body
    $documentName = "Customer"
    $source = "SAP"
    $preamble = '{ "header": { "timestamp": "' + $timestamp + '", "source": "' + $source + '", "version": "1.0", "documentName": "'+ $documentName +'", "date": "'+ $partition +'", "partitionKey": "'+ $partition +'" }, "document": '
    $postfix = '}'
    $msg = $preamble + $body + $postfix
}
Write-host $msg

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $status
    Body = $msg
})
#Push-OutputBinding -Name outputDocument -Value $msg