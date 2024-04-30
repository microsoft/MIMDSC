Set-Location c:\MimDsc

#region Call the Set and Test methods directly - allows for setting a breakpoint for debuggering
Search-Resources -XPath "/SearchScopeConfiguration" -ExpectedObjectType SearchScopeConfiguration -MaxResults 5

ipmo MimDsc -Force
ipmo 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcSearchScopeConfiguration\MimSvcSearchScopeConfiguration.psm1' -Force
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcSearchScopeConfiguration\MimSvcSearchScopeConfiguration.psm1'
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\Functions\Test-MimSvcTargetResource.ps1'
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\Functions\Set-MimSvcTargetResource.ps1'

$resourceProperties = @{
    DisplayName                 = 'All Mail Enabled Security Groups'
    IsConfigurationType         = $true
    Order                       = 30
    SearchScope                 = "/Group[Type='MailEnabledSecurity']"
    SearchScopeColumn           = 'DisplayName;Description;Email'
    SearchScopeContext          = 'DisplayName', 'AccountName'
    SearchScopeResultObjectType = 'Group'
    UsageKeyword                = 'customized', 'Distribution'
    Ensure						= 'Present'
}

Test-MimSvcTargetResource -ObjectType Resource -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

Set-MimSvcTargetResource -ObjectType Resource -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

#endregion

#region: Test for an existing SearchScopeConfiguration
Search-Resources -XPath  "/SearchScopeConfiguration[DisplayName='All Mail Enabled Security Groups']" -ExpectedObjectType SearchScopeConfiguration
Configuration TestSearchScopeConfiguration 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        SearchScopeConfiguration 'All Mail Enabled Security Groups'
        {
            DisplayName                 = 'All Mail Enabled Security Groups'
            IsConfigurationType         = $true
            Order                       = 30
            SearchScope                 = "/Group[Type='MailEnabledSecurity']"
            SearchScopeColumn           = 'DisplayName;Description;Email'
            SearchScopeContext          = 'DisplayName', 'AccountName'
            SearchScopeResultObjectType = 'Group'
            UsageKeyword                = 'customized', 'Distribution'
            Ensure						= 'Present'
        }
    } 
} 

TestSearchScopeConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestSearchScopeConfiguration" -Force
#endregion

#region: New SearchScopeConfiguration
$randomNumber = Get-Random -Minimum 1000 -Maximum 9999
Configuration TestSearchScopeConfiguration 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        SearchScopeConfiguration "TestSearchScopeConfiguration$randomNumber"
        {
            DisplayName                 = "TestSearchScopeConfiguration$randomNumber"
            IsConfigurationType         = $false
            Order                       = 1201
            SearchScope                 = "/Group[Type='MailEnabledSecurity']"
            SearchScopeColumn           = 'DisplayName;Description;Email'
            SearchScopeContext          = 'DisplayName', 'AccountName'
            SearchScopeResultObjectType = 'Group'
            UsageKeyword                = 'customized', 'Distribution'
            Ensure						= 'Present'
        }
    } 
} 

TestSearchScopeConfiguration

Start-DscConfiguration -Wait -Debug -Verbose -Path "C:\MimDsc\TestSearchScopeConfiguration" -Force
#endregion

#region: Update SearchScopeConfiguration
$randomNumber = Get-Random -Minimum 1000 -Maximum 9999

$searchScopeConfiguration = New-Resource -ObjectType SearchScopeConfiguration
$searchScopeConfiguration.DisplayName                 = "TestSearchScopeConfiguration$randomNumber"
$searchScopeConfiguration.IsConfigurationType         = $true
$searchScopeConfiguration.Order                       = $randomNumber
$searchScopeConfiguration.SearchScope                 = "/Group[Type='MailEnabledSecurity']"
$searchScopeConfiguration.SearchScopeColumn           = 'DisplayName;Description;Email;AccountName'
$searchScopeConfiguration.SearchScopeContext          = 'DisplayName', 'AccountName', 'Email'
$searchScopeConfiguration.SearchScopeResultObjectType = 'Group'
$searchScopeConfiguration.UsageKeyword                = 'customized', 'Distribution'
$searchScopeConfiguration | Save-Resource

Configuration TestSearchScopeConfiguration 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        SearchScopeConfiguration "TestSearchScopeConfiguration$randomNumber"
        {
            DisplayName                 = "TestSearchScopeConfiguration$randomNumber"
            IsConfigurationType         = $true
            Order                       = $randomNumber
            SearchScope                 = "/Group[Type='MailEnabledSecurity']"
            SearchScopeColumn           = 'DisplayName;Description;Email;AccountName'
            SearchScopeContext          = 'DisplayName', 'AccountName', 'Email'
            SearchScopeResultObjectType = 'Group'
            UsageKeyword                = 'customized', 'Distribution'
            Ensure						= 'Present'
        }
    } 
} 

TestSearchScopeConfiguration

Start-DscConfiguration -Wait -Verbose -Debug -Path "C:\MimDsc\TestSearchScopeConfiguration" -Force
#endregion