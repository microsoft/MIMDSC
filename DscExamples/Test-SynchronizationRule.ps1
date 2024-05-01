Set-Location c:\MimDsc

#region Call the Set and Test methods directly - allows for setting a breakpoint for debuggering
Search-Resources -XPath "/SynchronizationRule" -ExpectedObjectType SynchronizationRule -MaxResults 5

ipmo MimDsc -Force
ipmo 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcSynchronizationRule\MimSvcSynchronizationRule.psm1' -Force
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcSynchronizationRule\MimSvcSynchronizationRule.psm1'
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\Functions\Test-MimSvcTargetResource.ps1'
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\Functions\Set-MimSvcTargetResource.ps1'

$testResourceProperties = @{
    ConnectedObjectType             = 'user'
    ConnectedSystemScope            = '<scoping><scope><csAttribute>extensionAttribute2</csAttribute><csOperator>NOTEQUAL</csOperator><csValue>-5</csValue></scope><scope><csAttribute>extensionAttribute2</csAttribute><csOperator>NOTEQUAL</csOperator><csValue>-7</csValue></scope><scope><csAttribute>extensionAttribute2</csAttribute><csOperator>NOTEQUAL</csOperator><csValue>-8</csValue></scope><scope><csAttribute>extensionAttribute2</csAttribute><csOperator>NOTEQUAL</csOperator><csValue>-9</csValue></scope><scope><csAttribute>extensionAttribute2</csAttribute><csOperator>NOTEQUAL</csOperator><csValue>-10</csValue></scope><scope><csAttribute>extensionAttribute2</csAttribute><csOperator>NOTEQUAL</csOperator><csValue>-6</csValue></scope></scoping>'
    CreateConnectedSystemObject     = $false
    CreateILMObject                 = $true
    Description                     = 'initial description'
    DisconnectConnectedSystemObject = $false
    DisplayName                     = 'Inbound Sync Rule _ AD User Import for CORP Forest'
    FlowType                        = 0
    ILMObjectType                   = 'person'
            
    ManagementAgentID               = 'CORP'
    PersistentFlow                  = @(
    '<import-flow><src><attr>extensionAttribute4</attr></src><dest>employeeID</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>extensionAttribute5</attr></src><dest>costCenter</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>givenName</attr></src><dest>firstName</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>mail</attr></src><dest>email</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>mailNickname</attr></src><dest>mailNickname</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>manager</attr></src><dest>manager</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>middleName</attr></src><dest>middleName</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>mobile</attr></src><dest>mobile</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>physicalDeliveryOfficeName</attr></src><dest>officeLocation</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>sAMAccountName</attr></src><dest>accountName</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>sn</attr></src><dest>lastName</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>telephoneNumber</attr></src><dest>officePhone</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>title</attr></src><dest>jobTitle</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>company</attr></src><dest>company</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>department</attr></src><dest>costCenterName</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>department</attr></src><dest>department</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>displayName</attr></src><dest>displayName</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>extensionAttribute2</attr></src><dest>employeeType</dest><scoping></scoping><fn id="IIF" isCustomExpression="true"><arg><fn id="Eq" isCustomExpression="false"><arg>extensionAttribute2</arg><arg>"50"</arg></fn></arg><arg>"Full Time Employee"</arg><arg><fn id="IIF" isCustomExpression="false"><arg><fn id="Eq" isCustomExpression="false"><arg>extensionAttribute2</arg><arg>"53"</arg></fn></arg><arg>"Intern"</arg><arg><fn id="IIF" isCustomExpression="false"><arg><fn id="Eq" isCustomExpression="false"><arg>extensionAttribute2</arg><arg>"90"</arg></fn></arg><arg>"Contractor"</arg><arg><fn id="IIF" isCustomExpression="false"><arg><fn id="Eq" isCustomExpression="false"><arg>extensionAttribute2</arg><arg>"92"</arg></fn></arg><arg>"Vendor"</arg><arg>"Legacy"</arg></fn></arg></fn></arg></fn></arg></fn></import-flow>'
    )
    Precedence                      = 1
    RelationshipCriteria            = '<conditions><condition><ilmAttribute>employeeID</ilmAttribute><csAttribute>extensionAttribute4</csAttribute></condition></conditions>'
    Ensure						= 'Present'
}

Test-MimSvcTargetResource -ObjectType Resource -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

Set-MimSvcTargetResource -ObjectType Resource -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

#endregion


#region: Test for an existing SychronizationRule
$syncRule = New-Resource -ObjectType SychronizationRule

