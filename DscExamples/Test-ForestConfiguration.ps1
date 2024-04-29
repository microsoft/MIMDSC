Set-Location c:\MimDsc

#region Call the Set and Test methods directly - allows for setting a breakpoint for debuggering
Search-Resources -XPath "/ForestConfiguration" -ExpectedObjectType ForestConfiguration

ipmo MimDsc -Force
ipmo 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcForestConfiguration\MimSvcForestConfiguration.psm1' -Force
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcForestConfiguration\MimSvcForestConfiguration.psm1'

$resourceProperties = @{
    DisplayName                 = "TestDomain$randomNumber"
    Ensure						= 'Present'
}

Test-MimSvcTargetResource -ObjectType ForestConfiguration -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

Set-MimSvcTargetResource -ObjectType ForestConfiguration -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

#endregion


#region: Test for a new ForestConfiguration
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestForestConfiguration 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ForestConfiguration "Forest$randomNumber"
        {
            DisplayName                 = "Forest$randomNumber"
            Ensure						= 'Present'
        }
    } 
} 

TestForestConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestForestConfiguration" -Force
#endregion