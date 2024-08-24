$hookUrl = $env:DISCORD_WEBHOOK_URL

if ([string]::IsNullOrEmpty($hookUrl)) {
    Write-Output "Webhook URL: Invalid"
    Write-Output "Error: Webhook URL is not set."
    exit
} else {
    Write-Output "Webhook URL: Valid"
}

Write-Output 'Enter your request below'
$message = Read-Host ':'
$payload = [PSCustomObject]@{content = $message}
Invoke-RestMethod -Uri $hookUrl -Method Post -Body ($payload | ConvertTo-Json) -ContentType 'Application/Json'
Write-Output 'Request sent. You can now close this window.'
exit;

