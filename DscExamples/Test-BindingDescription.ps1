Set-Location c:\MimDsc

#region Call the Set and Test methods directly - allows for setting a breakpoint for debuggering
ipmo MimDsc -Force
ipmo 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcBindingDescription\MimSvcBindingDescription.psm1' -Force
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcBindingDescription\MimSvcBindingDescription.psm1'

$displayName = "Binding$(Get-Random -Minimum 100 -Maximum 999)"
$resourceProperties = @{
    DataType                    = 'String'
    Description					= 'initial description'
    DisplayName					= $displayName
    #Localizable                 = ''
    Name             			= $displayName
    Multivalued                 = $false
    #UsageKeyword            	= 'Microsoft.ResourceManagement.PasswordReset'
    Ensure						= 'Present'
}

$resourceProperties = @{
	BoundAttributeType = 'AccountName'
	BoundObjectType    = 'Person'
	Description        = 'User''s log on name'
	DisplayName        = 'Account Name'
	Required           = $False
	StringRegex        = '^[^"/\\[\]:;|=,+/*?<>]{1,64}$'
	UsageKeyword       = 'Microsoft.ResourceManagement.OfficeIntegration','Microsoft.ResourceManagement.PasswordReset','Microsoft.ResourceManagement.PortalClient'
	DependsOn          = '[cFimAttributeTypeDescription]AccountName','[cFimObjectTypeDescription]Person'
	Ensure             = 'Present'
	Credential         = $fimCredential
}

Test-MimSvcTargetResource -ObjectType BindingDescription -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

Set-MimSvcTargetResource -ObjectType BindingDescription -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

#endregion


#region: Test for an existing Binding
Search-Resources -XPath "/BindingDescription[BoundAttributeType=/AttributeTypeDescription[Name='DisplayName'] and BoundObjectType=/ObjectTypeDescription[Name='Person']]" -ExpectedObjectType BindingDescription

Configuration TestBinding 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        BindingDescription $displayName
        {
            BoundAttributeType          = 'DisplayName'
            BoundObjectType             = 'Person'            
            DisplayName					= 'Display Name'
            Required                    = $false
            UsageKeyword                = 'Microsoft.ResourceManagement.OfficeIntegration','Microsoft.ResourceManagement.PortalClient'
            Ensure						= 'Present'
        }
    } 
} 

TestBinding

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestBinding" -Force
#endregion

#region: New Binding
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestBinding 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        BindingDescription "Binding$randomNumber"
        {
            BoundAttributeType          = "Attribute$randomNumber"
            BoundObjectType             = 'Person'
            Description					= 'initial description'
            DisplayName					= "Binding$randomNumber"
            Required                    = $false
            Ensure						= 'Present'
            DependsOn                   = "[AttributeTypeDescription]Attribute$randomNumber"
        }

        AttributeTypeDescription "Attribute$randomNumber"
        {
            DataType                    = 'String'
            Description					= 'initial description'
            DisplayName					= "Attribute$randomNumber"
            Localizable                 = $false
            Name             			= "Attribute$randomNumber"
            Multivalued                 = $false
            Ensure						= 'Present'
        }
    } 
} 

TestBinding

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestBinding"
#endregion

#region: New Binding with StringRegEx
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestBinding 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        BindingDescription "Binding$randomNumber"
        {
            BoundAttributeType          = "Attribute$randomNumber"
            BoundObjectType             = 'Person'
            Description					= 'initial description'
            DisplayName					= "Binding$randomNumber"
            Required                    = $false
            StringRegEx                 = 'foo'
            Ensure						= 'Present'
            DependsOn                   = "[AttributeTypeDescription]Attribute$randomNumber"
        }

        AttributeTypeDescription "Attribute$randomNumber"
        {
            DataType                    = 'String'
            Description					= 'initial description'
            DisplayName					= "Attribute$randomNumber"
            Localizable                 = $false
            Name             			= "Attribute$randomNumber"
            Multivalued                 = $false
            Ensure						= 'Present'
        }
    } 
} 

TestBinding

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestBinding" -Force
#endregion

#region: Update Binding: Description
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestBinding 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        BindingDescription "Binding$randomNumber"
        {
            BoundAttributeType          = "Attribute$randomNumber"
            BoundObjectType             = 'Person'
            Description					= 'initial description'
            DisplayName					= "Binding$randomNumber"
            Required                    = $false
            Ensure						= 'Present'
            DependsOn                   = "[AttributeTypeDescription]Attribute$randomNumber"
        }

        AttributeTypeDescription "Attribute$randomNumber"
        {
            DataType                    = 'String'
            Description					= 'initial description'
            DisplayName					= "Attribute$randomNumber"
            Localizable                 = $false
            Name             			= "Attribute$randomNumber"
            Multivalued                 = $false
            Ensure						= 'Present'
        }
    } 
} 

TestBinding

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestBinding" -Force

Configuration TestBinding 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        BindingDescription "Binding$randomNumber"
        {
            BoundAttributeType          = "Attribute$randomNumber"
            BoundObjectType             = 'Person'
            Description					= 'updated description'
            DisplayName					= "Binding$randomNumber"
            Required                    = $false
            Ensure						= 'Present'
            DependsOn                   = "[AttributeTypeDescription]Attribute$randomNumber"
        }

        AttributeTypeDescription "Attribute$randomNumber"
        {
            DataType                    = 'String'
            Description					= 'initial description'
            DisplayName					= "Attribute$randomNumber"
            Localizable                 = $false
            Name             			= "Attribute$randomNumber"
            Multivalued                 = $false
            Ensure						= 'Present'
        }
    } 
} 

TestBinding

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestBinding" -Force
#endregion

#region: Test for an existing Binding that is not unique
Configuration TestBinding 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        BindingDescription PersonAccountName
        {
	        BoundAttributeType = 'AccountName'
	        BoundObjectType    = 'Person'
	        Description        = 'User''s log on name'
	        DisplayName        = 'Account Name'
	        Required           = $False
	        StringRegex        = '^[^"/\\[\]:;|=,+/*?<>]{1,64}$'
	        UsageKeyword       = 'Microsoft.ResourceManagement.OfficeIntegration','Microsoft.ResourceManagement.PasswordReset','Microsoft.ResourceManagement.PortalClient'
	        #DependsOn          = '[cFimAttributeTypeDescription]AccountName','[cFimObjectTypeDescription]Person'
	        Ensure             = 'Present'
        }
    } 
} 

TestBinding

Start-DscConfiguration -Wait -Verbose -Path "c:\MimDsc\TestBinding" -Force
#endregion