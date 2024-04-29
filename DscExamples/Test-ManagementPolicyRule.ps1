Set-Location c:\MimDsc

#region Call the Set and Test methods directly - allows for setting a breakpoint for debuggering
Search-Resources -XPath "/ManagementPolicyRule" -ExpectedObjectType ManagementPolicyRule -MaxResults 2

ipmo MimDsc -Force
ipmo 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcManagementPolicyRule\MimSvcManagementPolicyRule.psm1' -Force
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcManagementPolicyRule\MimSvcManagementPolicyRule.psm1'

$randomNumber = Get-Random -Minimum 100 -Maximum 999
$testResourceProperties = @{
    ActionParameter				= '*' 
    ActionType					= 'TransitionOut'
    ActionWorkflowDefinition	= 'Group Expiration Notification Workflow' 
    Description					= 'initial description'
    Disabled					= $false
    DisplayName					= $displayName
    GrantRight					= $false
    ResourceCurrentSet			= 'Administrators'
    ManagementPolicyRuleType	= 'SetTransition'
    Ensure						= 'Present'
}

Test-MimSvcTargetResource -ObjectType ManagementPolicyRule -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

Set-MimSvcTargetResource -ObjectType ManagementPolicyRule -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

#endregion


#region: New Transition-In MPR with no Action Workflows
$displayName = "Mpr$(Get-Random -Minimum 100 -Maximum 999)"
Configuration TestMpr 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ManagementPolicyRule $displayName
        {
            ActionParameter				= '*' 
            ActionType					= 'TransitionIn'
            Description					= 'initial description'
            Disabled					= $false
            DisplayName					= $displayName
            GrantRight					= $false
            ResourceFinalSet			= 'Administrators'
            ManagementPolicyRuleType	= 'SetTransition'
            Ensure						= 'Present'
        }
    } 
} 

TestMpr

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestMpr" -Force
#endregion

#region: New Transition-In MPR with one Action Workflow
$displayName = "Mpr$(Get-Random -Minimum 100 -Maximum 999)"
Configuration TestMpr 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ManagementPolicyRule $displayName
        {
            ActionParameter				= '*' 
            ActionType					= 'TransitionIn'
            ActionWorkflowDefinition	= 'Group Expiration Notification Workflow' 
            Description					= 'initial description'
            Disabled					= $false
            DisplayName					= $displayName
            GrantRight					= $false
            ResourceFinalSet			= 'Administrators'
            ManagementPolicyRuleType	= 'SetTransition'
            Ensure						= 'Present'
        }
    } 
} 

TestMpr

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestMpr" -Force
#endregion

#region: New Transition-Out MPR with one Action Workflow
$displayName = "Mpr$(Get-Random -Minimum 100 -Maximum 999)"
Configuration TestMpr 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ManagementPolicyRule $displayName
        {
            ActionParameter				= '*' 
            ActionType					= 'TransitionOut'
            ActionWorkflowDefinition	= 'Group Expiration Notification Workflow' 
            Description					= 'initial description'
            Disabled					= $false
            DisplayName					= $displayName
            GrantRight					= $false
            ResourceCurrentSet			= 'Administrators'
            ManagementPolicyRuleType	= 'SetTransition'
            Ensure						= 'Present'
        }
    } 
} 

TestMpr

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestMpr" -Force
#endregion

#region: New Transition MPR with multiple Action Workflows
$displayName = "Mpr$(Get-Random -Minimum 100 -Maximum 999)"
Configuration TestMpr 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ManagementPolicyRule $displayName
        {
            ActionParameter				= '*' 
            ActionType					= 'TransitionOut'
            ActionWorkflowDefinition	= 'Group Expiration Notification Workflow', 'Expiration Workflow' 
            Description					= 'initial description'
            Disabled					= $false
            DisplayName					= $displayName
            GrantRight					= $false
            ResourceCurrentSet			= 'Administrators'
            ManagementPolicyRuleType	= 'SetTransition'
            Ensure						= 'Present'
        }
    } 
} 

TestMpr

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestMpr" -Force
#endregion

#region: Update Transition MPR - Disabled
$displayName = "Mpr$(Get-Random -Minimum 100 -Maximum 999)"
Configuration TestMpr 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ManagementPolicyRule $displayName
        {
            ActionParameter				= '*' 
            ActionType					= 'TransitionOut'
            ActionWorkflowDefinition	= 'Group Expiration Notification Workflow', 'Expiration Workflow' 
            Description					= 'initial description'
            Disabled					= $false
            DisplayName					= $displayName
            GrantRight					= $false
            ResourceCurrentSet			= 'Administrators'
            ManagementPolicyRuleType	= 'SetTransition'
            Ensure						= 'Present'
        }
    } 
} 

