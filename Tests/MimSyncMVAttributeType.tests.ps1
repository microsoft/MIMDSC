$dscResource = Get-DscResource -Module MimDsc -Name MimSyncMVAttributeType

Import-Module -Name $dscResource.Path -Force

Describe -Tag 'Build' 'MimSyncMVAttributeType - calling Test-TargetResource Directly'{
    
    It 'MimSyncMVAttributeType - desired state' {  
        $dscResult = Test-TargetResource -ID Alias -SingleValue $true -Syntax '1.3.6.1.4.1.1466.115.121.1.15' -Indexable $true -Indexed $false -Ensure Present -Verbose

        $dscResult | Should be True
    }

    It 'MimSyncMVAttributeType - incorrect Syntax attributes' {  
        $dscResult = Test-TargetResource -ID ForwardingAddress -SingleValue $true -Syntax '1.3.6.1.4.1.1466.115.121.1.15' -Indexable $false -Indexed $false -Ensure Present -Verbose

        $dscResult | Should be False
    }

    It 'MimSyncMVAttributeType - incorrect single-valued' {  
        $dscResult = Test-TargetResource -ID ForwardingAddress -SingleValue $false -Syntax '1.3.6.1.4.1.1466.115.121.1.12' -Indexable $false -Indexed $false -Ensure Present -Verbose

        $dscResult | Should be False
    }
}

Describe -Tag 'Build' 'MimSyncMVAttributeType - calling Get-TargetResource Directly'{
    It 'Existing MV Attribute Type' {

        $dscResult = Get-TargetResource -ID Alias -Verbose

        $dscResult | Should Not Be Null    
    }

    It 'Existing MV Attribute Type - Syntax' {

        $dscResult = Get-TargetResource -ID Alias -Verbose

        $dscResult['Syntax'] | Should be '1.3.6.1.4.1.1466.115.121.1.15'        
    } 
    
    It 'Missing MV Attribute Type' {

        $dscResult = Get-TargetResource -ID SuperImportantAttribute -Verbose

        (-not $dscResult) | Should Be True    
    }  
}

Describe -Tag 'RunsInLocalConfigurationManager' 'MimSyncMVAttributeType - using the Local Configuration Manager'{
    It 'MimSyncMVAttributeType - desired state' {
        Configuration TestMimSyncMVAttributeType 
        { 
            Import-DscResource -ModuleName MimDsc

            Node (hostname) 
            { 
                MVAttributeType TestMimSyncMVAttributeTypeItem
                {
                    ID          = 'Alias'
                    SingleValue = $true
                    Indexable   = $true
                    Indexed     = $false
                    Syntax      = '1.3.6.1.4.1.1466.115.121.1.15'
                    Ensure      = 'present'
                }                
            }
        } 

        TestMimSyncMVAttributeType -OutputPath "$env:TEMP\TestMimSyncMVAttributeType"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncMVAttributeType" -Force -Wait -Verbose 

        Test-DscConfiguration | Should Be True
    }

    It 'MimSyncMVAttributeType - incorrect indexed state' {
        Configuration TestMimSyncMVAttributeType 
        { 
            Import-DscResource -ModuleName MimDsc

            Node (hostname) 
            { 
                MVAttributeType TestMimSyncMVAttributeTypeItem
                {
                    ID          = 'Alias'
                    SingleValue = $true
                    Indexable   = $true
                    Indexed     = $true
                    Syntax      = '1.3.6.1.4.1.1466.115.121.1.15'
                    Ensure      = 'present'
                }                
            }
        } 

        TestMimSyncMVAttributeType -OutputPath "$env:TEMP\TestMimSyncMVAttributeType"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncMVAttributeType" -Force -Wait -Verbose 

        Test-DscConfiguration | Should Be False
    }

    It 'MimSyncMVAttributeType - missing attribute type' {
        Configuration TestMimSyncMVAttributeType 
        { 
            Import-DscResource -ModuleName MimDsc

            Node (hostname) 
            { 
                MVAttributeType TestMimSyncMVAttributeTypeItem
                {
                    ID          = 'Gone'
                    SingleValue = $true
                    Indexable   = $true
                    Indexed     = $true
                    Syntax      = '1.3.6.1.4.1.1466.115.121.1.15'
                    Ensure      = 'present'
                }                
            }
        } 

        TestMimSyncMVAttributeType -OutputPath "$env:TEMP\TestMimSyncMVAttributeType"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncMVAttributeType" -Force -Wait -Verbose 

        Test-DscConfiguration | Should Be False
    }
}
