Set-Location c:\MimDsc

#region: Test for an existing Set
Configuration TestSet 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        Set 'All Non-Administrators'
        {
            DisplayName                 = 'All Non-Administrators'
            Filter                      = @'
<Filter xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" Dialect="http://schemas.microsoft.com/2006/11/XPathFilterDialect" xmlns="http://schemas.xmlsoap.org/ws/2004/09/enumeration">/Person[ObjectID != /Set[ObjectID = '{ObjectType:"Set",AttributeName:"DisplayName",AttributeValue:"Administrators"}']/ComputedMember]</Filter>
'@
            Ensure						= 'Present'
        }
    } 
} 

TestSet 

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestSet" -Force
#endregion

#region: New Set with Filter
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestSet 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        Set "TestSet$randomNumber"
        {
            DisplayName                 = "TestSet$randomNumber"
            Filter                      = @'
<Filter xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" Dialect="http://schemas.microsoft.com/2006/11/XPathFilterDialect" xmlns="http://schemas.xmlsoap.org/ws/2004/09/enumeration">/Person[ObjectID != /Set[ObjectID = '{ObjectType:"Set",AttributeName:"DisplayName",AttributeValue:"Administrators"}']/ComputedMember]</Filter>
'@
            Ensure						= 'Present'
        }
    } 
} 

TestSet 

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestSet" -Force
#endregion

#region: Update a Set with Filter
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestSet 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        Set "TestSet$randomNumber"
        {
            DisplayName                 = "TestSet$randomNumber"
            Filter                      = @'
<Filter xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" Dialect="http://schemas.microsoft.com/2006/11/XPathFilterDialect" xmlns="http://schemas.xmlsoap.org/ws/2004/09/enumeration">/Person[ObjectID != /Set[ObjectID = '{ObjectType:"Set",AttributeName:"DisplayName",AttributeValue:"Administrators"}']/ComputedMember]</Filter>
'@
            Ensure						= 'Present'
        }
    } 
} 

TestSet 

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestSet"

Configuration TestSet 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        Set "TestSet$randomNumber"
        {
            DisplayName                 = "TestSet$randomNumber"
            Filter                      = @'
<Filter xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" Dialect="http://schemas.microsoft.com/2006/11/XPathFilterDialect" xmlns="http://schemas.xmlsoap.org/ws/2004/09/enumeration">/Person[ObjectID != /Set[ObjectID = '{ObjectType:"Set",AttributeName:"DisplayName",AttributeValue:"All People"}']/ComputedMember]</Filter>
'@
            Ensure						= 'Present'
        }
    } 
} 

TestSet 

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestSet"
#endregion

#region: New Set with ExplicitMembers
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestSet 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        Set "TestSet$randomNumber"
        {
            DisplayName                 = "TestSet$randomNumber"
            ExplicitMember              = 'Administrator','Built-in Synchronization Account'
            Ensure						= 'Present'
            Credential					= $fimAdminCredential
        }
    } 
} 

TestSet

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestSet"

Get-Resource Set DisplayName "TestSet$randomNumber"
#endregion

#region: Update Set with ExplicitMembers
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestSet 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        Set "TestSet$randomNumber"
        {
            DisplayName                 = "TestSet$randomNumber"
            ExplicitMember              = 'Administrator','Built-in Synchronization Account'
            Ensure						= 'Present'
        }
    } 
} 

TestSet

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestSet"

Configuration TestSet 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        Set "TestSet$randomNumber"
        {
            DisplayName                 = "TestSet$randomNumber"
            ExplicitMember              = 'Built-in Synchronization Account'
            Ensure						= 'Present'
        }
    } 
} 

TestSet

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestSet"
#endregion