TestMpr

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestMpr" -Force

Configuration TestMpr 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ManagementPolicyRule $displayName
        {
            ActionParameter				= '*' 
            ActionType					= 'TransitionOut'
            ActionWorkflowDefinition	= 'Group Expiration Notification Workflow', 'Expiration Workflow' 
            Description					= 'initial description'
            Disabled					= $true
            DisplayName					= $displayName
            GrantRight					= $false
            ResourceCurrentSet			= 'Administrators'
            ManagementPolicyRuleType	= 'SetTransition'
            Ensure						= 'Present'
        }
    } 
} 

TestMpr
Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestMpr" -Force
#endregion

#region: Update Transition MPR - Description
$displayName = "Mpr$(Get-Random -Minimum 100 -Maximum 999)"
Configuration TestMpr 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ManagementPolicyRule $displayName
        {
            ActionParameter				= '*' 
            ActionType					= 'TransitionOut'
            ActionWorkflowDefinition	= 'Group Expiration Notification Workflow', 'Expiration Workflow' 
            Description					= 'initial description'
            Disabled					= $false
            DisplayName					= $displayName
            GrantRight					= $false
            ResourceCurrentSet			= 'Administrators'
            ManagementPolicyRuleType	= 'SetTransition'
            Ensure						= 'Present'
        }
    } 
} 

TestMpr
Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestMpr" -Force

Configuration TestMpr 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ManagementPolicyRule $displayName
        {
            ActionParameter				= '*' 
            ActionType					= 'TransitionOut'
            ActionWorkflowDefinition	= 'Group Expiration Notification Workflow', 'Expiration Workflow' 
            Description					= 'some other description'
            Disabled					= $false
            DisplayName					= $displayName
            GrantRight					= $false
            ResourceCurrentSet			= 'Administrators'
            ManagementPolicyRuleType	= 'SetTransition'
            Ensure						= 'Present'
        }
    } 
} 

TestMpr
Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestMpr" -Force
#endregion

#region: Update Transition MPR - ResourceCurrentSet
$displayName = "Mpr$(Get-Random -Minimum 100 -Maximum 999)"
Configuration TestMpr 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ManagementPolicyRule $displayName
        {
            ActionParameter				= '*' 
            ActionType					= 'TransitionOut'
            ActionWorkflowDefinition	= 'Group Expiration Notification Workflow', 'Expiration Workflow' 
            Description					= 'initial description'
            Disabled					= $false
            DisplayName					= $displayName
            GrantRight					= $false
            ResourceCurrentSet			= 'Administrators'
            ManagementPolicyRuleType	= 'SetTransition'
            Ensure						= 'Present'
        }
    } 
} 

TestMpr
Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestMpr" -Force

Configuration TestMpr 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ManagementPolicyRule $displayName
        {
            ActionParameter				= '*' 
            ActionType					= 'TransitionOut'
            ActionWorkflowDefinition	= 'Group Expiration Notification Workflow', 'Expiration Workflow' 
            Description					= 'initial description'
            Disabled					= $false
            DisplayName					= $displayName
            GrantRight					= $false
            ResourceCurrentSet			= 'All People'
            ManagementPolicyRuleType	= 'SetTransition'
            Ensure						= 'Present'
        }
    } 
} 

TestMpr
Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestMpr" -Force
#endregion

#region: New Request MPR with no WFs
$displayName = "Mpr$(Get-Random -Minimum 100 -Maximum 999)"
Configuration TestMpr 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ManagementPolicyRule $displayName
        {
            ActionParameter				= '*' 
            ActionType					= 'Modify'          
            Description					= 'initial description'
            Disabled					= $false
            DisplayName					= $displayName
            GrantRight					= $true
            PrincipalSet			    = 'Administrators'
            ResourceCurrentSet			= 'Administrators'
			ResourceFinalSet			= 'Administrators'
            ManagementPolicyRuleType	= 'Request'
            Ensure						= "Present"
        }
    } 
} 

TestMpr
Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestMpr" -Force
#endregion

#region: New Request MPR with WFs
$displayName = "Mpr$(Get-Random -Minimum 100 -Maximum 999)"
Configuration TestMpr 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ManagementPolicyRule $displayName
        {
            ActionParameter						= '*' 
            ActionType							= 'Modify'          
            Description							= 'initial description'
            Disabled							= $false
            DisplayName							= $displayName
            GrantRight							= $true
            PrincipalSet			    		= 'Administrators'
            ResourceCurrentSet					= 'Administrators'
			ResourceFinalSet					= 'Administrators'
            ManagementPolicyRuleType			= 'Request'
            AuthenticationWorkflowDefinition 	= 'Password Reset AuthN Workflow'
			AuthorizationWorkflowDefinition 	= 'Owner Approval Workflow'
			ActionWorkflowDefinition 			= 'Password Reset Action Workflow'
            Ensure								= "Present"
        }
    } 
} 

