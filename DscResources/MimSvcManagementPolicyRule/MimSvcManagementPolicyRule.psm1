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
		ActionParameter = [System.String[]]
		ActionType = [System.String[]]
		ActionWorkflowDefinition = [System.String[]]
		AuthenticationWorkflowDefinition = [System.String[]]
		AuthorizationWorkflowDefinition = [System.String[]]
		CreatedTime = [System.DateTime]
		Creator = [System.String]
		DeletedTime = [System.DateTime]
		Description = [System.String]
		DetectedRulesList = [System.String[]]
		Disabled = [System.Boolean]
		DisplayName = [System.String]
		ExpectedRulesList = [System.String[]]
		ExpirationTime = [System.DateTime]
		GrantRight = [System.Boolean]
		Locale = [System.String]
		ManagementPolicyRuleType = [System.String]
		MVObjectID = [System.String]
		PrincipalSet = [System.String]
		PrincipalRelativeToResource = [System.String]
		ResourceCurrentSet = [System.String]
		ResourceFinalSet = [System.String]
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
		$ActionParameter,

		[System.String[]]
		$ActionType,

		[System.String[]]
		$ActionWorkflowDefinition,

		[System.String[]]
		$AuthenticationWorkflowDefinition,

		[System.String[]]
		$AuthorizationWorkflowDefinition,

		[System.String]
		$Description,

		[System.String[]]
		$DetectedRulesList,

		[System.Boolean]
		$Disabled,

		[parameter(Mandatory = $true)]
		[System.String]
		$DisplayName,

		[System.String[]]
		$ExpectedRulesList,

		[System.DateTime]
		$ExpirationTime,

		[System.Boolean]
		$GrantRight,

		[System.String]
		$Locale,

		[System.String]
		$ManagementPolicyRuleType,

		[System.String]
		$MVObjectID,

		[System.String]
		$PrincipalSet,

		[System.String]
		$PrincipalRelativeToResource,

		[System.String]
		$ResourceCurrentSet,

		[System.String]
		$ResourceFinalSet,

		[System.Management.Automation.PSCredential]
		$Credential,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    Set-MimSvcTargetResource -ObjectType ManagementPolicyRule -KeyAttributeName DisplayName -DscBoundParameters $PSBoundParameters
}

function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[System.String[]]
		$ActionParameter,

		[System.String[]]
		$ActionType,

		[System.String[]]
		$ActionWorkflowDefinition,

		[System.String[]]
		$AuthenticationWorkflowDefinition,

		[System.String[]]
		$AuthorizationWorkflowDefinition,

		[System.String]
		$Description,

		[System.String[]]
		$DetectedRulesList,

		[System.Boolean]
		$Disabled,

		[parameter(Mandatory = $true)]
		[System.String]
		$DisplayName,

		[System.String[]]
		$ExpectedRulesList,

		[System.DateTime]
		$ExpirationTime,

		[System.Boolean]
		$GrantRight,

		[System.String]
		$Locale,

		[System.String]
		$ManagementPolicyRuleType,

		[System.String]
		$MVObjectID,

		[System.String]
		$PrincipalSet,

		[System.String]
		$PrincipalRelativeToResource,

		[System.String]
		$ResourceCurrentSet,

		[System.String]
		$ResourceFinalSet,

		[System.Management.Automation.PSCredential]
		$Credential,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    if ($DebugPreference -eq 'Inquire')
    {
        $PSBoundParameters | Export-Clixml C:\temp\psboundparameters.clixml
    }

    Test-MimSvcTargetResource -ObjectType ManagementPolicyRule -KeyAttributeName DisplayName -DscBoundParameters $PSBoundParameters
}

Export-ModuleMember -Function *-TargetResource