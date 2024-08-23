
$hookUrl = $env:DISCORD_WEBHOOK_URL

Write-Output "Webhook URL: Valid"

if ([string]::IsNullOrEmpty($hookUrl)) {
    Write-Output "Error: Webhook URL is not set."
    exit
}

Write-Output 'Enter your request below'
$message = Read-Host ':'
$payload = [PSCustomObject]@{content = $message}
Invoke-RestMethod -Uri $hookUrl -Method Post -Body ($payload | ConvertTo-Json) -ContentType 'Application/Json'
Write-Output 'Request sent. You can now close this window.'
exit;
