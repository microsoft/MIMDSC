Set-Location c:\MimDsc

#region Call the Set and Test methods directly - allows for setting a breakpoint for debuggering
Search-Resources -XPath "/PortalUIConfiguration" -ExpectedObjectType PortalUIConfiguration -MaxResults 5

ipmo MimDsc -Force
ipmo 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcPortalUIConfiguration\MimSvcPortalUIConfiguration.psm1' -Force
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcPortalUIConfiguration\MimSvcPortalUIConfiguration.psm1'
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\Functions\Test-MimSvcTargetResource.ps1'
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\Functions\Set-MimSvcTargetResource.ps1'

$resourceProperties = @{
	BrandingLeftImage    = '~/_layouts/images/MSILM2/msit-idweb1.png'
	BrandingRightImage   = '~/_layouts/images/MSILM2/banner.png'
	DisplayName          = 'Portal Configuration'
	IsConfigurationType  = $True
	ListViewCacheTimeOut = '120'
	ListViewPageSize     = '50'
	ListViewPagesToCache = '3'
	TimeZone             = 'Pacific Standard Time' #'(GMT-08:00) Pacific Time (US & Canada)'
	UICacheTime          = '86400'
	UICountCacheTime     = '600'
	UIUserCacheTime      = '14400'
	DependsOn            = '[MimSvcTimeZoneConfiguration]GMT0800PacificTimeUSCanada'
	Ensure               = 'Present'
}

Test-MimSvcTargetResource -ObjectType Person -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

Set-MimSvcTargetResource -ObjectType Person -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

#endregion

#region: Test for an existing PortalUIConfiguration
Configuration TestPortalUIConfiguration 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        PortalUIConfiguration 'My Profile'
        {
            BrandingLeftImage           = '~/_layouts/images/MSILM2/logo.png'
            BrandingRightImage          = '~/_layouts/images/MSILM2/banner.png'
            DisplayName                 = 'Portal Configuration'
            IsConfigurationType         = $false
            ListViewCacheTimeOut        = 120
            ListViewPageSize            = 30
            ListViewPagesToCache        = 3
            TimeZone                    = 'Pacific Standard Time'
            UICacheTime                 = 86400
            UICountCacheTime            = 600
            UIUserCacheTime             = 14400
            Ensure						= 'Present'
        }
    } 
} 

TestPortalUIConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestPortalUIConfiguration" -Force
#endregion

#region: New PortalUIConfiguration
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestPortalUIConfiguration 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        PortalUIConfiguration "TestPortalUIConfiguration$randomNumber"
        {
            BrandingLeftImage           = '~/_layouts/images/MSILM2/logo.png'
            BrandingRightImage          = '~/_layouts/images/MSILM2/banner.png'
            DisplayName                 = "TestPortalUIConfiguration$randomNumber"
            IsConfigurationType         = $false
            ListViewCacheTimeOut        = 120
            ListViewPageSize            = 30
            ListViewPagesToCache        = 3
            TimeZone                    = 'Pacific Standard Time'
            UICacheTime                 = 86400
            UICountCacheTime            = 600
            UIUserCacheTime             = 14400
            Ensure						= 'Present'
        }
    } 
} 

TestPortalUIConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestPortalUIConfiguration" -Force
#endregion

#region: Update PortalUIConfiguration
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestPortalUIConfiguration 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        PortalUIConfiguration "TestPortalUIConfiguration$randomNumber"
        {
            BrandingLeftImage           = '~/_layouts/images/MSILM2/logo.png'
            BrandingRightImage          = '~/_layouts/images/MSILM2/banner.png'
            DisplayName                 = "TestPortalUIConfiguration$randomNumber"
            IsConfigurationType         = $false
            ListViewCacheTimeOut        = 120
            ListViewPageSize            = 30
            ListViewPagesToCache        = 3
            TimeZone                    = 'Pacific Standard Time'
            UICacheTime                 = 86400
            UICountCacheTime            = 600
            UIUserCacheTime             = 14400
            Ensure						= 'Present'
        }
    } 
} 

TestPortalUIConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestPortalUIConfiguration" -Force

Configuration TestPortalUIConfiguration 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        PortalUIConfiguration "TestPortalUIConfiguration$randomNumber"
        {
            BrandingLeftImage           = '~/_layouts/images/MSILM2/logo.png'
            BrandingRightImage          = '~/_layouts/images/MSILM2/banner.png'
            DisplayName                 = "TestPortalUIConfiguration$randomNumber"
            IsConfigurationType         = $false
            ListViewCacheTimeOut        = 121
            ListViewPageSize            = 31
            ListViewPagesToCache        = 2
            TimeZone                    = 'Pacific Standard Time'
            UICacheTime                 = 86400
            UICountCacheTime            = 600
            UIUserCacheTime             = 14400
            Ensure						= 'Present'
        }
    } 
} 

TestPortalUIConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestPortalUIConfiguration" -Force
#endregion