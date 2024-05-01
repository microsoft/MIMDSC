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
		ClearRegistration = [System.Boolean]
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
		RequestPhase = [System.String]
		ObjectID = [System.String]
		ResourceTime = [System.DateTime]
		ObjectType = [System.String]
		Rules = [System.String]
		RunOnPolicyUpdate = [System.Boolean]
		XOML = [System.String]
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
		$ClearRegistration,

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

		[System.String]
		$RequestPhase,

		[System.String]
		$Rules,

		[System.Boolean]
		$RunOnPolicyUpdate,

		[System.String]
		$XOML,

		[System.Management.Automation.PSCredential]
		$Credential,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    Set-MimSvcTargetResource -ObjectType WorkflowDefinition -KeyAttributeName DisplayName -DscBoundParameters $PSBoundParameters
}

function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[System.Boolean]
		$ClearRegistration,

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

		[System.String]
		$RequestPhase,

		[System.String]
		$Rules,

		[System.Boolean]
		$RunOnPolicyUpdate,

		[System.String]
		$XOML,

		[System.Management.Automation.PSCredential]
		$Credential,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    Test-MimSvcTargetResource -ObjectType WorkflowDefinition -KeyAttributeName DisplayName -DscBoundParameters $PSBoundParameters
}

Export-ModuleMember -Function *-TargetResource