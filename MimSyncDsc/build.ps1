### Build script called by Azure Pipelines
Write-Host "I'm the build script"

# Install Pester module if it is not already installed
if (-not (Get-Module -Name Pester -ListAvailable))
{
    Write-Host "Installing Pester"
    Install-Module -Name Pester -Scope CurrentUser -Force -Confirm:$false
}

### Find out what version of Pester we have
Get-Module Pester -ListAvailable

Write-Host 'Copy MimSyncDsc module files to Program Files'
Copy-Item .\MimSyncDsc "$env:ProgramFiles\WindowsPowerShell\Modules" -Container -Recurse -Verbose -Force

Write-Host 'Copy Sync Configuration Files'
New-Item -ItemType Directory -Path "$env:ProgramData\MimSyncDsc\Svrexport" -Verbose -Force | Out-Null
Copy-Item -Path .\MimSyncDsc\Tests\MimSyncServerConfiguration\* "$env:ProgramData\MimSyncDsc\Svrexport\" -Force -Verbose

### Run Tests
$TestResults = Invoke-Pester -Script .\MimSyncDsc\Tests\MimSyncExportAttributeFlowRule.tests.ps1 -ExcludeTag RunsInLocalConfigurationManager -PassThru

if($TestResults.FailedCount -gt 0)
{
    Write-Error -Message "Test pass failed: `n`t$($TestResults.PassedCount) passed`n`t$($TestResults.FailedCount) failed "
}