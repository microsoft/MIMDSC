$dscResource = Get-DscResource -Module MimSyncDsc -Name MimSyncImportAttributePrecedence

Import-Module -Name $dscResource.Path -Force

Describe -Tag 'Build' 'MimSyncImportAttributePrecedence - calling Test-TargetResource Directly'{
    
    It 'MimSyncImportAttributePrecedence - desired state' {  
        $RankedPrecedenceOrder = @(
            New-CimInstance -ClassName MimSyncRankedPrecedenceOrder -Property @{Order = 0; ManagementAgentName='GrandHR'; CDObjectType='robot';  ID='{86E75ABE-B15D-4CFF-A785-BC968965A361}'}  -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration 
            New-CimInstance -ClassName MimSyncRankedPrecedenceOrder -Property @{Order = 1; ManagementAgentName='TinyHR';  CDObjectType='person'; ID='{385176D8-4EB8-4900-B627-DBAF137C8FF3}'} -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration 
            New-CimInstance -ClassName MimSyncRankedPrecedenceOrder -Property @{Order = 2; ManagementAgentName='TinyHR';  CDObjectType='person'; ID='{AF5CA310-1D8C-4669-95C2-1F7D0482CB8F}'} -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration 
            New-CimInstance -ClassName MimSyncRankedPrecedenceOrder -Property @{Order = 3; ManagementAgentName='TinyHR';  CDObjectType='person'; ID='{E1261AAA-DE1A-4AF0-8373-2C6C6FB76713}'} -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration
            
        ) -as [CimInstance[]]   
        
        $dscResult = Test-TargetResource -MVObjectType Contact -MVAttribute DisplayName -Type ranked -RankedPrecedenceOrder $RankedPrecedenceOrder -Verbose

        $dscResult | Should be True
    }

    It 'MimSyncImportAttributePrecedence - incorrect order' {  
        $RankedPrecedenceOrder = @(
            New-CimInstance -ClassName MimSyncRankedPrecedenceOrder -Property @{Order = 0; ManagementAgentName='GrandHR'; CDObjectType='robot';  ID='{86E75ABE-B15D-4CFF-A785-BC968965A361}'}  -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration 
            New-CimInstance -ClassName MimSyncRankedPrecedenceOrder -Property @{Order = 3; ManagementAgentName='TinyHR';  CDObjectType='person'; ID='{385176D8-4EB8-4900-B627-DBAF137C8FF3}'} -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration 
            New-CimInstance -ClassName MimSyncRankedPrecedenceOrder -Property @{Order = 2; ManagementAgentName='TinyHR';  CDObjectType='person'; ID='{AF5CA310-1D8C-4669-95C2-1F7D0482CB8F}'} -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration 
            New-CimInstance -ClassName MimSyncRankedPrecedenceOrder -Property @{Order = 1; ManagementAgentName='TinyHR';  CDObjectType='person'; ID='{E1261AAA-DE1A-4AF0-8373-2C6C6FB76713}'} -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration
            
        ) -as [CimInstance[]]   
        
        $dscResult = Test-TargetResource -MVObjectType Contact -MVAttribute DisplayName -Type ranked -RankedPrecedenceOrder $RankedPrecedenceOrder -Verbose

        $dscResult | Should be False
    }

    It 'MimSyncImportAttributePrecedence - incorrect type' {  
        $RankedPrecedenceOrder = @(
            New-CimInstance -ClassName MimSyncRankedPrecedenceOrder -Property @{Order = 0; ManagementAgentName='GrandHR'; CDObjectType='robot';  ID='{86E75ABE-B15D-4CFF-A785-BC968965A361}'}  -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration 
            New-CimInstance -ClassName MimSyncRankedPrecedenceOrder -Property @{Order = 3; ManagementAgentName='TinyHR';  CDObjectType='person'; ID='{385176D8-4EB8-4900-B627-DBAF137C8FF3}'} -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration 
            New-CimInstance -ClassName MimSyncRankedPrecedenceOrder -Property @{Order = 2; ManagementAgentName='TinyHR';  CDObjectType='person'; ID='{AF5CA310-1D8C-4669-95C2-1F7D0482CB8F}'} -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration 
            New-CimInstance -ClassName MimSyncRankedPrecedenceOrder -Property @{Order = 1; ManagementAgentName='TinyHR';  CDObjectType='person'; ID='{E1261AAA-DE1A-4AF0-8373-2C6C6FB76713}'} -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration
            
        ) -as [CimInstance[]]   
        
        $dscResult = Test-TargetResource -MVObjectType Contact -MVAttribute DisplayName -Type equal -RankedPrecedenceOrder $RankedPrecedenceOrder -Verbose

        $dscResult | Should be False
    }

}

Describe -Tag 'Build' 'MimSyncImportAttributePrecedence - calling Get-TargetResource Directly'{
    It 'Existing Flow Precedence' {

        $dscResult = Get-TargetResource -MVObjectType Contact -MVAttribute DisplayName -Verbose

        $dscResult | Should Not Be Null    
    }

    It 'Existing Flow Precedence' {

        $dscResult = Get-TargetResource -MVObjectType Contact -MVAttribute DisplayName -Verbose

        $dscResult['Type'] | Should be 'ranked'        
    } 
    
    It 'Missing Flow Precedence' {

        $dscResult = Get-TargetResource -MVObjectType Contact -MVAttribute AccountName -Verbose

        (-not $dscResult) | Should Be True    
    }  
}

Describe -Tag 'RunsInLocalConfigurationManager' 'MimSyncRunProfile - using the Local Configuration Manager'{
    It 'MimSyncRunProfile - desired state' {
        Configuration TestMimSyncImportAttributePrecedenceConfig 
        { 
            Import-DscResource -ModuleName MimSyncDsc

            Node (hostname) 
            { 
                ImportAttributePrecedence 'Contact-DisplayName'
                {
                   MVObjectType           = 'Contact'
                   MVAttribute            = 'DisplayName'
                   Type                   = 'ranked'
                   RankedPrecedenceOrder  = @(
                      RankedPrecedenceOrder{Order = 0; ManagementAgentName='GrandHR'; CDObjectType='robot';  ID='{86E75ABE-B15D-4CFF-A785-BC968965A361}'}
                      RankedPrecedenceOrder{Order = 1; ManagementAgentName='TinyHR';  CDObjectType='person'; ID='{385176D8-4EB8-4900-B627-DBAF137C8FF3}'}
                      RankedPrecedenceOrder{Order = 2; ManagementAgentName='TinyHR';  CDObjectType='person'; ID='{AF5CA310-1D8C-4669-95C2-1F7D0482CB8F}'}
                      RankedPrecedenceOrder{Order = 3; ManagementAgentName='TinyHR';  CDObjectType='person'; ID='{E1261AAA-DE1A-4AF0-8373-2C6C6FB76713}'}                      
                   )
                }
            }
        } 

        TestMimSyncImportAttributePrecedenceConfig -OutputPath "$env:TEMP\TestMimSyncImportAttributePrecedenceConfig"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncImportAttributePrecedenceConfig" -Force -Wait -Verbose 

        Test-DscConfiguration | Should Be True
    }
}
