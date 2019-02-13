
Get-SyncServerXml -Path (Get-MimSyncConfigCache) -Force

#region TestMimSyncExportAttributeFlowRule - Direct Mapping
Configuration TestMimSyncExportAttributeFlowRule 
{ 
    Import-DscResource -ModuleName MimSyncDsc

    Node (hostname) 
    { 
        ExportAttributeFlowRule TestMimSyncExportAttributeFlowRule
        {
           ManagementAgentName    = 'CORP AD'
           MVObjectType           = 'group'
           CDAttribute            = 'extensionAttribute5'
           CDObjectType           = 'group'
           Type                   = 'direct-mapping'
           SrcAttribute           = 'csObjectID'
           SuppressDeletions      = $true
           Ensure                 = 'Present'
        }
    }
} 

TestMimSyncExportAttributeFlowRule -OutputPath "$env:TEMP\TestMimSyncExportAttributeFlowRule"
Start-DscConfiguration                    -Path "$env:TEMP\TestMimSyncExportAttributeFlowRule" -Force -Wait -Verbose   

ipmo 'C:\Program Files\WindowsPowerShell\Modules\MimSyncDsc\DSCResources\MimSyncExportAttributeFlowRule\MimSyncExportAttributeFlowRule.psm1' -Force
Test-TargetResource -ManagementAgentName 'CORP AD' -MVObjectType group -CDAttribute extensionAttribute5 -CDObjectType group -Type 'direct-mapping' -SrcAttribute csObjectID -SuppressDeletions $true -Ensure Present -Verbose
Set-TargetResource  -ManagementAgentName 'CORP AD' -MVObjectType group -CDAttribute extensionAttribute5 -CDObjectType group -Type 'direct-mapping' -SrcAttribute csObjectID -SuppressDeletions $true -Ensure Present -Verbose
Get-TargetResource  -ManagementAgentName 'CORP AD' -MVObjectType group -CDAttribute extensionAttribute5 -CDObjectType group -Type 'direct-mapping' -Verbose
#endregion

#region TestMimSyncExportAttributeFlowRule - Scripted Mapping with Intrinsic SrcAttribute
Configuration TestMimSyncExportAttributeFlowRule 
{ 
    Import-DscResource -ModuleName MimSyncDsc

    Node (hostname) 
    { 
        ExportAttributeFlowRule TestMimSyncExportAttributeFlowRule
        {
           ManagementAgentName    = 'CORP AD'
           MVObjectType           = 'group'
           CDAttribute            = 'MVObjectID'
           CDObjectType           = 'group'
           Type                   = 'scripted-mapping'
           SrcAttribute           = 'object-id'
           ScriptContext          = 'cd.group:extensionAttribute9<-mv.group:<object-id>'
           SuppressDeletions      = $true
           Ensure                 = 'Present'
        }
    }
} 

TestMimSyncExportAttributeFlowRule -OutputPath "$env:TEMP\TestMimSyncExportAttributeFlowRule"
Start-DscConfiguration                    -Path "$env:TEMP\TestMimSyncExportAttributeFlowRule" -Force -Wait -Verbose   

ipmo 'C:\Program Files\WindowsPowerShell\Modules\MimSyncDsc\DSCResources\MimSyncExportAttributeFlowRule\MimSyncExportAttributeFlowRule.psm1' -Force
Test-TargetResource -ManagementAgentName 'CORP AD' -MVObjectType group -CDAttribute extensionAttribute9 -CDObjectType group -Type 'scripted-mapping' -SrcAttribute 'object-id' -ScriptContext 'cd.group:extensionAttribute9<-mv.group:<object-id>' -SuppressDeletions $true -Ensure Present -Verbose
Set-TargetResource  -ManagementAgentName 'CORP AD' -MVObjectType group -CDAttribute extensionAttribute9 -CDObjectType group -Type 'scripted-mapping' -SrcAttribute 'object-id' -ScriptContext 'cd.group:extensionAttribute9<-mv.group:<object-id>' -SuppressDeletions $true -Ensure Present -Verbose
Get-TargetResource  -ManagementAgentName 'CORP AD' -MVObjectType group -CDAttribute extensionAttribute9 -CDObjectType group -Type 'scripted-mapping' -Verbose
#endregion

