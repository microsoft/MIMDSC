Set-Location c:\MimDsc

#region: Test for an existing ActivityInformationConfiguration
Configuration TestActivityInformationConfiguration 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ActivityInformationConfiguration 'Notification'
        {

            ActivityName                = 'Microsoft.ResourceManagement.Workflow.Activities.EmailNotificationActivity'
            AssemblyName                = 'Microsoft.IdentityManagement.Activities, Version=4.6.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'
            Description                 = 'This activity sends notification to specific recipients.'
            DisplayName                 = 'Notification'
            IsActionActivity            = $true
            IsAuthenticationActivity    = $false
            IsAuthorizationActivity     = $true
            IsConfigurationType         = $false
            TypeName                    = 'Microsoft.IdentityManagement.WebUI.Controls.NotificationActivitySettingsPart'
            Ensure						= 'Present'
        }
    } 
} 

TestActivityInformationConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestActivityInformationConfiguration" -Force

#endregion

#region: New ActivityInformationConfiguration
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestActivityInformationConfiguration 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ActivityInformationConfiguration "TestActivityInformationConfiguration$randomNumber"
        {

            ActivityName                = 'Microsoft.ResourceManagement.Workflow.Activities.Foo'
            AssemblyName                = 'Microsoft.IdentityManagement.Activities, Version=4.6.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'
            Description                 = 'Initial, but very interesting description.'
            DisplayName                 = "TestActivityInformationConfiguration$randomNumber"
            IsActionActivity            = $true
            IsAuthenticationActivity    = $false
            IsAuthorizationActivity     = $true
            IsConfigurationType         = $false
            TypeName                    = 'Microsoft.IdentityManagement.WebUI.Controls.FooSettingsPart'
            Ensure						= 'Present'
        }
    } 
} 

TestActivityInformationConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestActivityInformationConfiguration" -Force
#endregion

#region: Update ActivityInformationConfiguration
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestActivityInformationConfiguration 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ActivityInformationConfiguration "TestActivityInformationConfiguration$randomNumber"
        {

            ActivityName                = 'Microsoft.ResourceManagement.Workflow.Activities.Foo'
            AssemblyName                = 'Microsoft.IdentityManagement.Activities, Version=4.6.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'
            Description                 = 'Initial, but very interesting description.'
            DisplayName                 = "TestActivityInformationConfiguration$randomNumber"
            IsActionActivity            = $true
            IsAuthenticationActivity    = $false
            IsAuthorizationActivity     = $true
            IsConfigurationType         = $false
            TypeName                    = 'Microsoft.IdentityManagement.WebUI.Controls.FooSettingsPart'
            Ensure						= 'Present'
        }
    } 
} 

TestActivityInformationConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestActivityInformationConfiguration" -Force

Configuration TestActivityInformationConfiguration 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ActivityInformationConfiguration "TestActivityInformationConfiguration$randomNumber"
        {

            ActivityName                = 'Microsoft.ResourceManagement.Workflow.Activities.Bar'
            AssemblyName                = 'Microsoft.IdentityManagement.Activities, Version=4.6.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'
            Description                 = 'Updated, and gripping description.'
            DisplayName                 = "TestActivityInformationConfiguration$randomNumber"
            IsActionActivity            = $false
            IsAuthenticationActivity    = $false
            IsAuthorizationActivity     = $true
            IsConfigurationType         = $false
            TypeName                    = 'Microsoft.IdentityManagement.WebUI.Controls.BarSettingsPart'
            Ensure						= 'Present'
        }
    } 
}

TestActivityInformationConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestActivityInformationConfiguration" -Force
#endregion