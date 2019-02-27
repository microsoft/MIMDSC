function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$MVAttribute,

		[parameter(Mandatory = $true)]
		[System.String]
		$MVObjectType
	)

    ### Check the schema cache and update if necessary
    Write-MimSyncConfigCache -Verbose

    ### Get the FIM object XML from the server configuration files
    Write-Verbose "Finding import attribute flow rules for [$MVObjectType].$MVAttribute ..."
    $xPathFilter = "//mv-data/import-attribute-flow/import-flow-set[@mv-object-type='$MVObjectType']/import-flows[@mv-attribute='$MVAttribute']"
    Write-Verbose "  Using XPath: $xPathFilter"
    $fimSyncObject = Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) mv.xml) -XPath $xPathFilter


    $outputObject = @{
		MVObjectType  = $MVObjectType
        MVAttribute   = $MVAttribute
        Type          = $fimSyncObject.Node.type
    }

    if ($fimSyncObject.Node.type -eq 'ranked')
    {
        $RankedPrecedenceOrderFromFim = ConvertFimSyncPrecedence-ToCimInstance -ImportFlows $fimSyncObject.Node
        $outputObject.Add('RankedPrecedenceOrder', $RankedPrecedenceOrderFromFim)
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
		$MVAttribute,

		[parameter(Mandatory = $true)]
		[System.String]
		$MVObjectType,

        [System.String]
        [ValidateSet("ranked","equal","manual")]
		$Type,

        [Microsoft.Management.Infrastructure.CimInstance[]]
        $RankedPrecedenceOrder
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
		$MVAttribute,

		[parameter(Mandatory = $true)]
		[System.String]
		$MVObjectType,

        [System.String]
        [ValidateSet("ranked","equal","manual")]
		$Type,

        [Microsoft.Management.Infrastructure.CimInstance[]]
        $RankedPrecedenceOrder
	)

    ### Check the schema cache and update if necessary
    Write-MimSyncConfigCache -Verbose

    ### Get the FIM object XML from the server configuration files
    Write-Verbose "Finding import attribute flow rules for [$MVObjectType].$MVAttribute ..."
    $xPathFilter = "//mv-data/import-attribute-flow/import-flow-set[@mv-object-type='$MVObjectType']/import-flows[@mv-attribute='$MVAttribute']"
    Write-Verbose "  Using XPath: $xPathFilter"
    $fimSyncObject = Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) mv.xml) -XPath $xPathFilter

    $objectsAreTheSame = $true

    if ($fimSyncObject -eq $null)
    {
        Write-Verbose "Attribute flow rules not found."
        $objectsAreTheSame = $false
    }
    else
    {
        Write-Verbose "Attribute flow rules found, diffing the precedence properties..."

        #region Compare script-context
        Write-Verbose "  Comparing property 'type'"
        Write-Verbose "    From DSC: $Type"
        Write-Verbose "    From FIM: $($fimSyncObject.Node.type)"
        if ($fimSyncObject.Node.type -ne $Type)
        {
            Write-Warning "  'type' property is not the same."
            $objectsAreTheSame = $false
        }
        #endregion

        #region Compare script-context
        if ($Type -eq 'ranked')
        {
            $RankedPrecedenceOrderFromFim = Convert-MimSyncPrecedenceToCimInstance -ImportFlows $fimSyncObject.Node

            Write-Verbose "  Comparing ranked precedence order"
            Write-Verbose "    From DSC: $($RankedPrecedenceOrder        | Format-Table Order,ManagementAgentName,CDObjectType -AutoSize | out-string)"
            Write-Verbose "    From FIM: $($RankedPrecedenceOrderFromFim | Format-Table Order,ManagementAgentName,CDObjectType -AutoSize | out-string)"

            $PrecedenceCompareResults = Compare-Object -ReferenceObject $RankedPrecedenceOrder -DifferenceObject $RankedPrecedenceOrderFromFim -Property Order,ManagementAgentName,CDObjectType 

            if ($PrecedenceCompareResults)
            {
                Write-Warning "  'ranked precedence order is not the same."
                $objectsAreTheSame = $false

                Write-Verbose "    From DSC: $(($PrecedenceCompareResults | Where-Object SideIndicator -eq '<=' | Format-Table -AutoSize | out-string))"
                Write-Verbose "    From FIM: $(($PrecedenceCompareResults | Where-Object SideIndicator -eq '=>' | Format-Table -AutoSize | out-string))"
            }
        }
        #endregion
    }

    if ($objectsAreTheSame -eq $false)
    {
        $currentObject = Get-TargetResource -MVAttribute $MVAttribute -MVObjectType $MVObjectType
        Write-MimSyncConfigCache -FimXpathFilter $xPathFilter -ObjectTestResult $objectsAreTheSame -DscBoundParameters $PSBoundParameters -CurrentObject $currentObject
    }

    return $objectsAreTheSame
}

Export-ModuleMember -Function *-TargetResource