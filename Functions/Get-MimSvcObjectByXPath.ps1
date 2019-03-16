function Get-MimSvcObjectByXPath
{
<#
.SYNOPSIS 
Gets objects from the MIM Service using Export-FimConfig, returns the ExportObjects converted to PSObjects

.DESCRIPTION
This is just a convenience function over the typica command of Export-FimConfig | Convert-MimSvcExportToPSObject
   
.EXAMPLE
Get-MimSvcObjectByXPath -Filter "/Person" 

#>
    param
    (
        [parameter(Mandatory = $true)]
        [string]
        $Filter,
        [string]
        $Uri = "http://localhost:5725",
        $Credential
    )
    if ($PSBoundParameters.ContainsKey('Credential'))
    {
        Export-FimConfig -Only -Custom $Filter -Uri $Uri -Credential $Credential | Convert-MimSvcExportToPSObject
    }
    else
    {
        Export-FimConfig -Only -Custom $Filter -Uri $Uri | Convert-MimSvcExportToPSObject
    }
}