TestMpr
Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestMpr" -Force
#endregion

#region: New Request MPR with Multiple Actions
$displayName = "Mpr$(Get-Random -Minimum 100 -Maximum 999)"
Configuration TestMpr 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ManagementPolicyRule $displayName
        {
            ActionParameter						= '*' 
            ActionType							= 'Create','Delete','Add','Modify','Remove','Read'
            Description							= 'initial description'
            Disabled							= $false
            DisplayName							= $displayName
            GrantRight							= $true
            PrincipalRelativeToResource    		= 'Manager'
            ResourceCurrentSet					= 'Administrators'
			ResourceFinalSet					= 'Administrators'
            ManagementPolicyRuleType			= 'Request'
            Ensure								= "Present"
        }
    } 
} 

TestMpr
Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestMpr" -Force
#endregion

#region: New Request MPR with no WFs
$displayName = "Mpr$(Get-Random -Minimum 100 -Maximum 999)"
Configuration TestMpr 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ManagementPolicyRule $displayName
        {
            ActionParameter				= '*' 
            ActionType					= 'Modify'          
            Description					= 'initial description'
            Disabled					= $false
            DisplayName					= $displayName
            GrantRight					= $true
            PrincipalSet			    = 'Administrators'
            ResourceCurrentSet			= 'Administrators'
			ResourceFinalSet			= 'Administrators'
            ManagementPolicyRuleType	= 'Request'
            Ensure						= "Present"
        }
    } 
} 

TestMpr
Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestMpr" -Force
#endregion

#region: Update Request MPR with Multiple Actions
$displayName = "Mpr$(Get-Random -Minimum 100 -Maximum 999)"
Configuration TestMpr 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ManagementPolicyRule $displayName
        {
            ActionParameter						= '*' 
            ActionType							= 'Create','Delete','Add'
            Description							= 'initial description'
            Disabled							= $false
            DisplayName							= $displayName
            GrantRight							= $true
            PrincipalRelativeToResource    		= 'Manager'
            ResourceCurrentSet					= 'Administrators'
			ResourceFinalSet					= 'Administrators'
            ManagementPolicyRuleType			= 'Request'
            Ensure								= "Present"
        }
    } 
} 

TestMpr
Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestMpr" -Force

Configuration TestMpr 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ManagementPolicyRule $displayName
        {
            ActionParameter						= '*' 
            ActionType							= 'Create','Modify','Remove','Read'
            Description							= 'initial description'
            Disabled							= $false
            DisplayName							= $displayName
            GrantRight							= $true
            PrincipalRelativeToResource    		= 'Manager'
            ResourceCurrentSet					= 'Administrators'
			ResourceFinalSet					= 'Administrators'
            ManagementPolicyRuleType			= 'Request'
            Ensure								= "Present"
        }
    } 
} 

TestMpr
Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestMpr" -Force
#endregion

#region: Update Request MPR with Multiple ActionParameters
$displayName = "Mpr$(Get-Random -Minimum 100 -Maximum 999)"
Configuration TestMpr 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ManagementPolicyRule $displayName
        {
            ActionParameter						= 'Description','Country','FreezeLevel' 
            ActionType							= 'Create','Delete','Add'
            Description							= 'initial description'
            Disabled							= $false
            DisplayName							= $displayName
            GrantRight							= $true
            PrincipalRelativeToResource    		= 'Manager'
            ResourceCurrentSet					= 'Administrators'
			ResourceFinalSet					= 'Administrators'
            ManagementPolicyRuleType			= 'Request'
            Ensure								= "Present"
        }
    } 
} 

TestMpr
Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestMpr" -Force

Configuration TestMpr 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ManagementPolicyRule $displayName
        {
            ActionParameter						= 'Description','Domain','FreezeLevel','MiddleName' 
            ActionType							= 'Create','Delete','Add'
            Description							= 'initial description'
            Disabled							= $false
            DisplayName							= $displayName
            GrantRight							= $true
            PrincipalRelativeToResource    		= 'Manager'
            ResourceCurrentSet					= 'Administrators'
			ResourceFinalSet					= 'Administrators'
            ManagementPolicyRuleType			= 'Request'
            Ensure								= "Present"
        }
    } 
} 

TestMpr
Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestMpr" -Force
#endregion

