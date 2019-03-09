$dscResource = Get-DscResource -Module MimDsc -Name MimSyncJoinRule

Import-Module -Name $dscResource.Path -Force

Describe -Tag 'Build' 'MimSyncJoinRule - calling Test-TargetResource Directly'{
    It 'Mega Join Rule - desired state' {
        $joinCriteria = @(
            New-CimInstance -ClassName MimSyncJoinCriterion -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
                MVObjectType            = 'Contact'
                ResolutionType          = 'none'
                ResolutionScriptContext = ''
                Order                   = 0
                AttributeMapping        = @(
                    New-CimInstance -ClassName MimSyncAttributeMapping -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
                        MVAttribute   = 'FirstName'
                        CDAttribute   = @('FirstName')
                        MappingType   = 'direct-mapping'
                        ScriptContext = ''
                    }
                    New-CimInstance -ClassName MimSyncAttributeMapping -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
                        MVAttribute   = 'LastName'
                        CDAttribute   = @('LastName')
                        MappingType   = 'direct-mapping'
                        ScriptContext = ''
                    }
                ) -as [CimInstance[]]
            }
            New-CimInstance -ClassName MimSyncJoinCriterion -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
                MVObjectType            = 'Contact'
                ResolutionType          = 'scripted'
                ResolutionScriptContext = 'cd.contact#2'
                Order                   = 1
                AttributeMapping        = @(
                    New-CimInstance -ClassName MimSyncAttributeMapping -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
                        MVAttribute   = 'Alias'
                        CDAttribute   = 'FirstName','LastName'
                        MappingType   = 'scripted-mapping'
                        ScriptContext = 'cd.contact#2:FirstName,LastName->Alias'
                    }                    
                ) -as [CimInstance[]]
            }
            New-CimInstance -ClassName MimSyncJoinCriterion -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
                MVObjectType            = ''
                ResolutionType          = 'none'
                ResolutionScriptContext = ''
                Order                   = 2
                AttributeMapping        = @(
                    New-CimInstance -ClassName MimSyncAttributeMapping -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
                        MVAttribute   = 'Alias'
                        CDAttribute   = @('UserID')
                        MappingType   = 'direct-mapping'
                        ScriptContext = ''
                    }                    
                ) -as [CimInstance[]]
            }
        )
        
        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -CDObjectType contact -JoinCriterion $joinCriteria -Ensure Present -Verbose

        $dscResult | Should be True
    }

    It 'Mega Join Rule - incorrect join rule order' {
        $joinCriteria = @(
            New-CimInstance -ClassName MimSyncJoinCriterion -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
                MVObjectType            = 'Contact'
                ResolutionType          = 'none'
                ResolutionScriptContext = ''
                Order                   = 2
                AttributeMapping        = @(
                    New-CimInstance -ClassName MimSyncAttributeMapping -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
                        MVAttribute   = 'FirstName'
                        CDAttribute   = @('FirstName')
                        MappingType   = 'direct-mapping'
                        ScriptContext = ''
                    }
                    New-CimInstance -ClassName MimSyncAttributeMapping -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
                        MVAttribute   = 'LastName'
                        CDAttribute   = @('LastName')
                        MappingType   = 'direct-mapping'
                        ScriptContext = ''
                    }
                ) -as [CimInstance[]]
            }
            New-CimInstance -ClassName MimSyncJoinCriterion -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
                MVObjectType            = 'Contact'
                ResolutionType          = 'scripted'
                ResolutionScriptContext = 'cd.contact#2'
                Order                   = 1
                AttributeMapping        = @(
                    New-CimInstance -ClassName MimSyncAttributeMapping -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
                        MVAttribute   = 'Alias'
                        CDAttribute   = 'FirstName','LastName'
                        MappingType   = 'scripted-mapping'
                        ScriptContext = 'cd.contact#2:FirstName,LastName->Alias'
                    }                    
                ) -as [CimInstance[]]
            }
            New-CimInstance -ClassName MimSyncJoinCriterion -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
                MVObjectType            = ''
                ResolutionType          = 'none'
                ResolutionScriptContext = ''
                Order                   = 0
                AttributeMapping        = @(
                    New-CimInstance -ClassName MimSyncAttributeMapping -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
                        MVAttribute   = 'Alias'
                        CDAttribute   = @('UserID')
                        MappingType   = 'direct-mapping'
                        ScriptContext = ''
                    }                    
                ) -as [CimInstance[]]
            }
        )
        
        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -CDObjectType contact -JoinCriterion $joinCriteria -Ensure Present -Verbose

        $dscResult | Should be False
    }    
}

Describe -Tag 'Build' 'MimSyncJoinRule - calling Get-TargetResource Directly'{
    It 'Missing Join Rule' {

        $dscResult = Get-TargetResource -ManagementAgentName TINYHR -CDObjectType faketype -Verbose

        (-not $dscResult) | Should Be True    
    }

    It 'Expected Join Rule' {

        $dscResult = Get-TargetResource -ManagementAgentName TinyHR -CDObjectType contact -Verbose

        $dscResult['JoinCriterion'].Count | Should be 3        
    }   
}

