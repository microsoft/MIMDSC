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
		AccountName = [System.String]
		ComputedMember = [System.String[]]
		CreatedTime = [System.DateTime]
		Creator = [System.String]
		msidmDeferredEvaluation = [System.Boolean]
		DeletedTime = [System.DateTime]
		Description = [System.String]
		DetectedRulesList = [System.String[]]
		DisplayName = [System.String]
		DisplayedOwner = [System.String]
		Domain = [System.String]
		DomainConfiguration = [System.String]
		Email = [System.String]
		MailNickname = [System.String]
		ExpectedRulesList = [System.String[]]
		ExpirationTime = [System.DateTime]
		Filter = [System.String]
		Locale = [System.String]
		ExplicitMember = [System.String[]]
		MembershipAddWorkflow = [System.String]
		MembershipLocked = [System.Boolean]
		MVObjectID = [System.String]
		Owner = [System.String[]]
		ObjectID = [System.String]
		ObjectSID = [System.String]
		ResourceTime = [System.DateTime]
		ObjectType = [System.String]
		Scope = [System.String]
		SIDHistory = [System.String[]]
		Temporal = [System.Boolean]
		Type = [System.String]
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
		$AccountName,

		[System.String[]]
		$ComputedMember,

		[System.Boolean]
		$msidmDeferredEvaluation,

		[System.String]
		$Description,

		[System.String[]]
		$DetectedRulesList,

		[parameter(Mandatory = $true)]
		[System.String]
		$DisplayName,

		[System.String]
		$DisplayedOwner,

		[System.String]
		$Domain,

		[System.String]
		$DomainConfiguration,

		[System.String]
		$Email,

		[System.String]
		$MailNickname,

		[System.String[]]
		$ExpectedRulesList,

		[System.DateTime]
		$ExpirationTime,

		[System.String]
		$Filter,

		[System.String]
		$Locale,

		[System.String[]]
		$ExplicitMember,

		[System.String]
		$MembershipAddWorkflow,

		[System.Boolean]
		$MembershipLocked,

		[System.String]
		$MVObjectID,

		[System.String[]]
		$Owner,

		[System.String]
		$ObjectSID,

		[System.String]
		$GroupScope,

		[System.String[]]
		$SIDHistory,

		[System.Boolean]
		$Temporal,

		[System.String]
		$Type,

		[System.Management.Automation.PSCredential]
		$Credential,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    Set-MimSvcTargetResource -ObjectType Group -KeyAttributeName DisplayName -DscBoundParameters $PSBoundParameters
}

function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[System.String]
		$AccountName,

		[System.String[]]
		$ComputedMember,

		[System.Boolean]
		$msidmDeferredEvaluation,

		[System.String]
		$Description,

		[System.String[]]
		$DetectedRulesList,

		[parameter(Mandatory = $true)]
		[System.String]
		$DisplayName,

		[System.String]
		$DisplayedOwner,

		[System.String]
		$Domain,

		[System.String]
		$DomainConfiguration,

		[System.String]
		$Email,

		[System.String]
		$MailNickname,

		[System.String[]]
		$ExpectedRulesList,

		[System.DateTime]
		$ExpirationTime,

		[System.String]
		$Filter,

		[System.String]
		$Locale,

		[System.String[]]
		$ExplicitMember,

		[System.String]
		$MembershipAddWorkflow,

		[System.Boolean]
		$MembershipLocked,

		[System.String]
		$MVObjectID,

		[System.String[]]
		$Owner,

		[System.String]
		$ObjectSID,

		[System.String]
		$GroupScope,

		[System.String[]]
		$SIDHistory,

		[System.Boolean]
		$Temporal,

		[System.String]
		$Type,

		[System.Management.Automation.PSCredential]
		$Credential,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    Test-MimSvcTargetResource -ObjectType Group -KeyAttributeName DisplayName -DscBoundParameters $PSBoundParameters
}

Export-ModuleMember -Function *-TargetResource