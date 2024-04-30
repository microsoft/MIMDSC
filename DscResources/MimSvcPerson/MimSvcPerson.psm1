function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$AccountName
	)

	#Write-Verbose "Use this cmdlet to deliver information about command processing."

	#Write-Debug "Use this cmdlet to write debug information while troubleshooting."


	<#
	$returnValue = @{
		AccountName = [System.String]
		AD_UserCannotChangePassword = [System.Boolean]
		Address = [System.String]
		Assistant = [System.String]
		Attribute114 = [System.String]
		Attribute339 = [System.String]
		Attribute743 = [System.String]
		AuthNWFLockedOut = [System.String[]]
		AuthNWFRegistered = [System.String[]]
		City = [System.String]
		Company = [System.String]
		CostCenter = [System.String]
		CostCenterName = [System.String]
		Country = [System.String]
		CreatedTime = [System.DateTime]
		Creator = [System.String]
		DeletedTime = [System.DateTime]
		Department = [System.String]
		Description = [System.String]
		DetectedRulesList = [System.String[]]
		DisplayName = [System.String]
		Domain = [System.String]
		DomainConfiguration = [System.String]
		Email = [System.String]
		MailNickname = [System.String]
		EmployeeEndDate = [System.DateTime]
		EmployeeID = [System.String]
		EmployeeStartDate = [System.DateTime]
		EmployeeType = [System.String]
		ExpectedRulesList = [System.String[]]
		ExpirationTime = [System.DateTime]
		OfficeFax = [System.String]
		FirstName = [System.String]
		FreezeCount = [System.UInt64]
		FreezeLevel = [System.String]
		JobTitle = [System.String]
		LastName = [System.String]
		LastResetAttemptTime = [System.DateTime]
		Locale = [System.String]
		AuthNLockoutRegistrationID = [System.String[]]
		LoginName = [System.String]
		Manager = [System.String]
		MiddleName = [System.String]
		MobilePhone = [System.String]
		MVObjectID = [System.String]
		OfficeLocation = [System.String]
		OfficePhone = [System.String]
		msidmOneTimePasswordEmailAddress = [System.String]
		msidmOneTimePasswordMobilePhone = [System.String]
		Photo = [System.String]
		PostalCode = [System.String]
		ProxyAddressCollection = [System.String[]]
		IsRASEnabled = [System.Boolean]
		Register = [System.Boolean]
		RegistrationRequired = [System.Boolean]
		ResetPassword = [System.String]
		ObjectID = [System.String]
		ObjectSID = [System.String]
		ResourceTime = [System.DateTime]
		ObjectType = [System.String]
		SIDHistory = [System.String[]]
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
        [parameter(Mandatory = $true)]
		[System.String]
		$AccountName,

		[System.Boolean]
		$AD_UserCannotChangePassword,

		[System.String]
		$Address,

		[System.String]
		$Assistant,

		[System.String]
		$Attribute114,

		[System.String]
		$Attribute339,

		[System.String]
		$Attribute743,

		[System.String[]]
		$AuthNWFLockedOut,

		[System.String[]]
		$AuthNWFRegistered,

		[System.String]
		$City,

		[System.String]
		$Company,

		[System.String]
		$CostCenter,

		[System.String]
		$CostCenterName,

		[System.String]
		$Country,

		[System.String]
		$Department,

		[System.String]
		$Description,

		[System.String[]]
		$DetectedRulesList,
		
		[System.String]
		$DisplayName,

		[System.String]
		$Domain,

		[System.String]
		$DomainConfiguration,

		[System.String]
		$Email,

		[System.String]
		$MailNickname,

		[System.DateTime]
		$EmployeeEndDate,

		[System.String]
		$EmployeeID,

		[System.DateTime]
		$EmployeeStartDate,

		[System.String]
		$EmployeeType,

		[System.String[]]
		$ExpectedRulesList,

		[System.DateTime]
		$ExpirationTime,

		[System.String]
		$OfficeFax,

		[System.String]
		$FirstName,

		[System.UInt64]
		$FreezeCount,

		[System.String]
		$FreezeLevel,

		[System.String]
		$JobTitle,

		[System.String]
		$LastName,

		[System.DateTime]
		$LastResetAttemptTime,

		[System.String]
		$Locale,

		[System.String[]]
		$AuthNLockoutRegistrationID,

		[System.String]
		$LoginName,

		[System.String]
		$Manager,

		[System.String]
		$MiddleName,

		[System.String]
		$MobilePhone,

		[System.String]
		$MVObjectID,

		[System.String]
		$OfficeLocation,

		[System.String]
		$OfficePhone,

		[System.String]
		$msidmOneTimePasswordEmailAddress,

		[System.String]
		$msidmOneTimePasswordMobilePhone,

		[System.String]
		$Photo,

		[System.String]
		$PostalCode,

		[System.String[]]
		$ProxyAddressCollection,

		[System.Boolean]
		$IsRASEnabled,

		[System.Boolean]
		$Register,

		[System.Boolean]
		$RegistrationRequired,

		[System.String]
		$ResetPassword,

		[System.String]
		$ObjectSID,

		[System.String[]]
		$SIDHistory,

		[System.String]
		$TimeZone,

		[System.Management.Automation.PSCredential]
		$Credential,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    Set-MimSvcTargetResource -ObjectType Person -KeyAttributeName AccountName -DscBoundParameters $PSBoundParameters
}

