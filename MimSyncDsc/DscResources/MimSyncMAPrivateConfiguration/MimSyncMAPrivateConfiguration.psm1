data DscParameterToXmlNodeMap
{
ConvertFrom-StringData @'
ForestName        = //private-configuration/adma-configuration/forest-name
ForestLoginDomain = //private-configuration/adma-configuration/forest-login-domain
ForestLoginUser   = //private-configuration/adma-configuration/forest-login-user
SignAndSeal       = //private-configuration/adma-configuration/sign-and-seal
SslBind           = //private-configuration/adma-configuration/ssl-bind
SslBindCrlCheck   = //private-configuration/adma-configuration/ssl-bind/@crl-check
SimpleBind        = //private-configuration/adma-configuration/simple-bind
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
		$ManagementAgentName
	)

	### Check the schema cache and update if necessary
    Write-MimSyncConfigCache -Verbose

    ### Get the FIM object XML from the server configuration files
    Write-Verbose "Finding Private Configuration..."
    $xPathFilter = "//ma-data[name='$ManagementAgentName']/private-configuration/adma-configuration"
    Write-Verbose "  Using XPath: $xPathFilter"
    $fimSyncObject = Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) *.xml) -XPath $xPathFilter

    if (-not $fimSyncObject)
    {
        Write-Warning "No matching object so returning nothing."
        return
    }

	$returnValue = @{
		ManagementAgentName = $ManagementAgentName
		ForestName          = $fimSyncObject.Node.'forest-name' -as [String]
		ForestLoginDomain   = $fimSyncObject.Node.'forest-login-domain' -as [String]
		ForestLoginUser     = $fimSyncObject.Node.'forest-login-user' -as [String]
		SignAndSeal         = [UInt32]$fimSyncObject.Node.'sign-and-seal' -as [Boolean]
		SslBind             = [UInt32]$fimSyncObject.Node.'ssl-bind'.'#text' -as [Boolean]
		SslBindCrlCheck     = [UInt32]$fimSyncObject.Node.'ssl-bind'.'crl-check' -as [Boolean]
		SimpleBind          = [UInt32]$fimSyncObject.Node.'simple-bind' -as [Boolean]
<#
		Authentication = [System.String]
		User = [System.String]
		Domain = [System.String]
		Server = [System.String]
		DatabaseName = [System.String]
		TableName = [System.String]
		DeltaTableName = [System.String]
		Credential = [System.Management.Automation.PSCredential]
		Ensure = [System.String]
#>
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

		[System.String]
		$ForestName,

		[System.String]
		$ForestLoginDomain,

		[System.String]
		$ForestLoginUser,

		[System.Boolean]
		$SignAndSeal,

		[System.Boolean]
		$SslBind,

		[System.Boolean]
		$SslBindCrlCheck,

		[System.Boolean]
		$SimpleBind,

		[System.String]
		$Authentication,

		[System.String]
		$User,

		[System.String]
		$Domain,

		[System.String]
		$Server,

		[System.String]
		$DatabaseName,

		[System.String]
		$TableName,

		[System.String]
		$DeltaTableName,

		[System.Management.Automation.PSCredential]
		$Credential,

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

		[System.String]
		$ForestName,

		[System.String]
		$ForestLoginDomain,

		[System.String]
		$ForestLoginUser,

		[System.Boolean]
		$SignAndSeal,

		[System.Boolean]
		$SslBind,

		[System.Boolean]
		$SslBindCrlCheck,

		[System.Boolean]
		$SimpleBind,

		[System.String]
		$Authentication,

		[System.String]
		$User,

		[System.String]
		$Domain,

		[System.String]
		$Server,

		[System.String]
		$DatabaseName,

		[System.String]
		$TableName,

		[System.String]
		$DeltaTableName,

		[System.Management.Automation.PSCredential]
		$Credential,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    ### Check the schema cache and update if necessary
    Write-MimSyncConfigCache -Verbose

    ### Get the FIM object XML from the server configuration files
    $currentObject = Get-TargetResource -ManagementAgentName $ManagementAgentName

    $objectsAreTheSame = $true

    if ($Ensure -eq 'Present')
    {
        if ($currentObject -eq $null)
        {
            Write-Verbose "Management agent not found."
            $objectsAreTheSame =  $false
        }
        else
        {
            Write-Verbose "Management agent found, diffing the properties..."

            #region Compare ForestName
            Write-Verbose "  Comparing property 'ForestName'"
            Write-Verbose "    From DSC: $ForestName"
            Write-Verbose "    From FIM: $($currentObject.ForestName)"
            if ($ForestName -ne $currentObject.ForestName)
            {
                Write-Warning "  Property is not the same."
                $objectsAreTheSame = $false
            }
            #endregion

            #region Compare ForestLoginDomain
            Write-Verbose "  Comparing property 'ForestLoginDomain'"
            Write-Verbose "    From DSC: $ForestLoginDomain"
            Write-Verbose "    From FIM: $($currentObject.ForestLoginDomain)"
            if ($ForestLoginDomain -ne $currentObject.ForestLoginDomain)
            {
                Write-Warning "  Property is not the same."
                $objectsAreTheSame = $false
            }
            #endregion

            #region Compare ForestLoginUser
            Write-Verbose "  Comparing property 'ForestLoginUser'"
            Write-Verbose "    From DSC: $ForestLoginUser"
            Write-Verbose "    From FIM: $($currentObject.ForestLoginUser)"
            if ($ForestLoginUser -ne $currentObject.ForestLoginUser)
            {
                Write-Warning "  Property is not the same."
                $objectsAreTheSame = $false
            }
            #endregion

            #region Compare SignAndSeal
            Write-Verbose "  Comparing property 'SignAndSeal'"
            Write-Verbose "    From DSC: $SignAndSeal"
            Write-Verbose "    From FIM: $($currentObject.SignAndSeal)"
            if ($SignAndSeal -ne $currentObject.SignAndSeal)
            {
                Write-Warning "  Property is not the same."
                $objectsAreTheSame = $false
            }
            #endregion

            #region Compare SslBind
            Write-Verbose "  Comparing property 'SslBind'"
            Write-Verbose "    From DSC: $SslBind"
            Write-Verbose "    From FIM: $($currentObject.SslBind)"
            if ($SslBind -ne $currentObject.SslBind)
            {
                Write-Warning "  Property is not the same."
                $objectsAreTheSame = $false
            }
            #endregion

            #region Compare SslBindCrlCheck
            Write-Verbose "  Comparing property 'SslBindCrlCheck'"
            Write-Verbose "    From DSC: $SslBindCrlCheck"
            Write-Verbose "    From FIM: $($currentObject.SslBindCrlCheck)"
            if ($SslBindCrlCheck -ne $currentObject.SslBindCrlCheck)
            {
                Write-Warning "  Property is not the same."
                $objectsAreTheSame = $false
            }
            #endregion

            #region Compare SimpleBind
            Write-Verbose "  Comparing property 'SimpleBind'"
            Write-Verbose "    From DSC: $SimpleBind"
            Write-Verbose "    From FIM: $($currentObject.SimpleBind)"
            if ($SimpleBind -ne $currentObject.SimpleBind)
            {
                Write-Warning "  Property is not the same."
                $objectsAreTheSame = $false
            }
            #endregion

        }
    }
    elseif($Ensure -eq 'Absent')
    {
        if ($currentObject -ne $null)
        {
            $objectsAreTheSame = $false
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