$syncRule.DisplayName                    = 'Inbound Sync Rule _ AD User Import for CORP Forest'
$syncRule.Description                    = 'initial description'
$syncRule.ManagementAgentID              = (Get-FimObjectID -ObjectType 'ma-data' -AttributeName DisplayName -AttributeValue CORP)
$syncRule.ExternalSystemResourceType     = 'user'
$syncRule.MetaverseResourceType          = 'person'
$syncRule.CreateResourceInExternalSystem = $false
$syncRule.CreateResourceInFIM            = $true
$syncRule.Direction                      = 'Inbound'
$syncRule.Precedence                     = 1
$syncRule.RelationshipCriteria           = '<conditions><condition><ilmAttribute>employeeID</ilmAttribute><csAttribute>extensionAttribute4</csAttribute></condition></conditions>'
$syncRule.ExternalSystemScopingFilter    = '<scoping><scope><csAttribute>extensionAttribute2</csAttribute><csOperator>NOTEQUAL</csOperator><csValue>-5</csValue></scope><scope><csAttribute>extensionAttribute2</csAttribute><csOperator>NOTEQUAL</csOperator><csValue>-7</csValue></scope><scope><csAttribute>extensionAttribute2</csAttribute><csOperator>NOTEQUAL</csOperator><csValue>-8</csValue></scope><scope><csAttribute>extensionAttribute2</csAttribute><csOperator>NOTEQUAL</csOperator><csValue>-9</csValue></scope><scope><csAttribute>extensionAttribute2</csAttribute><csOperator>NOTEQUAL</csOperator><csValue>-10</csValue></scope><scope><csAttribute>extensionAttribute2</csAttribute><csOperator>NOTEQUAL</csOperator><csValue>-6</csValue></scope></scoping>'
$syncRule.PersistentFlowRules            = @(
    '<import-flow><src><attr>extensionAttribute4</attr></src><dest>employeeID</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>extensionAttribute5</attr></src><dest>costCenter</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>givenName</attr></src><dest>firstName</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>mail</attr></src><dest>email</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>mailNickname</attr></src><dest>mailNickname</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>manager</attr></src><dest>manager</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>middleName</attr></src><dest>middleName</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>mobile</attr></src><dest>mobile</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>physicalDeliveryOfficeName</attr></src><dest>officeLocation</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>sAMAccountName</attr></src><dest>accountName</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>sn</attr></src><dest>lastName</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>telephoneNumber</attr></src><dest>officePhone</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>title</attr></src><dest>jobTitle</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>company</attr></src><dest>company</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>department</attr></src><dest>costCenterName</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>department</attr></src><dest>department</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>displayName</attr></src><dest>displayName</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>extensionAttribute2</attr></src><dest>employeeType</dest><scoping></scoping><fn id="IIF" isCustomExpression="true"><arg><fn id="Eq" isCustomExpression="false"><arg>extensionAttribute2</arg><arg>"50"</arg></fn></arg><arg>"Full Time Employee"</arg><arg><fn id="IIF" isCustomExpression="false"><arg><fn id="Eq" isCustomExpression="false"><arg>extensionAttribute2</arg><arg>"53"</arg></fn></arg><arg>"Intern"</arg><arg><fn id="IIF" isCustomExpression="false"><arg><fn id="Eq" isCustomExpression="false"><arg>extensionAttribute2</arg><arg>"90"</arg></fn></arg><arg>"Contractor"</arg><arg><fn id="IIF" isCustomExpression="false"><arg><fn id="Eq" isCustomExpression="false"><arg>extensionAttribute2</arg><arg>"92"</arg></fn></arg><arg>"Vendor"</arg><arg>"Legacy"</arg></fn></arg></fn></arg></fn></arg></fn></import-flow>'
    )
$syncRule | Save-Resource

