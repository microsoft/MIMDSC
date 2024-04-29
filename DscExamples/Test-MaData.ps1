

<#

Get-Resource -ObjectType 'ma-data' -AttributeName DisplayName -AttributeValue 'CORP AD'

ipmo MimDsc -Force
ipmo 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcMaData\MimSvcMaData.psm1' -Force
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcMaData\MimSvcMaData.psm1'


$testResourceProperties = @{
    DisplayName                 = "CORP AD"
    Ensure						= 'Present'
}

Test-TargetResource @testResourceProperties -Verbose:$true
Set-TargetResource  @testResourceProperties -Verbose:$true

#>


Set-Location c:\MimDsc

#region: Test for an existing ma-data

Configuration TestMaData 
{ 

    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        MaData 'CORPAD'
        {
            DisplayName = 'CORP AD'
            Ensure		= 'Present'
        }
    } 
} 

TestMaData

Start-DscConfiguration -Wait -Verbose -Path "c:\MimDsc\TestMaData" -Force
#endregion
