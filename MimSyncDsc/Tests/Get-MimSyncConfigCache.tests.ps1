Import-Module -Name MimSyncDsc

Describe Get-MimSyncConfigCache{
    <#
    It 'Does Throw When Cache is Missing' {
        #Arrange
        Remove-Item -Path "$env:ProgramData\MimSyncDsc\Svrexport" -ErrorAction SilentlyContinue

        (Get-MimSyncConfigCache -eq $null) | Should Be True 
    }
    #>

    It 'Does Not Throw When Cache folder is present' {
        # Arrange
        mkdir "$env:ProgramData\MimSyncDsc\Svrexport" 
        
        # Act
        $actualValue = Get-ChildItem "$env:ProgramData\MimSyncDsc\Svrexport"

        # Assert
        {Get-MimSyncConfigCache } | Should Not Throw 
    }
}