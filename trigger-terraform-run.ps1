[CmdletBinding()]
param (
    [Parameter()]
    [string]$workspaceId,

    [Parameter()]
    [string]$token, 

    [Parameter()]
    [string]$triggerMessage
)

$body = @{
    data = @{
        attributes    = @{
            message      = $triggerMessage
            "auto-apply" = $true
        }
        type          = "runs"
        relationships = @{
            workspace = @{
                data = @{
                    type = "workspaces"
                    id   = $workspaceId
                }
            }
        }
    }
}
$jsonBody = $body | ConvertTo-Json -Depth 5
$header = @{
    Authorization  = "Bearer $token"
    "Content-Type" = "application/vnd.api+json"
}
$parameters = @{
    header = $header
    method = "POST"
    body   = $jsonBody
}
# Start to run the workspace
$runUrl = "https://app.terraform.io/api/v2/runs/"
$runData = (Invoke-RestMethod -Uri $runUrl @parameters).data


# Check for current run status
$runDataUrl = $runUrl+ $runData.id
$status = (Invoke-RestMethod -Uri $runDataUrl -Headers $header -Method GET).data.attributes.status
do {
    $status = (Invoke-RestMethod -Uri $runDataUrl -Headers $header -Method GET).data.attributes.status
    $status
}
while ($status -ne 'applied')