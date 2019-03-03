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

    #region MVOptions

    $mvData = Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) mv.xml) -XPath "//mv-data"
    $dscConfigScriptItems += @'
    MVOptions MimSyncMVOptions
    {{
        FakeIdentifier                   = 'MVOptions'
        ProvisioningType                 = '{0}'
        ExtensionAssemblyName            = '{1}'
        ExtensionApplicationProtection   = '{2}'
    }}
'@ -f @(
    $mvData.Node.provisioning.type
    $mvData.Node.extension.'assembly-name'
    $mvData.Node.extension.'application-protection'
)
    #endregion MVOptions

    #region MVDeletionRule

    $mvDeletionRules = Get-MimSyncMVDeletionRule
    foreach($mvDeletionRule in Get-MimSyncMVDeletionRule)
    {
        $dscConfigScriptItems += @'
        MVDeletionRule MimSyncMVDeletionRule{0}
        {{
            MVObjectType         = '{0}'
            Type                 = '{1}'
            ManagementAgentName  = @({2})
        }}
'@ -f @(
    $mvDeletionRule.MVObjectType
    $mvDeletionRule.Type
    (($mvDeletionRule.ManagementAgentName | ForEach-Object {"'$PSItem'"}) -join ',')
)
    }

    
    #endregion MVOptions

    #region MAData
    $maDatas = Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) *.xml) -XPath "//ma-data"
    foreach ($maData in $maDatas.Node)
    {
        $dscConfigScriptItems += @'
        MaData MimSyncMAData{0}
        {{
            Name    = '{0}'
            AttributeInclusion           = @({1})
            Category                 = '{2}'
            ControllerConfiguration = ControllerConfiguration{{
                ApplicationArchitecture = '{3}'
                ApplicationProtection   = '{4}'
            }}
            Extension = Extension{{
                AssemblyName            = '{5}'
                ApplicationProtection   = '{6}'
            }}
            PasswordSync = PasswordSync{{
                AllowLowSecurity        = ${7}
                MaximumRetryCount       = {8}
                RetryInterval           = {9}
            }}
            PasswordSyncAllowed         = ${10}
            ProvisioningCleanup = ProvisioningCleanup{{
                Type                    = '{11}'
                Action                  = '{12}'
            }}
            Ensure = 'Present'
        }}
'@ -f @(
        $maData.name
        (($maData.'attribute-inclusion'.attribute | ForEach-Object {"'$PSItem'"}) -join ",`n`t")
        $maData.category
        $maData.'controller-configuration'.'application-architecture'
        $maData.'controller-configuration'.'application-protection'
        $maData.extension.'assembly-name'
        $maData.extension.'application-protection'
        ($maData.'password-sync'.'allow-low-security' -as [int] -as [Boolean])
        $maData.'password-sync'.'maximum-retry-count'
        $maData.'password-sync'.'retry-interval'
        ($maData.'password-sync-allowed' -as [int] -as [Boolean])
        $maData.'provisioning-cleanup'.type
        $maData.'provisioning-cleanup'.action
        )
    }
    #endregion MAData

    #region MVObjectType
    $namespace = @{dsml="http://www.dsml.org/DSML"; 'ms-dsml'="http://www.microsoft.com/MMS/DSML"}

    $mvObjectTypes = Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) mv.xml) -XPath "//mv-data/schema/dsml:dsml/dsml:directory-schema/dsml:class" -Namespace $namespace
    foreach ($mvObjectType in $mvObjectTypes.Node)
    {
        $mvAttributes = ($mvObjectType.attribute | ForEach-Object { "MVAttributeBinding {ID='$($PSItem.ref)';   Required=`$$($PSItem.required)}"}) -join "`n`t"
        $dscConfigScriptItems += @'
        MVObjectType MVObjectType{0}
        {{
            ID    = '{0}'
            Type  = '{1}'
            Attributes = @(
                {2}
            )
            Ensure = 'Present'
        }}
'@ -f @(
        $mvObjectType.ID
        $mvObjectType.Type
        $mvAttributes
        )
    }
    #endregion MVObjectType

    #region MVAttributeType
    $namespace = @{dsml="http://www.dsml.org/DSML"; 'ms-dsml'="http://www.microsoft.com/MMS/DSML"}

    $mvAttributeTypes = Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) mv.xml) -XPath "//mv-data/schema/dsml:dsml/dsml:directory-schema/dsml:attribute-type" -Namespace $namespace
    foreach ($mvAttributeType in $mvAttributeTypes.Node)
    {
        $singleValue = 'false'
        if ($mvAttributeType.'single-value')
        {
            $singleValue = $mvAttributeType.'single-value'
        }

        $indexed = 'false'
        if ($mvAttributeType.indexed)
        {
            $indexed = $mvAttributeType.indexed
        }

        $indexable = 'false'
        if ($mvAttributeType.indexable)
        {
            $indexable = $mvAttributeType.indexable
        }

        $dscConfigScriptItems += @'
        MVAttributeType MVAttributeType{0}
        {{
            ID          = '{0}'
            SingleValue = ${1}
            Indexable   = ${2}
            Indexed     = ${3}
            Syntax      = '{4}'
            Ensure      = 'present'
        }}
'@ -f @(
        $mvAttributeType.id
        $singleValue
        $indexable
        $indexed
        $mvAttributeType.syntax
        )
    }
    #endregion MVAttributeType

    #region RunProfile
    $runProfiles = Get-MimSyncRunProfile

    foreach ($runProfile in $runProfiles) {    
        $runStepStrings = @()
        foreach($runStep in $runProfile.RunSteps)
        {
            $runStepStrings += @'
        RunStep{{
            StepType            = '{0}'
            StepSubType         = @({1})
            PartitionIdentifier = '{2}'
            InputFile           = '{3}'
            PageSize            = {4}
            Timeout             = {5}
            ObjectDeleteLimit   = {6}
            ObjectProcessLimit  = {7}
            LogFilePath         = '{8}' 
            DropFileName        = '{9}'
            FakeIdentifier      = '{10}'
        }}
'@ -f @(
            $runStep.StepType
            ($runStep.StepSubType | ForEach-Object { "'$PSItem'"}) -join ','
            $runStep.PartitionIdentifier
            $runStep.InputFile
            $runStep.PageSize
            $runStep.Timeout
            $runStep.ObjectDeleteLimit
            $runStep.ObjectProcessLimit
            $runStep.LogFilePath
            $runStep.DropFileName
            [Guid]::NewGuid().Guid
        )              
        } 
        $dscConfigScriptItems += @'
    RunProfile '[{0}]{1}'
    {{   
        ManagementAgentName    = '{0}'        
        Name                   = '{1}'
        RunSteps               = @(
        {2}       
        )
        Ensure                 = 'Present'
    }}
