Set-Location c:\MimDsc

#region Call the Set and Test methods directly - allows for setting a breakpoint for debuggering
$displayName = "AttributeType$(Get-Random -Minimum 100 -Maximum 999)"
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

Test-MimSvcTargetResource -ObjectType AttributeTypeDescription -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

Set-MimSvcTargetResource -ObjectType AttributeTypeDescription -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

#endregion

#region: Test for an existing Attribute type

Configuration TestAttributeType 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        AttributeTypeDescription NewAttribute5000
        {
            DataType                    = 'String'
            Description					= 'initial description'
            DisplayName					= 'New Attribute 5000'
            Localizable                 = $false
            Name             			= 'NewAttribute5000'
            Multivalued                 = $false
            Ensure						= 'Present'
        }
    } 
} 

TestAttributeType

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestAttributeType" -Force
#endregion

#region: New Attribute Type
$displayName = "AttributeType$(Get-Random -Minimum 100 -Maximum 999)"
Configuration TestAttributeType 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        AttributeTypeDescription $displayName
        {
            DataType                    = 'String'
            Description					= 'initial description'
            DisplayName					= $displayName
            Localizable                 = $false
            Name             			= $displayName
            Multivalued                 = $false
            #UsageKeyword            	= 'Microsoft.ResourceManagement.PasswordReset'
            Ensure						= 'Present'
        }
    } 
} 

TestAttributeType

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestAttributeType" -Force
#endregion

#region: New Attribute Type - omitting Localizable
$displayName = "AttributeType$(Get-Random -Minimum 100 -Maximum 999)"
Configuration TestAttributeType 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        AttributeTypeDescription $displayName
        {
            DataType                    = 'String'
            Description					= 'initial description'
            DisplayName					= $displayName
            #Localizable                 = $false
            Name             			= $displayName
            Multivalued                 = $false
            #UsageKeyword            	= 'Microsoft.ResourceManagement.PasswordReset'
            Ensure						= 'Present'
        }
    } 
} 

TestAttributeType

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestAttributeType" -Force
#endregion

#region: New Attribute Type with StringRegEx
$displayName = "AttributeType$(Get-Random -Minimum 100 -Maximum 999)"
Configuration TestAttributeType 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        AttributeTypeDescription $displayName
        {
            DataType                    = 'String'
            Description					= 'initial description'
            DisplayName					= $displayName
            Localizable                 = $false
            Name             			= $displayName
            Multivalued                 = $false
            StringRegEx                 = 'foo'
            #UsageKeyword            	= 'Microsoft.ResourceManagement.PasswordReset'
            Ensure						= 'Present'
        }
    } 
} 

TestAttributeType

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestAttributeType" -Force
#endregion

#region: Update Attribute Type: Description
$displayName = "AttributeType$(Get-Random -Minimum 100 -Maximum 999)"
Configuration TestAttributeType 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        AttributeTypeDescription $displayName
        {
            DataType                    = 'String'
            Description					= 'initial description'
            DisplayName					= $displayName
            #Localizable                 = $false
            Name             			= $displayName
            Multivalued                 = $false
            #UsageKeyword            	= 'Microsoft.ResourceManagement.PasswordReset'
            Ensure						= 'Present'
        }
    } 
} 

TestAttributeType -ConfigurationData $Global:AllNodes

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestAttributeType"

Configuration TestAttributeType 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        AttributeTypeDescription $displayName
        {
            DataType                    = 'String'
            Description					= 'updated description'
            DisplayName					= $displayName
            Localizable                 = $false
            Name             			= $displayName
            Multivalued                 = $false
            #UsageKeyword            	= 'Microsoft.ResourceManagement.PasswordReset'
            Ensure						= 'Present'
        }
    } 
} 

TestAttributeType

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestAttributeType" -Force
#endregion