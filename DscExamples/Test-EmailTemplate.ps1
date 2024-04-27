
Set-Location c:\MimDsc

#region Call the Set and Test methods directly - allows for setting a breakpoint for debuggering
ipmo MimDsc -Force
ipmo 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcEmailTemplate\MimSvcEmailTemplate.psm1' -Force
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcEmailTemplate\MimSvcEmailTemplate.psm1'


$resourceProperties = @{
    DisplayName                 = 'Default expiration notification email template'
    EmailBody                   = 'The [//Target/ObjectType], [//Target/DisplayName], is due to expire on [//Target/ExpirationTime].  If you do not wish the [//Target/ObjectType] to be deleted, then you should extend its expiration date.'
    EmailSubject                = '[//Target/ObjectType] Expiration'
    EmailTemplateType           = 'Notification'
    Ensure						= 'Present'
}

$resourceProperties = @{
    DisplayName                 = "TestEmailTemplate$randomNumber"
    EmailBody                   = 'The [//Target/ObjectType], [//Target/DisplayName], is due to expire on [//Target/ExpirationTime].  If you do not wish the [//Target/ObjectType] to be deleted, then you should extend its expiration date.'
    EmailSubject                = '[//Target/ObjectType] Expiration'
    EmailTemplateType           = 'Notification'
    Ensure						= 'Absent'
}

Test-MimSvcTargetResource -ObjectType EmailTemplate -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

Set-MimSvcTargetResource -ObjectType EmailTemplate -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

#endregion



#region: Test for an existing EmailTemplate
Configuration TestEmailTemplate 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        EmailTemplate 'Default expiration notification email template'
        {
            DisplayName                 = 'Default expiration notification email template'
            EmailBody                   = 'The [//Target/ObjectType], [//Target/DisplayName], is due to expire on [//Target/ExpirationTime].  If you do not wish the [//Target/ObjectType] to be deleted, then you should extend its expiration date.'
            EmailSubject                = '[//Target/ObjectType] Expiration'
            EmailTemplateType           = 'Notification'
            Ensure						= 'Present'
        }
    } 
} 

TestEmailTemplate

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestEmailTemplate" -Force
#endregion

#region: New EmailTemplate
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestEmailTemplate 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        EmailTemplate "TestEmailTemplate$randomNumber"
        {
            DisplayName                 = "TestEmailTemplate$randomNumber"
            EmailBody                   = 'The [//Target/ObjectType], [//Target/DisplayName], is due to expire on [//Target/ExpirationTime].  If you do not wish the [//Target/ObjectType] to be deleted, then you should extend its expiration date.'
            EmailSubject                = '[//Target/ObjectType] Expiration'
            EmailTemplateType           = 'Notification'
            Ensure						= 'Present'
        }
    } 
} 

TestEmailTemplate

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestEmailTemplate" -Force
#endregion

#region: Update an EmailTemplate
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestEmailTemplate 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        EmailTemplate "TestEmailTemplate$randomNumber"
        {
            DisplayName                 = "TestEmailTemplate$randomNumber"
            EmailBody                   = 'The [//Target/ObjectType], [//Target/DisplayName], is due to expire on [//Target/ExpirationTime].  If you do not wish the [//Target/ObjectType] to be deleted, then you should extend its expiration date.'
            EmailSubject                = '[//Target/ObjectType] Expiration'
            EmailTemplateType           = 'Notification'
            Ensure						= 'Present'
        }
    } 
} 

TestEmailTemplate

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestEmailTemplate" -Force

Configuration TestEmailTemplate 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        EmailTemplate "TestEmailTemplate$randomNumber"
        {
            DisplayName                 = "TestEmailTemplate$randomNumber"
            EmailBody                   = 'The [//Target/FooType], [//Target/DisplayName], is due to expire on [//Target/ExpirationTime].  If you do not wish the [//Target/ObjectType] to be deleted, then you should extend its expiration date.'
            EmailSubject                = '[//Target/FooType] Expiration'
            EmailTemplateType           = 'Notification'
            Ensure						= 'Present'
        }
    } 
} 

TestEmailTemplate

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestEmailTemplate" -Force
#endregion

#region: Remove an EmailTemplate
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestEmailTemplate 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        EmailTemplate "TestEmailTemplate$randomNumber"
        {
            DisplayName                 = "TestEmailTemplate$randomNumber"
            EmailBody                   = 'The [//Target/ObjectType], [//Target/DisplayName], is due to expire on [//Target/ExpirationTime].  If you do not wish the [//Target/ObjectType] to be deleted, then you should extend its expiration date.'
            EmailSubject                = '[//Target/ObjectType] Expiration'
            EmailTemplateType           = 'Notification'
            Ensure						= 'Present'
        }
    } 
} 

TestEmailTemplate

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestEmailTemplate" -Force

Configuration TestEmailTemplate 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        EmailTemplate "TestEmailTemplate$randomNumber"
        {
            DisplayName                 = "TestEmailTemplate$randomNumber"
            EmailBody                   = 'The [//Target/ObjectType], [//Target/DisplayName], is due to expire on [//Target/ExpirationTime].  If you do not wish the [//Target/ObjectType] to be deleted, then you should extend its expiration date.'
            EmailSubject                = '[//Target/ObjectType] Expiration'
            EmailTemplateType           = 'Notification'
            Ensure						= 'Absent'
        }
    } 
} 

TestEmailTemplate

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestEmailTemplate" -Force
#endregion
