if (-not (Get-Module xDSCResourceDesigner -ListAvailable))
{
    Install-Module xDSCResourceDesigner -Scope CurrentUser -Force -Confirm:$false
}

Get-DscResource -Module MimDsc | ForEach-Object {
    $dscResource = $PSItem
    Describe -Tag 'Build' "DscResource Designer Validation for $($dscResource.ResourceType)"{
        It 'Test-xDscResource Should Pass'{
            Test-xDscResource -Name $dscResource.Name | Should Be True
        }

        It 'Test-xDscSchema Should Pass'{
            Test-xDscSchema -Path "$(Join-Path $dscResource.ParentPath $dscResource.ResourceType).schema.mof"  | Should Be True
        }
    }
}