#region: New Sets with Dependencies
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestSet 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        Set "TestSet1-$randomNumber"
        {
            DisplayName                 = "TestSet1-$randomNumber"
            Filter                      = @'
<Filter xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" Dialect="http://schemas.microsoft.com/2006/11/XPathFilterDialect" xmlns="http://schemas.xmlsoap.org/ws/2004/09/enumeration">/Person[ObjectID != /Set[ObjectID = '{ObjectType:"Set",AttributeName:"DisplayName",AttributeValue:"Administrators"}']/ComputedMember]</Filter>
'@ 
            Ensure						= 'Present'
        }

        Set "TestSet2-$randomNumber"
        {
            DisplayName                 = "TestSet2-$randomNumber"
            Filter                      = @'
<Filter xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" Dialect="http://schemas.microsoft.com/2006/11/XPathFilterDialect" xmlns="http://schemas.xmlsoap.org/ws/2004/09/enumeration">/Person[ObjectID != /Set[ObjectID = '{ObjectType:"Set",AttributeName:"DisplayName",AttributeValue:"TestSet1"}']/ComputedMember]</Filter>
'@ -replace 'TestSet1', "TestSet1-$randomNumber"
            DependsOn                   = "[Set]TestSet1-$randomNumber"
            Ensure						= 'Present'
        }

        Set "TestSet3-$randomNumber"
        {
            DisplayName                 = "TestSet3-$randomNumber"
            Filter                      = @'
<Filter xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" Dialect="http://schemas.microsoft.com/2006/11/XPathFilterDialect" xmlns="http://schemas.xmlsoap.org/ws/2004/09/enumeration">/Person[ObjectID != /Set[ObjectID = '{ObjectType:"Set",AttributeName:"DisplayName",AttributeValue:"TestSet2"}']/ComputedMember]</Filter>
'@ -replace 'TestSet2', "TestSet2-$randomNumber"
            DependsOn                   = "[Set]TestSet2-$randomNumber"
            Ensure						= 'Present'
        }
    } 
} 

TestSet

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestSet"
#endregion

#region: New Sets with Dependencies - Circular Reference
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestSet 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        Set "TestSet1-$randomNumber"
        {
            DisplayName                 = "TestSet1-$randomNumber"
            Filter                      = @'
<Filter xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" Dialect="http://schemas.microsoft.com/2006/11/XPathFilterDialect" xmlns="http://schemas.xmlsoap.org/ws/2004/09/enumeration">/Person[ObjectID != /Set[ObjectID = '{ObjectType:"Set",AttributeName:"DisplayName",AttributeValue:"TestSet3"}']/ComputedMember]</Filter>
'@ -replace 'TestSet3', "TestSet3-$randomNumber"
            DependsOn                   = "[Set]TestSet3-$randomNumber"
            Ensure						= 'Present'
        }

        Set "TestSet2-$randomNumber"
        {
            DisplayName                 = "TestSet2-$randomNumber"
            Filter                      = @'
<Filter xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" Dialect="http://schemas.microsoft.com/2006/11/XPathFilterDialect" xmlns="http://schemas.xmlsoap.org/ws/2004/09/enumeration">/Person[ObjectID != /Set[ObjectID = '{ObjectType:"Set",AttributeName:"DisplayName",AttributeValue:"TestSet1"}']/ComputedMember]</Filter>
'@ -replace 'TestSet1', "TestSet1-$randomNumber"
            DependsOn                   = "[Set]TestSet1-$randomNumber"
            Ensure						= 'Present'
        }

        Set "TestSet3-$randomNumber"
        {
            DisplayName                 = "TestSet3-$randomNumber"
            Filter                      = @'
<Filter xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" Dialect="http://schemas.microsoft.com/2006/11/XPathFilterDialect" xmlns="http://schemas.xmlsoap.org/ws/2004/09/enumeration">/Person[ObjectID != /Set[ObjectID = '{ObjectType:"Set",AttributeName:"DisplayName",AttributeValue:"TestSet2"}']/ComputedMember]</Filter>
'@ -replace 'TestSet2', "TestSet2-$randomNumber"
            DependsOn                   = "[Set]TestSet2-$randomNumber"
            Ensure						= 'Present'
        }
    } 
} 

TestSet

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestSet"
#endregion