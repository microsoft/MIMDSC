data DscParameterToXmlNodeMap
{
ConvertFrom-StringData @'
CreationTime            = creation-time
LastModificationTime    = last-modification-time
Name                    = name
RunSteps                = configuration/step
Version                 = version
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

    ### Get the object XML from the server configuration files
    Write-Verbose "Finding run profile '$Name' on management agent '$ManagementAgentName'..."   
    $xPathFilter = "//ma-data[name='$ManagementAgentName']/ma-run-data/run-configuration[name='$Name']"
    Write-Verbose "  Using XPath: $xPathFilter"
    $fimSyncObject = Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) *.xml) -XPath $xPathFilter

    if (-not $fimSyncObject)
    {
        ### No matching object so return nothing
        return
    }

    $runSteps = @($fimSyncObject.Node.SelectNodes($DscParameterToXmlNodeMap.RunSteps) | Convert-MimSyncRunStepToCimInstance)

    Write-Output @{
		Name                       = $Name
        ManagementAgentName        = $ManagementAgentName
        CreationTime               = $fimSyncObject.Node.SelectSingleNode($DscParameterToXmlNodeMap.CreationTime).InnerText
        LastModificationTime       = $fimSyncObject.Node.SelectSingleNode($DscParameterToXmlNodeMap.LastModificationTime).InnerText
        Version                    = $fimSyncObject.Node.SelectSingleNode($DscParameterToXmlNodeMap.Version).InnerText
        RunSteps                   = $runSteps
    }
}

function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$Name,

		[parameter(Mandatory = $true)]
		[System.String]
		$ManagementAgentName,

        [Microsoft.Management.Infrastructure.CimInstance[]]
        $RunSteps,

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
		$Name,

		[parameter(Mandatory = $true)]
		[System.String]
		$ManagementAgentName,

        [Microsoft.Management.Infrastructure.CimInstance[]]
        $RunSteps,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    ### Check the schema cache and update if necessary
    Write-MimSyncConfigCache -Verbose

    ### Get the FIM object XML from the server configuration files
    Write-Verbose "Finding run profile '$Name' on management agent '$ManagementAgentName'..."   
    $xPathFilter = "//ma-data[name='$ManagementAgentName']/ma-run-data/run-configuration[name='$Name']"
    Write-Verbose "  Using XPath: $xPathFilter"
    $fimSyncObject = Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) *.xml) -XPath $xPathFilter

    $objectsAreTheSame = $true

    if ($Ensure -eq 'Present')
    {
        if ($fimSyncObject -eq $null)
        {
            Write-Verbose "Run Profile not found: $Name."
            $objectsAreTheSame = $false
        }
        else
        {
            Write-Verbose "Run Profile found, diffing the properties: $($fimSyncObject.Path)"
            $objectsAreTheSame = $true

            foreach ($dscResourceProperty in Get-DscResource -Name MimSyncRunProfile | Select-Object -ExpandProperty Properties)
            {
                if ($dscResourceProperty.Name -in 'Ensure','DependsOn','ManagementAgentName','PsDscRunAsCredential')
                {
                    Write-Verbose "  Skipping system-owned attribute: $($dscResourceProperty.Name)"
                    continue
                }

                if ($dscResourceProperty.Name -eq 'RunSteps')
                {
                    Write-Verbose "  Comparing property $($dscResourceProperty.Name) using XPath: $($DscParameterToXmlNodeMap.($dscResourceProperty.Name))"

                    $valuesFromDSC = @($RunSteps)
                    $valuesFromFIM = @($fimSyncObject.Node.SelectNodes($DscParameterToXmlNodeMap.($dscResourceProperty.Name)) | Convert-MimSyncRunStepToCimInstance)

                    Write-Verbose "    From DSC: $($valuesFromDSC.count)"
                    Write-Verbose "    From FIM: $($valuesFromFIM.count)"

                    #TODO - make this compare smarter - for example it needs to interpret a missing input as equal to a present input that has a null value
                    $valueCompare = Compare-Object -ReferenceObject $valuesFromDSC -DifferenceObject $valuesFromFIM -Property StepType,StepSubtype,PartitionIdentifier,DropFileName,PageSize,Timeout,ObjectDeleteLimit,ObjectProcessLimit,InputFile
                    if ($valueCompare)
                    {
                        Write-Warning "  '$($dscResourceProperty.Name)' property is not the same."
                        $objectsAreTheSame = $false

                        Write-Verbose "    From DSC: $(($valueCompare | Where-Object SideIndicator -eq '<='))"
                        Write-Verbose "    From FIM: $(($valueCompare | Where-Object SideIndicator -eq '=>'))"
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
        }
    }
    elseif($Ensure -eq 'Absent')
    {
        if ($fimSyncObject -ne $null)
        {
            Write-Warning "Run Profile found ($Name) but is supposed to be Absent. DESTROY!!!"
            $objectsAreTheSame = $false
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