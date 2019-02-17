data DscParameterToXmlNodeMap
{
ConvertFrom-StringData @'
CDObjectType     = //join/join-profile[@cd-object-type='{0}']
JoinCriterion    = join-criterion
JoinCriteriaType = join-cri-type
MVObjectType     = mv-object-type
MVAttribute      = mv-attribute
CDAttribute      = src-attribute
ResolutionType   = resolution/type
ScriptContext    = join-criterion/resolution/script-context
'@
}

data XmlParameters
{
'JoinCriterion'
}

function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$ManagementAgentName,

		[parameter(Mandatory = $true)]
		[System.String]
		$CDObjectType
	)
    ### Check the schema cache and update if necessary
    Write-MimSyncConfigCache -Verbose

    $svrexportPath = Get-MimSyncConfigCache
    Write-Verbose "Getting sync configuration files from '$svrexportPath'"

    ### Get the FIM object XML from the server configuration files
    Write-Verbose "Finding join rule with a CD object type of '$CDObjectType' on management agent '$ManagementAgentName'..."
    $fimSyncObject = Select-Xml -Path (Join-Path $svrexportPath *.xml) -XPath "//ma-data[name='$ManagementAgentName']/join/join-profile[@cd-object-type='$CDObjectType']"

    $joinCriterion = @($fimSyncObject.Node.SelectNodes($DscParameterToXmlNodeMap.JoinCriterion) | Convert-MimSyncJoinCriterionToCimInstance)

    Write-Output @{
		ManagementAgentName  = $Name
        CDObjectType         = $CDObjectType
        JoinCriterion        = $joinCriterion
    }
}

function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$ManagementAgentName,

		[parameter(Mandatory = $true)]
		[System.String]
		$CDObjectType,

        [Microsoft.Management.Infrastructure.CimInstance[]]
        $JoinCriterion,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    Write-Warning "DSC resources for the MIM Synchronization Service are not able to update the MIM Synchronization configuration."

}

function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$ManagementAgentName,

		[parameter(Mandatory = $true)]
		[System.String]
		$CDObjectType,

        [Microsoft.Management.Infrastructure.CimInstance[]]
        $JoinCriterion,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    ### Check the schema cache and update if necessary
    Write-MimSyncConfigCache -Verbose

    $svrexportPath = Get-MimSyncConfigCache
    Write-Verbose "Getting sync configuration files from '$svrexportPath'"

    ### Get the FIM object XML from the server configuration files
    Write-Verbose "Finding join rule with a CD object type of '$CDObjectType' on management agent '$ManagementAgentName'..."
    $fimSyncObject = Select-Xml -Path (Join-Path $svrexportPath *.xml) -XPath "//ma-data[name='$ManagementAgentName']/join/join-profile[@cd-object-type='$CDObjectType']"

    $objectsAreTheSame = $true

    if ($Ensure -eq 'Present')
    {
        if ($fimSyncObject -eq $null)
        {
            Write-Warning "Join Rule not found: $Name."

            return $false
        }
        else
        {
            Write-Verbose "Join Rule found, diffing the properties: $($fimSyncObject.Path)"
            $objectsAreTheSame = $true

            foreach ($dscResourceProperty in Get-DscResource -Name cMimSyncJoinRule | Select-Object -ExpandProperty Properties)
            {
                if ($dscResourceProperty.Name -in 'Ensure','DependsOn','ManagementAgentName','CDObjectType')
                {
                    Write-Verbose "  Skipping system-owned attribute: $($dscResourceProperty.Name)"
                    continue
                }

                if ($dscResourceProperty.Name -eq 'JoinCriterion')
                {
                    Write-Verbose "  Comparing property $($dscResourceProperty.Name) using XPath: $($DscParameterToXmlNodeMap.($dscResourceProperty.Name))"

                    $valuesFromDSC = @($JoinCriterion)
                    $valuesFromFIM = @($fimSyncObject.Node.SelectNodes($DscParameterToXmlNodeMap.($dscResourceProperty.Name)) | Convert-MimSyncJoinCriterionToCimInstance)

                    Write-Verbose "    From DSC: $($valuesFromDSC.count)"
                    Write-Verbose "    From FIM: $($valuesFromFIM.count)"

                    $JoinCriterionCompareResults = Compare-Object -ReferenceObject $valuesFromDSC -DifferenceObject $valuesFromFIM -Property MVObjectType,ResolutionType,ResolutionScriptContext 
                    $AttributeMappingCompareResults = Compare-Object -ReferenceObject $valuesFromDSC.AttributeMapping -DifferenceObject $valuesFromFIM.AttributeMapping -Property MVAttribute,CDAttribute,MappingType,ScriptContext
                    
                    if ($JoinCriterionCompareResults)
                    {
                        Write-Warning "  '$($dscResourceProperty.Name)' property is not the same."
                        $objectsAreTheSame = $false

                        Write-Verbose "    From DSC: $(($JoinCriterionCompareResults | Where-Object SideIndicator -eq '<=' | Format-Table -AutoSize | out-string))"
                        Write-Verbose "    From FIM: $(($JoinCriterionCompareResults | Where-Object SideIndicator -eq '=>' | Format-Table -AutoSize | out-string))"
                    }
                    elseif ($AttributeMappingCompareResults)
                    {
                        Write-Warning "  '$($dscResourceProperty.Name)' attribute mappings property is not the same."
                        $objectsAreTheSame = $false

                        Write-Verbose "    From DSC: $(($AttributeMappingCompareResults | Where-Object SideIndicator -eq '<=' | Format-Table -AutoSize | out-string))"
                        Write-Verbose "    From FIM: $(($AttributeMappingCompareResults | Where-Object SideIndicator -eq '=>' | Format-Table -AutoSize | out-string))"
                    }
                }
                else
                {
                    Write-Verbose "  Comparing property '$($dscResourceProperty.Name)' using XPath: $($DscParameterToXmlNodeMap.($dscResourceProperty.Name))"

                    $fimValue = $fimSyncObject.Node.SelectSingleNode($DscParameterToXmlNodeMap.($dscResourceProperty.Name)).InnerText
                    
                    if ($dscResourceProperty.PropertyType -eq '[bool]')
                    {
                        $fimValue = [Convert]::ToBoolean([int]$fimValue) #HACK - not loving this
                    }

                    Write-Verbose "    From DSC: $($PSBoundParameters[$dscResourceProperty.Name])"
                    Write-Verbose "    From FIM: $fimValue"

                    if ((-not $PSBoundParameters.ContainsKey($dscResourceProperty.Name)) -and [String]::IsNullOrEmpty($fimValue))
                    {
                        #Empty on both sides, do nothing
                    }
                    elseif ($PSBoundParameters[$dscResourceProperty.Name] -ne $fimValue)
                    {
                        Write-Warning "  '$($dscResourceProperty.Name)' property is not the same."
                        $objectsAreTheSame = $false
                    } 
                }
            }

            return $objectsAreTheSame
        }
    }
    elseif($Ensure -eq 'Absent')
    {
        if ($fimSyncObject -ne $null)
        {
            Write-Warning "Join Rule found ($Name) but is supposed to be Absent. DESTROY!!!"
            return $false
        }
        else
        {
            return $true
        }
    }
    else
    {
        Write-Error "Expected the 'Ensure' parameter to be 'Present' or 'Absent'"
    }
}

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
            AttributeMapping        = $AttributeMappings                         -as [CimInstance[]]
        }
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

Export-ModuleMember -Function *-TargetResource