Configuration TestSynchronizationRule 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        SynchronizationRule TestSyncRule
        {
            ConnectedObjectType             = 'user'
            ConnectedSystemScope            = '<scoping><scope><csAttribute>extensionAttribute2</csAttribute><csOperator>NOTEQUAL</csOperator><csValue>-5</csValue></scope><scope><csAttribute>extensionAttribute2</csAttribute><csOperator>NOTEQUAL</csOperator><csValue>-7</csValue></scope><scope><csAttribute>extensionAttribute2</csAttribute><csOperator>NOTEQUAL</csOperator><csValue>-8</csValue></scope><scope><csAttribute>extensionAttribute2</csAttribute><csOperator>NOTEQUAL</csOperator><csValue>-9</csValue></scope><scope><csAttribute>extensionAttribute2</csAttribute><csOperator>NOTEQUAL</csOperator><csValue>-10</csValue></scope><scope><csAttribute>extensionAttribute2</csAttribute><csOperator>NOTEQUAL</csOperator><csValue>-6</csValue></scope></scoping>'
            CreateConnectedSystemObject     = $false
            CreateILMObject                 = $true
            Description                     = 'initial description'
            DisconnectConnectedSystemObject = $false
            DisplayName                     = 'Inbound Sync Rule _ AD User Import for CORP Forest'
            FlowType                        = 0
            ILMObjectType                   = 'person'           
            ManagementAgentID               = 'CORP'
            PersistentFlow                  = @(
    '<import-flow><src><attr>extensionAttribute4</attr></src><dest>employeeID</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>extensionAttribute5</attr></src><dest>costCenter</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>givenName</attr></src><dest>firstName</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>mail</attr></src><dest>email</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>mailNickname</attr></src><dest>mailNickname</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>manager</attr></src><dest>manager</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>middleName</attr></src><dest>middleName</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>mobile</attr></src><dest>mobile</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>physicalDeliveryOfficeName</attr></src><dest>officeLocation</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>sAMAccountName</attr></src><dest>accountName</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>sn</attr></src><dest>lastName</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>telephoneNumber</attr></src><dest>officePhone</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>title</attr></src><dest>jobTitle</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>company</attr></src><dest>company</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>department</attr></src><dest>costCenterName</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>department</attr></src><dest>department</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>displayName</attr></src><dest>displayName</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>extensionAttribute2</attr></src><dest>employeeType</dest><scoping></scoping><fn id="IIF" isCustomExpression="true"><arg><fn id="Eq" isCustomExpression="false"><arg>extensionAttribute2</arg><arg>"50"</arg></fn></arg><arg>"Full Time Employee"</arg><arg><fn id="IIF" isCustomExpression="false"><arg><fn id="Eq" isCustomExpression="false"><arg>extensionAttribute2</arg><arg>"53"</arg></fn></arg><arg>"Intern"</arg><arg><fn id="IIF" isCustomExpression="false"><arg><fn id="Eq" isCustomExpression="false"><arg>extensionAttribute2</arg><arg>"90"</arg></fn></arg><arg>"Contractor"</arg><arg><fn id="IIF" isCustomExpression="false"><arg><fn id="Eq" isCustomExpression="false"><arg>extensionAttribute2</arg><arg>"92"</arg></fn></arg><arg>"Vendor"</arg><arg>"Legacy"</arg></fn></arg></fn></arg></fn></arg></fn></import-flow>'
    )
            Precedence                      = 1
            RelationshipCriteria            = '<conditions><condition><ilmAttribute>employeeID</ilmAttribute><csAttribute>extensionAttribute4</csAttribute></condition></conditions>'
            Ensure		                    = 'Present'
        }
    } 
} 

TestSynchronizationRule

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestSynchronizationRule" -Force
#endregion

#region: New SychronizationRule (Inbound)
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestSynchronizationRule 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        SynchronizationRule "TestSyncRule$randomNumber"
        {
            ConnectedObjectType             = 'user'
            ConnectedSystemScope            = '<scoping><scope><csAttribute>extensionAttribute2</csAttribute><csOperator>NOTEQUAL</csOperator><csValue>-5</csValue></scope><scope><csAttribute>extensionAttribute2</csAttribute><csOperator>NOTEQUAL</csOperator><csValue>-7</csValue></scope><scope><csAttribute>extensionAttribute2</csAttribute><csOperator>NOTEQUAL</csOperator><csValue>-8</csValue></scope><scope><csAttribute>extensionAttribute2</csAttribute><csOperator>NOTEQUAL</csOperator><csValue>-9</csValue></scope><scope><csAttribute>extensionAttribute2</csAttribute><csOperator>NOTEQUAL</csOperator><csValue>-10</csValue></scope><scope><csAttribute>extensionAttribute2</csAttribute><csOperator>NOTEQUAL</csOperator><csValue>-6</csValue></scope></scoping>'
            CreateConnectedSystemObject     = $false
            CreateILMObject                 = $true
            Description                     = 'initial description'
            DisconnectConnectedSystemObject = $false
            DisplayName                     = "TestSyncRule$randomNumber"
            FlowType                        = 0
            ILMObjectType                   = 'person'           
            ManagementAgentID               = 'CORP'
            PersistentFlow                  = @(
    '<import-flow><src><attr>extensionAttribute4</attr></src><dest>employeeID</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>extensionAttribute5</attr></src><dest>costCenter</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>givenName</attr></src><dest>firstName</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>mail</attr></src><dest>email</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>mailNickname</attr></src><dest>mailNickname</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>manager</attr></src><dest>manager</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>middleName</attr></src><dest>middleName</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>mobile</attr></src><dest>mobile</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>physicalDeliveryOfficeName</attr></src><dest>officeLocation</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>sAMAccountName</attr></src><dest>accountName</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>sn</attr></src><dest>lastName</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>telephoneNumber</attr></src><dest>officePhone</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>title</attr></src><dest>jobTitle</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>company</attr></src><dest>company</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>department</attr></src><dest>costCenterName</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>department</attr></src><dest>department</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>displayName</attr></src><dest>displayName</dest><scoping></scoping></import-flow>'
    '<import-flow><src><attr>extensionAttribute2</attr></src><dest>employeeType</dest><scoping></scoping><fn id="IIF" isCustomExpression="true"><arg><fn id="Eq" isCustomExpression="false"><arg>extensionAttribute2</arg><arg>"50"</arg></fn></arg><arg>"Full Time Employee"</arg><arg><fn id="IIF" isCustomExpression="false"><arg><fn id="Eq" isCustomExpression="false"><arg>extensionAttribute2</arg><arg>"53"</arg></fn></arg><arg>"Intern"</arg><arg><fn id="IIF" isCustomExpression="false"><arg><fn id="Eq" isCustomExpression="false"><arg>extensionAttribute2</arg><arg>"90"</arg></fn></arg><arg>"Contractor"</arg><arg><fn id="IIF" isCustomExpression="false"><arg><fn id="Eq" isCustomExpression="false"><arg>extensionAttribute2</arg><arg>"92"</arg></fn></arg><arg>"Vendor"</arg><arg>"Legacy"</arg></fn></arg></fn></arg></fn></arg></fn></import-flow>'
    )
            Precedence                      = 1
            RelationshipCriteria            = '<conditions><condition><ilmAttribute>employeeID</ilmAttribute><csAttribute>extensionAttribute4</csAttribute></condition></conditions>'
            Ensure		                    = 'Present'
        }
    } 
} 