Describe -Tag 'RunsInLocalConfigurationManager' 'MimSyncJoinRule - using the Local Configuration Manager'{
    It 'Join Rule - desired state' {
        Configuration TestMimSyncJoinRule 
        { 
            Import-DscResource -ModuleName MimDsc

            Node (hostname) 
            { 
                JoinRule TestMimSyncJoinRule
                {
                   ManagementAgentName    = 'TinyHR'
                   CDObjectType           = 'contact'                   
                   Ensure                 = 'Present'
                   JoinCriterion          = @(
                      JoinCriterion{
                          ID                      = [Guid]::NewGuid().Guid
                          MVObjectType            = 'Contact'
                          ResolutionType          = 'none'
                          ResolutionScriptContext = ''
                          Order                   = 0
                          AttributeMapping        = @(
                             AttributeMapping{
                                MappingType   = 'direct-mapping'
                                MVAttribute   = 'FirstName'
                                CDAttribute   = 'FirstName'
                                ScriptContext = ''
                             }
                             AttributeMapping{
                                MappingType   = 'direct-mapping'
                                MVAttribute   = 'LastName'
                                CDAttribute   = 'LastName'
                                ScriptContext = ''
                             }                             
                          )
                      }
                      JoinCriterion{
                          ID                      = [Guid]::NewGuid().Guid
                          MVObjectType            = 'Contact'
                          ResolutionType          = 'scripted'
                          ResolutionScriptContext = 'cd.contact#2'
                          Order                   = 1
                          AttributeMapping        = @(
                             AttributeMapping{
                                MappingType   = 'scripted-mapping'
                                MVAttribute   = 'Alias'
                                CDAttribute   = 'FirstName','LastName'
                                ScriptContext = 'cd.contact#2:FirstName,LastName->Alias'
                             }                       
                          )
                      }
                      JoinCriterion{
                          ID                      = [Guid]::NewGuid().Guid
                          MVObjectType            = ''
                          ResolutionType          = 'none'
                          ResolutionScriptContext = ''
                          Order                   = 2
                          AttributeMapping        = @(
                             AttributeMapping{
                                MappingType   = 'direct-mapping'
                                MVAttribute   = 'Alias'
                                CDAttribute   = 'UserID'
                                ScriptContext = ''
                             }                       
                          )
                      }
                   )
                }
            }
        } 

        TestMimSyncJoinRule -OutputPath "$env:TEMP\TestMimSyncJoinRule"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncJoinRule" -Force -Wait -Verbose 

        Test-DscConfiguration | Should Be True
    }

    It 'Join Rule - incorrect order' {
        Configuration TestMimSyncJoinRule 
        { 
            Import-DscResource -ModuleName MimDsc

            Node (hostname) 
            { 
                JoinRule TestMimSyncJoinRule
                {
                   ManagementAgentName    = 'TinyHR'
                   CDObjectType           = 'contact'                   
                   Ensure                 = 'Present'
                   JoinCriterion          = @(
                      JoinCriterion{
                          ID                      = [Guid]::NewGuid().Guid
                          MVObjectType            = 'Contacts'##
                          ResolutionType          = 'none'
                          ResolutionScriptContext = ''
                          Order                   = 2
                          AttributeMapping        = @(
                             AttributeMapping{
                                MappingType   = 'direct-mapping'
                                MVAttribute   = 'FirstName'
                                CDAttribute   = 'FirstName'
                                ScriptContext = ''
                             }
                             AttributeMapping{
                                MappingType   = 'direct-mapping'
                                MVAttribute   = 'LastName'
                                CDAttribute   = 'LastName'
                                ScriptContext = ''
                             }                             
                          )
                      }
                      JoinCriterion{
                          ID                      = [Guid]::NewGuid().Guid
                          MVObjectType            = 'Contact'
                          ResolutionType          = 'scripted'
                          ResolutionScriptContext = 'cd.contact#2'
                          Order                   = 1
                          AttributeMapping        = @(
                             AttributeMapping{
                                MappingType   = 'scripted-mapping'
                                MVAttribute   = 'Alias'
                                CDAttribute   = 'FirstName','LastName'
                                ScriptContext = 'cd.contact#2:FirstName,LastName->Alias'
                             }                       
                          )
                      }
                      JoinCriterion{
                          ID                      = [Guid]::NewGuid().Guid
                          MVObjectType            = ''
                          ResolutionType          = 'none'
                          ResolutionScriptContext = ''
                          Order                   = 0
                          AttributeMapping        = @(
                             AttributeMapping{
                                MappingType   = 'direct-mapping'
                                MVAttribute   = 'Alias'
                                CDAttribute   = 'UserID'
                                ScriptContext = ''
                             }                       
                          )
                      }
                   )
                }
            }
        } 

        TestMimSyncJoinRule -OutputPath "$env:TEMP\TestMimSyncJoinRule"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncJoinRule" -Force -Wait -Verbose 

        Test-DscConfiguration | Should Be False
    }
}
