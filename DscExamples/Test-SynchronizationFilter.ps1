Set-Location c:\MimDsc

#region Call the Set and Test methods directly - allows for setting a breakpoint for debuggering
Search-Resources -XPath "/SynchronizationFilter" -ExpectedObjectType SynchronizationFilter -MaxResults 5

ipmo MimDsc -Force
ipmo 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcSynchronizationFilter\MimSvcSynchronizationFilter.psm1' -Force
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcSynchronizationFilter\MimSvcSynchronizationFilter.psm1'
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\Functions\Test-MimSvcTargetResource.ps1'
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\Functions\Set-MimSvcTargetResource.ps1'

$resourceProperties = @{
    DisplayName					= 'Synchronization Filter'
    SynchronizeObjectType       = @(
                                    'DetectedRuleEntry'
                                    'ExpectedRuleEntry'
                                    'Group'
                                    'SynchronizationRule'
                                    'Person'
    )
    Ensure						= 'Present'
}

Test-MimSvcTargetResource -ObjectType SynchronizationFilter -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

Set-MimSvcTargetResource -ObjectType SynchronizationFilter -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

#endregion


#region: Test for an existing SynchronizationFilter
Configuration TestSynchronizationFilter 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        SynchronizationFilter 'Synchronization Filter'
        {
            DisplayName					= 'Synchronization Filter'
            SynchronizeObjectType       = @(
                                            'DetectedRuleEntry'
                                            'ExpectedRuleEntry'
                                            'Group'
                                            'SynchronizationRule'
                                            'Person'
            )
            Ensure						= 'Present'
        }
    } 
} 

TestSynchronizationFilter

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestSynchronizationFilter" -Force
#endregion

#region: Update an existing SynchronizationFilter
Configuration TestSynchronizationFilter 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        SynchronizationFilter 'Synchronization Filter'
        {
            DisplayName					= 'Synchronization Filter'
            SynchronizeObjectType       = @(
                                            'DetectedRuleEntry'
                                            'ExpectedRuleEntry'
                                            'Group'
                                            'SynchronizationRule'
                                            'Person'
                                            'HomepageConfiguration'
            )
            Ensure						= 'Present'
        }
    } 
} 

TestSynchronizationFilter

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestSynchronizationFilter" -Force
#endregion