#region TestMimSyncExportAttributeFlowRule - Scripted Mapping
Configuration TestMimSyncExportAttributeFlowRule 
{ 
    Import-DscResource -ModuleName MimSyncDsc

    Node (hostname) 
    { 
        ExportAttributeFlowRule TestMimSyncExportAttributeFlowRule
        {
           ManagementAgentName    = 'CORP AD'
           MVObjectType           = 'group'
           CDAttribute            = 'proxyAddresses'
           CDObjectType           = 'group'
           Type                   = 'scripted-mapping'
           SrcAttribute           = 'agManaged','legacyExchangeDNs'
           ScriptContext          = 'EAFLEGDNs'
           SuppressDeletions      = $true
           Ensure                 = 'Present'
        }
    }
} 

TestMimSyncExportAttributeFlowRule -OutputPath "$env:TEMP\TestMimSyncExportAttributeFlowRule"
Start-DscConfiguration                    -Path "$env:TEMP\TestMimSyncExportAttributeFlowRule" -Force -Wait -Verbose   

### Test the audit output
dir "$env:ProgramData\MimSyncDsc\Audit-TestTargetResource\*.clixml" | Select-Object -last 1 | Import-Clixml -ov AuditObject

ipmo 'C:\Program Files\WindowsPowerShell\Modules\MimSyncDsc\DSCResources\MimSyncExportAttributeFlowRule\MimSyncExportAttributeFlowRule.psm1' -Force
Test-TargetResource -ManagementAgentName 'CORP AD' -MVObjectType group -CDAttribute proxyAddresses -CDObjectType group -Type 'scripted-mapping' -SrcAttribute 'agManaged','legacyExchangeDNs' -ScriptContext 'EAFLEGDN' -SuppressDeletions $true -Ensure Present -Verbose
Set-TargetResource  -ManagementAgentName 'CORP AD' -MVObjectType group -CDAttribute proxyAddresses -CDObjectType group -Type 'scripted-mapping' -SrcAttribute 'agManaged','legacyExchangeDNs' -ScriptContext 'EAFLEGDN' -SuppressDeletions $true -Ensure Present -Verbose
Get-TargetResource  -ManagementAgentName 'CORP AD' -MVObjectType group -CDAttribute proxyAddresses -CDObjectType group -Type 'scripted-mapping' -Verbose
#endregion

#region TestMimSyncExportAttributeFlowRule - Constant Mapping
Configuration TestMimSyncExportAttributeFlowRule 
{ 
    Import-DscResource -ModuleName FimSyncPowerShellModule

    Node (hostname) 
    { 
        ExportAttributeFlowRule TestMimSyncExportAttributeFlowRule
        {
           ManagementAgentName    = 'CORP AD'
           MVObjectType           = 'group'
           CDAttribute            = 'description'
           CDObjectType           = 'group'
           Type                   = 'constant-mapping'
           ConstantValue          = 'foo'
           SuppressDeletions      = $true
           Ensure                 = 'Present'
        }
    }
} 

TestMimSyncExportAttributeFlowRule -OutputPath "$env:TEMP\TestMimSyncExportAttributeFlowRule"
Start-DscConfiguration                    -Path "$env:TEMP\TestMimSyncExportAttributeFlowRule" -Force -Wait -Verbose   

ipmo 'C:\Program Files\WindowsPowerShell\Modules\MimSyncDsc\DSCResources\MimSyncExportAttributeFlowRule\MimSyncExportAttributeFlowRule.psm1' -Force
Test-TargetResource -ManagementAgentName 'CORP AD' -MVObjectType group -CDAttribute description -CDObjectType group -Type 'constant-mapping' -ConstantValue 'foo' -Ensure Present -Verbose
Set-TargetResource  -ManagementAgentName 'CORP AD' -MVObjectType group -CDAttribute description -CDObjectType group -Type 'constant-mapping' -ConstantValue 'foo' -Ensure Present -Verbose
Get-TargetResource  -ManagementAgentName 'CORP AD' -MVObjectType group -CDAttribute description -CDObjectType group -Type 'constant-mapping' -Verbose
#endregion
