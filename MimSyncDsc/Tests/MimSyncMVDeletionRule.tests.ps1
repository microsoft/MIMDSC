$dscResource = Get-DscResource -Module MimSyncDsc -Name MimSyncMVDeletionRule

Import-Module -Name $dscResource.Path -Force

Describe -Tag 'Build' 'MimSyncMVDeletionRule - calling Test-TargetResource Directly'{
    It 'MimSyncMVDeletionRule - desired state' {        
        
        $dscResult = Test-TargetResource -MVObjectType SyncObject -Type scripted -Verbose

        $dscResult | Should be True
    }

    It 'MimSyncMVDeletionRule - incorrect type' {        
        
        $dscResult = Test-TargetResource -MVObjectType SyncObject -Type foo -Verbose

        $dscResult | Should be False
    }

    It 'MimSyncMVDeletionRule - incorrect MVObjectType' {        
        
        $dscResult = Test-TargetResource -MVObjectType Var -Type foo -Verbose

        $dscResult | Should be False
    }
}

Describe -Tag 'Build' 'MimSyncMVDeletionRule - calling Get-TargetResource Directly'{    
    It 'Expected MimSyncMVDeletionRule' {

        $dscResult = Get-TargetResource -MVObjectType SyncObject -Verbose

        $dscResult['Type'] | Should be 'scripted'        
    }   
}

Describe -Tag 'RunsInLocalConfigurationManager' 'MimSyncMVDeletionRule - using the Local Configuration Manager'{
    It 'MimSyncMVDeletionRule - desired state' {
        Configuration TestMimSyncMVDeletionRule 
        { 
            Import-DscResource -ModuleName MimSyncDsc

            Node (hostname) 
            { 
                MVDeletionRule TestMimSyncMVDeletionRule
                {
                    MVObjectType = 'SyncObject'
                    Type         = 'scripted'
                }
            }
        } 

        TestMimSyncMVDeletionRule -OutputPath "$env:TEMP\TestMimSyncMVDeletionRule"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncMVDeletionRule" -Force -Wait -Verbose 

        Test-DscConfiguration | Should Be True
    }

    It 'MimSyncMVDeletionRule - desired state' {
        Configuration TestMimSyncMVDeletionRule 
        { 
            Import-DscResource -ModuleName MimSyncDsc

            Node (hostname) 
            { 
                MVDeletionRule TestMimSyncMVDeletionRule
                {
                    MVObjectType = 'SyncObject'
                    Type         = 'declared'
                }
            }
        } 

        TestMimSyncMVDeletionRule -OutputPath "$env:TEMP\TestMimSyncMVDeletionRule"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncMVDeletionRule" -Force -Wait -Verbose 

        Test-DscConfiguration | Should Be False
    }
}

<#
#TODO - more tests for other deletion rule types, such as
Configuration TestMimSyncMVDeletionRule 
{ 
    Import-DscResource -ModuleName MimSyncDsc

    Node (hostname) 
    { 
        MVDeletionRule TestMimSyncMVDeletionRule
        {
            MVObjectType        = 'Contact'
            Type                = 'declared-any'
            ManagementAgentName = @(
                'TinyHR'
                'GiantHR'
                'OnPremiseAD'
            )
        }
    }
} 
#>
