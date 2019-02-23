$dscResource = Get-DscResource -Module MimSyncDsc -Name MimSyncMaData

Import-Module -Name $dscResource.Path -Force

Describe -Tag 'Build' 'MimSyncMaData - calling Test-TargetResource Directly'{
    $attributeInclusion = @(
        'UserID'
        'FirstName'
        'Initial'
        'LastName'
        'Title'
        'JobTitle'
        'HireDate'
        'Status'
    )
    $controllerConfiguration = New-CimInstance -ClassName MimSyncControllerConfiguration -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
        ApplicationArchitecture = 'process'
        ApplicationProtection   = 'low'
    }
    $extension = New-CimInstance -ClassName MimSyncExtension -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
        AssemblyName            = 'TinyHRExtension.dll'
        ApplicationProtection   = 'low'
    }
    $passwordSync = New-CimInstance -ClassName MimSyncPasswordSync -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
        AllowLowSecurity        = $false
        MaximumRetryCount       = 10
        RetryInterval           = 60
    }
    $provisioningCleanup = New-CimInstance -ClassName MimSyncProvisioningCleanup -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
        Type                    = 'declared'
        Action                  = 'make-normal-disconnector'
    }

    It 'Mega MaData - desired state' {  
        $testTargetResource = @{
            Name                    = 'TinyHR'
            AttributeInclusion      = $attributeInclusion
            Category                = 'Delimited'
            ControllerConfiguration = $controllerConfiguration
            Extension               = $extension
            PasswordSync            = $passwordSync
            PasswordSyncAllowed     = $false 
            ProvisioningCleanup     = $provisioningCleanup
            Ensure                  = 'Present'
        }                     
        $dscResult = Test-TargetResource @testTargetResource -Verbose

        $dscResult | Should be True
    }

    It 'Mega MaData - incorrect attribute inclusion list' {  
        $testTargetResource = @{
            Name                    = 'TinyHR'
            #AttributeInclusion      = $attributeInclusion
            Category                = 'Delimited'
            ControllerConfiguration = $controllerConfiguration
            Extension               = $extension
            PasswordSync            = $passwordSync
            PasswordSyncAllowed     = $false 
            ProvisioningCleanup     = $provisioningCleanup
            Ensure                  = 'Present'
        }    
        
        $attributeInclusion = @(
            'UserID'
            #'FirstName'
            'Initial'
            #'LastName'
            'Title'
            'JobTitle'
            'HireDate'
            'Status'
        )
        $dscResult = Test-TargetResource -AttributeInclusion $attributeInclusion @testTargetResource -Verbose

        $dscResult | Should be False
    }
}

Describe -Tag 'Build' 'MimSyncMaData - calling Get-TargetResource Directly'{
    It 'Existing Management Agent' {

        $dscResult = Get-TargetResource -Name TinyHR -Verbose

        $dscResult | Should Not Be Null    
    }

    It 'Existing Management Agent - Category' {

        $dscResult = Get-TargetResource -Name TinyHR -Verbose

        $dscResult['Category'] | Should be 'Delimited'        
    } 
    
    It 'Missing Management Agent' {

        $dscResult = Get-TargetResource -Name TINYHR -Verbose

        (-not $dscResult) | Should Be True    
    }  
}