#region: Update Request MPR with WFs
$displayName = "Mpr$(Get-Random -Minimum 100 -Maximum 999)"
Configuration TestMpr 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ManagementPolicyRule $displayName
        {
            ActionParameter						= '*' 
            ActionType							= 'Modify'          
            Description							= 'initial description'
            Disabled							= $false
            DisplayName							= $displayName
            GrantRight							= $true
            PrincipalSet			    		= 'Administrators'
            ResourceCurrentSet					= 'Administrators'
			ResourceFinalSet					= 'Administrators'
            ManagementPolicyRuleType			= 'Request'
            AuthenticationWorkflowDefinition 	= 'Password Reset AuthN Workflow'
			AuthorizationWorkflowDefinition 	= 'Owner Approval Workflow'
			ActionWorkflowDefinition 			= 'Password Reset Action Workflow'
            Ensure								= "Present"
        }
    } 
} 

TestMpr 
Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestMpr" -Force

Configuration TestMpr 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ManagementPolicyRule $displayName
        {
            ActionParameter						= '*' 
            ActionType							= 'Modify'          
            Description							= 'initial description'
            Disabled							= $false
            DisplayName							= $displayName
            GrantRight							= $true
            PrincipalSet			    		= 'Administrators'
            ResourceCurrentSet					= 'Administrators'
			ResourceFinalSet					= 'Administrators'
            ManagementPolicyRuleType			= 'Request'
            AuthenticationWorkflowDefinition 	= 'Password Reset AuthN Workflow','System Workflow Required for Registration'
			AuthorizationWorkflowDefinition 	= 'Owner Approval Workflow','Filter Validation Workflow for Administrators','Requestor Validation With Owner Authorization'
			ActionWorkflowDefinition 			= 'Expiration Workflow'
            Ensure								= "Present"
        }
    } 
} 

TestMpr
Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestMpr" -Force
#endregion

#region: Update Request MPR with removing WFs
$displayName = "Mpr$(Get-Random -Minimum 100 -Maximum 999)"
Configuration TestMpr 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ManagementPolicyRule $displayName
        {
            ActionParameter						= '*' 
            ActionType							= 'Modify'          
            Description							= 'initial description'
            Disabled							= $false
            DisplayName							= $displayName
            GrantRight							= $true
            PrincipalSet			    		= 'Administrators'
            ResourceCurrentSet					= 'Administrators'
			ResourceFinalSet					= 'Administrators'
            ManagementPolicyRuleType			= 'Request'
            AuthenticationWorkflowDefinition 	= 'Password Reset AuthN Workflow','System Workflow Required for Registration'
			AuthorizationWorkflowDefinition 	= 'Owner Approval Workflow','Filter Validation Workflow for Administrators','Requestor Validation With Owner Authorization'
			ActionWorkflowDefinition 			= 'Expiration Workflow'
            Ensure								= "Present"
        }
    } 
} 

TestMpr 
Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestMpr" -Force

Configuration TestMpr 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ManagementPolicyRule $displayName
        {
            ActionParameter						= '*' 
            ActionType							= 'Modify'          
            Description							= 'initial description'
            Disabled							= $false
            DisplayName							= $displayName
            GrantRight							= $true
            PrincipalSet			    		= 'Administrators'
            ResourceCurrentSet					= 'Administrators'
			ResourceFinalSet					= 'Administrators'
            ManagementPolicyRuleType			= 'Request'
            Ensure								= "Present"
        }
    } 
} 

TestMpr
Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestMpr" -Force
#endregion

#region: Delete Request MPR
$displayName = "Mpr$(Get-Random -Minimum 100 -Maximum 999)"
Configuration TestMpr 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ManagementPolicyRule $displayName
        {
            ActionParameter				= '*' 
            ActionType					= 'Modify'          
            Description					= 'initial description'
            Disabled					= $false
            DisplayName					= $displayName
            GrantRight					= $true
            PrincipalSet			    = 'Administrators'
            ResourceCurrentSet			= 'Administrators'
			ResourceFinalSet			= 'Administrators'
            ManagementPolicyRuleType	= 'Request'
            Ensure						= "Present"
        }
    } 
} 

TestMpr
Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestMpr" -Force

Configuration TestMpr 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ManagementPolicyRule $displayName
        {
            ActionParameter				= '*' 
            ActionType					= 'Modify'          
            Description					= 'initial description'
            Disabled					= $false
            DisplayName					= $displayName
            GrantRight					= $true
            PrincipalSet			    = 'Administrators'
            ResourceCurrentSet			= 'Administrators'
			ResourceFinalSet			= 'Administrators'
            ManagementPolicyRuleType	= 'Request'
            Ensure						= "Absent"
        }
    } 
} 

TestMpr
Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestMpr" -Force
#endregion