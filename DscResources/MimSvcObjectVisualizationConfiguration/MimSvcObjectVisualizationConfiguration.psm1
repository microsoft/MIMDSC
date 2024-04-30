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
		AppliesToCreate = [System.Boolean]
		AppliesToEdit = [System.Boolean]
		AppliesToView = [System.Boolean]
		ConfigurationData = [System.String]
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
		ObjectID = [System.String]
		ResourceTime = [System.DateTime]
		ObjectType = [System.String]
		StringResources = [System.String]
		TargetObjectType = [System.String]
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
		[System.Boolean]
		$AppliesToCreate,

		[System.Boolean]
		$AppliesToEdit,

		[System.Boolean]
		$AppliesToView,

		[System.String]
		$ConfigurationData,

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
		$StringResources,

		[System.String]
		$TargetObjectType,

		[System.Management.Automation.PSCredential]
		$Credential,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    Set-MimSvcTargetResource -ObjectType ObjectVisualizationConfiguration -KeyAttributeName DisplayName -DscBoundParameters $PSBoundParameters

}

function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[System.Boolean]
		$AppliesToCreate,

		[System.Boolean]
		$AppliesToEdit,

		[System.Boolean]
		$AppliesToView,

		[System.String]
		$ConfigurationData,

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
		$StringResources,

		[System.String]
		$TargetObjectType,

		[System.Management.Automation.PSCredential]
		$Credential,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    Test-MimSvcTargetResource -ObjectType ObjectVisualizationConfiguration -KeyAttributeName DisplayName -DscBoundParameters $PSBoundParameters

}

Export-ModuleMember -Function *-TargetResource