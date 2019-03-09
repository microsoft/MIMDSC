$dscResource = Get-DscResource -Module MimDsc -Name MimSyncMAPartitionData

Import-Module -Name $dscResource.Path -Force

Describe -Tag 'Build' 'MimSyncMAPartitionData - calling Test-TargetResource Directly'{
    
    It 'MimSyncMAPartitionData - desired state' {  
        $testResourceProperties = @{
            ManagementAgentName   = 'TinyHR'
            Name                  = 'default'
            Selected              = $true 
            ObjectClassInclusions = @(
                'person'
                'contact'
                'robot'
                'hybrid'
            )
            ContainerExclusions   = @()
            ContainerInclusions   = @()
            Ensure                = 'Present'
        }
        
        $dscResult = Test-TargetResource @testResourceProperties -Verbose

        $dscResult | Should be True
    }

    It 'MimSyncMAPartitionData - incorrect ObjectClassInclusions' {  
        $testResourceProperties = @{
           ManagementAgentName   = 'TinyHR'
            Name                  = 'default'
            Selected              = $true 
            ObjectClassInclusions = @(
                'person'
                'contact'
                'robot'
                'hybird'
            )
            ContainerExclusions   = @()
            ContainerInclusions   = @()
            Ensure                = 'Present'
        }
        
        $dscResult = Test-TargetResource @testResourceProperties -Verbose

        $dscResult | Should be false
    }

    It 'MimSyncMAPartitionData - missing partition' {                
        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -Name foo -Selected $true  -Ensure Present -Verbose

        $dscResult | Should be False
    }
}

Describe -Tag 'Build' 'MimSyncMAPartitionData - calling Get-TargetResource Directly'{
    It 'Existing Partition' {

        $dscResult = Get-TargetResource -ManagementAgentName TinyHR -Name default -Verbose

        $dscResult | Should Not Be Null    
    }

    It 'Existing Partition - Selected' {

        $dscResult = Get-TargetResource -ManagementAgentName TinyHR -Name default -Verbose

        $dscResult['Selected'] | Should be True     
    } 
    
    It 'Missing Partition' {

        $dscResult = Get-TargetResource -ManagementAgentName TinyHR -Name Potato -Verbose

        (-not $dscResult) | Should Be True    
    }  
}

Describe -Tag 'RunsInLocalConfigurationManager' 'MimSyncMAPartitionData - using the Local Configuration Manager'{
    It 'MimSyncMAPartitionData - desired state' {
        Configuration TestMimSyncMAPartitionDataConfig 
        { 
            Import-DscResource -ModuleName MimDsc

            Node (hostname) 
            { 
                MimSyncMAPartitionData '[TinyHR]default'
                {
                    ManagementAgentName   = 'TinyHR'
                    Name                  = 'default'
                    Selected              = $true 
                    ObjectClassInclusions = @(
                        'person'
                        'contact'
                        'robot'
                        'hybrid'
                    )
                    ContainerExclusions   = @()
                    ContainerInclusions   = @()
                    Ensure                = 'Present'
                }
            }
        } 

        TestMimSyncMAPartitionDataConfig -OutputPath "$env:TEMP\TestMimSyncMAPartitionDataConfig"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncMAPartitionDataConfig" -Force -Wait -Verbose 

        Test-DscConfiguration | Should Be True
    }
}
