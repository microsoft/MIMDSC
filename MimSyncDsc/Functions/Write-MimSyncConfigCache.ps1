function Write-MimSyncConfigCache
{
<#
.Synopsis
   Write the Sync Server Configuration XML to a cache folder on disk
.DESCRIPTION
    1. Test the cache folder age
    2. Export the server configuration to the folder
.EXAMPLE
   Write-MimSyncConfigCache
.EXAMPLE
   Write-MimSyncConfigCache -CacheLocation C:\Temp
.EXAMPLE
   Write-MimSyncConfigCache -CacheAge ([TimeSpan]::FromSeconds(60))
#>
    [CmdletBinding()]
    Param
    (
        # Cache Folder (defaults to $env:ProgramData\MimSyncDsc\Svrexport)
        $CacheLocation = "$env:ProgramData\MimSyncDsc\Svrexport",

        # Cache Age (defaults to one day)
        [TimeSpan]
        $CacheAge = [TimeSpan]::FromDays(1)
    )
    Write-Verbose "Using CacheLocation: $CacheLocation"
    Write-Verbose "Using CacheAge:      $($CacheAge.TotalMinutes) (in minutes)"

    ### Create the folder if it doesn't already exist
    if(-not (Test-Path -PathType Container $CacheLocation))
    {
        mkdir $CacheLocation | Out-Null
    }

    $CacheCreationTime = Get-Item -Path $CacheLocation | Select-Object -ExpandProperty CreationTime
    if ([DateTime]::Now.Subtract($CacheCreationTime) -ge $CacheAge)
    {
        Write-Verbose "Cache expired, wipe it"
        Remove-Item -Path $CacheLocation -Recurse

        Get-MimSyncServerXml -Path $CacheLocation     
    }
    else
    {
        Write-Verbose "Cache still valid, leave it"
    }
}