TestSynchronizationRule

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestSynchronizationRule" -Force
#endregion

#region: New SychronizationRule (Outbound)
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestSynchronizationRule 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        SynchronizationRule "TestSyncRule$randomNumber"
        {
            ConnectedObjectType             = 'user'
            ConnectedSystemScope            = '<scoping><scope><csAttribute>extensionAttribute2</csAttribute><csOperator>NOTEQUAL</csOperator><csValue>-5</csValue></scope><scope><csAttribute>extensionAttribute2</csAttribute><csOperator>NOTEQUAL</csOperator><csValue>-7</csValue></scope><scope><csAttribute>extensionAttribute2</csAttribute><csOperator>NOTEQUAL</csOperator><csValue>-8</csValue></scope><scope><csAttribute>extensionAttribute2</csAttribute><csOperator>NOTEQUAL</csOperator><csValue>-9</csValue></scope><scope><csAttribute>extensionAttribute2</csAttribute><csOperator>NOTEQUAL</csOperator><csValue>-10</csValue></scope><scope><csAttribute>extensionAttribute2</csAttribute><csOperator>NOTEQUAL</csOperator><csValue>-6</csValue></scope></scoping>'
            CreateConnectedSystemObject     = $true
            CreateILMObject                 = $false
            Description                     = 'initial description'
            DisconnectConnectedSystemObject = $true
            DisplayName                     = "TestSyncRule$randomNumber"
            FlowType                        = 1
            ILMObjectType                   = 'person'  
            InitialFlow                     = '<export-flow allows-null="false"><src><attr>accountName</attr><attr>domain</attr></src><dest>dn</dest><scoping></scoping><fn id="+" isCustomExpression="true"><arg><fn id="EscapeDNComponent" isCustomExpression="false"><arg><fn id="+" isCustomExpression="false"><arg>"CN="</arg><arg>accountName</arg></fn></arg></fn></arg><arg>",OU=UserAccounts,DC="</arg><arg>domain</arg><arg>",DC=corp,DC=microsoft,DC=com"</arg></fn></export-flow>'         
            ManagementAgentID               = 'CORP'
            msidmOutboundIsFilterBased      = $false
            PersistentFlow                  = @(
                '<export-flow allows-null="false"><src><attr>accountName</attr></src><dest>sAMAccountName</dest><scoping></scoping></export-flow>'
                '<export-flow allows-null="false"><src><attr>displayName</attr></src><dest>displayName</dest><scoping></scoping><fn id="Trim" isCustomExpression="true"><arg>displayName</arg></fn></export-flow>'
                '<export-flow allows-null="false"><src><attr>email</attr></src><dest>mail</dest><scoping></scoping></export-flow>'
            )
            Precedence                      = 1
            RelationshipCriteria            = '<conditions><condition><ilmAttribute>employeeID</ilmAttribute><csAttribute>extensionAttribute4</csAttribute></condition></conditions>'
            SynchronizationRuleParameters   = @(
                '<sync-parameter><name>workflowParameterOne</name><type>String</type></sync-parameter>'
                '<sync-parameter><name>workflowParameterTwo</name><type>Boolean</type></sync-parameter>'
            )
            Ensure		                    = 'Present'
        }
    } 
} 

TestSynchronizationRule

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestSynchronizationRule" -Force
#endregion

