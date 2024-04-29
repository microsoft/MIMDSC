Set-Location c:\MimDsc


#region Call the Set and Test methods directly - allows for setting a breakpoint for debuggering
Search-Resources -XPath "/Group" -ExpectedObjectType Group -MaxResults 2

ipmo MimDsc -Force
ipmo 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcGroup\MimSvcGroup.psm1' -Force
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcGroup\MimSvcGroup.psm1'

$randomNumber = Get-Random -Minimum 100 -Maximum 999
$testResourceProperties = @{
    AccountName				= "TestGroup$randomNumber"
    DisplayName 			= "Test Group $randomNumber"
    DisplayedOwner   		= 'Administrator'
    Owner                   = 'Administrator'
    Domain 					= 'Redmond' 
    MembershipAddWorkflow 	= 'None'
    MembershipLocked 		= 'false'            
    GroupScope 				= 'Universal'
    Type					= 'Security'
    Ensure					= 'Present'
}

Test-MimSvcTargetResource -ObjectType Group -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

Set-MimSvcTargetResource -ObjectType Group -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

#endregion


#region: Test for an existing Group


$randomNumber = Get-Random -Minimum 100 -Maximum 999
$groupOwner = New-Resource -ObjectType Person
$groupOwner.AccountName = "TestGroupOwner$randomNumber"
$groupOwner | Save-Resource

$group = New-Resource -ObjectType Group
$group.AccountName		     = "TestGroup$randomNumber"
$group.DisplayedOwner  		 = $groupOwner
$group.Owner                 = $groupOwner
$group.DisplayName 			 = "Test Group $randomNumber"
$group.Domain 				 = 'Redmond' 
$group.MembershipAddWorkflow = 'None'
$group.MembershipLocked 	 = 'false'            
$group.Scope 				 = 'Universal'
$group.Type					 = 'Security'
$group | Save-Resource

Configuration TestGroup 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        Group "TestGroup$randomNumber"
        {
            AccountName				= "TestGroup$randomNumber"
            DisplayName 			= "Test Group $randomNumber"
            DisplayedOwner   		= "TestGroupOwner$randomNumber"
            Owner                   = "TestGroupOwner$randomNumber"
            Domain 					= 'Redmond' 
            MembershipAddWorkflow 	= 'None'
            MembershipLocked 		= $false            
            GroupScope 				= 'Universal'
            Type					= 'Security'
            Ensure		            = 'Present'
        }
    } 
} 

TestGroup

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestGroup" -Force
#endregion

#region: New Group with Membership
$randomNumber = Get-Random -Minimum 100 -Maximum 999

$groupOwner = New-Resource -ObjectType Person
$groupOwner.AccountName = "TestGroupOwner$randomNumber"
$groupOwner | Save-Resource

$groupMember = New-Resource -ObjectType Person
$groupMember.AccountName = "TestGroupMember$randomNumber"
$groupMember | Save-Resource
Configuration TestGroup 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        Group "TestGroup$randomNumber"
        {
            AccountName				= "TestGroup$randomNumber"
            DisplayName 			= "Test Group $randomNumber"
            DisplayedOwner   		= "TestGroupOwner$randomNumber"
            Owner                   = "TestGroupOwner$randomNumber"
            Domain 					= 'Redmond' 
            ExplicitMember          = "TestGroupMember$randomNumber"
            MembershipAddWorkflow 	= 'None'
            MembershipLocked 		= $false            
            GroupScope 				= 'Universal'
            Type					= 'Security'
            Ensure		            = 'Present'
        }
    } 
} 

TestGroup

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestGroup" -Force
#endregion
