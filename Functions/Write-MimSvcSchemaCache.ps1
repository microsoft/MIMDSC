function Write-MimSvcSchemaCache
{
<#
.Synopsis
   Write the MIM Schema to a cache folder on disk
.DESCRIPTION
    1. Test the cache folder age
    2. Get all the attribute types by object type
    3. Output to a serialized file per object type
.EXAMPLE
   Write-MimSvcSchemaCache
.EXAMPLE
   Write-MimSvcSchemaCache -CacheLocation C:\Temp
.EXAMPLE
   Write-MimSvcSchemaCache -CacheAge ([TimeSpan]::FromSeconds(60))
#>
    [CmdletBinding()]
    Param
    (
        # Cache Folder (defaults to $env:ProgramData\MimDsc\BoundAttributesCache)
        $CacheLocation = "$env:ProgramData\MimDsc\BoundAttributesCache",

        # Cache Age (defaults to one day)
        [TimeSpan]
        $CacheAge = [TimeSpan]::FromDays(1)
    )
    Write-Verbose "Using CacheLocation: $CacheLocation"
    Write-Verbose "Using CacheAge:      $($CacheAge.TotalMinutes) (in minutes)"

    $needToWriteCache = $false
    ### Create the folder if it doesn't already exist
    if(Test-Path -PathType Container $CacheLocation)
    {
        $CacheCreationTime = Get-Item -Path $CacheLocation | Select-Object -ExpandProperty CreationTime
        if ([DateTime]::Now.Subtract($CacheCreationTime) -ge $CacheAge)
        {
            Write-Verbose "Cache present but expired, wipe it."
            Remove-Item -Path $CacheLocation -Recurse
            mkdir $CacheLocation -Force | Out-Null
            $needToWriteCache = $true
        }
    }
    else
    {
        Write-Verbose "Cache not present, creating the folder: $CacheLocation" 
        mkdir $CacheLocation | Out-Null
        $needToWriteCache = $true
    }

    if ($needToWriteCache)
    {
        foreach ($mimObjectType in Search-Resources -XPath "/ObjectTypeDescription" -ExpectedObjectType ObjectTypeDescription)
        {
            Write-Verbose "Getting bound attributes for '$($mimObjectType.Name)'"
            $boundAttributes = Search-Resources -XPath  @"
                        /BindingDescription
                        [
                            BoundObjectType= /ObjectTypeDescription
                            [
                                Name='$($mimObjectType.Name)'
                            ]
                        ]
                        /BoundAttributeType
"@ -ExpectedObjectType AttributeTypeDescription
            $boundAttributes | Export-Clixml -Path (Join-Path $CacheLocation $mimObjectType.Name)
        }
    }
    else
    {
        Write-Verbose "Cache still valid, leave it"
    }
}