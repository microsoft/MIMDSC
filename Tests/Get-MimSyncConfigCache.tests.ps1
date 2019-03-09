Import-Module -Name MimDsc

Describe Get-MimSyncConfigCache{
    <#
    It 'Does Throw When Cache is Missing' {
        #Arrange
        Remove-Item -Path "$env:ProgramData\MimDsc\Svrexport" -ErrorAction SilentlyContinue

        (Get-MimSyncConfigCache -eq $null) | Should Be True 
    }
    #>

    It 'Does Not Throw When Cache folder is present' {
        # Arrange
        mkdir "$env:ProgramData\MimDsc\Svrexport" 
        
        # Act
        $actualValue = Get-ChildItem "$env:ProgramData\MimDsc\Svrexport"

        # Assert
        {Get-MimSyncConfigCache } | Should Not Throw 
    }
}