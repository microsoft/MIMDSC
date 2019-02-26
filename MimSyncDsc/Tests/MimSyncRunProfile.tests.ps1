$dscResource = Get-DscResource -Module MimSyncDsc -Name MimSyncRunProfile

Import-Module -Name $dscResource.Path -Force

Describe -Tag 'Build' 'MimSyncRunProfile - calling Test-TargetResource Directly'{
    
    It 'MimSyncRunProfile - desired state' {  
        $RunSteps = @(
            New-CimInstance -ClassName MimSyncRunStep -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
                StepType            = 'full-import'
                StepSubType         = @('to-cs')
                PartitionIdentifier = '{08F64D3F-B82C-44E2-AC6F-9F680DECFEBE}'
                InputFile           = 'tinyhr.txt'
                PageSize            = 0
                Timeout             = 0
                ObjectDeleteLimit   = 0
                ObjectProcessLimit  = 0
                LogFilePath         = '' 
                DropFileName        = ''
            }
        )    
        
        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -Name FISO -RunSteps $RunSteps -Ensure Present -Verbose

        $dscResult | Should be True
    }

    It 'MimSyncRunProfile - incorrect step type' {  
        $RunSteps = @(
            New-CimInstance -ClassName MimSyncRunStep -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
                StepType            = 'apply-rules'
                StepSubType         = @('reevaluate-flow-connectors')
                PartitionIdentifier = '{08F64D3F-B82C-44E2-AC6F-9F680DECFEBE}'
                InputFile           = 'tinyhr.txt'
                PageSize            = 0
                Timeout             = 0
                ObjectDeleteLimit   = 0
                ObjectProcessLimit  = 0
                LogFilePath         = '' 
                DropFileName        = ''
            }
        )    
        
        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -Name FISO -RunSteps $RunSteps -Ensure Present -Verbose

        $dscResult | Should be false
    }

    It 'MimSyncRunProfile - incorrect input file' {  
        $RunSteps = @(
            New-CimInstance -ClassName MimSyncRunStep -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
                StepType            = 'full-import'
                StepSubType         = @('to-cs')
                PartitionIdentifier = '{08F64D3F-B82C-44E2-AC6F-9F680DECFEBE}'
                InputFile           = 'HumongousHR.txt'
                PageSize            = 0
                Timeout             = 0
                ObjectDeleteLimit   = 0
                ObjectProcessLimit  = 0
                LogFilePath         = '' 
                DropFileName        = ''
            }
        )    
        
        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -Name FISO -RunSteps $RunSteps -Ensure Present -Verbose

        $dscResult | Should be False
    }

    It 'MimSyncRunProfile - missing run profile' {                
        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -Name Potato  -Ensure Present -Verbose

        $dscResult | Should be False
    }
}

Describe -Tag 'Build' 'MimSyncRunProfile - calling Get-TargetResource Directly'{
    It 'Existing Run Profile' {

        $dscResult = Get-TargetResource -ManagementAgentName TinyHR -Name FISO -Verbose

        $dscResult | Should Not Be Null    
    }

    It 'Existing Run Profile - RunSteps' {

        $dscResult = Get-TargetResource -ManagementAgentName TinyHR -Name FISO -Verbose

        $dscResult['RunSteps'][0].StepType | Should be 'full-import'        
    } 
    
    It 'Missing Run Profile' {

        $dscResult = Get-TargetResource -ManagementAgentName TinyHR -Name Potato -Verbose

        (-not $dscResult) | Should Be True    
    }  
}

Describe -Tag 'RunsInLocalConfigurationManager' 'MimSyncRunProfile - using the Local Configuration Manager'{
    It 'MimSyncRunProfile - desired state' {
        Configuration TestMimSyncRunProfile 
        { 
            Import-DscResource -ModuleName MimSyncDsc

            Node (hostname) 
            { 
                RunProfile '[TinyHR]FISO'
                {
                    ManagementAgentName   = 'TinyHR'
                    Name                  = 'FISO'
                    RunSteps              = @(
                        RunStep{
                            StepType            = 'full-import'
                            StepSubType         = @('to-cs')
                            PartitionIdentifier = '{08F64D3F-B82C-44E2-AC6F-9F680DECFEBE}'
                            InputFile           = 'tinyhr.txt'
                            PageSize            = 0
                            Timeout             = 0
                            ObjectDeleteLimit   = 0
                            ObjectProcessLimit  = 0
                            LogFilePath         = '' 
                            DropFileName        = ''
                            FakeIdentifier      = [Guid]::Empty
                        }
                    )
                    Ensure                 = 'Present'
                }
            }
        } 

        TestMimSyncRunProfile -OutputPath "$env:TEMP\TestMimSyncRunProfile"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncRunProfile" -Force -Wait -Verbose 

        Test-DscConfiguration | Should Be True
    }
}
