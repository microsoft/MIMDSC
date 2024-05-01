Set-Location c:\MimDsc

#region Call the Set and Test methods directly - allows for setting a breakpoint for debuggering
Search-Resources -XPath "/TimeZoneConfiguration" -ExpectedObjectType TimeZoneConfiguration -MaxResults 5

ipmo MimDsc -Force
ipmo 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcTimeZoneConfiguration\MimSvcTimeZoneConfiguration.psm1' -Force
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcTimeZoneConfiguration\MimSvcTimeZoneConfiguration.psm1'
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\Functions\Test-MimSvcTargetResource.ps1'
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\Functions\Set-MimSvcTargetResource.ps1'

$resourceProperties = @{
DisplayName = '(GMT) Casablanca, Monrovia, Reykjavik'
            TimeZoneId  = 'Greenwich Standard Time'            
            Ensure		= 'Present'
}

Test-MimSvcTargetResource -ObjectType TimeZoneConfiguration -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

Set-MimSvcTargetResource -ObjectType TimeZoneConfiguration -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

#endregion

#region: Test for an existing TimeZoneConfiguration
Configuration TestTimeZoneConfiguration 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        TimeZoneConfiguration 'Greenwich Standard Time'
        {
            DisplayName = '(GMT) Casablanca, Monrovia, Reykjavik'
            TimeZoneId  = 'Greenwich Standard Time'            
            Ensure		= 'Present'
        }
    } 
} 

TestTimeZoneConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestTimeZoneConfiguration" -Force
#endregion

#region: Create a TimeZoneConfiguration
Configuration TestTimeZoneConfiguration 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        TimeZoneConfiguration 'Happy Hour'
        {
            DisplayName = '(HHST) Happy Hour Standard Time'
            TimeZoneId  = 'Happy Hour Standard Time'            
            Ensure		= 'Present'
        }
    } 
} 

TestTimeZoneConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestTimeZoneConfiguration" -Force
#endregion