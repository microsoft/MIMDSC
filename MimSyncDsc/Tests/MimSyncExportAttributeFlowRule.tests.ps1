
#Get-MimSyncServerXml -Path (Get-MimSyncConfigCache) -Force

$dscResource = Get-DscResource -Module MimSyncDsc -Name MimSyncExportAttributeFlowRule

Import-Module -Name $dscResource.Path -Force

Describe -Tag 'Build' 'MimSyncExportAttributeFlowRule - calling Test-TargetResource Directly'{
    It 'Direct EAF Rule - desired state' {

        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -CDAttribute JobTitle -CDObjectType person -Type 'direct-mapping' -SrcAttribute Title -SuppressDeletions $false -Ensure Present -Verbose

        $dscResult | Should be True
    }

    It 'Scripted EAF Rule - desired state' {

        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -CDAttribute HireDate -CDObjectType person -Type 'scripted-mapping' -SrcAttribute 'object-id' -ScriptContext 'cd.person:HireDate<-mv.SyncObject:<object-id>' -SuppressDeletions $true -Ensure Present -Verbose

        $dscResult | Should be True
    }

    It 'Scripted EAF Rule - multiple source attributes - desired state' {

        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -CDAttribute Initial -CDObjectType person -Type 'scripted-mapping' -SrcAttribute 'Alias','FirstName','LastName' -ScriptContext 'cd.person:Initial<-mv.SyncObject:Alias,FirstName,LastName' -SuppressDeletions $false -Ensure Present -Verbose

        $dscResult | Should be True
    }

    It 'Scripted EAF Rule - multiple source attributes - incorrect suppress-deletion' {

        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -CDAttribute Initial -CDObjectType person -Type 'scripted-mapping' -SrcAttribute 'Alias','FirstName','LastName' -ScriptContext 'cd.person:Initial<-mv.SyncObject:Alias,FirstName,LastName' -SuppressDeletions $true -Ensure Present -Verbose

        $dscResult | Should be False
    }

    It 'Scripted EAF Rule - multiple source attributes - incorrect src-attribute' {

        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -CDAttribute Initial -CDObjectType person -Type 'scripted-mapping' -SrcAttribute 'Alias','FirstName','LastName','MiddleName' -ScriptContext 'cd.person:Initial<-mv.SyncObject:Alias,FirstName,LastName' -SuppressDeletions $false -Ensure Present -Verbose

        $dscResult | Should be False
    }

    It 'Constant EAF Rule - desired state' {

        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -CDAttribute Status -CDObjectType person -Type 'constant-mapping' -ConstantValue 'AlwaysThisLate' -Ensure Present -Verbose

        $dscResult | Should be True
    }
    
    It 'Constant EAF Rule - incorrect contant-value' {

        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -CDAttribute Status -CDObjectType person -Type 'constant-mapping' -ConstantValue 'AllTheBaseAre ' -Ensure Present -Verbose

        $dscResult | Should be False
    }

    It 'Constant EAF Rule - missing EAF rule' {

        $dscResult = Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -CDAttribute Foo -CDObjectType person -Type 'constant-mapping' -ConstantValue 'AllTheBaseAre ' -Ensure Present -Verbose

        $dscResult | Should be False
    }
}


Describe -Tag 'Build' 'MimSyncExportAttributeFlowRule - calling Get-TargetResource Directly'{
    It 'Direct EAF Rule - desired state' {

        $dscResult = Get-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -CDAttribute JobTitle -CDObjectType person -Type 'direct-mapping' -Verbose

        $dscResult['SrcAttribute'] | Should be 'Title'        
    }

    It 'Scripted EAF Rule - desired state' {

        $dscResult = Get-TargetResource  -ManagementAgentName TinyHR -MVObjectType SyncObject -CDAttribute HireDate -CDObjectType person -Type 'scripted-mapping' -Verbose

        $dscResult['SrcAttribute'] | Should be 'object-id'        
    }

    It 'Direct EAF Rule - undesirable state' {
        {Get-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -CDAttribute JobTitles -CDObjectType person -Type 'direct-mapping' -Verbose} | Should Throw
    }
}


