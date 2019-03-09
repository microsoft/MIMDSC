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

    ### Get the FIM object XML from the server configuration files
    Write-Verbose "Finding projection rule with a CD object type of '$CDObjectType' on management agent '$ManagementAgentName'..."    
    $xPathFilter = "//ma-data[name='$ManagementAgentName']/projection/class-mapping[@cd-object-type='$CDObjectType' and @type !='sync-rule']"
    Write-Verbose "  Using XPath: $xPathFilter"
    $fimSyncObject = Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) *.xml) -XPath $xPathFilter

    if (-not $fimSyncObject)
    {
        ### No matching object so return nothing
        return
    }

    $outputObject = @{
		ManagementAgentName  = $ManagementAgentName
        CDObjectType         = $CDObjectType
        Type                 = $fimSyncObject.Node.type
        ID                   = $fimSyncObject.Node.ID
    }

    if ($fimSyncObject.Node.type -eq 'declared')
    {
        $outputObject.Add('MVObjectType',$fimSyncObject.Node.'mv-object-type')
    }

    Write-Output -InputObject $outputObject
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

        [System.String]
        [ValidateSet("declared","scripted")]
		$Type,

		[System.String]
		$MVObjectType,

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

        [ValidateSet("declared","scripted")]
		[System.String]
		$Type,

		[System.String]
		$MVObjectType,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)
    ### Check the schema cache and update if necessary
    Write-MimSyncConfigCache -Verbose

    ### Get the MIM object XML from the server configuration files
    Write-Verbose "Finding projection rule with a CD object type of '$CDObjectType' on management agent '$ManagementAgentName'..."    
    $xPathFilter = "//ma-data[name='$ManagementAgentName']/projection/class-mapping[@cd-object-type='$CDObjectType' and @type !='sync-rule']"
    Write-Verbose "  Using XPath: $xPathFilter"
    $fimSyncObject = Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) *.xml) -XPath $xPathFilter

    $objectsAreTheSame = $true

    if ($Ensure -eq 'Present')
    {
        if ($fimSyncObject -eq $null)
        {
            Write-Verbose "Projection Rule not found: $Name."
            $objectsAreTheSame = $false
        }
        else
        {
            Write-Verbose "Projection Rule found, diffing the properties: $($fimSyncObject.Path)"

            Write-Verbose "  Comparing property 'type'"
            Write-Verbose "    From DSC: $Type"
            Write-Verbose "    From FIM: $($fimSyncObject.Node.type)"
            if ($fimSyncObject.Node.type -ne $Type)
            {
                Write-Warning "  'type' property is not the same."
                $objectsAreTheSame = $false
            }

            if ($Type -eq 'scripted')
            {
                Write-Verbose "  Skipping property 'mv-object-type' because this is a scripted rule."
            }
            else
            {
                Write-Verbose "  Comparing property 'mv-object-type'"
                Write-Verbose "    From DSC: $MVObjectType"
                Write-Verbose "    From FIM: $($fimSyncObject.Node.'mv-object-type')"
                if ($fimSyncObject.Node.'mv-object-type' -ne $MVObjectType)
                {
                    Write-Warning "  'mv-object-type' property is not the same."
                    $objectsAreTheSame = $false
                }
            }
        }
    }
    elseif($Ensure -eq 'Absent')
    {
        if ($fimSyncObject -ne $null)
        {
            Write-Warning "Projection Rule found, but is supposed to be Absent. DESTROY!!!"
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

Export-ModuleMember -Function *-TargetResource