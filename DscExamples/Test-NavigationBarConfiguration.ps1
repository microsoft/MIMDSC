
Set-Location c:\MimDsc


#region Call the Set and Test methods directly - allows for setting a breakpoint for debuggering
Search-Resources -XPath "/NavigationBarConfiguration" -ExpectedObjectType NavigationBarConfiguration -MaxResults 2

ipmo MimDsc -Force
ipmo 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcNavigationBarConfiguration\MimSvcNavigationBarConfiguration.psm1' -Force
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcNavigationBarConfiguration\MimSvcNavigationBarConfiguration.psm1'

$testResourceProperties = @{
    DisplayName                 = 'My Profile'
    IsConfigurationType         = $true
    NavigationUrl               = '~/IdentityManagement/aspx/users/EditPerson.aspx'
    Order                       = 1
    ParentOrder                 = 3
    UsageKeyword                = 'BasicUI'
    Ensure						= 'Present'
}

Test-MimSvcTargetResource -ObjectType NavigationBarConfiguration -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

Set-MimSvcTargetResource -ObjectType NavigationBarConfiguration -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

#endregion

#region: Test for an existing NavigationBarConfiguration
Configuration TestNavigationBarConfiguration 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        NavigationBarConfiguration 'My Profile'
        {
            DisplayName                 = 'My Profile'
            IsConfigurationType         = $true
            NavigationUrl               = '~/IdentityManagement/aspx/users/EditPerson.aspx'
            Order                       = 1
            ParentOrder                 = 3
            UsageKeyword                = 'BasicUI'
            Ensure						= 'Present'
        }
    } 
} 

TestNavigationBarConfiguration 

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestNavigationBarConfiguration" -Force
#endregion

#region: New NavigationBarConfiguration
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestNavigationBarConfiguration 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        NavigationBarConfiguration "TestNavigationBarConfiguration$randomNumber"
        {
            DisplayName                 = "TestNavigationBarConfiguration$randomNumber"
            IsConfigurationType         = $true
            NavigationUrl               = '~/IdentityManagement/aspx/users/EditPerson.aspx'
            Order                       = 1
            ParentOrder                 = 3
            UsageKeyword                = 'BasicUI'
            Ensure						= 'Present'
        }
    } 
} 

TestNavigationBarConfiguration -ConfigurationData $Global:AllNodes

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestNavigationBarConfiguration" -Force
#endregion

#region: Update a NavigationBarConfiguration
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestNavigationBarConfiguration 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        NavigationBarConfiguration "TestNavigationBarConfiguration$randomNumber"
        {
            DisplayName                 = "TestNavigationBarConfiguration$randomNumber"
            IsConfigurationType         = $true
            NavigationUrl               = '~/IdentityManagement/aspx/users/EditPerson.aspx'
            Order                       = 1
            ParentOrder                 = 3
            UsageKeyword                = 'BasicUI'
            Ensure						= 'Present'
        }
    } 
} 

TestNavigationBarConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestNavigationBarConfiguration" -Force

Configuration TestNavigationBarConfiguration 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        NavigationBarConfiguration "TestNavigationBarConfiguration$randomNumber"
        {
            DisplayName                 = "TestNavigationBarConfiguration$randomNumber"
            IsConfigurationType         = $true
            NavigationUrl               = '~/IdentityManaglement/aspx/users/EditPerson.aspx'
            Order                       = 100
            ParentOrder                 = 300
            UsageKeyword                = 'BasicUI'
            Ensure						= 'Present'
        }
    } 
} 

TestNavigationBarConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestNavigationBarConfiguration" -Force
#endregion

#region: Remove a NavigationBarConfiguration
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestNavigationBarConfiguration 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        NavigationBarConfiguration "TestNavigationBarConfiguration$randomNumber"
        {
            DisplayName                 = "TestNavigationBarConfiguration$randomNumber"
            IsConfigurationType         = $true
            NavigationUrl               = '~/IdentityManagement/aspx/users/EditPerson.aspx'
            Order                       = 1
            ParentOrder                 = 3
            UsageKeyword                = 'BasicUI'
            Ensure						= 'Present'
        }
    } 
} 

TestNavigationBarConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestNavigationBarConfiguration" -Force

Configuration TestNavigationBarConfiguration 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        NavigationBarConfiguration "TestNavigationBarConfiguration$randomNumber"
        {
           DisplayName                 = "TestNavigationBarConfiguration$randomNumber"
            IsConfigurationType         = $true
            NavigationUrl               = '~/IdentityManagement/aspx/users/EditPerson.aspx'
            Order                       = 1
            ParentOrder                 = 3
            UsageKeyword                = 'BasicUI'
            Ensure						= 'Absent'
        }
    } 
} 

TestNavigationBarConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestNavigationBarConfiguration" -Force
#endregion
