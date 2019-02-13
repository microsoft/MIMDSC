function Get-MimRegistryKey
{
<#
.Synopsis
   Gets the MIM Registry Key
.DESCRIPTION
   The MIM registry contains some useful detail for automation, such as the file path, logging level, database name, etc
.EXAMPLE
   Get-MimRegistryKey
#>
    [CmdletBinding()]
    Param
    (
        # param1 help description
        [Parameter(Position=0)]
        [ValidateSet('FIMSynchronization', 'FIMService', 'Via')]
        $Component = 'FIMSynchronization'
    )

    switch ($Component)
    {
        FIMSynchronization 
        {
	        ### The registry location depends on the version of the sync engine (it changed in FIM2010)
	        $fimRegKey = Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\miiserver -ErrorAction silentlycontinue
	        if (-not $fimRegKey )
	        {
	            $fimRegKey = Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\FIMSynchronizationService -ErrorAction silentlycontinue
	        }    
        }
        FIMService
        {
            $fimRegKey = Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\FIMService -ErrorAction silentlycontinue
        }
        Via
        {
            Write-Warning "Time to upgrade, perhaps?"
        }
    }

    ### Only output if we found what we were looking for
	if ($fimRegKey)
    {
        Write-Verbose ("Found the key: {0}" -F $fimRegKey.PSPath)
        Write-Output $fimRegKey
    }
    else
	{
	    Write-Warning "FIMSync does not seem to be installed on this system."	    
	}
}##Closing: function Get-MimRegistryKey