
Get-MimSyncServerXml -Path (Get-MimSyncConfigCache) -Force

$dscResource = Get-DscResource -Module MimSyncDsc -Name MimSyncExportAttributeFlowRule

ipmo $dscResource.Path -Force

#region TestMimSyncExportAttributeFlowRule - Direct Mapping
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
Start-DscConfiguration                    -Path "$env:TEMP\TestMimSyncExportAttributeFlowRule" -Force -Wait -Verbose   

Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -CDAttribute JobTitle -CDObjectType person -Type 'direct-mapping' -SrcAttribute Title -SuppressDeletions $false -Ensure Present -Verbose
Get-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -CDAttribute JobTitle -CDObjectType person -Type 'direct-mapping' -Verbose

#endregion

#region TestMimSyncExportAttributeFlowRule - Scripted Mapping with Intrinsic SrcAttribute
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
Start-DscConfiguration                    -Path "$env:TEMP\TestMimSyncExportAttributeFlowRule" -Force -Wait -Verbose   

Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -CDAttribute HireDate -CDObjectType person -Type 'scripted-mapping' -SrcAttribute 'object-id' -ScriptContext 'cd.person:HireDate<-mv.SyncObject:<object-id>' -SuppressDeletions $true -Ensure Present -Verbose
Set-TargetResource  -ManagementAgentName TinyHR -MVObjectType SyncObject -CDAttribute HireDate -CDObjectType person -Type 'scripted-mapping' -SrcAttribute 'object-id' -ScriptContext 'cd.person:HireDate<-mv.SyncObject:<object-id>' -SuppressDeletions $true -Ensure Present -Verbose
Get-TargetResource  -ManagementAgentName TinyHR -MVObjectType SyncObject -CDAttribute HireDate -CDObjectType person -Type 'scripted-mapping' -Verbose
#endregion

#region TestMimSyncExportAttributeFlowRule - Scripted Mapping
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
Start-DscConfiguration                    -Path "$env:TEMP\TestMimSyncExportAttributeFlowRule" -Force -Wait -Verbose   

Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -CDAttribute Initial -CDObjectType person -Type 'scripted-mapping' -SrcAttribute 'Alias','FirstName','LastName' -ScriptContext 'cd.person:Initial<-mv.SyncObject:Alias,FirstName,LastName' -SuppressDeletions $false -Ensure Present -Verbose
Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -CDAttribute Initial -CDObjectType person -Type 'scripted-mapping' -SrcAttribute 'Alias','FirstName','LastName' -ScriptContext 'cd.person:Initial<-mv.SyncObject:Alias,FirstName,LastName' -SuppressDeletions $true -Ensure Present -Verbose
Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -CDAttribute Initial -CDObjectType person -Type 'scripted-mapping' -SrcAttribute 'Alias','FirstName','LastName','MiddleName' -ScriptContext 'cd.person:Initial<-mv.SyncObject:Alias,FirstName,LastName' -SuppressDeletions $false -Ensure Present -Verbose
Set-TargetResource  -ManagementAgentName TinyHR -MVObjectType SyncObject -CDAttribute Initial -CDObjectType person -Type 'scripted-mapping' -SrcAttribute 'Alias','FirstName','LastName' -ScriptContext 'cd.person:Initial<-mv.SyncObject:Alias,FirstName,LastName' -SuppressDeletions $true -Ensure Present -Verbose
Get-TargetResource  -ManagementAgentName TinyHR -MVObjectType SyncObject -CDAttribute Initial -CDObjectType person -Type 'scripted-mapping' -Verbose
#endregion

#region TestMimSyncExportAttributeFlowRule - Constant Mapping
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
Start-DscConfiguration                    -Path "$env:TEMP\TestMimSyncExportAttributeFlowRule" -Force -Wait -Verbose   

Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -CDAttribute Status -CDObjectType person -Type 'constant-mapping' -ConstantValue 'AlwaysThisLate' -Ensure Present -Verbose
Test-TargetResource -ManagementAgentName TinyHR -MVObjectType SyncObject -CDAttribute FooBar -CDObjectType person -Type 'constant-mapping' -ConstantValue 'AllTheBaseAre ' -Ensure Present -Verbose

Set-TargetResource  -ManagementAgentName TinyHR -MVObjectType SyncObject -CDAttribute Status -CDObjectType person -Type 'constant-mapping' -ConstantValue 'AlwaysThisLate' -Ensure Present -Verbose
Get-TargetResource  -ManagementAgentName TinyHR -MVObjectType SyncObject -CDAttribute Status -CDObjectType person -Type 'constant-mapping' -Verbose
Get-TargetResource  -ManagementAgentName TinyHR -MVObjectType SyncObject -CDAttribute 3tatus -CDObjectType person -Type 'constant-mapping' -Verbose
#endregion
