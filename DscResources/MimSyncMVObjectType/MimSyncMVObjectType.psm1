function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$ID
	)
    $namespace = @{dsml="http://www.dsml.org/DSML"; 'ms-dsml'="http://www.microsoft.com/MMS/DSML"}

    ### Check the schema cache and update if necessary
    Write-MimSyncConfigCache -Verbose

    ### Get the FIM object XML from the server configuration files
    Write-Verbose "Finding the MV Object Type..."
    $xPathFilter = "//mv-data/schema/dsml:dsml/dsml:directory-schema/dsml:class[@id='$ID']"

    Write-Verbose "  Using XPath: $xPathFilter"
    $fimSyncObject = Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) mv.xml) -XPath $xPathFilter -Namespace $namespace

    if (-not $fimSyncObject)
    {
        ### No matching object so return nothing
        return
    }
    
    $outputObject = @{
		ID     = $ID
        Name   = $fimSyncObject.Node.name
        Type   = $fimSyncObject.Node.type
    }

    $BindingsFromFim = $fimSyncObject.Node.attribute | Convert-MimSyncMVObjectTypeToCimInstance
    $outputObject.Add('Attributes', $BindingsFromFim)

    Write-Output $outputObject
}

function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$ID,

		[System.String]
		$Name,

		[System.String]
		$Type,

        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Attributes,

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
		$ID,

		[System.String]
		$Name,

		[System.String]
		$Type,

        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Attributes,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)
    $namespace = @{dsml="http://www.dsml.org/DSML"; 'ms-dsml'="http://www.microsoft.com/MMS/DSML"}

    ### Check the schema cache and update if necessary
    Write-MimSyncConfigCache -Verbose

    ### Get the FIM object XML from the server configuration files
    Write-Verbose "Finding the MV Object Type..."
    $xPathFilter = "//mv-data/schema/dsml:dsml/dsml:directory-schema/dsml:class[@id='$ID']"

    Write-Verbose "  Using XPath: $xPathFilter"
    $fimSyncObject = Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) mv.xml) -XPath $xPathFilter -Namespace $namespace

    $objectsAreTheSame = $true

    if ($Ensure -eq 'Present')
    {
        if ($fimSyncObject -eq $null)
        {
            Write-Verbose "MV Object Type not found: $Name."
            $objectsAreTheSame = $false
        }
        else
        {
            Write-Verbose "MV Object Type found, diffing the properties: $($fimSyncObject.Path)"
            
            #region Compare Name
            Write-Verbose "  Comparing property 'name'"
            Write-Verbose "    From DSC: $Name"
            Write-Verbose "    From FIM: $($fimSyncObject.Node.name)"
            if ($fimSyncObject.Node.provisioning.type -ne $ProvisioningType)
            {
                Write-Warning "  'name' property is not the same."
                $objectsAreTheSame = $false
            }
            #endregion

            #region Compare Type
            Write-Verbose "  Comparing property 'type'"
            Write-Verbose "    From DSC: $Type"
            Write-Verbose "    From FIM: $($fimSyncObject.Node.type)"
            if ($fimSyncObject.Node.type -ne $Type)
            {
                Write-Warning "  'type' property is not the same."
                $objectsAreTheSame = $false
            }
            #endregion

            #region Compare Attribute
            $BindingsFromFim = $fimSyncObject.Node.attribute | Convert-MimSyncMVObjectTypeToCimInstance

            Write-Verbose "  Comparing attribute bindings"
            Write-Verbose "    From DSC: $($Attributes       | Format-Table ID,Required -AutoSize | out-string)"
            Write-Verbose "    From FIM: $($BindingsFromFim  | Format-Table ID,Required -AutoSize | out-string)"

            $BindingsCompareResults = Compare-Object -ReferenceObject $Attributes -DifferenceObject $BindingsFromFim -Property ID,Required 

            if ($BindingsCompareResults)
            {
                Write-Warning "  'attribute bindings are not the same."
                $objectsAreTheSame = $false

                Write-Verbose "    From DSC: $(($BindingsCompareResults | Where-Object SideIndicator -eq '<=' | ft -AutoSize | out-string))"
                Write-Verbose "    From FIM: $(($BindingsCompareResults | Where-Object SideIndicator -eq '=>' | ft -AutoSize | out-string))"
            }
            #endregion

            $objectsAreTheSame = $objectsAreTheSame
        }
    }
    elseif($Ensure -eq 'Absent')
    {
        if ($fimSyncObject -ne $null)
        {
            Write-Warning "MV Object Type found ($Name) but is supposed to be Absent. DESTROY!!!"
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