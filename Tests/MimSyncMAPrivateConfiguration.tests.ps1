$dscResource = Get-DscResource -Module MimDsc -Name MimSyncMAPrivateConfiguration

Import-Module -Name $dscResource.Path -Force

Describe -Tag 'Build' 'MimSyncMAPrivateConfiguration - calling Test-TargetResource Directly'{
    
    It 'MimSyncMAPrivateConfiguration - desired state' {  
        $testProperties = @{
            ManagementAgentName   = 'Litware'
            ForestName            = 'cmlitware.selfhost.corp.microsoft.com'
            SslBindCrlCheck       = $false 
            SslBind               = $false
            SimpleBind            = $false
            SignAndSeal           = $true
            ForestLoginUser       = 'administrator'
            ForestLoginDomain     = 'cmlitware'          
            Ensure                = 'Present'
        }
        
        $dscResult = Test-TargetResource @testProperties -Verbose

        $dscResult | Should be True
    }

    It 'MimSyncMAPrivateConfiguration - incorrect ForestLoginDomain' {  
        $testProperties = @{
            ManagementAgentName   = 'Litware'
            ForestName            = 'cmlitware.selfhost.corp.microsoft.com'
            SslBindCrlCheck       = $false 
            SslBind               = $false
            SimpleBind            = $false
            SignAndSeal           = $true
            ForestLoginUser       = 'forestGump'
            ForestLoginDomain     = 'cmlitware'          
            Ensure                = 'Present'
        }
        
        $dscResult = Test-TargetResource @testProperties -Verbose

        $dscResult | Should be False
    }

    It 'MimSyncMAPrivateConfiguration - missing Private Configuration' {                
        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -Ensure Present -Verbose

        $dscResult | Should be False
    }
}

Describe -Tag 'Build' 'MimSyncMAPrivateConfiguration - calling Get-TargetResource Directly'{
    It 'Existing Private Configuration' {

        $dscResult = Get-TargetResource -ManagementAgentName Litware -Verbose

        $dscResult | Should Not Be Null    
    }

    It 'Existing Partition - ForestName' {

        $dscResult = Get-TargetResource -ManagementAgentName Litware -Verbose

        $dscResult['ForestName'] | Should be 'cmlitware.selfhost.corp.microsoft.com'     
    } 
    
    It 'Missing Private Configuration' {

        $dscResult = Get-TargetResource -ManagementAgentName TinyHR -Verbose

        (-not $dscResult) | Should Be True    
    }  
}

Describe -Tag 'RunsInLocalConfigurationManager' 'MimSyncMAPartitionData - using the Local Configuration Manager'{
    It 'MimSyncMAPartitionData - desired state' {
        Configuration TestMimSyncMAPrivateConfigurationConfig 
        { 
            Import-DscResource -ModuleName MimDsc

            Node (hostname) 
            { 
                MimSyncMAPrivateConfiguration Litware
                {
                    ManagementAgentName   = 'Litware'
                    ForestName            = 'cmlitware.selfhost.corp.microsoft.com'
                    ForestLoginDomain     = 'cmlitware' 
                    ForestLoginUser       = 'administrator'
                    SignAndSeal           = $true
                    SslBind               = $false
                    SslBindCrlCheck       = $false
                    SimpleBind            = $false
                    Ensure                = 'Present'
                }
            }
        } 

        TestMimSyncMAPrivateConfigurationConfig -OutputPath "$env:TEMP\TestMimSyncMAPrivateConfigurationConfig"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncMAPrivateConfigurationConfig" -Force -Wait -Verbose 

        Test-DscConfiguration | Should Be True
    }
}
