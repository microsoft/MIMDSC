
Get-MimSyncServerXml -Path (Get-MimSyncConfigCache) -Force

$dscResource = Get-DscResource -Module MimSyncDsc -Name MimSyncFilterRule

ipmo $dscResource.Path -Force

Describe 'MimSyncFilterRule - calling Test-TargetResource Directly'{
    
    It 'Scripted Filter Rule - desired state' {
        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -CDObjectType contact -Type scripted -ImportFilter $false -Ensure Present -Verbose 

        $dscResult | Should be True
    }
    
    It 'Scripted Filter Rule - undesirable state' {
        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -CDObjectType person -Type scripted -ImportFilter $false -Ensure Present -Verbose 

        $dscResult | Should be False
    }

    It 'Declared Filter Rule - desired state' {
        $FilterAlternative = @(
        New-CimInstance -ClassName MimSyncFilterAlternative -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
            FilterCondition = @(
                New-CimInstance -ClassName MimSyncFilterCondition -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
                    CDAttribute  = 'FirstName'
                    Operator     = 'equality'
                    Value        = 'Dave'
                }
            ) -as [CimInstance[]]
        }
        New-CimInstance -ClassName MimSyncFilterAlternative -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
            FilterCondition = @(
                New-CimInstance -ClassName MimSyncFilterCondition -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
                    CDAttribute  = 'FirstName'
                    Operator     = 'equality'
                    Value        = 'Joe'
                }
                New-CimInstance -ClassName MimSyncFilterCondition -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
                    CDAttribute  = 'Initial'
                    Operator     = 'inequality'
                    Value        = 'Queue'
                }
                New-CimInstance -ClassName MimSyncFilterCondition -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
                    CDAttribute  = 'Title'
                    Operator     = 'present'
                    Value        = ''
                }
            ) -as [CimInstance[]]
        }
    )
    $dscResult = Test-TargetResource -ManagementAgentName TinyHR -CDObjectType person -Type declared -ImportFilter $false -FilterAlternative $FilterAlternative -Ensure Present -Verbose 

    $dscResult | Should be True
    }

    It 'Declared Filter Rule - filter rules in wrong order' {
        $FilterAlternative = @(        
        New-CimInstance -ClassName MimSyncFilterAlternative -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
            FilterCondition = @(
                New-CimInstance -ClassName MimSyncFilterCondition -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
                    CDAttribute  = 'FirstName'
                    Operator     = 'equality'
                    Value        = 'Joe'
                }
                New-CimInstance -ClassName MimSyncFilterCondition -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
                    CDAttribute  = 'Initial'
                    Operator     = 'inequality'
                    Value        = 'Queue'
                }
                New-CimInstance -ClassName MimSyncFilterCondition -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
                    CDAttribute  = 'Title'
                    Operator     = 'present'
                    Value        = ''
                }
            ) -as [CimInstance[]]
        }
        New-CimInstance -ClassName MimSyncFilterAlternative -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
            FilterCondition = @(
                New-CimInstance -ClassName MimSyncFilterCondition -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
                    CDAttribute  = 'FirstName'
                    Operator     = 'equality'
                    Value        = 'Dave'
                }
            ) -as [CimInstance[]]
        }
    )
    $dscResult = Test-TargetResource -ManagementAgentName TinyHR -CDObjectType person -Type declared -ImportFilter $false -FilterAlternative $FilterAlternative -Ensure Present -Verbose 

    $dscResult | Should be False
    }
}

Describe 'MimSyncFilterRule - calling Get-TargetResource Directly'{
    
    It 'Scripted Filter Rule - desired state' {
        $dscResult = Get-TargetResource -ManagementAgentName TinyHR -CDObjectType contact -Verbose 
      
        $dscResult['Type'] | Should be 'scripted'        
    }
    
    It 'Scripted Filter Rule - undesirable state' {
        {Get-TargetResource -ManagementAgentName TinyHR -CDObjectType android -Verbose} | Should Throw
    }
}

Describe 'MimSyncFilterRule - using the Local Configuration Manager'{
    It 'Scripted Filter Rule - desired state' {
        Configuration TestMimSyncFilterRule 
        { 
            Import-DscResource -ModuleName MimSyncDsc

            Node (hostname) 
            { 
                FilterRule TestcFimSyncFilterRule
                {
                   ManagementAgentName    = 'TinyHR'
                   CDObjectType           = 'contact'
                   Type                   = 'scripted'
                   ImportFilter           = $false
                   Ensure                 = 'Present'
                }
            }
        } 

        TestMimSyncFilterRule -OutputPath "$env:TEMP\TestMimSyncFilterRule"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncFilterRule" -Force -Wait -Verbose 

        $dscStatus = Get-DscConfigurationStatus

        $dscStatus.Status | Should Be 'Success'
    }

    It 'Scripted Filter Rule - desired state' {
        Configuration TestMimSyncFilterRule 
        { 
            Import-DscResource -ModuleName MimSyncDsc

            Node (hostname) 
            { 
                FilterRule TestcFimSyncFilterRule
                {
                   ManagementAgentName    = 'TinyHR'
                   CDObjectType           = 'person'
                   Type                   = 'scripted'
                   ImportFilter           = $false
                   Ensure                 = 'Present'
                }
            }
        } 

        TestMimSyncFilterRule -OutputPath "$env:TEMP\TestMimSyncFilterRule"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncFilterRule" -Force -Wait -Verbose 

        $dscStatus = Get-DscConfigurationStatus

        $dscStatus.Status | Should Be 'Success'
    }

    It 'Declared Filter Rule - desired state' {
        Configuration TestMimSyncFilterRule 
        { 
            Import-DscResource -ModuleName MimSyncDsc

            Node (hostname) 
            { 
                FilterRule TestMimSyncFilterRule
                {
                   ManagementAgentName = 'TinyHR'
                   CDObjectType        = 'person'
                   Type                = 'declared'
                   ImportFilter        = $false
                   Ensure              = 'Present'
                   FilterAlternative   = @(
                      FilterAlternative{
                         FilterCondition = @(
                            FilterCondition{
                                CDAttribute  = 'FirstName'
                                Operator     = 'equality'
                                Value        = 'Dave'
                            }
                         )
                      }
                      FilterAlternative{
                         FilterCondition = @(
                            FilterCondition{
                                CDAttribute  = 'FirstName'
                                Operator     = 'equality'
                                Value        = 'Joe'
                            }
                            FilterCondition{
                                CDAttribute  = 'Initial'
                                Operator     = 'inequality'
                                Value        = 'Queue'
                            }
                            FilterCondition{
                                CDAttribute  = 'Title'
                                Operator     = 'present'
                                Value        = ''
                            }
                         )
                      }
                   )
                }
            }
        } 

        TestMimSyncFilterRule -OutputPath "$env:TEMP\TestMimSyncFilterRule"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncFilterRule" -Force -Wait -Verbose   

        $dscStatus = Get-DscConfigurationStatus

        $dscStatus.Status | Should Be 'Success'
    }
}
