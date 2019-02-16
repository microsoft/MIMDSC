
$dscResource = Get-DscResource -Module MimSyncDsc -Name MimSyncImportAttributeFlowRule

Import-Module -Name $dscResource.Path -Force

Describe -Tag 'Build' 'MimSyncImportAttributeFlowRule - calling Test-TargetResource Directly'{
    It 'Direct IAF Rule - desired state' {

        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -SrcAttribute FirstName -CDObjectType person -Type 'direct-mapping' -MVAttribute FirstName -Ensure Present -Verbose

        $dscResult | Should be True
    }

    It 'Direct IAF Rule - rogue state' {

        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -SrcAttribute FirstName -CDObjectType person -Type 'direct-mapping' -MVAttribute SamAccountName -Ensure Present -Verbose

        $dscResult | Should be False
    }

    It 'Direct IAF Rule - missing IAF rule' {

        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -SrcAttribute FirstName -CDObjectType person -Type 'direct-mapping' -MVAttribute Initial -Ensure Present -Verbose

        $dscResult | Should be False
    }

    It 'Direct-Mapping IAF Rule - dn-mapping desired state' {

        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -SrcAttribute dn -CDObjectType person -Type 'direct-mapping' -MVAttribute Fax -Ensure Present -Verbose

        $dscResult | Should be True
    }

    It 'Scripted IAF Rule - desired state' {

        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -SrcAttribute FirstName,Initial,LastName,Title -CDObjectType person -Type 'scripted-mapping' -MVAttribute DisplayName -ScriptContext 'cd.person:FirstName,LastName->mv.SyncObject:DisplayName' -Ensure Present -Verbose

        $dscResult | Should be True
    }

    It 'Scripted IAF Rule - missing one source attribute' {

        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -SrcAttribute FirstName,LastName,Title -CDObjectType person -Type 'scripted-mapping' -MVAttribute DisplayName -ScriptContext 'cd.person:FirstName,LastName->mv.SyncObject:DisplayName' -Ensure Present -Verbose

        $dscResult | Should be False
    }

    It 'Scripted IAF Rule - missing IAF rule' {

        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -SrcAttribute FirstName,LastName,Title -CDObjectType person -Type 'scripted-mapping' -MVAttribute Oid -ScriptContext 'cd.person:FirstName,LastName->mv.SyncObject:DisplayName' -Ensure Present -Verbose

        $dscResult | Should be False
    }    

    It 'Constant IAF Rule - desired state' {

        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -MVAttribute OnPremiseObjectType -CDObjectType person -Type 'constant-mapping' -ConstantValue 'superPerson' -Ensure Present -Verbose

        $dscResult | Should be True
    }
    
    It 'DN Mapping IAF Rule - desired state' {

        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -MVAttribute RetentionUrl -CDObjectType person -Type 'dn-part-mapping' -DNPart 3 -Ensure Present -Verbose

        $dscResult | Should be True
    }

    It 'DN Mapping IAF Rule - incorrect DN part' {

        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -MVAttribute RetentionUrl -CDObjectType person -Type 'dn-part-mapping' -DNPart 2 -Ensure Present -Verbose

        $dscResult | Should be False
    }
}

Describe -Tag 'Build' 'MimSyncImportAttributeFlowRule - calling Get-TargetResource Directly'{
    It 'Direct IAF Rule - desired state' {

        $dscResult = Get-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -MVAttribute SamAccountName -CDObjectType person -Type 'direct-mapping' -Verbose

        $dscResult['SrcAttribute'] | Should be 'UserID'        
    }

    It 'Scripted IAF Rule - desired state' {

        $dscResult = Get-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -MVAttribute DisplayName -CDObjectType person -Type 'scripted-mapping' -Verbose

        $dscResult['ScriptContext'] | Should be 'cd.person:FirstName,LastName->mv.SyncObject:DisplayName'        
    }

    It 'Direct EAF Rule - undesirable state' {
        $dscResult = Get-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObjects -MVAttribute SamAccountName -CDObjectType person -Type 'direct-mapping' -Verbose
        (-not $dscResult) | Should Be True
    }
}

