function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$MVObjectType
	)
    ### Check the schema cache and update if necessary
    Write-MimSyncConfigCache -Verbose

    ### Get the FIM object XML from the server configuration files
    Write-Verbose "Finding the MV Deletion Rule for MV Object Type '$MVObjectType' ..."
    $xPathFilter = "//mv-data/mv-deletion/mv-deletion-rule[@mv-object-type='$MVObjectType']"
    Write-Verbose "  Using XPath: $xPathFilter"
    $fimSyncObject = Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) mv.xml) -XPath $xPathFilter

    $outputObject = @{
		MVObjectType       = $MVObjectType
        Type               = $fimSyncObject.Node.type
    }

    if ($fimSyncObject.Node.type -in 'declared-any','declared-last')
    {
        Write-Verbose "Creating MA ID:Name map."
        $maNameToGuidMap = @{}
        foreach ($maDataXml in Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) *.xml) -XPath "//ma-data")
        {   
            $maNameToGuidMap.Add($maDataXml.node.id, $maDataXml.node.name)
        }
    }

    if ($fimSyncObject.Node.type -eq 'declared-any')
    {
        $srcMANames = @()
        foreach ($srcMAID in $fimSyncObject.Node.'src-ma')
        {
            $srcMANames += $maNameToGuidMap[$srcMAID]
        }
        $outputObject.Add('ManagementAgentName',$srcMANames)
    }

    if ($fimSyncObject.Node.type -eq 'declared-last')
    {
        $srcMANames = @()
        foreach ($srcMAID in $fimSyncObject.Node.'exclude-ma')
        {
            $srcMANames += $maNameToGuidMap[$srcMAID]
        }
        $outputObject.Add('ManagementAgentName',$srcMANames)
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
		$MVObjectType,

		[System.String]
		$Type,

		[System.String[]]
		$ManagementAgentName
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
		$MVObjectType,

		[System.String]
		$Type,

		[System.String[]]
		$ManagementAgentName
	)
    ### Check the schema cache and update if necessary
    Write-MimSyncConfigCache -Verbose

    ### Get the FIM object XML from the server configuration files
    Write-Verbose "Finding the MV Deletion Rule for MV Object Type '$MVObjectType' ..."
    $xPathFilter = "//mv-data/mv-deletion/mv-deletion-rule[@mv-object-type='$MVObjectType']"
    Write-Verbose "  Using XPath: $xPathFilter"
    $fimSyncObject = Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) mv.xml) -XPath $xPathFilter

    $objectsAreTheSame = $true

    if ($fimSyncObject -eq $null)
    {
        Write-Verbose "MV Deletion Rules not found."
        $objectsAreTheSame = $false
    }
    else
    {
        Write-Verbose "MV Deletion Rules found, diffing the properties..."

        if ($fimSyncObject.Node.type -in 'declared-any','declared-last')
        {
            Write-Verbose "Creating MA ID:Name map."
            $maNameToGuidMap = @{}
            foreach ($maDataXml in Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) *.xml) -XPath "//ma-data")
            {   
                $maNameToGuidMap.Add($maDataXml.node.id, $maDataXml.node.name)
            }
        }

        #region Compare type
        Write-Verbose "  Comparing property 'type'"
        Write-Verbose "    From DSC: $Type"
        Write-Verbose "    From FIM: $($fimSyncObject.Node.type)"
        if ($fimSyncObject.Node.type -ne $Type)
        {
            Write-Warning "  'type' property is not the same."
            $objectsAreTheSame = $false
        }
        #endregion

        #region Compare src-ma
        if ($fimSyncObject.Node.type -eq 'declared-any')
        {
            $srcMANames = @()
            foreach ($srcMAID in $fimSyncObject.Node.'src-ma')
            {
                $srcMANames += $maNameToGuidMap[$srcMAID]
            }

            Write-Verbose "  Comparing property 'src-ma'"
            Write-Verbose "    From DSC: $($ManagementAgentName -join ',')"
            Write-Verbose "    From FIM: $($srcMANames -join ',')"
            if (Compare-Object -ReferenceObject $ManagementAgentName -DifferenceObject $srcMANames)
            {
                Write-Warning "  'src-ma' property is not the same."
                $objectsAreTheSame = $false
            }
        }
        #endregion

        #region Compare exclude-ma
        if ($fimSyncObject.Node.type -eq 'declared-last')
        {
            $srcMANames = @()
            foreach ($srcMAID in $fimSyncObject.Node.'exclude-ma')
            {
                $srcMANames += $maNameToGuidMap[$srcMAID]
            }

            Write-Verbose "  Comparing property 'exclude-ma'"
            Write-Verbose "    From DSC: $($ManagementAgentName -join ',')"
            Write-Verbose "    From FIM: $($srcMANames -join ',')"
            if (Compare-Object -ReferenceObject $ManagementAgentName -DifferenceObject $srcMANames)
            {
                Write-Warning "  'exclude-ma' property is not the same."
                $objectsAreTheSame = $false
            }
        }
        #endregion
    }

    Write-Verbose "Returning: $objectsAreTheSame"
    return $objectsAreTheSame
}


Export-ModuleMember -Function *-TargetResource