Describe -Tag 'RunsInLocalConfigurationManager' 'MimSyncMaData - using the Local Configuration Manager'{
    It 'MaData - desired state' {
        Configuration TestMimSyncMaData 
        { 
            Import-DscResource -ModuleName MimSyncDsc

            Node (hostname) 
            { 
                MaData TestMimSyncMaData
                {
                    Name    = 'TinyHR'
                    AttributeInclusion           = @(
                        'UserID'
                        'FirstName'
                        'Initial'
                        'LastName'
                        'Title'
                        'JobTitle'
                        'HireDate'
                        'Status'
                    )
                    Category                 = 'Delimited'
                    ControllerConfiguration = ControllerConfiguration{
                        ApplicationArchitecture = 'process'
                        ApplicationProtection   = 'low'
                    }
                    Extension = Extension{
                        AssemblyName            = 'TinyHRExtension.dll'
                        ApplicationProtection   = 'low'
                    }
                    PasswordSync = PasswordSync{
                        AllowLowSecurity        = $false
                        MaximumRetryCount       = 10
                        RetryInterval           = 60
                    }
                    PasswordSyncAllowed         = $false
                    ProvisioningCleanup = ProvisioningCleanup{
                        Type                    = 'declared'
                        Action                  = 'make-normal-disconnector'
                    }
                    Ensure = 'Present'
                }                
            }
        } 

        TestMimSyncMaData -OutputPath "$env:TEMP\TestMimSyncMaData"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncMaData" -Force -Wait -Verbose 

        Test-DscConfiguration | Should Be True
    }

    It 'MaData - incorrect Attribute Inclusion' {
        Configuration TestMimSyncMaData 
        { 
            Import-DscResource -ModuleName MimSyncDsc

            Node (hostname) 
            { 
                MaData TestMimSyncMaData
                {
                    Name    = 'TinyHR'
                    AttributeInclusion           = @(
                        'UserID'
                        #'FirstName'
                        'Initial'
                        #'LastName'
                        'Title'
                        'JobTitle'
                        'HireDate'
                        'Status'
                    )
                    Category                 = 'Delimited'
                    ControllerConfiguration = ControllerConfiguration{
                        ApplicationArchitecture = 'process'
                        ApplicationProtection   = 'low'
                    }
                    Extension = Extension{
                        AssemblyName            = 'TinyHRExtension.dll'
                        ApplicationProtection   = 'low'
                    }
                    PasswordSync = PasswordSync{
                        AllowLowSecurity        = $true
                        MaximumRetryCount       = 10
                        RetryInterval           = 60
                    }
                    PasswordSyncAllowed         = $false
                    ProvisioningCleanup = ProvisioningCleanup{
                        Type                    = 'declared'
                        Action                  = 'make-normal-disconnector'
                    }
                    Ensure = 'Present'
                }                
            }
        } 

        TestMimSyncMaData -OutputPath "$env:TEMP\TestMimSyncMaData"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncMaData" -Force -Wait -Verbose 

        Test-DscConfiguration | Should Be False
    }

    It 'MaData - incorrect Assembly Name' {
        Configuration TestMimSyncMaData 
        { 
            Import-DscResource -ModuleName MimSyncDsc

            Node (hostname) 
            { 
                MaData TestMimSyncMaData
                {
                    Name    = 'TinyHR'
                    AttributeInclusion           = @(
                        'UserID'
                        'FirstName'
                        'Initial'
                        'LastName'
                        'Title'
                        'JobTitle'
                        'HireDate'
                        'Status'
                    )
                    Category                 = 'Delimited'
                    ControllerConfiguration = ControllerConfiguration{
                        ApplicationArchitecture = 'process'
                        ApplicationProtection   = 'low'
                    }
                    Extension = Extension{
                        AssemblyName            = 'GiantHRExtension.dll'
                        ApplicationProtection   = 'low'
                    }
                    PasswordSync = PasswordSync{
                        AllowLowSecurity        = $true
                        MaximumRetryCount       = 10
                        RetryInterval           = 60
                    }
                    PasswordSyncAllowed         = $false
                    ProvisioningCleanup = ProvisioningCleanup{
                        Type                    = 'declared'
                        Action                  = 'make-normal-disconnector'
                    }
                    Ensure = 'Present'
                }                
            }
        } 

        TestMimSyncMaData -OutputPath "$env:TEMP\TestMimSyncMaData"
        Start-DscConfiguration       -Path "$env:TEMP\TestMimSyncMaData" -Force -Wait -Verbose 

        Test-DscConfiguration | Should Be False
    }
}
