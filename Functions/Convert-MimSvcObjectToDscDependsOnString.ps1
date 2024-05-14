function Convert-MimSvcObjectToDscDependsOnString
{
	param
	( 
	<#
	A MIM Service Object to convert
	#>
    [parameter(Mandatory=$true, ValueFromPipeline = $true)]
    $MimObject
	) 
    begin
    {
        $dependsOnStrings = @()
    }
	process
	{        
        $dscConfigurationItemName = Convert-MimSvcObjectToDscItemName -MimObject $MimObject
        Write-Verbose "   DependsOn [$($MimObject.ObjectType)]$($dscConfigurationItemName)"
        $dependsOnStrings += ("'[{0}]{1}'" -F ($MimObject.ObjectType  -replace '-'), $dscConfigurationItemName)    
    }
    end
    {
        ### Only output if we have items
        if ($dependsOnStrings.Count -gt 0)
        {
            Write-Output ($dependsOnStrings -join ',')
        }
    }
}