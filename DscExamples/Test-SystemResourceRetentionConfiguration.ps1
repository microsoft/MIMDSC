Set-Location c:\MimDsc

#region Call the Set and Test methods directly - allows for setting a breakpoint for debuggering
Search-Resources -XPath "/SystemResourceRetentionConfiguration" -ExpectedObjectType SystemResourceRetentionConfiguration -MaxResults 5

ipmo MimDsc -Force
ipmo 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcSystemResourceRetentionConfiguration\MimSvcSystemResourceRetentionConfiguration.psm1' -Force
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcSystemResourceRetentionConfiguration\MimSvcSystemResourceRetentionConfiguration.psm1'
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\Functions\Test-MimSvcTargetResource.ps1'
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\Functions\Set-MimSvcTargetResource.ps1'

$resourceProperties = @{
    Description                 = 'This resource configures the number of days Requests and Workflow Instances are to be retained before being available only through historical query.'
    DisplayName                 = 'Request and workflow instance retention period configuration'
    RetentionPeriod             = 30
    Ensure						= 'Present'
}

Test-MimSvcTargetResource -ObjectType SystemResourceRetentionConfiguration -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

Set-MimSvcTargetResource -ObjectType SystemResourceRetentionConfiguration -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true


Search-Resources -XPath "/ManagementPolicyRule" -ExpectedObjectType ManagementPolicyRule -MaxResults 10
Search-Resources -XPath "/Set" -ExpectedObjectType Set | Where Filter -like '*SystemResourceRetentionConfiguration*'
$mpr = New-Resource -ObjectType ManagementPolicyRule 
$mpr.ActionParameter          = '*'
$mpr.ActionType               = 'Create','Modify','Delete'
$mpr.DisplayName              = 'Administration: Administrators can control SystemResourceRetentionConfiguration resources'
$mpr.Disabled                 = $false
$mpr.GrantRight               = $true
$mpr.ManagementPolicyRuleType = 'Request'
$mpr.PrincipalSet             = (Get-Resource Set DisplayName 'Administrators')
$mpr.ResourceCurrentSet       = (Get-Resource Set DisplayName 'All System Resource Retention Configurations')
$mpr.ResourceFinalSet         = (Get-Resource Set DisplayName 'All System Resource Retention Configurations')
$mpr | Save-Resource
#endregion

#region: Test for an existing SystemResourceRetentionConfiguration
Configuration TestSystemResourceRetentionConfiguration 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        SystemResourceRetentionConfiguration 'Request and workflow instance retention period configuration'
        {
            Description                 = 'This resource configures the number of days Requests and Workflow Instances are to be retained before being available only through historical query.'
            DisplayName                 = 'Request and workflow instance retention period configuration'
            RetentionPeriod             = 30
            Ensure						= 'Present'
        }
    } 
} 

TestSystemResourceRetentionConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestSystemResourceRetentionConfiguration" -Force
#endregion

#region: New SystemResourceRetentionConfiguration
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestSystemResourceRetentionConfiguration 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        SystemResourceRetentionConfiguration "TestSystemResourceRetentionConfiguration$randomNumber"
        {
            Description                 = 'This resource configures the number of days Requests and Workflow Instances are to be retained before being available only through historical query.'
            DisplayName                 = "TestSystemResourceRetentionConfiguration$randomNumber"
            RetentionPeriod             = 30
            Ensure						= 'Present'
        }
    } 
} 

TestSystemResourceRetentionConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestSystemResourceRetentionConfiguration" -Force ### Note: no default MPRs grant this permission
#endregion

#region: Update SystemResourceRetentionConfiguration
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestSystemResourceRetentionConfiguration 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        SystemResourceRetentionConfiguration "TestSystemResourceRetentionConfiguration$randomNumber"
        {
            Description                 = 'This resource configures the number of days Requests and Workflow Instances are to be retained before being available only through historical query.'
            DisplayName                 = "TestSystemResourceRetentionConfiguration$randomNumber"
            RetentionPeriod             = 30
            Ensure						= 'Present'
        }
    } 
} 

TestSystemResourceRetentionConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestSystemResourceRetentionConfiguration" -Force ### Note: no default MPRs grant this permission

Configuration TestSystemResourceRetentionConfiguration 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        SystemResourceRetentionConfiguration "TestSystemResourceRetentionConfiguration$randomNumber"
        {
            Description                 = 'This resource configures the number of days Requests and Workflow Instances are to be retained before being available only through historical query.'
            DisplayName                 = "TestSystemResourceRetentionConfiguration$randomNumber"
            RetentionPeriod             = 60
            Ensure						= 'Present'
        }
    } 
} 

TestSystemResourceRetentionConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestSystemResourceRetentionConfiguration" -Force ### Note: no default MPRs grant this permission
#endregion

#region: Remove SystemResourceRetentionConfiguration
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestSystemResourceRetentionConfiguration 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        SystemResourceRetentionConfiguration "TestSystemResourceRetentionConfiguration$randomNumber"
        {
            Description                 = 'This resource configures the number of days Requests and Workflow Instances are to be retained before being available only through historical query.'
            DisplayName                 = "TestSystemResourceRetentionConfiguration$randomNumber"
            RetentionPeriod             = 30
            Ensure						= 'Present'
        }
    } 
} 

TestSystemResourceRetentionConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestSystemResourceRetentionConfiguration" -Force ### Note: no default MPRs grant this permission

Configuration TestSystemResourceRetentionConfiguration 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        SystemResourceRetentionConfiguration "TestSystemResourceRetentionConfiguration$randomNumber"
        {
            Description                 = 'This resource configures the number of days Requests and Workflow Instances are to be retained before being available only through historical query.'
            DisplayName                 = "TestSystemResourceRetentionConfiguration$randomNumber"
            RetentionPeriod             = 60
            Ensure						= 'Absent'
        }
    } 
} 

TestSystemResourceRetentionConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestSystemResourceRetentionConfiguration" -Force ### Note: no default MPRs grant this permission
#endregion
