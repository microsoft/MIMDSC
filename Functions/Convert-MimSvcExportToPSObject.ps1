Function Convert-MimSvcExportToPSObject
{
    Param
    (
        [parameter(Mandatory=$true, ValueFromPipeline = $true)]
        [Microsoft.ResourceManagement.Automation.ObjectModel.ExportObject]
        $ExportObject
    )
    Process
    {        
        $psObject = New-Object PSObject
        $psObject.PSTypeNames.Insert(0, 'MimSvc.FimObject')

        $ExportObject.ResourceManagementObject.ResourceManagementAttributes | ForEach-Object{
            if ($_.Value -ne $null)
            {
                $value = $_.Value
            }
            elseif($_.Values -ne $null)
            {
                $value = $_.Values
            }
            else
            {
                $value = $null
            }
            $psObject | Add-Member -MemberType NoteProperty -Name $_.AttributeName -Value $value
        }
        Write-Output $psObject
    }
}