function Write-MimDscAuditObject
{
<#
.Synopsis
   Writes a file containing audit details for the MIM DSC resources
.DESCRIPTION
   The Set-TargetResource and Test-TargetResource functions of a DSC resource use this function to output audit details.  The details are stored in a custom object then serialized to a file.
.EXAMPLE
   Example for using the command for Test-TargetResource
Write-MimDscAuditObject -XpathFilter "/Person[HoofHoofhearted='IceMelted']" -ObjectTestResult $false -DscBoundParameters @{param1='foo';param2='bar'} -CurrentObject @{param1='foo';param2='bar'}
dir "$env:ProgramData\MimSyncDsc\Audit-TestTargetResource\*.clixml" | 
Select-Object -last 1 | 
Import-Clixml

.NOTES
   The output is created in the 'ProgramData' folder which is hidden by default in Exporer.
#>
    [CmdletBinding()]
    Param
    (
        # The XPath filter for the MIM object
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        $XpathFilter,

        # The Sync object in the current configuration
        $CurrentObject,

        # The result of the Test-TargetResource function
        [Boolean]
        $ObjectTestResult,

        # The bound parameters sent to the function
        $DscBoundParameters,

        # The error, which never happens, really
        $ErrorRecord
    )


    $AuditLocation = "$env:ProgramData\MimSyncDsc\Audit-TestTargetResource"

    $AuditObject = [pscustomobject]@{
        fimXpath           = $XpathFilter
        CurrentObject      = $CurrentObject
        ObjectTestResult   = $ObjectTestResult
        DscBoundParameters = $DscBoundParameters
        ErrorRecord        = $ErrorRecord
    }

    ###
    ### Output the audit object
    ###
    if(-not (Test-Path -PathType Container $AuditLocation))
    {
        mkdir $AuditLocation -Force | Out-Null
    }

    Export-Clixml -InputObject $AuditObject -Path (Join-Path $AuditLocation "$([DateTime]::Now.Ticks).clixml")
}