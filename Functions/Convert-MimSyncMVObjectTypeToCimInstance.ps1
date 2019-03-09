function Convert-MimSyncMVObjectTypeToCimInstance
{
<#
.Synopsis
   Converts the Sync XML MVObjectType to a CIM Instance
.DESCRIPTION
   Sync uses XML to represent the configuration objects
   DSC uses CIM instances to work with custom MOF classes
   It is necessary for the DSC resource to create CIM instances from the Sync XML 
.EXAMPLE
   Get-MimSyncServerXml -Path (Get-MimSyncConfigCache) -Force
   $fimSyncObject = Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) *.xml) -XPath "//ma-data[name='CORP AD']/stay-disconnector/filter-set[@cd-object-type='computer']"
   $fimSyncObject.Node.'join-criterion'[3] | Convert-MimSyncJoinCriterionToCimInstance 
.INPUTS
   XML of the MVObjectType
.OUTPUTS
   a CIM Instance for the MVObjectType
#>
    [CmdletBinding()]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    Param
    (
        # Join Criterion to Convert
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   Position=0)] 
        $MVAttributeBinding
    )
    Process
    {
        $cimInstance = New-CimInstance -ClassName MimSyncMVAttributeBinding -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
            ID       = $MVAttributeBinding.ref                            -as [String]
            Required = [Convert]::ToBoolean($MVAttributeBinding.required) -as [Boolean]
        }

        Write-Output -InputObject $cimInstance
    }
}