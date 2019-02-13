Import-Module -Name MimSyncDsc

Describe Get-MimRegistryKey{
    It 'Does Not Throw' {
        {Get-MimRegistryKey  } | Should Not Throw 
    }

    It 'Finds the Sync Service registry key' {
        # Act
        $actualValue = Get-MimRegistryKey -Component FIMSynchronization

        # Arrange
        $expectedValue = '.\mimsync'

        # Assert
        $actualValue.ObjectName | Should Be $expectedValue
    }

    It 'Finds the Service registry key' {
        # Act
        $actualValue = Get-MimRegistryKey -Component FIMService

        # Arrange
        $expectedValue = '.\mimsvc'

        # Assert
        $actualValue.ObjectName | Should Be $expectedValue
    }
}