function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$DisplayName
	)

	#Write-Verbose "Use this cmdlet to deliver information about command processing."

	#Write-Debug "Use this cmdlet to write debug information while troubleshooting."


	<#
	$returnValue = @{
		BrandingCenterText = [System.String]
		BrandingLeftImage = [System.String]
		BrandingRightImage = [System.String]
		CreatedTime = [System.DateTime]
		Creator = [System.String]
		DeletedTime = [System.DateTime]
		Description = [System.String]
		DetectedRulesList = [System.String[]]
		DisplayName = [System.String]
		ExpectedRulesList = [System.String[]]
		ExpirationTime = [System.DateTime]
		UICacheTime = [System.UInt64]
		IsConfigurationType = [System.Boolean]
		ListViewCacheTimeOut = [System.UInt64]
		ListViewPageSize = [System.UInt64]
		ListViewPagesToCache = [System.UInt64]
		Locale = [System.String]
		MVObjectID = [System.String]
		UICountCacheTime = [System.UInt64]
		UIUserCacheTime = [System.UInt64]
		ObjectID = [System.String]
		ResourceTime = [System.DateTime]
		ObjectType = [System.String]
		TimeZone = [System.String]
		Credential = [System.Management.Automation.PSCredential]
		Ensure = [System.String]
	}

	$returnValue
	#>
}

function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[System.String]
		$BrandingCenterText,

		[System.String]
		$BrandingLeftImage,

		[System.String]
		$BrandingRightImage,

		[System.String]
		$Description,

		[System.String[]]
		$DetectedRulesList,

		[parameter(Mandatory = $true)]
		[System.String]
		$DisplayName,

		[System.String[]]
		$ExpectedRulesList,

		[System.DateTime]
		$ExpirationTime,

		[System.UInt64]
		$UICacheTime,

		[System.Boolean]
		$IsConfigurationType,

		[System.UInt64]
		$ListViewCacheTimeOut,

		[System.UInt64]
		$ListViewPageSize,

		[System.UInt64]
		$ListViewPagesToCache,

		[System.String]
		$Locale,

		[System.String]
		$MVObjectID,

		[System.UInt64]
		$UICountCacheTime,

		[System.UInt64]
		$UIUserCacheTime,

		[System.String]
		$TimeZone,

		[System.Management.Automation.PSCredential]
		$Credential,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    Set-MimSvcTargetResource -ObjectType PortalUIConfiguration -KeyAttributeName DisplayName -DscBoundParameters $PSBoundParameters
}

function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[System.String]
		$BrandingCenterText,

		[System.String]
		$BrandingLeftImage,

		[System.String]
		$BrandingRightImage,

		[System.String]
		$Description,

		[System.String[]]
		$DetectedRulesList,

		[parameter(Mandatory = $true)]
		[System.String]
		$DisplayName,

		[System.String[]]
		$ExpectedRulesList,

		[System.DateTime]
		$ExpirationTime,

		[System.UInt64]
		$UICacheTime,

		[System.Boolean]
		$IsConfigurationType,

		[System.UInt64]
		$ListViewCacheTimeOut,

		[System.UInt64]
		$ListViewPageSize,

		[System.UInt64]
		$ListViewPagesToCache,

		[System.String]
		$Locale,

		[System.String]
		$MVObjectID,

		[System.UInt64]
		$UICountCacheTime,

		[System.UInt64]
		$UIUserCacheTime,

		[System.String]
		$TimeZone,

		[System.Management.Automation.PSCredential]
		$Credential,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    Test-MimSvcTargetResource -ObjectType PortalUIConfiguration -KeyAttributeName DisplayName -DscBoundParameters $PSBoundParameters
}

Export-ModuleMember -Function *-TargetResource