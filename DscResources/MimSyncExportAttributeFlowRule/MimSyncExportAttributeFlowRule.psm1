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
		$MVObjectType,

		[parameter(Mandatory = $true)]
		[System.String]
		$CDAttribute,

		[parameter(Mandatory = $true)]
		[System.String]
		$CDObjectType,

        [parameter(Mandatory = $true)]
        [ValidateSet("direct-mapping","scripted-mapping","constant-mapping")]
		[String]
		$Type
	)
    ### Check the schema cache and update if necessary
    Write-MimSyncConfigCache -Verbose

    ### Get the FIM object XML from the server configuration files
    Write-Verbose "Finding export attribute flow rule [$ManagementAgentName].$CDObjectType.[$($SrcAttribute -Join ',')] --> MV.$MVObjectType.[$MVAttribute] ..."

    $xPathFilter = "//ma-data[name='$ManagementAgentName']/export-attribute-flow/export-flow-set[@mv-object-type='$MVObjectType'and @cd-object-type='$CDObjectType']/export-flow[@cd-attribute='$CDAttribute' and $Type]" 
    Write-Verbose "  Using XPath: $xPathFilter"
    $fimSyncObject = Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) *.xml) -XPath $xPathFilter

    $fimSrcAttributes = @()
    foreach($fimSrcAttribute in Select-Xml -Xml $fimSyncObject.Node -XPath '*/src-attribute')
    {
        $fimSrcAttributes += $fimSrcAttribute
    }

    $outputObject = @{
		ManagementAgentName  = $ManagementAgentName
        CDObjectType         = $CDObjectType
        MVObjectType         = $MVObjectType
        CDAttribute          = $CDAttribute
        Type                 = $Type
        ID                   = $fimSyncObject.Node.ID
    }

    if ($Type -eq 'scripted-mapping')
    {
        $outputObject.Add('ScriptContext',$fimSyncObject.Node.'scripted-mapping'.'script-context')
        $outputObject.Add('SrcAttribute', $fimSrcAttributes)
    }
    if ($Type -eq 'direct-mapping')
    {
        $outputObject.Add('SrcAttribute', $fimSrcAttributes)
    }
    if ($Type -eq 'constant-mapping')
    {
        $outputObject.Add('ConstantValue', $fimSyncObject.Node.'constant-mapping'.'constant-value')
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
		$ManagementAgentName,

		[parameter(Mandatory = $true)]
		[System.String]
		$MVObjectType,

		[parameter(Mandatory = $true)]
		[System.String]
		$CDAttribute,

		[parameter(Mandatory = $true)]
		[System.String]
		$CDObjectType,

        [parameter(Mandatory = $true)]
        [ValidateSet("direct-mapping","scripted-mapping","constant-mapping")]
		[String]
		$Type,

        [String[]]
        $SrcAttribute,

        [String]
        $ConstantValue,

        [Boolean]
        $SuppressDeletions,

        [String]
        $ScriptContext,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)
    Write-Warning "DSC resources for the FIM Synchronization Service are not able to update the FIM Synchronization configuration."
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
		$MVObjectType,

		[parameter(Mandatory = $true)]
		[System.String]
		$CDAttribute,

		[parameter(Mandatory = $true)]
		[System.String]
		$CDObjectType,

        [parameter(Mandatory = $true)]
        [ValidateSet("direct-mapping","scripted-mapping","constant-mapping")]
		[String]
		$Type,

        [String[]]
        $SrcAttribute,

        [String]
        $ConstantValue,

        [Boolean]
        $SuppressDeletions,

        [String]
        $ScriptContext,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)
    ### Check the schema cache and update if necessary
    Write-MimSyncConfigCache -Verbose

    ### Get the FIM object XML from the server configuration files
    Write-Verbose "Finding export attribute flow rule [$ManagementAgentName].$CDObjectType.[$($SrcAttribute -Join ',')] <-- MV.$MVObjectType.[$SrcAttribute] ..."

    $xPathFilter = "//ma-data[name='$ManagementAgentName']/export-attribute-flow/export-flow-set[@mv-object-type='$MVObjectType'and @cd-object-type='$CDObjectType']/export-flow[@cd-attribute='$CDAttribute' and $Type]" 
    Write-Verbose "  Using XPath: $xPathFilter"
    $fimSyncObject = Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) *.xml) -XPath $xPathFilter 

    $objectsAreTheSame = $true

    if ($Ensure -eq 'Present')
    {
        if ($fimSyncObject -eq $null)
        {
            Write-Verbose "Attribute flow rule not found: $Name."
            $objectsAreTheSame = $false
        }
        else
        {
            Write-Verbose "Attribute flow rule found, diffing the properties..."

            #region Compare script-context
            if ($Type -eq 'scripted-mapping')
            {
                Write-Verbose "  Comparing property 'script-context'"
                Write-Verbose "    From DSC: $ScriptContext"
                Write-Verbose "    From MIM: $($fimSyncObject.Node.'scripted-mapping'.'script-context')"
                if ($fimSyncObject.Node.'scripted-mapping'.'script-context' -ne $ScriptContext)
                {
                    Write-Warning "  'script-context' property is not the same."
                    $objectsAreTheSame = $false
                }
            }
            #endregion

            #region Compare src-attribute
            if ($Type -in 'scripted-mapping','direct-mapping')
            {
                $fimSrcAttributes = @()
                foreach($fimSrcAttribute in Select-Xml -Xml $fimSyncObject.Node -XPath '*/src-attribute')
                {
                    $fimSrcAttributes += $fimSrcAttribute
                }
                Write-Verbose "  Comparing property 'src-attribute'"
                Write-Verbose "    From DSC: $($SrcAttribute -join ',')"
                Write-Verbose "    From MIM: $($fimSrcAttributes -join ',')"
                if (Compare-Object -ReferenceObject $SrcAttribute -DifferenceObject $fimSrcAttributes )
                {
                    Write-Warning "  'src-attribute' property is not the same."
                    $objectsAreTheSame = $false
                }
            }
            #endregion

            #region Compare constant-value
            if ($Type -eq 'constant-mapping')
            {
                Write-Verbose "  Comparing property 'constant-mapping'"
                Write-Verbose "    From DSC: $ConstantValue"
                Write-Verbose "    From MIM: $($fimSyncObject.Node.'constant-mapping'.'constant-value')"
                if ($fimSyncObject.Node.'constant-mapping'.'constant-value' -ne $ConstantValue)
                {
                    Write-Warning "  'constant-value' property is not the same."
                    $objectsAreTheSame = $false
                }
            }
            #endregion

            #region Compare suppress-deletions
            if ($Type -ne 'constant-mapping') ### Suppress Deletions is not supported for Constant-Mapping
            {
                Write-Verbose "  Comparing property 'suppress-deletions'"
                $fimSuppressDeletionsValue = [Convert]::ToBoolean($fimSyncObject.Node.'suppress-deletions')
                Write-Verbose "    From DSC: $SuppressDeletions"
                Write-Verbose "    From MIM: $fimSuppressDeletionsValue"
                if ($fimSuppressDeletionsValue -ne $SuppressDeletions)
                {
                    Write-Warning "  'suppress-deletions' property is not the same."
                    $objectsAreTheSame = $false
                }
            }
            #endregion

            $objectsAreTheSame = $objectsAreTheSame
        }
    }
    elseif($Ensure -eq 'Absent')
    {
        if ($fimSyncObject -ne $null)
        {
            Write-Warning "Attribute flow rule found ($Name) but is supposed to be Absent. DESTROY!!!"
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
