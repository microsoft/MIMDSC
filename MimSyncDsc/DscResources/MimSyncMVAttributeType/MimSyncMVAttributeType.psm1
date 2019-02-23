
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

    ### Get the object XML from the server configuration files
    Write-Verbose "Finding the MV Object Type..."
    $xPathFilter = "//mv-data/schema/dsml:dsml/dsml:directory-schema/dsml:attribute-type[@id='$ID']"

    Write-Verbose "  Using XPath: $xPathFilter"
    $fimSyncObject = Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) mv.xml) -XPath $xPathFilter -Namespace $namespace

    if (-not $fimSyncObject)
    {
        ### No matching object so return nothing
        return
    }

    $outputObject = @{
		ID     = $ID
        Syntax = $fimSyncObject.Node.syntax
    }

    if ($fimSyncObject.Node.'single-value')
    {
        $outputObject.Add('SingleValue', [Convert]::ToBoolean($fimSyncObject.Node.'single-value'))
    }
    else
    {
        $outputObject.Add('SingleValue', $false)
    }

    if ($fimSyncObject.Node.indexed)
    {
        $outputObject.Add('Indexed', [Convert]::ToBoolean($fimSyncObject.Node.indexed))
    }
    else
    {
        $outputObject.Add('Indexed', $false)
    }

    if ($fimSyncObject.Node.indexable)
    {
        $outputObject.Add('Indexable', [Convert]::ToBoolean($fimSyncObject.Node.indexable))
    }
    else
    {
        $outputObject.Add('Indexable', $false)
    }

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

		[Boolean]
		$SingleValue,

		[Boolean]
		$Indexable,

		[Boolean]
		$Indexed,

        [System.String]
        $Syntax,

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

		[Boolean]
		$SingleValue,

		[Boolean]
		$Indexable,

		[Boolean]
		$Indexed,

        [System.String]
        $Syntax,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)
    $namespace = @{dsml="http://www.dsml.org/DSML"; 'ms-dsml'="http://www.microsoft.com/MMS/DSML"}

    ### Check the schema cache and update if necessary
    Write-MimSyncConfigCache -Verbose

    ### Get the FIM object XML from the server configuration files
    Write-Verbose "Finding the MV Attribute Type..."
    $xPathFilter = "//mv-data/schema/dsml:dsml/dsml:directory-schema/dsml:attribute-type[@id='$ID']"

    Write-Verbose "  Using XPath: $xPathFilter"
    $fimSyncObject = Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) mv.xml) -XPath $xPathFilter -Namespace $namespace

    $objectsAreTheSame = $true

    if ($Ensure -eq 'Present')
    {
        if ($fimSyncObject -eq $null)
        {
            Write-Verbose "MV Attribute Type not found: $Name."
            $objectsAreTheSame = $false
        }
        else
        {
            Write-Verbose "MV Attribute Type found, diffing the properties: $($fimSyncObject.Path)"
            
            #region Compare Syntax
            Write-Verbose "  Comparing property 'syntax'"
            Write-Verbose "    From DSC: $Syntax"
            Write-Verbose "    From FIM: $($fimSyncObject.Node.syntax)"
            if ($fimSyncObject.Node.syntax -ne $Syntax)
            {
                Write-Warning "  'syntax' property is not the same."
                $objectsAreTheSame = $false
            }
            #endregion

            #region Compare SingleValue
            Write-Verbose "  Comparing property 'syntax'"
            Write-Verbose "    From DSC: $SingleValue"
            $fimValue = [Convert]::ToBoolean($fimSyncObject.Node.'single-value')
            Write-Verbose "    From FIM: $fimValue"
            if ($SingleValue -ne $fimValue)
            {
                Write-Warning "  'single-value' property is not the same."
                $objectsAreTheSame = $false
            }
            #endregion

            #region Compare Indexable
            Write-Verbose "  Comparing property 'indexable'"
            Write-Verbose "    From DSC: $Indexable"
            $fimIndexableValue = [Convert]::ToBoolean($fimSyncObject.Node.indexable)
            Write-Verbose "    From FIM: $fimIndexableValue"
            if ($Indexable -ne $fimIndexableValue)
            {
                Write-Warning "  'indexable' property is not the same."
                $objectsAreTheSame = $false
            }
            #endregion

            #region Compare Indexed
            Write-Verbose "  Comparing property 'indexed'"
            Write-Verbose "    From DSC: $Indexed"
            $fimIndexedValue = [Convert]::ToBoolean($fimSyncObject.Node.indexed)
            Write-Verbose "    From FIM: $fimIndexedValue"
            if ($Indexed -ne $fimIndexedValue)
            {
                Write-Warning "  'indexed' property is not the same."
                $objectsAreTheSame = $false
            }
            #endregion

            #$objectsAreTheSame = $objectsAreTheSame
        }
    }
    elseif($Ensure -eq 'Absent')
    {
        if ($fimSyncObject -ne $null)
        {
            Write-Warning "MV Attribute Type found ($Name) but is supposed to be Absent. DESTROY!!!"
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