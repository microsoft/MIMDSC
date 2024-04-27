Set-Location c:\MimDsc

#region Call the Set and Test methods directly - allows for setting a breakpoint for debuggering
ipmo MimDsc -Force
ipmo 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcEmailTemplate\MimSvcDomainConfiguration.psm1' -Force
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcEmailTemplate\MimSvcDomainConfiguration.psm1'

Search-Resources -XPath "/DomainConfiguration" -ExpectedObjectType DomainConfiguration

$resourceProperties = @{
    DisplayName                 = 'REDMOND'
    Domain                      = 'REDMOND'
    Ensure						= 'Present'
}

$resourceProperties = @{
    DisplayName                 = "TestDomain$randomNumber"
    Domain                      = "TestDomain$randomNumber"
    Ensure						= 'Present'
}

Test-MimSvcTargetResource -ObjectType DomainConfiguration -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

Set-MimSvcTargetResource -ObjectType DomainConfiguration -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

#endregion


#region: Test for an existing DomainConfiguration
Configuration TestDomainConfiguration 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        DomainConfiguration 'REDMOND'
        {
            DisplayName                 = 'REDMOND'
            Domain                      = 'REDMOND'
            IsConfigurationType         = $false
            Ensure						= 'Present'
        }
    } 
} 

TestDomainConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestDomainConfiguration" -Force
#endregion