$dscResource = Get-DscResource -Module MimSyncDsc -Name MimSyncMVObjectType

Import-Module -Name $dscResource.Path -Force

Describe -Tag 'Build' 'MimSyncMVObjectType - calling Test-TargetResource Directly'{
    
    It 'MimSyncMVObjectType - desired state' {  
        $attributes = @(
        '#Alias'
        '#AssistantName'
        '#City'
        '#Company'
        '#CustomAttribute1'
        '#CustomAttribute10'
        '#CustomAttribute11'
        '#CustomAttribute12'
        '#CustomAttribute13'
        '#CustomAttribute14'
        '#CustomAttribute15'
        '#CustomAttribute2'
        '#CustomAttribute3'
        '#CustomAttribute4'
        '#CustomAttribute5'
        '#CustomAttribute6'
        '#CustomAttribute7'
        '#CustomAttribute8'
        '#CustomAttribute9'
        '#DeliverToMailboxAndForward'
        '#Department'
        '#DisplayName'
        '#EmailAddresses'
        '#ExchangeGuid'
        '#ExternalEmailAddress'
        '#Fax'
        '#FirstName'
        '#ForwardingAddress'
        '#HomePhone'
        '#HostedObjectType'
        '#Initials'
        '#Languages'
        '#LastName'
        '#LegacyExchangeDN'
        '#Manager'
        '#MobilePhone'
        '#Notes'
        '#Office'
        '#OnPremiseObjectDirSyncId'
        '#OnPremiseObjectType'
        '#OtherHomePhone'
        '#OtherTelephone'
        '#Pager'
        '#Phone'
        '#PostalCode'
        '#ResourceCapacity'
        '#ResourceCustom'
        '#RetentionUrl'
        '#SamAccountName'
        '#StateOrProvince'
        '#StreetAddress'
        '#TelephoneAssistant'
        '#Title'
        '#UserPrincipalName'
        '#WindowsEmailAddress'
        ) | ForEach-Object {
            New-CimInstance -ClassName MimSyncMVAttributeBinding -Property @{ID=$PSItem; Required=$false} -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration 
        }        
        
        $dscResult = Test-TargetResource -ID SyncObject -Type structural -Attributes $attributes -Ensure Present -Verbose

        $dscResult | Should be True
    }

    It 'MimSyncMVObjectType - missing attributes' {  
        $attributes = @(
        '#Alias'
        '#AssistantName'
        '#City'
        #'#Company'
        '#CustomAttribute1'
        '#CustomAttribute10'
        '#CustomAttribute11'
        '#CustomAttribute12'
        '#CustomAttribute13'
        '#CustomAttribute14'
        '#CustomAttribute15'
        '#CustomAttribute2'
        '#CustomAttribute3'
        '#CustomAttribute4'
        '#CustomAttribute5'
        '#CustomAttribute6'
        '#CustomAttribute7'
        '#CustomAttribute8'
        '#CustomAttribute9'
        '#DeliverToMailboxAndForward'
        #'#Department'
        '#DisplayName'
        '#EmailAddresses'
        '#ExchangeGuid'
        '#ExternalEmailAddress'
        '#Fax'
        '#FirstName'
        '#ForwardingAddress'
        '#HomePhone'
        '#HostedObjectType'
        '#Initials'
        '#Languages'
        '#LastName'
        '#LegacyExchangeDN'
        '#Manager'
        '#MobilePhone'
        '#Notes'
        '#Office'
        '#OnPremiseObjectDirSyncId'
        '#OnPremiseObjectType'
        '#OtherHomePhone'
        '#OtherTelephone'
        '#Pager'
        '#Phone'
        '#PostalCode'
        '#ResourceCapacity'
        '#ResourceCustom'
        '#RetentionUrl'
        '#SamAccountName'
        '#StateOrProvince'
        '#StreetAddress'
        '#TelephoneAssistant'
        '#Title'
        '#UserPrincipalName'
        '#WindowsEmailAddress'
        ) | ForEach-Object {
            New-CimInstance -ClassName MimSyncMVAttributeBinding -Property @{ID=$PSItem; Required=$false} -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration 
        }        
        
        $dscResult = Test-TargetResource -ID SyncObject -Type structural -Attributes $attributes -Ensure Present -Verbose

        $dscResult | Should be False
    }

    It 'MimSyncMVObjectType - one attribute required set to true' {  
        $attributes = @(
        '#Alias'
        '#AssistantName'
        '#City'
        '#Company'
        '#CustomAttribute1'
        '#CustomAttribute10'
        '#CustomAttribute11'
        '#CustomAttribute12'
        '#CustomAttribute13'
        '#CustomAttribute14'
        '#CustomAttribute15'
        '#CustomAttribute2'
        '#CustomAttribute3'
        '#CustomAttribute4'
        '#CustomAttribute5'
        '#CustomAttribute6'
        '#CustomAttribute7'
        '#CustomAttribute8'
        '#CustomAttribute9'
        '#DeliverToMailboxAndForward'
        '#Department'
        '#DisplayName'
        '#EmailAddresses'
        '#ExchangeGuid'
        '#ExternalEmailAddress'
        '#Fax'
        '#FirstName'
        '#ForwardingAddress'
        '#HomePhone'
        '#HostedObjectType'
        '#Initials'
        '#Languages'
        '#LastName'
        '#LegacyExchangeDN'
        '#Manager'
        '#MobilePhone'
        '#Notes'
        '#Office'
        '#OnPremiseObjectDirSyncId'
        '#OnPremiseObjectType'
        '#OtherHomePhone'
        '#OtherTelephone'
        '#Pager'
        '#Phone'
        '#PostalCode'
        '#ResourceCapacity'
        '#ResourceCustom'
        '#RetentionUrl'
        '#SamAccountName'
        '#StateOrProvince'
        '#StreetAddress'
        '#TelephoneAssistant'
        '#Title'
        '#UserPrincipalName'
        '#WindowsEmailAddress'
        ) | ForEach-Object {
            New-CimInstance -ClassName MimSyncMVAttributeBinding -Property @{ID=$PSItem; Required=$false} -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration 
        }        
        
        ($attributes | Where-Object ID -EQ '#Alias').Required = $true

        $dscResult = Test-TargetResource -ID SyncObject -Type structural -Attributes $attributes -Ensure Present -Verbose

        $dscResult | Should be False
    }
}

