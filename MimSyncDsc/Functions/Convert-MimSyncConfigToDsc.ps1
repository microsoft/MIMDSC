function Convert-MimSyncConfigToDsc {
    <#
.Synopsis
   Convert the Sync Server Configuration XML to PowerShell Desired State Configuration strings
.DESCRIPTION
    1. Read configuration from the ma-data and mv-data XMLs
    2. Generate DSC configuration item strings
.EXAMPLE
   Convert-MimSyncConfigToDsc
.EXAMPLE
   Convert-MimSyncConfigToDsc -Path C:\Temp
#>
    [CmdletBinding()]
    Param
    (
        # Folder with the Sync Service configuration XML files (defaults to $env:ProgramData\MimSyncDsc\Svrexport)
        $Path = "$env:ProgramData\MimSyncDsc\Svrexport"
    )
    Write-Verbose "Using Path: $Path"

    $dscConfigScriptItems = @()

    #region EAF rules
    $eafRules = Get-MimSyncExportAttributeFlow -ServerConfigurationFolder $Path
    
    foreach ($eafRule in $eafRules) {    
        $SyncObjectID = ([Guid]$eafRule.ID).Guid #the curlies will break the DSC configuration string so need to remove them
        switch ($eafRule.RuleType) {
            'direct-mapping' {            
                $dscConfigScriptItems += @'
    ExportAttributeFlowRule {0}
    {{   
        ManagementAgentName    = '{1}'
        MVObjectType           = '{2}'
        CDAttribute            = '{3}'
        CDObjectType           = '{4}'
        Type                   = '{5}'
        SrcAttribute           = '{6}'
        SuppressDeletions      = ${7}
        Ensure                 = 'Present'
    }}
'@ -f @(
                    $SyncObjectID
                    $eafRule.MAName
                    $eafRule.MVObjectType
                    $eafRule.CDAttribute
                    $eafRule.CDObjectType
                    $eafRule.RuleType
                    $eafRule.MVAttribute
                    $eafRule.AllowNulls
                )
            
            }
            'scripted-mapping' {
                $mvAttribute = ($eafRule.MVAttribute | ForEach-Object {"'$PSItem'"}) -join ','
                $dscConfigScriptItems += @'
    ExportAttributeFlowRule {0}
    {{
        ManagementAgentName    = '{1}'
        MVObjectType           = '{2}'
        CDAttribute            = '{3}'
        CDObjectType           = '{4}'
        Type                   = '{5}'
        SrcAttribute           = {6}
        SuppressDeletions      = ${7}
        ScriptContext          = '{8}'
        Ensure                 = 'Present'
    }}
'@ -f @(
                    $SyncObjectID
                    $eafRule.MAName
                    $eafRule.MVObjectType
                    $eafRule.CDAttribute
                    $eafRule.CDObjectType
                    $eafRule.RuleType
                    $mvAttribute
                    $eafRule.AllowNulls
                    $eafRule.ScriptContext
                )       
            }  
            'constant-mapping' {            
                $dscConfigScriptItems += @'
    ExportAttributeFlowRule {0}
    {{
        ManagementAgentName    = '{1}'
        MVObjectType           = '{2}'
        CDAttribute            = '{3}'
        CDObjectType           = '{4}'
        Type                   = '{5}'
        ConstantValue          = '{6}'
        Ensure                 = 'Present'
    }}
'@ -f @(
                    $SyncObjectID
                    $eafRule.MAName
                    $eafRule.MVObjectType
                    $eafRule.CDAttribute
                    $eafRule.CDObjectType
                    $eafRule.RuleType
                    $eafRule.ConstantValue
                )
            
            }      
            Default {
                Write-Warning "Unexpected EAF rule type: $($eafRule.RuleType)"
            }
        }
    }

    #endregion EAF rules

    #region IAF rules
    $iafRules = Get-MimSyncImportAttributeFlow -ServerConfigurationFolder $Path
    
    foreach ($iafRule in $iafRules) {    
        $SyncObjectID = ([Guid]$iafRule.ID).Guid #the curlies will break the DSC configuration string so need to remove them
        switch ($iafRule.RuleType) {
            'direct-mapping' {            
                $dscConfigScriptItems += @'
    ImportAttributeFlowRule {0}
    {{   
        ManagementAgentName    = '{1}'
        MVObjectType           = '{2}'
        MVAttribute            = '{3}'
        CDObjectType           = '{4}'
        Type                   = '{5}'
        SrcAttribute           = '{6}'
        Ensure                 = 'Present'
    }}
'@ -f @(
                    $SyncObjectID
                    $iafRule.MAName
                    $iafRule.MVObjectType
                    $iafRule.MVAttribute
                    $iafRule.CDObjectType
                    $iafRule.RuleType
                    $iafRule.SrcAttribute
                )
            
            }
            'scripted-mapping' {
                $srcAttribute = ($iafRule.SrcAttribute | ForEach-Object {"'$PSItem'"}) -join ','
                $dscConfigScriptItems += @'
    ImportAttributeFlowRule {0}
    {{
        ManagementAgentName    = '{1}'
        MVObjectType           = '{2}'
        MVAttribute            = '{3}'
        CDObjectType           = '{4}'
        Type                   = '{5}'
        SrcAttribute           = {6}
        ScriptContext          = '{7}'
        Ensure                 = 'Present'
    }}
'@ -f @(
                    $SyncObjectID
                    $iafRule.MAName
                    $iafRule.MVObjectType
                    $iafRule.MVAttribute
                    $iafRule.CDObjectType
                    $iafRule.RuleType
                    $srcAttribute
                    $iafRule.ScriptContext
                )       
            }  
            'constant-mapping' {            
                $dscConfigScriptItems += @'
    ImportAttributeFlowRule {0}
    {{
        ManagementAgentName    = '{1}'
        MVObjectType           = '{2}'
        MVAttribute            = '{3}'
        CDObjectType           = '{4}'
        Type                   = '{5}'
        ConstantValue          = '{6}'
        Ensure                 = 'Present'
    }}
'@ -f @(
                    $SyncObjectID
                    $iafRule.MAName
                    $iafRule.MVObjectType
                    $iafRule.MVAttribute
                    $iafRule.CDObjectType
                    $iafRule.RuleType
                    $iafRule.ConstantValue
                )          
            }
            'dn-part-mapping' {            
                $dscConfigScriptItems += @'
    ImportAttributeFlowRule {0}
    {{
        ManagementAgentName    = '{1}'
        MVObjectType           = '{2}'
        MVAttribute            = '{3}'
        CDObjectType           = '{4}'
        Type                   = '{5}'
        DNPart                 = '{6}'
        Ensure                 = 'Present'
    }}
'@ -f @(
                    $SyncObjectID
                    $iafRule.MAName
                    $iafRule.MVObjectType
                    $iafRule.MVAttribute
                    $iafRule.CDObjectType
                    $iafRule.RuleType
                    $iafRule.DNPart
                )          
            }            
            Default {
                Write-Warning "Unexpected IAF rule type: $($iafRule.RuleType)"
            }
        }
    }      

    #endregion IAF rules

    #region Join rules
    $joinRules = Get-MimSyncJoinRule -ServerConfigurationFolder "$env:ProgramData\MimSyncDsc\Svrexport\"

    foreach ($joinRule in $joinRules) {    
        $joinCriteriaStrings = @()
        foreach($joinCriteria in $joinRule.JoinCriterion)
        {
            $attributeMappingStrings = @()
            foreach($attributeMapping in $joinCriteria.AttributeMapping)
            {
                $CDAttribute = ($attributeMapping.CDAttribute | ForEach-Object {"'$PSItem'"}) -join ','
                $attributeMappingStrings += @'
            AttributeMapping{{
                MappingType   = '{0}'
                MVAttribute   = '{1}'
                CDAttribute   = {2}
                ScriptContext = '{3}'
            }}
'@ -f @(
    $attributeMapping.MappingType
    $attributeMapping.MVAttribute
    $CDAttribute
    $attributeMapping.ScriptContext
)
            }

            $joinCriteriaStrings += @'
        JoinCriterion{{
            ID                      = {0}
            MVObjectType            = '{1}'
            ResolutionType          = '{2}'
            ResolutionScriptContext = '{3}'
            Order                   = {4}
            AttributeMapping        = @(
                {5}
            )
        }}
'@ -f @(
            $joinCriteria.ID
            $joinCriteria.MVObjectType
            $joinCriteria.ResolutionType
            $joinCriteria.ResolutionScriptContext
            $joinCriteria.Order
            ($attributeMappingStrings -join "`n")
        )              
        } 
        $dscConfigScriptItems += @'
    JoinRule {1}
    {{   
        ManagementAgentName    = '{0}'        
        CDObjectType           = '{1}'
        JoinCriterion          = @(
        {2}       
        )
        Ensure                 = 'Present'
    }}
'@ -f @(
            $joinRule.MAName
            $joinRule.CDObjectType
            $joinCriteriaStrings -join "`n"            
        )
            
    }
    #endregion Join rules

    #region Projection rules
    $projectionRules = Get-MimSyncProjectionRule -ServerConfigurationFolder "$env:ProgramData\MimSyncDsc\Svrexport\" 
    foreach ($projectionRule in $projectionRules) {
        $dscConfigScriptItems += @'
    ProjectionRule {1}
    {{   
        ManagementAgentName    = '{0}'        
        CDObjectType           = '{1}'
        Type                   = '{2}'
        MVObjectType           = '{3}'
        Ensure                 = 'Present'
    }}
'@ -f @(
    $projectionRule.MAName
    $projectionRule.CDObjectType
    $projectionRule.Type
    $projectionRule.MVObjectType
)
    }

    #endregion Projection rules

    $dscConfigScriptItems

}