'@ -f @(
            $runProfile.ManagementAgentName
            $runProfile.Name
            $runStepStrings -join "`n"            
        )           
    }

    #endregion RunProfile

    #region ImportAttributePrecedence
    $iafRules = Get-MimSyncImportAttributeFlow -ServerConfigurationFolder $Path | Sort-Object MVObjectType, MVAttribute, PrecedenceRank
    $iafRules | Group-Object MVObjectType, MVAttribute | Where-Object Count -GT 1 | ForEach-Object {
        $mvObjectType = $PSItem.Group[0].MVObjectType
        $mvAttributeType = $PSItem.Group[0].MVAttribute
        $Type = $PSItem.Group[0].PrecedenceType

        if ($Type -eq 'ranked')
        {
            $rankedStrings = @()
            foreach($rankedItem in $PSItem.Group)
            {
                $rankedStrings += "RankedPrecedenceOrder{{Order = {0}; ManagementAgentName='{1}'; CDObjectType='{2}';  ID='{3}'}}" -f ($rankedItem.PrecedenceRank -1), $rankedItem.MAName, $rankedItem.CDObjectType, $rankedItem.ID
            }

            $dscConfigScriptItems += @'
            ImportAttributePrecedence '{0}-{1}'
            {{
                MVObjectType          = '{0}'
                MVAttribute           = '{1}'
                Type                  = '{2}'
                RankedPrecedenceOrder = @(
                    {3}
                )
            }}
'@ -f @(
            $mvObjectType
            $mvAttributeType
            $Type
            $rankedStrings -join "`n`t"
            )
        }
        else
        {
            $dscConfigScriptItems += @'
            ImportAttributePrecedence '{0}-{1}'
            {{
                MVObjectType = '{0}'
                MVAttribute  = '{1}'
                Type         = '{2}'
            }}
'@ -f @(
            $mvObjectType
            $mvAttributeType
            $Type
            )
        }
    }
    #endregion ImportAttributePrecedence

    #region MAData
    $maDatas = Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) *.xml) -XPath "//ma-data"
    foreach ($maData in $maDatas.Node)
    {
        foreach ($maPartition in $maData.'ma-partition-data'.partition)
        {  
                                                                                                                    $dscConfigScriptItems += @'
        MimSyncMAPartitionData '[{0}]{1}'
        {{
            ManagementAgentName   = '{0}'
            Name                  = '{1}'
            Selected              = ${2} 
            ObjectClassInclusions = @(
                {3}
            )
            ContainerExclusions   = @(
                {4}
            )
            ContainerInclusions   = @(
                {5}
            )
            Ensure                = 'Present'
        }}
'@ -f @(
            $maData.name
            $maPartition.name
            $maPartition.selected -as [Int] -as [Boolean]
            (($maPartition.filter.'object-classes'.'object-class' | ForEach-Object {"'$PSItem'"}) -join ",`n`t")
            (($maPartition.filter.containers.exclusions.exclusion | ForEach-Object {"'$PSItem'"}) -join ",`n`t")
            (($maPartition.filter.containers.inclusions.inclusion | ForEach-Object {"'$PSItem'"}) -join ",`n`t")            
            )
        }
    }
    #endregion MAData

    #region MAPrivateConfiguration
    Write-Warning 'Skipping MAPrivateConfiguration...'
    #endregion MAPrivateConfiguration

    $dscConfigScriptItems

}