function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
        [parameter(Mandatory = $true)]
		[System.String]
		$AccountName,

		[System.Boolean]
		$AD_UserCannotChangePassword,

		[System.String]
		$Address,

		[System.String]
		$Assistant,

		[System.String]
		$Attribute114,

		[System.String]
		$Attribute339,

		[System.String]
		$Attribute743,

		[System.String[]]
		$AuthNWFLockedOut,

		[System.String[]]
		$AuthNWFRegistered,

		[System.String]
		$City,

		[System.String]
		$Company,

		[System.String]
		$CostCenter,

		[System.String]
		$CostCenterName,

		[System.String]
		$Country,

		[System.String]
		$Department,

		[System.String]
		$Description,

		[System.String[]]
		$DetectedRulesList,

		[System.String]
		$DisplayName,

		[System.String]
		$Domain,

		[System.String]
		$DomainConfiguration,

		[System.String]
		$Email,

		[System.String]
		$MailNickname,

		[System.DateTime]
		$EmployeeEndDate,

		[System.String]
		$EmployeeID,

		[System.DateTime]
		$EmployeeStartDate,

		[System.String]
		$EmployeeType,

		[System.String[]]
		$ExpectedRulesList,

		[System.DateTime]
		$ExpirationTime,

		[System.String]
		$OfficeFax,

		[System.String]
		$FirstName,

		[System.UInt64]
		$FreezeCount,

		[System.String]
		$FreezeLevel,

		[System.String]
		$JobTitle,

		[System.String]
		$LastName,

		[System.DateTime]
		$LastResetAttemptTime,

		[System.String]
		$Locale,

		[System.String[]]
		$AuthNLockoutRegistrationID,

		[System.String]
		$LoginName,

		[System.String]
		$Manager,

		[System.String]
		$MiddleName,

		[System.String]
		$MobilePhone,

		[System.String]
		$MVObjectID,

		[System.String]
		$OfficeLocation,

		[System.String]
		$OfficePhone,

		[System.String]
		$msidmOneTimePasswordEmailAddress,

		[System.String]
		$msidmOneTimePasswordMobilePhone,

		[System.String]
		$Photo,

		[System.String]
		$PostalCode,

		[System.String[]]
		$ProxyAddressCollection,

		[System.Boolean]
		$IsRASEnabled,

		[System.Boolean]
		$Register,

		[System.Boolean]
		$RegistrationRequired,

		[System.String]
		$ResetPassword,

		[System.String]
		$ObjectSID,

		[System.String[]]
		$SIDHistory,

		[System.String]
		$TimeZone,

		[System.Management.Automation.PSCredential]
		$Credential,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    Test-MimSvcTargetResource -ObjectType Person -KeyAttributeName AccountName -DscBoundParameters $PSBoundParameters
}

Export-ModuleMember -Function *-TargetResource