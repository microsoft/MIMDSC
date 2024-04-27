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
		AllowedAttributes = [System.String[]]
		AllowedMembershipReferences = [System.String[]]
		CreatedTime = [System.DateTime]
		Creator = [System.String]
		DeletedTime = [System.DateTime]
		Description = [System.String]
		DetectedRulesList = [System.String[]]
		DisplayName = [System.String]
		ExpectedRulesList = [System.String[]]
		ExpirationTime = [System.DateTime]
		Locale = [System.String]
		MVObjectID = [System.String]
		ObjectID = [System.String]
		ResourceTime = [System.DateTime]
		ObjectType = [System.String]
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
		[System.String[]]
		$AllowedAttributes,

		[System.String[]]
		$AllowedMembershipReferences,

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

		[System.String]
		$Locale,

		[System.String]
		$MVObjectID,

		[System.Management.Automation.PSCredential]
		$Credential,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    Set-MimSvcTargetResource -ObjectType FilterScope -KeyAttributeName DisplayName -DscBoundParameters $PSBoundParameters
}

function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[System.String[]]
		$AllowedAttributes,

		[System.String[]]
		$AllowedMembershipReferences,

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

		[System.String]
		$Locale,

		[System.String]
		$MVObjectID,

		[System.Management.Automation.PSCredential]
		$Credential,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    Test-MimSvcTargetResource -ObjectType FilterScope -KeyAttributeName DisplayName -DscBoundParameters $PSBoundParameters
}

Export-ModuleMember -Function *-TargetResource