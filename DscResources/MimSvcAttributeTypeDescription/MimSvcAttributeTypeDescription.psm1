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

	#Write-Verbose "Use this cmdlet to deliver information about command processing."

	#Write-Debug "Use this cmdlet to write debug information while troubleshooting."


	<#
	$returnValue = @{
		CreatedTime = [System.DateTime]
		Creator = [System.String]
		DataType = [System.String]
		DeletedTime = [System.DateTime]
		Description = [System.String]
		DetectedRulesList = [System.String[]]
		DisplayName = [System.String]
		ExpectedRulesList = [System.String[]]
		ExpirationTime = [System.DateTime]
		IntegerMaximum = [System.UInt64]
		IntegerMinimum = [System.UInt64]
		Locale = [System.String]
		Localizable = [System.Boolean]
		Multivalued = [System.Boolean]
		MVObjectID = [System.String]
		Name = [System.String]
		ObjectID = [System.String]
		ResourceTime = [System.DateTime]
		ObjectType = [System.String]
		StringRegex = [System.String]
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
		$DataType,

		[System.String]
		$Description,

		[System.String[]]
		$DetectedRulesList,

		[System.String]
		$DisplayName,

		[System.String[]]
		$ExpectedRulesList,

		[System.DateTime]
		$ExpirationTime,

		[System.UInt64]
		$IntegerMaximum,

		[System.UInt64]
		$IntegerMinimum,

		[System.String]
		$Locale,

		[System.Boolean]
		$Localizable,

		[System.Boolean]
		$Multivalued,

		[System.String]
		$MVObjectID,

		[parameter(Mandatory = $true)]
		[System.String]
		$Name,

		[System.String]
		$StringRegex,

		[System.String[]]
		$UsageKeyword,

		[System.Management.Automation.PSCredential]
		$Credential,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    Set-MimSvcTargetResource -ObjectType AttributeTypeDescription -KeyAttributeName Name -DscBoundParameters $PSBoundParameters
}

function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[System.String]
		$DataType,

		[System.String]
		$Description,

		[System.String[]]
		$DetectedRulesList,

		[System.String]
		$DisplayName,

		[System.String[]]
		$ExpectedRulesList,

		[System.DateTime]
		$ExpirationTime,

		[System.UInt64]
		$IntegerMaximum,

		[System.UInt64]
		$IntegerMinimum,

		[System.String]
		$Locale,

		[System.Boolean]
		$Localizable,

		[System.Boolean]
		$Multivalued,

		[System.String]
		$MVObjectID,

		[parameter(Mandatory = $true)]
		[System.String]
		$Name,

		[System.String]
		$StringRegex,

		[System.String[]]
		$UsageKeyword,

		[System.Management.Automation.PSCredential]
		$Credential,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    Test-MimSvcTargetResource -ObjectType AttributeTypeDescription -KeyAttributeName Name -DscBoundParameters $PSBoundParameters
}

Export-ModuleMember -Function *-TargetResource