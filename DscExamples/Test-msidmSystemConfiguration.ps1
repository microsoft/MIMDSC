Set-Location c:\MimDsc

#region Call the Set and Test methods directly - allows for setting a breakpoint for debuggering
Search-Resources -XPath "/msidmSystemConfiguration" -ExpectedObjectType msidmSystemConfiguration -MaxResults 2

ipmo MimDsc -Force
ipmo 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcmsidmSystemConfiguration\MimSvcmsidmSystemConfiguration.psm1' -Force
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcmsidmSystemConfiguration\MimSvcmsidmSystemConfiguration.psm1'

$randomNumber = Get-Random -Minimum 100 -Maximum 999
$testResourceProperties = @{
    Description                                       = 'Common configuration settings across all FIM Service instances.'
    DisplayName                                       = 'System Configuration Settings'
    IsConfigurationType                               = $false
    msidmSystemThrottleLevel                          = 75
    msidmRequestMaximumActiveDuration                 = 60
    msidmRequestMaximumCancelingDuration              = 2
    msidmReportingLoggingEnabled                      = $false
    msidmCreateCriteriaBasedGroupsAsDeferredByDefault = $false
    Ensure						                      = 'Present'
}

Test-MimSvcTargetResource -ObjectType msidmSystemConfiguration -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

Set-MimSvcTargetResource -ObjectType msidmSystemConfiguration -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

#endregion


#region: Test for an existing msidmSystemConfiguration
Configuration TestmsidmSystemConfiguration 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        msidmSystemConfiguration 'Request and workflow instance retention period configuration'
        {
            Description                                       = 'Common configuration settings across all FIM Service instances.'
            DisplayName                                       = 'System Configuration Settings'
            IsConfigurationType                               = $false
            msidmSystemThrottleLevel                          = 75
            msidmRequestMaximumActiveDuration                 = 60
            msidmRequestMaximumCancelingDuration              = 2
            msidmReportingLoggingEnabled                      = $false
            msidmCreateCriteriaBasedGroupsAsDeferredByDefault = $false
            Ensure						                      = 'Present'
        }
    } 
} 

TestmsidmSystemConfiguration 

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestmsidmSystemConfiguration" -Force
#endregion

#region: Update an existing msidmSystemConfiguration
Configuration TestmsidmSystemConfiguration 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        msidmSystemConfiguration 'Request and workflow instance retention period configuration'
        {
            Description                                       = 'Common configuration settings across all FIM Service instances.'
            DisplayName                                       = 'System Configuration Settings'
            IsConfigurationType                               = $false
            msidmSystemThrottleLevel                          = 74
            msidmRequestMaximumActiveDuration                 = 30
            msidmRequestMaximumCancelingDuration              = 5
            msidmReportingLoggingEnabled                      = $false
            msidmCreateCriteriaBasedGroupsAsDeferredByDefault = $false
            Ensure						                      = 'Present'
        }
    } 
} 

TestmsidmSystemConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestmsidmSystemConfiguration" -Force
#endregion