
Set-Location c:\MimDsc

#region Call the Set and Test methods directly - allows for setting a breakpoint for debuggering
Search-Resources -XPath "/ObjectTypeDescription" -ExpectedObjectType ObjectTypeDescription -MaxResults 2

ipmo MimDsc -Force
ipmo 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcObjectTypeDescription\MimSvcObjectTypeDescription.psm1' -Force
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcObjectTypeDescription\MimSvcObjectTypeDescription.psm1'

$testResourceProperties = @{
    Description					= 'initial description'
    DisplayName					= 'Management Policy Rule'
    Name             			= $displayName
    UsageKeyword            	= 'Microsoft.ResourceManagement.WebServices'
    Ensure						= 'Present'
}

Test-MimSvcTargetResource -ObjectType ObjectTypeDescription -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

Set-MimSvcTargetResource -ObjectType ObjectTypeDescription -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

#endregion

#region: Test for an existing object type
$displayName = "ManagementPolicyRule"
Configuration TestObjectType 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ObjectTypeDescription $displayName
        {
            Description					= 'initial description'
            DisplayName					= 'Management Policy Rule'
            Name             			= $displayName
            UsageKeyword            	= 'Microsoft.ResourceManagement.WebServices'
            Ensure						= 'Present'
        }
    } 
} 

TestObjectType

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestObjectType" -Force
#endregion

#region: New Object Type
$displayName = "ObjectType$(Get-Random -Minimum 100 -Maximum 999)"
Configuration TestObjectType 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ObjectTypeDescription $displayName
        {
            Description					= 'initial description'
            DisplayName					= $displayName
            Name             			= $displayName
            #UsageKeyword            	= 'UsageKeywordOne'
            Ensure						= 'Present'
        }
    } 
} 

TestObjectType

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestObjectType" -Force
#endregion

#region: Update Object Type: Description
$displayName = "ObjectType$(Get-Random -Minimum 100 -Maximum 999)"
Configuration TestObjectType 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ObjectTypeDescription $displayName
        {
            Description					= 'initial description'
            DisplayName					= $displayName
            Name             			= $displayName
            #UsageKeyword            	= 'UsageKeywordOne'
            Ensure						= 'Present'
        }
    } 
} 

TestObjectType

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestObjectType" -Force

Configuration TestObjectType 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ObjectTypeDescription $displayName
        {
            Description					= 'awesome new description'
            DisplayName					= $displayName
            Name             			= $displayName
            #UsageKeyword            	= 'UsageKeywordOne'
            Ensure						= 'Present'
        }
    } 
} 

TestObjectType

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestObjectType" -Force
#endregion