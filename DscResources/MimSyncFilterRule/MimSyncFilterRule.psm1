
data DscParameterToXmlNodeMap
{
ConvertFrom-StringData @'
CDObjectType      = //stay-disconnector/filter-set[@cd-object-type='{0}']
ImportFilter      = 'import-filter'
Type              = 'type'  
FilterAlternative = 'filter-alternative'
'@
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

    ### Get the MIM object XML from the server configuration files
    Write-Verbose "Finding filter rule with a CD object type of '$CDObjectType' on management agent '$ManagementAgentName'..."
    $fimSyncObject = Select-Xml -Path (Join-Path $svrexportPath *.xml) -XPath "//ma-data[name='$ManagementAgentName']/stay-disconnector/filter-set[@cd-object-type='$CDObjectType']"

    $FilterAlternative = @($fimSyncObject.Node.SelectNodes('filter-alternative') | ConvertMimSyncFilterAlternative-ToCimInstance)

    Write-Output @{
		ManagementAgentName  = $ManagementAgentName
        CDObjectType         = $CDObjectType
        FilterAlternative    = $FilterAlternative
        ImportFilter         = $fimSyncObject.Node.'import-filter' -as [Boolean]
        Type                 = $fimSyncObject.Node.type
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

		[Boolean]
		$ImportFilter,

		[String]
		$Type,

        [Microsoft.Management.Infrastructure.CimInstance[]]
        $FilterAlternative,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)
    Write-Warning "DSC resources for the Synchronization Service are not able to update the Synchronization configuration."
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

		[Boolean]
		$ImportFilter,

		[String]
		$Type,

        [Microsoft.Management.Infrastructure.CimInstance[]]
        $FilterAlternative,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    ### Check the schema cache and update if necessary
    Write-MimSyncConfigCache -Verbose

    ### Get the MIM object XML from the server configuration files
    Write-Verbose "Finding filter rule with a CD object type of '$CDObjectType' on management agent '$ManagementAgentName'..."
    $xPathFilter = "//ma-data[name='$ManagementAgentName']/stay-disconnector/filter-set[@cd-object-type='$CDObjectType']"
    Write-Verbose "  Using XPath: $xPathFilter"
    $fimSyncObject = Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) *.xml) -XPath $xPathFilter

    $objectsAreTheSame = $true

    if ($Ensure -eq 'Present')
    {
        if ($fimSyncObject -eq $null)
        {
            Write-Verbose "Filter Rule not found: $Name."
            $objectsAreTheSame = $false
        }
        else
        {
            Write-Verbose "Filter Rule found, diffing the properties: $($fimSyncObject.Path)"
            
            foreach ($dscResourceProperty in Get-DscResource -Name MimSyncFilterRule | Select-Object -ExpandProperty Properties)
            {
                if ($dscResourceProperty.Name -in 'Ensure','DependsOn','PsDscRunAsCredential','ManagementAgentName','CDObjectType')
                {
                    Write-Verbose "  Skipping system-owned attribute: $($dscResourceProperty.Name)"
                    continue
                }

                if ($dscResourceProperty.Name -eq 'FilterAlternative')
                {
                    if ($Type -eq 'scripted')
                    {
                        Write-Verbose "  Skipping property $($dscResourceProperty.Name) because this is a scripted filter rule (they have no conditions)"
                        continue
                    }
                    Write-Verbose "  Comparing property $($dscResourceProperty.Name) using XPath: $($DscParameterToXmlNodeMap.($dscResourceProperty.Name))"

                    $valuesFromDSC = @($FilterAlternative)
                    $valuesFromMIM = @($fimSyncObject.Node.SelectNodes('filter-alternative') | ConvertMimSyncFilterAlternative-ToCimInstance)

                    Write-Verbose "    From DSC: $($valuesFromDSC.count)"
                    Write-Verbose "    From MIM: $($valuesFromMIM.count)"                    

                    if ($valuesFromDSC.count -ne $valuesFromMIM.count)
                    {
                        Write-Warning "   The number of filters is different, therefore the filter rule is not the same."
                        $objectsAreTheSame = $false
                    }
                    else
                    {
                        ### Compare each FilterAlternative
                        for ($i = 0; $i -lt $valuesFromDSC.count; $i++)
                        { 
                            Write-Verbose "       Comparing Filter $i"
                            $filterConditionCompareResults = Compare-Object -ReferenceObject $valuesFromDSC[$i].FilterCondition -DifferenceObject $valuesFromMIM[$i].FilterCondition -Property CDAttribute,Operator,Value

                            if ($filterConditionCompareResults)
                            {
                                Write-Warning "  'Filter $i is not the same."
                                $objectsAreTheSame = $false

                                Write-Verbose "    From DSC: $(($filterConditionCompareResults | Where SideIndicator -eq '<=' | ft -AutoSize | out-string))"
                                Write-Verbose "    From FIM: $(($filterConditionCompareResults | Where SideIndicator -eq '=>' | ft -AutoSize | out-string))"
                            }
                        }
                    }
                }
                else
                {
                    Write-Verbose "  Comparing property '$($dscResourceProperty.Name)' using XPath: $($DscParameterToXmlNodeMap.($dscResourceProperty.Name))"

                    if ($dscResourceProperty.Name -eq 'ImportFilter')
                    {
                        $fimValue = $fimSyncObject.Node.'import-filter'
                    }
                    elseif ($dscResourceProperty.Name -eq 'Type')
                    {
                        $fimValue = $fimSyncObject.Node.type
                    }
                    else
                    {
                        $fimValue = $fimSyncObject.Node.SelectSingleNode($DscParameterToXmlNodeMap.($dscResourceProperty.Name)).InnerText
                    }
                                  
                    if ($dscResourceProperty.PropertyType -eq '[bool]')
                    {
                        $fimValue = [Convert]::ToBoolean([int]$fimValue) #HACK - not loving this
                    }

                    Write-Verbose "    From DSC: $($PSBoundParameters[$dscResourceProperty.Name])"
                    Write-Verbose "    From MIM: $fimValue"

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

            $objectsAreTheSame = $objectsAreTheSame
        }
    }
    elseif($Ensure -eq 'Absent')
    {
        if ($fimSyncObject -ne $null)
        {
            Write-Warning "Join Rule found ($Name) but is supposed to be Absent. DESTROY!!!"
            $objectsAreTheSame = $false
        }
        else
        {
            $objectsAreTheSame = $true
        }
    }
    else
    {
        Write-Error "Expected the 'Ensure' parameter to be 'Present' or 'Absent'"
    }

    Write-Verbose "Returning: $objectsAreTheSame"
    return $objectsAreTheSame
}


function ConvertMimSyncFilterAlternative-ToCimInstance
{
<#
.Synopsis
   Converts the MIM Sync XML to a CIM Instance
.DESCRIPTION
   MIM Sync uses XML to represent the configuration objects
   DSC uses CIM instances to work with custom MOF classes
   It is necessary for the DSC resource to create CIM instances from the MIM Sync XML 
.EXAMPLE
    Get-MimSyncServerXml -Path (Get-MimSyncConfigCache) -Force
   $fimSyncObject = Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) *.xml) -XPath "//ma-data[name='CORP AD']/stay-disconnector/filter-set[@cd-object-type='computer']"
   $fimSyncObject.Node.'join-criterion'[3] | ConvertMimSyncJoinCriterion-ToCimInstance
