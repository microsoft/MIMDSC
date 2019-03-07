
$dscResource = Get-DscResource -Module MimSyncDsc -Name MimSyncImportAttributeFlowRule

Import-Module -Name $dscResource.Path -Force

Describe -Tag 'Build' 'MimSyncImportAttributeFlowRule - calling Test-TargetResource Directly'{
    It 'Direct IAF Rule - desired state' {

        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -SrcAttribute FirstName -CDObjectType person -Type 'direct-mapping' -MVAttribute FirstName -FakeIdentifier foo -Ensure Present -Verbose

        $dscResult | Should be True
    }

    It 'Direct IAF Rule - rogue state' {

        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -SrcAttribute FirstName -CDObjectType person -Type 'direct-mapping' -MVAttribute SamAccountName -FakeIdentifier foo -Ensure Present -Verbose

        $dscResult | Should be False
    }

    It 'Direct IAF Rule - missing IAF rule' {

        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -SrcAttribute FirstName -CDObjectType person -Type 'direct-mapping' -MVAttribute Initial -FakeIdentifier foo -Ensure Present -Verbose

        $dscResult | Should be False
    }

    It 'Direct-Mapping IAF Rule - dn-mapping desired state' {

        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -SrcAttribute dn -CDObjectType person -Type 'direct-mapping' -MVAttribute Fax -FakeIdentifier foo -Ensure Present -Verbose

        $dscResult | Should be True
    }

    It 'Scripted IAF Rule - desired state' {

        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -SrcAttribute FirstName,Initial,LastName,Title -CDObjectType person -Type 'scripted-mapping' -MVAttribute DisplayName -ScriptContext 'cd.person:FirstName,LastName->mv.SyncObject:DisplayName' -FakeIdentifier foo -Ensure Present -Verbose

        $dscResult | Should be True
    }

    It 'Scripted IAF Rule - missing one source attribute' {

        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -SrcAttribute FirstName,LastName,Title -CDObjectType person -Type 'scripted-mapping' -MVAttribute DisplayName -ScriptContext 'cd.person:FirstName,LastName->mv.SyncObject:DisplayName' -FakeIdentifier foo -Ensure Present -Verbose

        $dscResult | Should be False
    }

    It 'Scripted IAF Rule - missing IAF rule' {

        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -SrcAttribute FirstName,LastName,Title -CDObjectType person -Type 'scripted-mapping' -MVAttribute Oid -ScriptContext 'cd.person:FirstName,LastName->mv.SyncObject:DisplayName' -FakeIdentifier foo -Ensure Present -Verbose

        $dscResult | Should be False
    }    

    It 'Constant IAF Rule - desired state' {

        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -MVAttribute OnPremiseObjectType -CDObjectType person -Type 'constant-mapping' -ConstantValue 'superPerson' -FakeIdentifier foo -Ensure Present -Verbose

        $dscResult | Should be True
    }
    
    It 'DN Mapping IAF Rule - desired state' {

        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -MVAttribute RetentionUrl -CDObjectType person -Type 'dn-part-mapping' -DNPart 3 -FakeIdentifier foo -Ensure Present -Verbose

        $dscResult | Should be True
    }

    It 'DN Mapping IAF Rule - incorrect DN part' {

        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -MVAttribute RetentionUrl -CDObjectType person -Type 'dn-part-mapping' -DNPart 2 -FakeIdentifier foo -Ensure Present -Verbose

        $dscResult | Should be False
    }
}

Describe -Tag 'Build' 'MimSyncImportAttributeFlowRule - calling Get-TargetResource Directly'{
    It 'Direct IAF Rule - desired state' {

        $dscResult = Get-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -MVAttribute SamAccountName -CDObjectType person -Type 'direct-mapping' -SrcAttribute UserID -FakeIdentifier foo -Verbose

        $dscResult['SrcAttribute'] | Should be 'UserID'        
    }

    It 'Scripted IAF Rule - desired state' {

        $dscResult = Get-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -MVAttribute DisplayName -CDObjectType person -Type 'scripted-mapping' -ScriptContext 'cd.person:FirstName,LastName->mv.SyncObject:DisplayName' -FakeIdentifier foo -Verbose

        $dscResult['ScriptContext'] | Should be 'cd.person:FirstName,LastName->mv.SyncObject:DisplayName'        
    }

    It 'DN-Part IAF Rule - desired state' {

        $dscResult = Get-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -MVAttribute RetentionUrl -CDObjectType person -Type 'dn-part-mapping' -DNPart 3 -FakeIdentifier foo -Verbose

        $dscResult['DNPart'] | Should be 3        
    }

    It 'Constant IAF Rule - desired state' {

        $dscResult = Get-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -MVAttribute OnPremiseObjectType -CDObjectType person -Type 'constant-mapping' -ConstantValue 'superPerson' -FakeIdentifier foo -Verbose

        $dscResult['ConstantValue'] | Should be 'superPerson'        
    }

    It 'Direct EAF Rule - undesirable state' {
        $dscResult = Get-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObjects -MVAttribute SamAccountName -CDObjectType person -Type 'direct-mapping' -FakeIdentifier foo -Verbose
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
                   FakeIdentifier         = 'foo'
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
                   FakeIdentifier         = 'foo'
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
                   FakeIdentifier         = 'foo'
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
                   FakeIdentifier         = 'foo'
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
                   FakeIdentifier         = 'foo'
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

    It 'Issue: IAF Rules with identical key properties' {
        Configuration TestMimSyncConfig 
        { 
            Import-DscResource -ModuleName MimSyncDsc

            Node (hostname) 
            { 
               ImportAttributeFlowRule af5ca310-1d8c-4669-95c2-1f7d0482cb8f
                {  
                    FakeIdentifier         = 'foo' 
                    ManagementAgentName    = 'TinyHR'
                    MVObjectType           = 'Contact'
                    MVAttribute            = 'DisplayName'
                    CDObjectType           = 'person'
                    Type                   = 'direct-mapping'
                    SrcAttribute           = 'LastName'
                    Ensure                 = 'Present'
                }
    
                ImportAttributeFlowRule e1261aaa-de1a-4af0-8373-2c6c6fb76713
                {   
                    FakeIdentifier         = 'bar'
                    ManagementAgentName    = 'TinyHR'
                    MVObjectType           = 'Contact'
                    MVAttribute            = 'DisplayName'
                    CDObjectType           = 'person'
                    Type                   = 'direct-mapping'
                    SrcAttribute           = 'FirstName'
                    Ensure                 = 'Present'
                }
            }
        } 
        {TestMimSyncConfig -OutputPath "$env:TEMP\TestMimSyncConfig" } | Should Not Throw       
    }
}
