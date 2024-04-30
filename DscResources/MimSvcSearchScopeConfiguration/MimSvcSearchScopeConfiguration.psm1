function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$DisplayName,

        [parameter(Mandatory = $true)]
		[System.UInt64]
		$Order
	)

	#Write-Verbose "Use this cmdlet to deliver information about command processing."

	#Write-Debug "Use this cmdlet to write debug information while troubleshooting."


	<#
	$returnValue = @{
		msidmSearchScopeAdvancedFilter = [System.String]
		SearchScopeColumn = [System.String]
		SearchScopeContext = [System.String[]]
		CreatedTime = [System.DateTime]
		Creator = [System.String]
		DeletedTime = [System.DateTime]
		Description = [System.String]
		DetectedRulesList = [System.String[]]
		DisplayName = [System.String]
		ExpectedRulesList = [System.String[]]
		ExpirationTime = [System.DateTime]
		IsConfigurationType = [System.Boolean]
		Locale = [System.String]
		MVObjectID = [System.String]
		NavigationPage = [System.String]
		Order = [System.UInt64]
		SearchScopeTargetURL = [System.String]
		ObjectID = [System.String]
		ResourceTime = [System.DateTime]
		ObjectType = [System.String]
		SearchScopeResultObjectType = [System.String]
		SearchScope = [System.String]
		UsageKeyword = [System.String[]]
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
		$msidmSearchScopeAdvancedFilter,

		[System.String]
		$SearchScopeColumn,

		[System.String[]]
		$SearchScopeContext,

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

		[System.Boolean]
		$IsConfigurationType,

		[System.String]
		$Locale,

		[System.String]
		$MVObjectID,

		[System.String]
		$NavigationPage,

        [parameter(Mandatory = $true)]
		[System.UInt64]
		$Order,

		[System.String]
		$SearchScopeTargetURL,

		[System.String]
		$SearchScopeResultObjectType,

		[System.String]
		$SearchScope,

		[System.String[]]
		$UsageKeyword,

		[System.Management.Automation.PSCredential]
		$Credential,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    Set-MimSvcTargetResource -ObjectType SearchScopeConfiguration -KeyAttributeName DisplayName -DscBoundParameters $PSBoundParameters
}

function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[System.String]
		$msidmSearchScopeAdvancedFilter,

		[System.String]
		$SearchScopeColumn,

		[System.String[]]
		$SearchScopeContext,

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

		[System.Boolean]
		$IsConfigurationType,

		[System.String]
		$Locale,

		[System.String]
		$MVObjectID,

		[System.String]
		$NavigationPage,

        [parameter(Mandatory = $true)]
		[System.UInt64]
		$Order,

		[System.String]
		$SearchScopeTargetURL,

		[System.String]
		$SearchScopeResultObjectType,

		[System.String]
		$SearchScope,

		[System.String[]]
		$UsageKeyword,

		[System.Management.Automation.PSCredential]
		$Credential,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    Test-MimSvcTargetResource -ObjectType SearchScopeConfiguration -KeyAttributeName DisplayName -DscBoundParameters $PSBoundParameters

}

Export-ModuleMember -Function *-TargetResource