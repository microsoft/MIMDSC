data DscParameterToXmlNodeMap
{
ConvertFrom-StringData @'
AttributeInclusion      = //ma-data/attribute-inclusion/attribute
Category                = //ma-data/category
ControllerConfiguration = //ma-data/controller-configuration
CreationTime            = //ma-data/creation-time
Description             = //ma-data/description
Extension               = //ma-data/extension
LastModificationTime    = //ma-data/last-modification-time
MACompanyName           = //ma-data/ma-companyname
MAListName              = //ma-data/ma-listname
Name                    = //ma-data/name
PasswordSyncAllowed     = //ma-data/password-sync-allowed
ProvisioningCleanup     = //ma-data/provisioning-cleanup
PasswordSync            = //ma-data/password-sync
PrivateConfiguration    = //ma-data/private-configuration
Subtype                 = //ma-data/subtype
Version                 = //ma-data/version
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
		$Name
	)

    ### Check the schema cache and update if necessary
    Write-MimSyncConfigCache -Verbose

    $svrexportPath = Get-MimSyncConfigCache
    Write-Verbose "Getting sync configuration files from '$svrexportPath'"

    ### Get the MA XML from the server configuration files
    Write-Verbose "Finding a management agent XML file with a name of '$Name'"
    $maData = Select-Xml -Path (Join-Path $svrexportPath *.xml) -XPath "//ma-data[name='$Name']"

    if (-not $maData)
    {
        ### No matching object so return nothing
        return
    }

    Write-Output @{
		Name                       = $Name
        Category                   = $maData.Node.SelectSingleNode($DscParameterToXmlNodeMap.Category).InnerText
        Subtype                    = $maData.Node.SelectSingleNode($DscParameterToXmlNodeMap.Subtype).InnerText
        CreationTime               = $maData.Node.SelectSingleNode($DscParameterToXmlNodeMap.CreationTime).InnerText
        LastModificationTime       = $maData.Node.SelectSingleNode($DscParameterToXmlNodeMap.LastModificationTime).InnerText
        Version                    = $maData.Node.SelectSingleNode($DscParameterToXmlNodeMap.Version).InnerText
        PasswordSyncAllowed        = $maData.Node.SelectSingleNode($DscParameterToXmlNodeMap.PasswordSyncAllowed).InnerText -as [Boolean]
        Description                = $maData.Node.SelectSingleNode($DscParameterToXmlNodeMap.Description).InnerText
        AttributeInclusion         = $maData.Node.SelectNodes($DscParameterToXmlNodeMap.AttributeInclusion).'#text'
        PrivateConfiguration       = $maData.Node.SelectSingleNode($DscParameterToXmlNodeMap.PrivateConfiguration).OuterXml
        ProvisioningCleanup = New-CimInstance -ClassName MimSyncProvisioningCleanup -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
            Type                   = $maData.Node.SelectSingleNode($DscParameterToXmlNodeMap.ProvisioningCleanup).type -as [String]
            Action                 = $maData.Node.SelectSingleNode($DscParameterToXmlNodeMap.ProvisioningCleanup).action -as [String]
        }        
        Extension = New-CimInstance -ClassName MimSyncExtension -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
            AssemblyName            = $maData.Node.SelectSingleNode($DscParameterToXmlNodeMap.Extension).'assembly-name' -as [String]
            ApplicationProtection   = $maData.Node.SelectSingleNode($DscParameterToXmlNodeMap.Extension).'application-protection' -as [String]
        } 
        ControllerConfiguration = New-CimInstance -ClassName MimSyncControllerConfiguration -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
            ApplicationArchitecture = $maData.Node.SelectSingleNode($DscParameterToXmlNodeMap.ControllerConfiguration).'application-architecture' -as [String]
            ApplicationProtection   = $maData.Node.SelectSingleNode($DscParameterToXmlNodeMap.ControllerConfiguration).'application-protection' -as [String]
        } 
        PasswordSync = New-CimInstance -ClassName MimSyncPasswordSync -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
            MaximumRetryCount       = $maData.Node.SelectSingleNode($DscParameterToXmlNodeMap.PasswordSync).'maximum-retry-count' -as [UInt32]
            RetryInterval           = $maData.Node.SelectSingleNode($DscParameterToXmlNodeMap.PasswordSync).'retry-interval' -as [UInt32]
            AllowLowSecurity        = $maData.Node.SelectSingleNode($DscParameterToXmlNodeMap.PasswordSync).'allow-low-security' -as [Boolean]
        }
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

		[System.String]
		$Category,

		[System.String]
		$Subtype,

		[System.Boolean]
		$PasswordSyncAllowed,

		[Microsoft.Management.Infrastructure.CimInstance]
		$AnchorConstructionSettings,

		[System.String[]]
		$AttributeInclusion,

		[Microsoft.Management.Infrastructure.CimInstance]
		$ProvisioningCleanup,

		[Microsoft.Management.Infrastructure.CimInstance]
		$Extension,

		[Microsoft.Management.Infrastructure.CimInstance]
		$ControllerConfiguration,

		[System.String]
		$Description,

		[Microsoft.Management.Infrastructure.CimInstance]
		$PasswordSync,

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

        [System.String]
		$Category,

		[System.String]
		$Subtype,

		[System.Boolean]
		$PasswordSyncAllowed,

		[Microsoft.Management.Infrastructure.CimInstance]
		$AnchorConstructionSettings,

		[System.String[]]
		$AttributeInclusion,

		[Microsoft.Management.Infrastructure.CimInstance]
		$ProvisioningCleanup,

		[Microsoft.Management.Infrastructure.CimInstance]
		$Extension,

		[Microsoft.Management.Infrastructure.CimInstance]
		$ControllerConfiguration,

		[System.String]
		$Description,

		[Microsoft.Management.Infrastructure.CimInstance]
		$PasswordSync,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    ### Check the schema cache and update if necessary
    Write-MimSyncConfigCache -Verbose

    ### Get the FIM object XML from the server configuration files
    Write-Verbose "Finding a management agent XML file with a name of '$Name'"
    $xPathFilter = "//ma-data[name='$Name']"
    Write-Verbose "  Using XPath: $xPathFilter"
    $fimSyncObject = Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) *.xml) -XPath $xPathFilter

    $objectsAreTheSame = $true

    if ($Ensure -eq 'Present')
    {
        if ($fimSyncObject -eq $null)
        {
            Write-Verbose "Management agent not found: $Name."
            $objectsAreTheSame = $false
        }
        else
        {
            Write-Verbose "Management agent found, diffing the properties..."
            $objectsAreTheSame = $true

            foreach ($dscResourceProperty in Get-DscResource -Name MimSyncMaData | Select-Object -ExpandProperty Properties)
            {
                if ($dscResourceProperty.Name -in 'Ensure','DependsOn','PsDscRunAsCredential')
                {
                    Write-Verbose "  Skipping system-owned attribute: $($dscResourceProperty.Name)"
                    continue
                }

                if ($dscResourceProperty.Name -in 'AnchorConstructionSettings','PrivateConfiguration')
                {
                    Write-Verbose "  Skipping '$($dscResourceProperty.Name)' because it is not yet supported by this DSC resource."
                    continue
                }

                if ($dscResourceProperty.Name -eq 'ProvisioningCleanup')
                {
                    Write-Verbose "  Comparing property $($dscResourceProperty.Name) using XPath: $($DscParameterToXmlNodeMap.($dscResourceProperty.Name))"
                    $fimValue = $fimSyncObject.Node.SelectSingleNode($DscParameterToXmlNodeMap.($dscResourceProperty.Name))

                    $valueFromDSC = "type={0} action={1}" -F $ProvisioningCleanup.Type, $ProvisioningCleanup.Action
                    $valueFromFIM = "type={0} action={1}" -F $fimValue.type, $fimValue.action
 
                    Write-Verbose "    From DSC: $valueFromDSC"
                    Write-Verbose "    From FIM: $valueFromFIM"

                    if ($valueFromDSC -ne $valueFromFIM )
                    {
                        Write-Warning "  '$($dscResourceProperty.Name)' property is not the same."
                        $objectsAreTheSame = $false
                    }
                }
                elseif ($dscResourceProperty.Name -eq 'Extension')
                {
                    Write-Verbose "  Comparing property $($dscResourceProperty.Name) using XPath: $($DscParameterToXmlNodeMap.($dscResourceProperty.Name))"
                    $fimValue = $fimSyncObject.Node.SelectSingleNode($DscParameterToXmlNodeMap.($dscResourceProperty.Name))

                    $valueFromDSC = "AssemblyName={0} ApplicationProtection={1}" -F $Extension.AssemblyName, $Extension.ApplicationProtection
                    $valueFromFIM = "AssemblyName={0} ApplicationProtection={1}" -F $fimValue.'assembly-name', $fimValue.'application-protection'
 
                    Write-Verbose "    From DSC: $valueFromDSC"
                    Write-Verbose "    From FIM: $valueFromFIM"

                    if ($valueFromDSC -ne $valueFromFIM )
                    {
                        Write-Warning "  '$($dscResourceProperty.Name)' property is not the same."
                        $objectsAreTheSame = $false
                    }
                }
                elseif ($dscResourceProperty.Name -eq 'ControllerConfiguration')
                {
                    Write-Verbose "  Comparing property $($dscResourceProperty.Name) using XPath: $($DscParameterToXmlNodeMap.($dscResourceProperty.Name))"
                    $fimValue = $fimSyncObject.Node.SelectSingleNode($DscParameterToXmlNodeMap.($dscResourceProperty.Name))

                    $valueFromDSC = "ApplicationArchitecture={0} ApplicationProtection={1}" -F $ControllerConfiguration.ApplicationArchitecture, $ControllerConfiguration.ApplicationProtection
                    $valueFromFIM = "ApplicationArchitecture={0} ApplicationProtection={1}" -F $fimValue.'application-architecture', $fimValue.'application-protection'
 
                    Write-Verbose "    From DSC: $valueFromDSC"
                    Write-Verbose "    From FIM: $valueFromFIM"

                    if ($valueFromDSC -ne $valueFromFIM )
                    {
                        Write-Warning "  '$($dscResourceProperty.Name)' property is not the same."
                        $objectsAreTheSame = $false
                    }
                }
                elseif ($dscResourceProperty.Name -eq 'PasswordSync')
                {
                    Write-Verbose "  Comparing property $($dscResourceProperty.Name) using XPath: $($DscParameterToXmlNodeMap.($dscResourceProperty.Name))"
                    $fimValue = $fimSyncObject.Node.SelectSingleNode($DscParameterToXmlNodeMap.($dscResourceProperty.Name))

                    $valueFromDSC = "MaximumRetryCount={0} RetryInterval={1} AllowLowSecurity={2}" -F $PasswordSync.MaximumRetryCount, $PasswordSync.RetryInterval, $PasswordSync.AllowLowSecurity
                    $valueFromFIM = "MaximumRetryCount={0} RetryInterval={1} AllowLowSecurity={2}" -F $fimValue.'maximum-retry-count', $fimValue.'retry-interval', ($fimValue.'allow-low-security' -as [Boolean])
 
                    Write-Verbose "    From DSC: $valueFromDSC"
                    Write-Verbose "    From FIM: $valueFromFIM"

                    if ($valueFromDSC -ne $valueFromFIM )
                    {
                        Write-Warning "  '$($dscResourceProperty.Name)' property is not the same."
                        $objectsAreTheSame = $false
                    }
                }
                elseif ($dscResourceProperty.Name -eq 'AttributeInclusion')
                {
                    Write-Verbose "  Comparing property '$($dscResourceProperty.Name)' using XPath: $($DscParameterToXmlNodeMap.($dscResourceProperty.Name))"
                    $fimValue = $fimSyncObject.Node.SelectNodes($DscParameterToXmlNodeMap.($dscResourceProperty.Name)).'#text'

                    Write-Verbose ("    From DSC: ({0}) {1}" -F $PSBoundParameters[$dscResourceProperty.Name].Count, ($PSBoundParameters[$dscResourceProperty.Name] -join ', '))
                    Write-Verbose ("    From FIM: ({0}) {1}" -F $fimValue.Count,  ($fimValue  -join ', '))

                    if ($PSBoundParameters[$dscResourceProperty.Name].Count -eq 0 -and $fimValue.Count -eq 0)
                    {
                        ### do nothing.  done.
                    }
                    elseif ($PSBoundParameters[$dscResourceProperty.Name].Count -eq 0 -and $fimValue.Count -ne 0)
                    {
                        ### need to delete all values
                        Write-Warning "  '$($dscResourceProperty.Name)' property is not the same."
                        $objectsAreTheSame = $false
                    }
                    elseif ($PSBoundParameters[$dscResourceProperty.Name].Count -ne 0 -and $fimValue.Count -eq 0)
                    {
                        ### need to add all values 
                        Write-Warning "  '$($dscResourceProperty.Name)' property is not the same."
                        $objectsAreTheSame = $false
                    }
                    else
                    {
                        if (Compare-Object $PSBoundParameters[$dscResourceProperty.Name] $fimValue)
                        {
                            Write-Warning "  '$($dscResourceProperty.Name)' property is not the same."
                            $objectsAreTheSame = $false
                        }
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
            Write-Warning "Management agent found ($Name) but is supposed to be Absent. DESTROY!!!"
            $objectsAreTheSame =  $false
        }
        else
        {
            $objectsAreTheSame =  $true
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