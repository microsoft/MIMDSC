function Get-MimSyncPath
{
<#
.Synopsis
   Get the Path for the Synchronization Service
.DESCRIPTION
   Long description
.EXAMPLE
   Get-MimSyncPath
#>
    $fimRegKey = Get-MimRegistryKey -Component FIMSynchronization
    Get-ItemProperty -Path (Join-Path $fimRegKey.PSPath Parameters) | select -ExpandProperty Path
}##Closing: function Get-MimSyncPath