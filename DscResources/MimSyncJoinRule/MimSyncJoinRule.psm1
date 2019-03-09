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
    $xPathFilter = "//ma-data[name='$ManagementAgentName']/join/join-profile[@cd-object-type='$CDObjectType']"
    Write-Verbose "  Using XPath: $xPathFilter"

    $fimSyncObject = Select-Xml -Path (Join-Path $svrexportPath *.xml) -XPath $xPathFilter

    if (-not $fimSyncObject)
    {
        Write-Warning "Join Rule not found: $Name."
        return
    }

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

            foreach ($dscResourceProperty in Get-DscResource -Name MimSyncJoinRule | Select-Object -ExpandProperty Properties)
            {
                if ($dscResourceProperty.Name -in 'Ensure','DependsOn','PsDscRunAsCredential','ManagementAgentName','CDObjectType')
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

                    $JoinCriterionCompareResults = Compare-Object -ReferenceObject $valuesFromDSC -DifferenceObject $valuesFromFIM -Property MVObjectType,ResolutionType,ResolutionScriptContext,Order 
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

            Write-Verbose "Returning: $objectsAreTheSame"
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

Export-ModuleMember -Function *-TargetResource
