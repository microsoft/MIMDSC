$dscResource = Get-DscResource -Module MimSyncDsc -Name MimSyncMVOptions

Import-Module -Name $dscResource.Path -Force

Describe -Tag 'Build' 'MimSyncMVOptions - calling Test-TargetResource Directly'{
    It 'MimSyncMVOptions - desired state' {        
        
        $dscResult = Test-TargetResource -FakeIdentifier foo -ProvisioningType scripted -ExtensionAssemblyName ELMA-MV-Sample.dll -ExtensionApplicationProtection low -Verbose

        $dscResult | Should be True
    }

    It 'MimSyncMVOptions - incorrect ExtensionAssemblyName' {        
        
        $dscResult = Test-TargetResource -FakeIdentifier foo -ProvisioningType scripted -ExtensionAssemblyName wrong.dll -ExtensionApplicationProtection low -Verbose

        $dscResult | Should be False
    }

    It 'MimSyncMVOptions - incorrect ProvisioningType' {        
        
        $dscResult = Test-TargetResource -FakeIdentifier foo -ProvisioningType declared -ExtensionAssemblyName ELMA-MV-Sample.dll -ExtensionApplicationProtection low -Verbose

        $dscResult | Should be False
    }    
}

Describe -Tag 'Build' 'MimSyncMVOptions - calling Get-TargetResource Directly'{    
    It 'Expected MimSyncMVOptions' {

        $dscResult = Get-TargetResource -FakeIdentifier foo -Verbose

        $dscResult['ProvisioningType'] | Should be 'scripted'        
    }   
}

Describe -Tag 'RunsInLocalConfigurationManager' 'MimSyncProjectionRule - using the Local Configuration Manager'{
    It 'MVOptions - desired state' {
        Configuration TestMimSyncMVOptions 
        { 
            Import-DscResource -ModuleName MimSyncDsc

            Node (hostname) 
            { 
                MVOptions TestcFimSyncMVOptions
                {
                    FakeIdentifier                   = 'foo'
                    ProvisioningType                 = 'scripted'
                    ExtensionAssemblyName            = 'ELMA-MV-Sample.dll'
                    ExtensionApplicationProtection   = 'low'
                }
            }
        } 

        TestMimSyncMVOptions -OutputPath "$env:TEMP\TestMimSyncMVOptions"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncMVOptions" -Force -Wait -Verbose 

        Test-DscConfiguration | Should Be True
    }

    It 'MVOptions - incorrect state' {
        Configuration TestMimSyncMVOptions 
        { 
            Import-DscResource -ModuleName MimSyncDsc

            Node (hostname) 
            { 
                MVOptions TestcFimSyncMVOptions
                {
                    FakeIdentifier                   = 'foo'
                    ProvisioningType                 = 'scripted'
                    ExtensionAssemblyName            = 'foo.dll'
                    ExtensionApplicationProtection   = 'low'
                }
            }
        } 

        TestMimSyncMVOptions -OutputPath "$env:TEMP\TestMimSyncMVOptions"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncMVOptions" -Force -Wait -Verbose 

        Test-DscConfiguration | Should Be False
    }
}
