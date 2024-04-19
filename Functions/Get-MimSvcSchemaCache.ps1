function Get-MimSvcSchemaCache
{
<#
.Synopsis
    Gets attributes from the MIM Schema by ojbect type
.DESCRIPTION
    Finds the serialized MIM objects in the MIM Schema cache, then deserializes them and outputs them
.EXAMPLE
   Get-MimSvcSchemaCache -ObjectType Person
.EXAMPLE
   Get-MimSvcSchemaCache -ObjectType Person | Convert-MimSvcExportToPSObject
#>
    [CmdletBinding()]
    Param
    (
        # Cache Folder (defaults to $env:ProgramData\MimDsc\BoundAttributesCache)
        $CacheLocation = "$env:ProgramData\MimDsc\BoundAttributesCache",

        # Object Type
        $ObjectType
    )
    Write-Verbose "Using CacheLocation: $CacheLocation"
    Write-Verbose "Using ObjectType:    $ObjectType"

    Import-Clixml -Path (Join-Path $CacheLocation $ObjectType)
}