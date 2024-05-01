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
		CreateConnectedSystemObject = [System.Boolean]
		CreateILMObject = [System.Boolean]
		CreatedTime = [System.DateTime]
		Creator = [System.String]
		FlowType = [System.UInt64]
		DeletedTime = [System.DateTime]
		Dependency = [System.String]
		Description = [System.String]
		DetectedRulesList = [System.String[]]
		DisconnectConnectedSystemObject = [System.Boolean]
		DisplayName = [System.String]
		ExistenceTest = [System.String[]]
		ExpectedRulesList = [System.String[]]
		ExpirationTime = [System.DateTime]
		ConnectedSystem = [System.String]
		ConnectedObjectType = [System.String]
		ConnectedSystemScope = [System.String]
		ILMObjectType = [System.String]
		InitialFlow = [System.String[]]
		Locale = [System.String]
		ManagementAgentID = [System.String]
		MVObjectID = [System.String]
		msidmOutboundIsFilterBased = [System.Boolean]
		msidmOutboundScopingFilters = [System.String]
		PersistentFlow = [System.String[]]
		Precedence = [System.UInt64]
		RelationshipCriteria = [System.String]
		ObjectID = [System.String]
		ResourceTime = [System.DateTime]
		ObjectType = [System.String]
		SynchronizationRuleParameters = [System.String[]]
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
		$CreateConnectedSystemObject,

		[System.Boolean]
		$CreateILMObject,

		[System.UInt64]
		$FlowType,

		[System.String]
		$Dependency,

		[System.String]
		$Description,

		[System.String[]]
		$DetectedRulesList,

		[System.Boolean]
		$DisconnectConnectedSystemObject,

		[parameter(Mandatory = $true)]
		[System.String]
		$DisplayName,

		[System.String[]]
		$ExistenceTest,

		[System.String[]]
		$ExpectedRulesList,

		[System.DateTime]
		$ExpirationTime,

		[System.String]
		$ConnectedSystem,

		[System.String]
		$ConnectedObjectType,

		[System.String]
		$ConnectedSystemScope,

		[System.String]
		$ILMObjectType,

		[System.String[]]
		$InitialFlow,

		[System.String]
		$Locale,

		[System.String]
		$ManagementAgentID,

		[System.String]
		$MVObjectID,

		[System.Boolean]
		$msidmOutboundIsFilterBased,

		[System.String]
		$msidmOutboundScopingFilters,

		[System.String[]]
		$PersistentFlow,

		[System.UInt64]
		$Precedence,

		[System.String]
		$RelationshipCriteria,

		[System.String[]]
		$SynchronizationRuleParameters,

		[System.Management.Automation.PSCredential]
		$Credential,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    Set-MimSvcTargetResource -ObjectType SynchronizationRule -KeyAttributeName DisplayName -DscBoundParameters $PSBoundParameters
}

function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[System.Boolean]
		$CreateConnectedSystemObject,

		[System.Boolean]
		$CreateILMObject,

		[System.UInt64]
		$FlowType,

		[System.String]
		$Dependency,

		[System.String]
		$Description,

		[System.String[]]
		$DetectedRulesList,

		[System.Boolean]
		$DisconnectConnectedSystemObject,

		[parameter(Mandatory = $true)]
		[System.String]
		$DisplayName,

		[System.String[]]
		$ExistenceTest,

		[System.String[]]
		$ExpectedRulesList,

		[System.DateTime]
		$ExpirationTime,

		[System.String]
		$ConnectedSystem,

		[System.String]
		$ConnectedObjectType,

		[System.String]
		$ConnectedSystemScope,

		[System.String]
		$ILMObjectType,

		[System.String[]]
		$InitialFlow,

		[System.String]
		$Locale,

		[System.String]
		$ManagementAgentID,

		[System.String]
		$MVObjectID,

		[System.Boolean]
		$msidmOutboundIsFilterBased,

		[System.String]
		$msidmOutboundScopingFilters,

		[System.String[]]
		$PersistentFlow,

		[System.UInt64]
		$Precedence,

		[System.String]
		$RelationshipCriteria,

		[System.String[]]
		$SynchronizationRuleParameters,

		[System.Management.Automation.PSCredential]
		$Credential,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    Test-MimSvcTargetResource -ObjectType SynchronizationRule -KeyAttributeName DisplayName -DscBoundParameters $PSBoundParameters
}

Export-ModuleMember -Function *-TargetResource