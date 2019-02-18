function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$FakeIdentifier
	)
    ### Check the schema cache and update if necessary
    Write-MimSyncConfigCache -Verbose

    ### Get the FIM object XML from the server configuration files
    Write-Verbose "Finding the MV options ..."
    $xPathFilter = "//mv-data"
    Write-Verbose "  Using XPath: $xPathFilter"
    $fimSyncObject = Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) mv.xml) -XPath $xPathFilter

    $outputObject = @{
		FakeIdentifier                 = $FakeIdentifier
        ProvisioningType               = $fimSyncObject.Node.provisioning.type
        ExtensionAssemblyName          = $fimSyncObject.Node.extension.'assembly-name'
        ExtensionApplicationProtection = $fimSyncObject.Node.extension.'application-protection'
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
		$FakeIdentifier,

		[System.String]
		$ProvisioningType,

		[System.String]
		$ExtensionAssemblyName,

		[System.String]
		$ExtensionApplicationProtection
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
		$FakeIdentifier,

		[System.String]
		$ProvisioningType,

		[System.String]
		$ExtensionAssemblyName,

		[System.String]
		$ExtensionApplicationProtection
	)
    ### Check the schema cache and update if necessary
    Write-MimSyncConfigCache -Verbose

    ### Get the FIM object XML from the server configuration files
    Write-Verbose "Finding the MV options ..."
    $xPathFilter = "//mv-data"
    Write-Verbose "  Using XPath: $xPathFilter"
    $fimSyncObject = Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) mv.xml) -XPath $xPathFilter

    $objectsAreTheSame = $true

    if ($fimSyncObject -eq $null)
    {
        Write-Verbose "MV Options not found."
        $objectsAreTheSame = $false
    }
    else
    {
        Write-Verbose "MV Options found, diffing the properties..."

        #region Compare provisioning type
        Write-Verbose "  Comparing property 'provisioning type'"
        Write-Verbose "    From DSC: $ProvisioningType"
        Write-Verbose "    From FIM: $($fimSyncObject.Node.provisioning.type)"
        if ($fimSyncObject.Node.provisioning.type -ne $ProvisioningType)
        {
            Write-Warning "  'provisioning type' property is not the same."
            $objectsAreTheSame = $false
        }
        #endregion

        #region Compare extension.assembly-name
        Write-Verbose "  Comparing property 'extension.assembly-name'"
        Write-Verbose "    From DSC: $ExtensionAssemblyName"
        Write-Verbose "    From FIM: $($fimSyncObject.Node.extension.'assembly-name')"
        if ($fimSyncObject.Node.extension.'assembly-name' -ne $ExtensionAssemblyName)
        {
            Write-Warning "  'extension.assembly-name' property is not the same."
            $objectsAreTheSame = $false
        }
        #endregion

        #region Compare extension.application-protection
        Write-Verbose "  Comparing property 'extension.application-protection'"
        Write-Verbose "    From DSC: $ExtensionApplicationProtection"
        Write-Verbose "    From FIM: $($fimSyncObject.Node.extension.'application-protection')"
        if ($fimSyncObject.Node.extension.'application-protection' -ne $ExtensionApplicationProtection)
        {
            Write-Warning "  'extension.application-protection' property is not the same."
            $objectsAreTheSame = $false
        }
        #endregion
    }    
    Write-Verbose "Returning: $objectsAreTheSame"
    return $objectsAreTheSame
}

Export-ModuleMember -Function *-TargetResource