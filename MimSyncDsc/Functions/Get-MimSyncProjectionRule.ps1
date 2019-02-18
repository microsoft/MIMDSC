function Get-MimSyncProjectionRule
{
<#
   .SYNOPSIS 
   Gets the Join Rules from Sync Server Configuration

   .DESCRIPTION
   Reads the server configuration from the XML files, and outputs the projection rules as PSObjects

   .OUTPUTS
   PSObjects containing the synchronization server projection rules
   
   .EXAMPLE
   Get-MimSyncProjectionRule -ServerConfigurationFolder "C:\Temp\Zoomit\ServerConfiguration"

#>
   Param
   (        
        [parameter(Mandatory=$false)]
		[String]
		[ValidateScript({Test-Path $_})]
		$ServerConfigurationFolder
   ) 
   End
   {   	
   		### This is where the rules will be aggregated before we output them
		$rules = @()
		
		### projection rules are contained in the ma-data nodes of the MA*.XML files
		$maFiles = @(get-item (Join-Path $ServerConfigurationFolder "MA-*.xml"))
				
		foreach ($maFile in $maFiles)
		{
			### Get the MA Name and MA ID
		   	$maName = (select-xml $maFile -XPath "//ma-data/name").Node.InnerText
		   
            foreach($projectionRule in (Select-Xml -path $maFile -XPath "//projection/class-mapping" | Select-Object -ExpandProperty Node))
            {                
                $rule = New-Object PSObject                
                $rule | Add-Member -MemberType noteproperty -name 'MAName' -value $maName
                $rule | Add-Member -MemberType noteproperty -name 'CDObjectType' -value $projectionRule.'cd-object-type'                
                $rule | Add-Member -MemberType noteproperty -name 'Type' -value $projectionRule.type

                $mvObjectType = ''
                if ($projectionRule.type -eq 'declared') {
                    $mvObjectType = $projectionRule.'cd-object-type'
                }                
                $rule | Add-Member -MemberType noteproperty -name 'MVObjectType' -value $mvObjectType
                $rules += $rule                
            }
        }
        Write-Output $rules
    }
}