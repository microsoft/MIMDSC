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

Write-Host 'Copy MimDsc module files to Program Files'
Remove-Item "$env:ProgramFiles\WindowsPowerShell\Modules\MimDsc" -Force -Verbose -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path "$env:ProgramFiles\WindowsPowerShell\Modules\MimDsc" -Verbose -Force | Out-Null
Copy-Item * "$env:ProgramFiles\WindowsPowerShell\Modules\MimDsc" -Recurse -Verbose -Force -Exclude .git

Write-Host 'Copy Sync Configuration Files'
New-Item -ItemType Directory -Path "$env:ProgramData\MimDsc\Svrexport" -Verbose -Force | Out-Null
Copy-Item -Path .\Tests\MimSyncServerConfiguration\* "$env:ProgramData\MimDsc\Svrexport\" -Force -Verbose

### Run Tests
$TestResults = Invoke-Pester -Script .\Tests\*.tests.ps1 -Tag Build  -ExcludeTag RunsInLocalConfigurationManager -OutputFile MimSyncDsc.testresults.xml -OutputFormat NUnitXML

if($TestResults.FailedCount -gt 0)
{
    Write-Error -Message "Test pass failed: `n`t$($TestResults.PassedCount) passed`n`t$($TestResults.FailedCount) failed "
}