Describe -Tag 'RunsInLocalConfigurationManager' 'MimSyncExportAttributeFlowRule - using the Local Configuration Manager'{
    It 'Direct EAF Rule - desired state' {
        Configuration TestMimSyncExportAttributeFlowRule 
        { 
            Import-DscResource -ModuleName MimSyncDsc

            Node (hostname) 
            { 
                ExportAttributeFlowRule TestMimSyncExportAttributeFlowRule
                {
                   ManagementAgentName    = 'TinyHR'
                   MVObjectType           = 'SyncObject'
                   CDAttribute            = 'JobTitle'
                   CDObjectType           = 'person'
                   Type                   = 'direct-mapping'
                   SrcAttribute           = 'Title'
                   SuppressDeletions      = $false
                   Ensure                 = 'Present'
                }
            }
        } 

        TestMimSyncExportAttributeFlowRule -OutputPath "$env:TEMP\TestMimSyncExportAttributeFlowRule"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncExportAttributeFlowRule" -Force -Wait -Verbose 

        $dscStatus = Get-DscConfigurationStatus

        $dscStatus.Status | Should Be 'Success'
    }

    It 'Scripted EAF Rule - desired state' {
        Configuration TestMimSyncExportAttributeFlowRule 
        { 
            Import-DscResource -ModuleName MimSyncDsc

            Node (hostname) 
            { 
                ExportAttributeFlowRule TestMimSyncExportAttributeFlowRule
                {
                   ManagementAgentName    = 'TinyHR'
                   MVObjectType           = 'SyncObject'
                   CDAttribute            = 'HireDate'
                   CDObjectType           = 'person'
                   Type                   = 'scripted-mapping'
                   SrcAttribute           = 'object-id'
                   ScriptContext          = 'cd.person:HireDate<-mv.SyncObject:<object-id>'
                   SuppressDeletions      = $true
                   Ensure                 = 'Present'
                }
            }
        } 

        TestMimSyncExportAttributeFlowRule -OutputPath "$env:TEMP\TestMimSyncExportAttributeFlowRule"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncExportAttributeFlowRule" -Force -Wait -Verbose 

        $dscStatus = Get-DscConfigurationStatus

        $dscStatus.Status | Should Be 'Success'
    }

    It 'Scripted EAF Rule - multiple source attributes - desired state' {
        Configuration TestMimSyncExportAttributeFlowRule 
        { 
            Import-DscResource -ModuleName MimSyncDsc

            Node (hostname) 
            { 
                ExportAttributeFlowRule TestMimSyncExportAttributeFlowRule
                {
                   ManagementAgentName    = 'TinyHR'
                   MVObjectType           = 'SyncObject'
                   CDAttribute            = 'Initial'
                   CDObjectType           = 'person'
                   Type                   = 'scripted-mapping'
                   SrcAttribute           = 'Alias','FirstName','LastName'
                   ScriptContext          = 'cd.person:Initial<-mv.SyncObject:Alias,FirstName,LastName'
                   SuppressDeletions      = $false
                   Ensure                 = 'Present'
                }
            }
        } 

        TestMimSyncExportAttributeFlowRule -OutputPath "$env:TEMP\TestMimSyncExportAttributeFlowRule"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncExportAttributeFlowRule" -Force -Wait -Verbose 

        $dscStatus = Get-DscConfigurationStatus

        $dscStatus.Status | Should Be 'Success'
    }

    It 'Constant EAF Rule - desired state' {
        Configuration TestMimSyncExportAttributeFlowRule 
        { 
            Import-DscResource -ModuleName MimSyncDsc

            Node (hostname) 
            { 
                ExportAttributeFlowRule TestMimSyncExportAttributeFlowRule
                {
                   ManagementAgentName    = 'TinyHR'
                   MVObjectType           = 'SyncObject'
                   CDAttribute            = 'Status'
                   CDObjectType           = 'person'
                   Type                   = 'constant-mapping'
                   ConstantValue          = 'AlwaysThisLate'
                   SuppressDeletions      = $true
                   Ensure                 = 'Present'
                }
            }
        } 

        TestMimSyncExportAttributeFlowRule -OutputPath "$env:TEMP\TestMimSyncExportAttributeFlowRule"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncExportAttributeFlowRule" -Force -Wait -Verbose 

        $dscStatus = Get-DscConfigurationStatus

        $dscStatus.Status | Should Be 'Success'
    }
}
