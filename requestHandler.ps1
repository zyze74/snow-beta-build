$hookUrl = $env:DISCORD_WEBHOOK_URL

$Host.UI.RawUI.ForegroundColor = 'Blue'

Clear-Host

if ([string]::IsNullOrEmpty($hookUrl)) {
    $Host.UI.RawUI.ForegroundColor = 'Red'
    Write-Output "Webhook URL: Invalid"
    Write-Output ""
    Write-Output "Error: Webhook URL is not set."
    exit
} else {
    $Host.UI.RawUI.ForegroundColor = 'Green'
    Write-Output "Webhook URL: Valid"
    $Host.UI.RawUI.ForegroundColor = 'Blue'
    Write-Output ""
    Write-Output 'Start typing and enter your Feeback:'
}

$message = Read-Host '# '
$payload = [PSCustomObject]@{content = $message}
Invoke-RestMethod -Uri $hookUrl -Method Post -Body ($payload | ConvertTo-Json) -ContentType 'Application/Json'

Clear-Host

Write-Output 'Feedback submitted. You can now close this window.'
exit;
# created by @zyze74
