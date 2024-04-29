Set-Location c:\MimDsc

#region Call the Set and Test methods directly - allows for setting a breakpoint for debuggering
Search-Resources -XPath "/HomepageConfiguration" -ExpectedObjectType HomepageConfiguration -MaxResults 2

ipmo MimDsc -Force
ipmo 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcHomepageConfiguration\MimSvcHomepageConfiguration.psm1' -Force
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcHomepageConfiguration\MimSvcHomepageConfiguration.psm1'

$randomNumber = Get-Random -Minimum 100 -Maximum 999
$testResourceProperties = @{
    DisplayName                 = "TestHomepageConfiguration$randomNumber"
    IsConfigurationType         = $true
    NavigationUrl               = 'javascript:PopupPage("/IdentityManagement/aspx/groups/CreateSecurityGroup.aspx");'
    Order                       = 1
    ParentOrder                 = 2
    Region                      = 1
    Ensure						= 'Present'
}

Test-MimSvcTargetResource -ObjectType HomepageConfiguration -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

Set-MimSvcTargetResource -ObjectType HomepageConfiguration -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

#endregion


#region: Test for an existing HomepageConfiguration
Configuration TestHomepageConfiguration 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        HomepageConfiguration 'Create a new SG'
        {
            DisplayName                 = 'Create a new SG'
            IsConfigurationType         = $true
            NavigationUrl               = 'javascript:PopupPage("/IdentityManagement/aspx/groups/CreateSecurityGroup.aspx");'
            Order                       = 1
            ParentOrder                 = 2
            Region                      = 1
            Ensure						= 'Present'
        }
    } 
} 

TestHomepageConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestHomepageConfiguration" -Force
#endregion

#region: New HomepageConfiguration
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestHomepageConfiguration 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        HomepageConfiguration "TestHomepageConfiguration$randomNumber"
        {
            DisplayName                 = "TestHomepageConfiguration$randomNumber"
            IsConfigurationType         = $true
            NavigationUrl               = 'javascript:PopupPage("/IdentityManagement/aspx/groups/CreateSecurityGroup.aspx");'
            Order                       = '1'
            ParentOrder                 = '2'
            Region                      = '1'
            Ensure						= 'Present'
        }
    } 
} 

TestHomepageConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestHomepageConfiguration" -Force
#endregion

#region: Update a HomepageConfiguration
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestHomepageConfiguration 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        HomepageConfiguration "TestHomepageConfiguration$randomNumber"
        {
            DisplayName                 = "TestHomepageConfiguration$randomNumber"
            IsConfigurationType         = $true
            NavigationUrl               = 'javascript:PopupPage("/IdentityManagement/aspx/groups/CreateSecurityGroup.aspx");'
            Order                       = '1'
            ParentOrder                 = '2'
            Region                      = '1'
            Ensure						= 'Present'
        }
    } 
} 

TestHomepageConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestHomepageConfiguration"

Configuration TestHomepageConfiguration 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        HomepageConfiguration "TestHomepageConfiguration$randomNumber"
        {
            DisplayName                 = "TestHomepageConfiguration$randomNumber"
            IsConfigurationType         = $true
            NavigationUrl               = 'javascript:PopupPage("/IdentityManagement/aspx/groups/CreateSecurityGroup.aspx");'
            Order                       = '100'
            ParentOrder                 = '200'
            Region                      = '2'
            Ensure						= 'Present'
        }
    } 
} 

TestHomepageConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestHomepageConfiguration" -Force
#endregion

#region: Remove a HomepageConfiguration
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestHomepageConfiguration 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        HomepageConfiguration "TestHomepageConfiguration$randomNumber"
        {
            DisplayName                 = "TestHomepageConfiguration$randomNumber"
            IsConfigurationType         = $true
            NavigationUrl               = 'javascript:PopupPage("/IdentityManagement/aspx/groups/CreateSecurityGroup.aspx");'
            Order                       = '1'
            ParentOrder                 = '2'
            Region                      = '1'
            Ensure						= 'Present'
        }
    } 
} 

TestHomepageConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestHomepageConfiguration" -Force

Configuration TestHomepageConfiguration 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        HomepageConfiguration "TestHomepageConfiguration$randomNumber"
        {
            DisplayName                 = "TestHomepageConfiguration$randomNumber"
            IsConfigurationType         = $true
            NavigationUrl               = 'javascript:PopupPage("/IdentityManagement/aspx/groups/CreateSecurityGroup.aspx");'
            Order                       = '1'
            ParentOrder                 = '2'
            Region                      = '1'
            Ensure						= 'Absent'
        }
    } 
} 

TestHomepageConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestHomepageConfiguration" -Force
#endregion