Describe -Tag 'RunsInLocalConfigurationManager' 'MimSyncImportAttributeFlowRule - using the Local Configuration Manager'{
    It 'Direct IAF Rule - desired state' {
        Configuration TestMimSyncImportAttributeFlowRule 
        { 
            Import-DscResource -ModuleName MimSyncDsc

            Node (hostname) 
            { 
                ImportAttributeFlowRule TestMimSyncImportAttributeFlowRule
                {
                   ManagementAgentName    = 'TinyHR'
                   MVObjectType           = 'SyncObject'
                   MVAttribute            = 'FirstName'
                   CDObjectType           = 'person'
                   Type                   = 'direct-mapping'
                   SrcAttribute           = 'FirstName'
                   Ensure                 = 'Present'
                }
            }
        } 

        TestMimSyncImportAttributeFlowRule -OutputPath "$env:TEMP\TestMimSyncImportAttributeFlowRule"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncImportAttributeFlowRule" -Force -Wait -Verbose 

        $dscStatus = Get-DscConfigurationStatus

        $dscStatus.Status | Should Be 'Success'
    }

    It 'Direct IAF Rule - dn-mapping - desired state' {
        Configuration TestMimSyncImportAttributeFlowRule 
        { 
            Import-DscResource -ModuleName MimSyncDsc

            Node (hostname) 
            { 
                ImportAttributeFlowRule TestMimSyncImportAttributeFlowRule
                {
                   ManagementAgentName    = 'TinyHR'
                   MVObjectType           = 'SyncObject'
                   MVAttribute            = 'Fax'
                   CDObjectType           = 'person'
                   Type                   = 'direct-mapping'
                   SrcAttribute           = 'dn'                   
                   Ensure                 = 'Present'
                }
            }
        } 

        TestMimSyncImportAttributeFlowRule -OutputPath "$env:TEMP\TestMimSyncImportAttributeFlowRule"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncImportAttributeFlowRule" -Force -Wait -Verbose 

        $dscStatus = Get-DscConfigurationStatus

        $dscStatus.Status | Should Be 'Success'
    }

    It 'DN-Part-Mapping IAF Rule - desired state' {
        Configuration TestMimSyncImportAttributeFlowRule 
        { 
            Import-DscResource -ModuleName MimSyncDsc

            Node (hostname) 
            { 
                ImportAttributeFlowRule TestMimSyncImportAttributeFlowRule
                {
                   ManagementAgentName    = 'TinyHR'
                   MVObjectType           = 'SyncObject'
                   MVAttribute            = 'RetentionUrl'
                   CDObjectType           = 'person'
                   Type                   = 'dn-part-mapping'
                   DNPart                 = '3'                   
                   Ensure                 = 'Present'
                }
            }
        } 

        TestMimSyncImportAttributeFlowRule -OutputPath "$env:TEMP\TestMimSyncImportAttributeFlowRule"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncImportAttributeFlowRule" -Force -Wait -Verbose 

        $dscStatus = Get-DscConfigurationStatus

        $dscStatus.Status | Should Be 'Success'
    }

    It 'Scripted IAF Rule - multiple source attributes - desired state' {
        Configuration TestMimSyncImportAttributeFlowRule 
        { 
            Import-DscResource -ModuleName MimSyncDsc

            Node (hostname) 
            { 
                ImportAttributeFlowRule TestMimSyncImportAttributeFlowRule
                {
                   ManagementAgentName    = 'TinyHR'
                   MVObjectType           = 'SyncObject'
                   MVAttribute            = 'DisplayName'
                   CDObjectType           = 'person'
                   Type                   = 'scripted-mapping'
                   SrcAttribute           = 'FirstName','LastName','Initial','Title'
                   ScriptContext          = 'cd.person:FirstName,LastName->mv.SyncObject:DisplayName'                   
                   Ensure                 = 'Present'
                }
            }
        } 

        TestMimSyncImportAttributeFlowRule -OutputPath "$env:TEMP\TestMimSyncImportAttributeFlowRule"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncImportAttributeFlowRule" -Force -Wait -Verbose 

        $dscStatus = Get-DscConfigurationStatus

        $dscStatus.Status | Should Be 'Success'
    }

    It 'Constant IAF Rule - desired state' {
        Configuration TestMimSyncImportAttributeFlowRule 
        { 
            Import-DscResource -ModuleName MimSyncDsc

            Node (hostname) 
            { 
                ImportAttributeFlowRule TestMimSyncImportAttributeFlowRule
                {
                   ManagementAgentName    = 'TinyHR'
                   MVObjectType           = 'SyncObject'
                   MVAttribute            = 'OnPremiseObjectType'
                   CDObjectType           = 'person'
                   Type                   = 'constant-mapping'
                   ConstantValue          = 'superPerson'                   
                   Ensure                 = 'Present'
                }
            }
        } 

        TestMimSyncImportAttributeFlowRule -OutputPath "$env:TEMP\TestMimSyncImportAttributeFlowRule"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncImportAttributeFlowRule" -Force -Wait -Verbose 

        $dscStatus = Get-DscConfigurationStatus

        $dscStatus.Status | Should Be 'Success'
    }
}
