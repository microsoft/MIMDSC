function Convert-MimSyncJoinCriterionToCimInstance
{
<#
.Synopsis
   Converts the MIM Sync XML to a CIM Instance
.DESCRIPTION
   MIM Sync uses XML to represent the configuration objects
   DSC uses CIM instances to work with custom MOF classes
   It is necessary for the DSC resource to create CIM instances from the MIM Sync XML 
.EXAMPLE
   $fimSyncObject = Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) *.xml) -XPath "//ma-data[name='TINYHR']/join/join-profile[@cd-object-type='computer']"
   $fimSyncObject.Node.'join-criterion'[3] | ConvertMimSyncJoinCriterion-ToCimInstance
.EXAMPLE
   [xml]@'
    <join-criterion id="{6CF33C21-1FA8-405A-B41F-03243CC730F2}">
      <search mv-object-type="computer">
        <attribute-mapping mv-attribute="displayName">
          <direct-mapping>
            <src-attribute>displayName</src-attribute>
          </direct-mapping>
        </attribute-mapping>
        <attribute-mapping mv-attribute="accountName">
          <direct-mapping>
            <src-attribute>sAMAccountName</src-attribute>
          </direct-mapping>
        </attribute-mapping>
        <attribute-mapping mv-attribute="cn">
          <direct-mapping>
            <src-attribute>name</src-attribute>
          </direct-mapping>
        </attribute-mapping>
        <attribute-mapping mv-attribute="company">
          <scripted-mapping>
            <script-context>cd.computer#5:company-&gt;company</script-context>
            <src-attribute>company</src-attribute>
          </scripted-mapping>
        </attribute-mapping>
      </search>
      <resolution type="scripted">
        <script-context>JoinResolutionForComputer</script-context>
      </resolution>
    </join-criterion>
'@ | Select-Object -ExpandProperty 'join-criterion' | Convert-MimSyncJoinCriterionToCimInstance | select -expand DirectMapping
.INPUTS
   XML of the RunSteps from the RunProfile
.OUTPUTS
   a CIM Instance for the RunStep
.COMPONENT
   The component this cmdlet belongs to
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
        $JoinCriterion
    )
    Begin{
        $Order = 0
    }
    Process
    {
        $AttributeMappings = @()

        foreach($attributeMapping in $JoinCriterion.search.'attribute-mapping')
        {
            if ($attributeMapping.'direct-mapping')
            {
                $AttributeMappings += New-CimInstance -ClassName MimSyncAttributeMapping -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
                    MVAttribute   = $attributeMapping.'mv-attribute' -as [String]
                    CDAttribute   = @($attributeMapping.'direct-mapping'.'src-attribute') -as [String[]]
                    MappingType   = 'direct-mapping' -as [String]
                    ScriptContext = '' -as [String]
                }
            }
            elseif ($attributeMapping.'scripted-mapping')
            {
                $AttributeMappings += New-CimInstance -ClassName MimSyncAttributeMapping -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
                    MVAttribute   = $attributeMapping.'mv-attribute' -as [String]
                    CDAttribute   = @($attributeMapping.'scripted-mapping'.'src-attribute') -as [String[]]
                    MappingType   = 'scripted-mapping' -as [String]
                    ScriptContext = $attributeMapping.'scripted-mapping'.'script-context' -as [String]
                }
            }
        }

        $cimInstance = New-CimInstance -ClassName MimSyncJoinCriterion -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
            ID                      = $JoinCriterion.ID                          -as [String]
            MVObjectType            = $JoinCriterion.search.'mv-object-type'     -as [String]
            ResolutionType          = $JoinCriterion.resolution.type             -as [String]
            ResolutionScriptContext = $JoinCriterion.resolution.'script-context' -as [String]
            Order                   = $Order                                     -as [Uint16]
            AttributeMapping        = $AttributeMappings                         -as [CimInstance[]]
        }
        $Order++
        <#
        if ($DirectMappings.Count -gt 0)
        {
            $cimInstance.DirectMapping = $DirectMappings
        }
        else
        {
            $cimInstance.DirectMapping = $null
        }

        if ($ScriptedMappings.Count -gt 0)
        {
            $cimInstance.ScriptedMapping = $ScriptedMappings
        }
        else
        {
            $cimInstance.ScriptedMapping = $null
        }
        #>
        Write-Output -InputObject $cimInstance
    }
}