Describe -Tag 'Build' 'MimSyncMVObjectType - calling Get-TargetResource Directly'{
    It 'Existing MV Object Type' {

        $dscResult = Get-TargetResource -ID SyncObject -Verbose

        $dscResult | Should Not Be Null    
    }

    It 'Existing MV Object Type - Type' {

        $dscResult = Get-TargetResource -ID SyncObject -Verbose

        $dscResult['Type'] | Should be 'structural'        
    } 
    
    It 'Missing MV Object Type' {

        $dscResult = Get-TargetResource -ID DivideByObject -Verbose

        (-not $dscResult) | Should Be True    
    }  
}

Describe -Tag 'RunsInLocalConfigurationManager' 'MimSyncMVObjectType - using the Local Configuration Manager'{
    It 'MimSyncMVObjectType - desired state' {
        Configuration TestMimSyncMVObjectType 
        { 
            Import-DscResource -ModuleName MimSyncDsc

            Node (hostname) 
            { 
                MVObjectType TestMimSyncMVObjectType
                {
                    ID    = 'SyncObject'
                    Type  = 'structural'
                    Attributes           = @(
                        MVAttributeBinding {ID='#Alias';              Required=$false}
                        MVAttributeBinding {ID='#AssistantName';      Required=$false}
                        MVAttributeBinding {ID='#City';               Required=$false}
                        MVAttributeBinding {ID='#Company';            Required=$false}
                        MVAttributeBinding {ID='#CustomAttribute1';   Required=$false}
                        MVAttributeBinding {ID='#CustomAttribute10';  Required=$false}
                        MVAttributeBinding {ID='#CustomAttribute11';  Required=$false}
                        MVAttributeBinding {ID='#CustomAttribute12';  Required=$false}
                        MVAttributeBinding {ID='#CustomAttribute13';  Required=$false}
                        MVAttributeBinding {ID='#CustomAttribute14';  Required=$false}
                        MVAttributeBinding {ID='#CustomAttribute15';  Required=$false}
                        MVAttributeBinding {ID='#CustomAttribute2';   Required=$false}
                        MVAttributeBinding {ID='#CustomAttribute3';            Required=$false}
                        MVAttributeBinding {ID='#CustomAttribute4';            Required=$false}
                        MVAttributeBinding {ID='#CustomAttribute5';            Required=$false}
                        MVAttributeBinding {ID='#CustomAttribute6';            Required=$false}
                        MVAttributeBinding {ID='#CustomAttribute7';            Required=$false}
                        MVAttributeBinding {ID='#CustomAttribute8';            Required=$false}
                        MVAttributeBinding {ID='#CustomAttribute9';            Required=$false}
                        MVAttributeBinding {ID='#DeliverToMailboxAndForward';  Required=$false}
                        MVAttributeBinding {ID='#Department';                  Required=$false}
                        MVAttributeBinding {ID='#DisplayName';                 Required=$false}
                        MVAttributeBinding {ID='#EmailAddresses';              Required=$false}
                        MVAttributeBinding {ID='#ExchangeGuid';                Required=$false}
                        MVAttributeBinding {ID='#ExternalEmailAddress';        Required=$false}
                        MVAttributeBinding {ID='#Fax';                         Required=$false}
                        MVAttributeBinding {ID='#FirstName';                   Required=$false}
                        MVAttributeBinding {ID='#ForwardingAddress';           Required=$false}
                        MVAttributeBinding {ID='#HomePhone';                   Required=$false}
                        MVAttributeBinding {ID='#HostedObjectType';            Required=$false}
                        MVAttributeBinding {ID='#Initials';                    Required=$false}
                        MVAttributeBinding {ID='#Languages';                   Required=$false}
                        MVAttributeBinding {ID='#LastName';                    Required=$false}
                        MVAttributeBinding {ID='#LegacyExchangeDN';            Required=$false}
                        MVAttributeBinding {ID='#Manager';                     Required=$false}
                        MVAttributeBinding {ID='#MobilePhone';                 Required=$false}
                        MVAttributeBinding {ID='#Notes';                       Required=$false}
                        MVAttributeBinding {ID='#Office';                      Required=$false}
                        MVAttributeBinding {ID='#OnPremiseObjectDirSyncId';    Required=$false}
                        MVAttributeBinding {ID='#OnPremiseObjectType';         Required=$false}
                        MVAttributeBinding {ID='#OtherHomePhone';              Required=$false}
                        MVAttributeBinding {ID='#OtherTelephone';              Required=$false}
                        MVAttributeBinding {ID='#Pager';                       Required=$false}
                        MVAttributeBinding {ID='#Phone';                       Required=$false}
                        MVAttributeBinding {ID='#PostalCode';                  Required=$false}
                        MVAttributeBinding {ID='#ResourceCapacity';            Required=$false}
                        MVAttributeBinding {ID='#ResourceCustom';              Required=$false}
                        MVAttributeBinding {ID='#RetentionUrl';                Required=$false}
                        MVAttributeBinding {ID='#SamAccountName';              Required=$false}
                        MVAttributeBinding {ID='#StateOrProvince';             Required=$false}
                        MVAttributeBinding {ID='#StreetAddress';               Required=$false}
                        MVAttributeBinding {ID='#TelephoneAssistant';          Required=$false}
                        MVAttributeBinding {ID='#Title';                       Required=$false}
                        MVAttributeBinding {ID='#UserPrincipalName';           Required=$false}
                        MVAttributeBinding {ID='#WindowsEmailAddress';         Required=$false}
                    )                    
                    Ensure = 'Present'
                }                
            }
        } 

        TestMimSyncMVObjectType -OutputPath "$env:TEMP\TestMimSyncMVObjectType"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncMVObjectType" -Force -Wait -Verbose 

        Test-DscConfiguration | Should Be True
    }

    It 'MimSyncMVObjectType - missing attributes' {
        Configuration TestMimSyncMaData 
        { 
            Import-DscResource -ModuleName MimSyncDsc

            Node (hostname) 
            { 
                MVObjectType TestMimSyncMVObjectType
                {
                    ID    = 'SyncObject'
                    Type  = 'structural'
                    Attributes           = @(
                        MVAttributeBinding {ID='#Alias';              Required=$false}
                        MVAttributeBinding {ID='#AssistantName';      Required=$false}
                        MVAttributeBinding {ID='#City';               Required=$false}
                        MVAttributeBinding {ID='#Company';            Required=$false}
                        MVAttributeBinding {ID='#CustomAttribute1';   Required=$false}
                        MVAttributeBinding {ID='#CustomAttribute10';  Required=$false}
                        MVAttributeBinding {ID='#CustomAttribute11';  Required=$false}
                        MVAttributeBinding {ID='#CustomAttribute12';  Required=$false}
                        MVAttributeBinding {ID='#CustomAttribute13';  Required=$false}
                        MVAttributeBinding {ID='#CustomAttribute14';  Required=$false}
                        MVAttributeBinding {ID='#CustomAttribute15';  Required=$false}                        
                    )                    
                    Ensure = 'Present'
                }         
            }
        } 

        TestMimSyncMVObjectType -OutputPath "$env:TEMP\TestMimSyncMVObjectType"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncMVObjectType" -Force -Wait -Verbose 

        Test-DscConfiguration | Should Be False
    }
}