.EXAMPLE
   [xml]@'
  <filter-set import-filter="1" cd-object-type="computer" type="declared">
    <filter-alternative id="{D3FAE5BC-E685-413C-9D4A-3D5C108EC135}">
      <condition cd-attribute="sAMAccountName" operator="substring-start">
        <value>$Duplicate</value>
      </condition>
    </filter-alternative>
    <filter-alternative id="{CD0801C0-6145-4DD1-BCE3-E2FEA8E3D554}">
      <condition cd-attribute="cn" operator="equality">
        <value>foo</value>
      </condition>
      <condition cd-attribute="employeeID" operator="inequality">
        <value>oo7</value>
      </condition>
      <condition cd-attribute="extensionAttribute11" operator="present">
        <value></value>
      </condition>
    </filter-alternative>
  </filter-set>
'@ | Select-Object -ExpandProperty 'filter-set' | ConvertMimSyncFilterAlternative-ToCimInstance 
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
        $FilterAlternative
    )
    Process
    {

        $FilterConditions = @()

        foreach($filterCondition in $FilterAlternative.condition)
        {
            $FilterConditions += New-CimInstance -ClassName MimSyncFilterCondition -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
                CDAttribute = $filterCondition.'cd-attribute' -as [String]
                Operator    = $filterCondition.operator       -as [String]
                Value       = $filterCondition.value          -as [String]
            }
        }

        $cimInstance = New-CimInstance -ClassName MimSyncFilterAlternative -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
            ID              = $FilterAlternative.id           -as [String]
            FilterCondition = $FilterConditions               -as [CimInstance[]]
        }

        Write-Output -InputObject $cimInstance
    }
}

Export-ModuleMember -Function *-TargetResource