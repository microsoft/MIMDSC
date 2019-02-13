if (-not (Get-Module xDSCResourceDesigner -ListAvailable))
{
    Install-Module xDSCResourceDesigner
}

Get-DscResource -Module MimSyncDsc | ForEach-Object {
    $dscResource = $PSItem
    Describe "DscResource Designer Validation for $($dscResource.ResourceType)"{
        It 'Test-xDscResource Should Pass'{
            Test-xDscResource -Name $dscResource.Name | Should Be True
        }

        It 'Test-xDscSchema Should Pass'{
            Test-xDscSchema -Path "$(Join-Path $dscResource.ParentPath $dscResource.ResourceType).schema.mof"  | Should Be True
        }
    }
}