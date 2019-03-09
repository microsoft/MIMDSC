data DscParameterToXmlNodeMap
{
ConvertFrom-StringData @'
Name                  = //partition[name='{0}']
Selected              = selected
ObjectClassInclusions = filter/object-classes/object-class
ContainerInclusions   = filter/containers/inclusions/inclusion
ContainerExclusions   = filter/containers/exclusions/exclusion
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
		$Name,

		[parameter(Mandatory = $true)]
		[System.String]
		$ManagementAgentName
	)

    ### Check the schema cache and update if necessary
    Write-MimSyncConfigCache -Verbose

    ### Get the FIM object XML from the server configuration files
    Write-Verbose "Finding a partition..."
    $xPathFilter = "//ma-data[name='$ManagementAgentName']/ma-partition-data/partition[name='$Name']"
    Write-Verbose "  Using XPath: $xPathFilter"
    $fimSyncObject = Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) *.xml) -XPath $xPathFilter

    if (-not $fimSyncObject)
    {
        ### No matching object so return nothing
        return
    }
    
	$returnValue = @{
		ManagementAgentName = $ManagementAgentName
		Name = $Name
		Selected = [Convert]::ToBoolean([int]$fimSyncObject.Node.selected)
		ObjectClassInclusions = $fimSyncObject.Node.filter.'object-classes'.'object-class' -as [String[]]
		ContainerInclusions = $fimSyncObject.Node.filter.containers.inclusions.inclusion   -as [String[]]
		ContainerExclusions = $fimSyncObject.Node.filter.containers.exclusions.exclusion   -as [String[]]
		#Ensure = [System.String]
	}

	$returnValue
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
		$Name,

		[System.Boolean]
		$Selected,

		[System.String[]]
		$ObjectClassInclusions,

		[System.String[]]
		$ContainerInclusions,

		[System.String[]]
		$ContainerExclusions,

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
		$Name,

		[System.Boolean]
		$Selected,

		[System.String[]]
		$ObjectClassInclusions,

		[System.String[]]
		$ContainerInclusions,

		[System.String[]]
		$ContainerExclusions,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    ### Check the schema cache and update if necessary
    Write-MimSyncConfigCache -Verbose

    ### Get the FIM object XML from the server configuration files
    Write-Verbose "Finding a partition..."
    $xPathFilter = "//ma-data[name='$ManagementAgentName']/ma-partition-data/partition[name='$Name']"
    Write-Verbose "  Using XPath: $xPathFilter"
    $fimSyncObject = Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) *.xml) -XPath $xPathFilter

    $objectsAreTheSame = $true

    if ($Ensure -eq 'Present')
    {
        if ($fimSyncObject -eq $null)
        {
            Write-Verbose "Partition not found."
            return $false
        }
        else
        {
            Write-Verbose "Partition found, diffing the properties."
            
            #region Compare Selected
            Write-Verbose "  Comparing property 'selected'"
            Write-Verbose "    From DSC: $Selected"
            ### the value from the FIM XML will be 1 or 0, we need to convert to a boolean
            $fimSelectedValue = [Convert]::ToBoolean([int]$fimSyncObject.Node.selected)
            Write-Verbose "    From FIM: $fimSelectedValue"
            if ($Selected -ne $fimSelectedValue)
            {
                Write-Warning "  'selected' property is not the same."
                $objectsAreTheSame = $false
            }
            #endregion

            #region Compare filter/object-classes/object-class
            $fimObjectInclusions = @()
            $dscObjectInclusions = @()
            if ($fimSyncObject.Node.filter.'object-classes'.'object-class'){$fimObjectInclusions = $fimSyncObject.Node.filter.'object-classes'.'object-class'}
            if ($ObjectClassInclusions){$dscObjectInclusions = $ObjectClassInclusions}
            Write-Verbose "  Comparing property 'filter/object-classes/object-class'"
            Write-Verbose "    From DSC: $($dscObjectInclusions    -join ',')"
            Write-Verbose "    From FIM: $($fimObjectInclusions -join ',')"
            if (Compare-Object -ReferenceObject $dscObjectInclusions -DifferenceObject $fimObjectInclusions )
            {
                Write-Warning "  'filter/object-classes/object-class' property is not the same."
                $objectsAreTheSame = $false
            }
            #endregion

            #region Compare filter/containers/inclusions/inclusion
            $fimInclusions = @()
            $dscInclusions = @()
            if ($fimSyncObject.Node.filter.containers.inclusions.inclusion){$fimInclusions = $fimSyncObject.Node.filter.containers.inclusions.inclusion}
            if ($ContainerInclusions){$dscInclusions = $ContainerInclusions}
            Write-Verbose "  Comparing property 'filter/containers/inclusions/inclusion'"
            Write-Verbose "    From DSC: $($dscInclusions -join ',')"
            Write-Verbose "    From FIM: $($fimInclusions -join ',')"
            if (Compare-Object -ReferenceObject $dscInclusions -DifferenceObject $fimInclusions )
            {
                Write-Warning "  'filter/containers/inclusions/inclusion' property is not the same."
                $objectsAreTheSame = $false
            }
            #endregion

            #region Compare filter/containers/exclusions/exclusion
            $fimExclusions = @()
            $dscExclusions = @()
            if ($fimSyncObject.Node.filter.containers.exclusions.exclusion){$fimExclusions = $fimSyncObject.Node.filter.containers.exclusions.exclusion}
            if ($ContainerExclusions){$dscExclusions = $ContainerExclusions}
            Write-Verbose "  Comparing property 'filter/containers/exclusions/exclusion'"
            Write-Verbose "    From DSC: $($dscExclusions    -join ',')"
            Write-Verbose "    From FIM: $($fimExclusions -join ',')"
            if (Compare-Object -ReferenceObject $dscExclusions -DifferenceObject $fimExclusions )
            {
                Write-Warning "  'filter/containers/exclusions/exclusion' property is not the same."
                $objectsAreTheSame = $false
            }
            #endregion
        }
    }
    elseif($Ensure -eq 'Absent')
    {
        if ($fimSyncObject -ne $null)
        {
            $objectsAreTheSame = $false
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

    Write-Verbose "Returning: $objectsAreTheSame"
    return $objectsAreTheSame
}

Export-ModuleMember -Function *-TargetResource