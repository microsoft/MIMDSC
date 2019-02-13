function Get-MimSyncServerXml
{
<#
.Synopsis
   Gets the Server Configuration XML for the Synchronization Service
.DESCRIPTION
   Uses svrexport.exe to return the server XML
.EXAMPLE
   Get-MimSyncServerXml
#>
    [CmdletBinding()]
    Param
    (
        # Path to store server configuration
        [Parameter(Position=0)]
        $Path = (Join-Path $HOME "SyncConfig$((Get-Date).ToString('yyyy-MM-dd_hh-mm-ss'))"),

        # Force svrexport.exe to overwrite files
        [Switch]
        $Force
    )

    ##TODO - do this better such that we handle failures in the command
    if ((Test-Path $Path) -and $Force)
    {
        Write-Verbose "Removing existing folder: $Path"
        Remove-Item -Path $Path -Force -Recurse
    }
    elseif (Test-Path $Path)
    {
        throw "Path exists already, consider using the -Force parameter to replace it."
    }

    Write-Verbose "Creating folder: $Path"
    New-Item -Path $Path -ItemType Directory | Out-Null

    Write-Verbose "Calling svrexport.exe with path: $Path"
    & (join-path (Get-MimSyncPath) \bin\svrexport.exe) $Path 
}##Closing: function Get-MimSyncServerXml