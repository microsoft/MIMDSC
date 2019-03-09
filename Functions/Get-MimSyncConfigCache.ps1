function Get-MimSyncConfigCache
{
<#
.Synopsis
    Gets the folder where the MIM Sync server configuration is cached
.EXAMPLE
   Get-FimSyncConfigCache
#>

    # Cache Folder (defaults to $env:ProgramData\MimDsc\BoundAttributesCache)
    $CacheLocation = "$env:ProgramData\MimDsc\Svrexport"

    Write-Verbose "Using CacheLocation: $CacheLocation"

    Get-Item -Path $CacheLocation
}