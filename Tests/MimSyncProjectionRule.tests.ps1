$dscResource = Get-DscResource -Module MimDsc -Name MimSyncProjectionRule

Import-Module -Name $dscResource.Path -Force

Describe -Tag 'Build' 'MimSyncProjectionRule - calling Test-TargetResource Directly'{
    It 'Declared Projection Rule - desired state' {        
        
        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -CDObjectType person -Type declared -MVObjectType SyncObject -Ensure Present -Verbose

        $dscResult | Should be True
    }

    It 'Declared Projection Rule - incorrect MVObjectType' {        
        
        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -CDObjectType person -Type declared -MVObjectType person -Ensure Present -Verbose

        $dscResult | Should be False
    }

    It 'Scripted Projection Rule - desired state' {        
        
        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -CDObjectType contact -Type scripted -Ensure Present -Verbose

        $dscResult | Should be True
    }

    It 'Scripted Projection Rule - missing rule' {        
        
        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -CDObjectType contacts -Type scripted -Ensure Present -Verbose

        $dscResult | Should be False
    }
}

Describe -Tag 'Build' 'MimSyncProjectionRule - calling Get-TargetResource Directly'{
    It 'Missing Projection Rule' {

        $dscResult = Get-TargetResource -ManagementAgentName TINYHR -CDObjectType faketype -Verbose

        (-not $dscResult) | Should Be True    
    }

    It 'Expected Projection Rule' {

        $dscResult = Get-TargetResource -ManagementAgentName TinyHR -CDObjectType contact -Verbose

        $dscResult['Type'] | Should be 'scripted'        
    }   
}

Describe -Tag 'RunsInLocalConfigurationManager' 'MimSyncProjectionRule - using the Local Configuration Manager'{
    It 'Projection Rule - desired state' {
        Configuration TestMimSyncProjectionRule 
        { 
            Import-DscResource -ModuleName MimDsc

            Node (hostname) 
            { 
                ProjectionRule TestMimSyncProjectionRule
                {
                   ManagementAgentName    = 'TinyHR'
                   CDObjectType           = 'contact'
                   Type                   = 'scripted'                   
                   Ensure                 = 'Present'                   
                }
            }
        } 

        TestMimSyncProjectionRule -OutputPath "$env:TEMP\TestMimSyncProjectionRule"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncProjectionRule" -Force -Wait -Verbose 

        Test-DscConfiguration | Should Be True
    }

    It 'Projection Rule - incorrect type' {
        Configuration TestMimSyncProjectionRule 
        { 
            Import-DscResource -ModuleName MimDsc

            Node (hostname) 
            { 
                ProjectionRule TestMimSyncProjectionRule
                {
                   ManagementAgentName    = 'TinyHR'
                   CDObjectType           = 'contact'
                   Type                   = 'declared'                   
                   Ensure                 = 'Present'                   
                }
            }
        } 

        TestMimSyncProjectionRule -OutputPath "$env:TEMP\TestMimSyncProjectionRule"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncProjectionRule" -Force -Wait -Verbose 

        Test-DscConfiguration | Should Be False
    }
}
