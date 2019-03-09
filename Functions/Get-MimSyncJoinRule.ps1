function Get-MimSyncJoinRule
{
<#
   .SYNOPSIS 
   Gets the Join Rules from Sync Server Configuration

   .DESCRIPTION
   Reads the server configuration from the XML files, and outputs the join rules as PSObjects

   .OUTPUTS
   PSObjects containing the synchronization server join rules
   
   .EXAMPLE
   Get-MimSyncJoinRule -ServerConfigurationFolder "C:\Temp\Zoomit\ServerConfiguration"

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
		
		### join rules are contained in the ma-data nodes of the MA*.XML files
		$maFiles = @(get-item (Join-Path $ServerConfigurationFolder "MA-*.xml"))
				
		foreach ($maFile in $maFiles)
		{
			### Get the MA Name and MA ID
		   	$maName = (select-xml $maFile -XPath "//ma-data/name").Node.InnerText
		   
            foreach($joinRule in (Select-Xml -path $maFile -XPath "//join/join-profile" | Select-Object -ExpandProperty Node))
            {
                $joinCriterion = $joinRule.'join-criterion' | Convert-MimSyncJoinCriterionToCimInstance

                $rule = New-Object PSObject                
                $rule | Add-Member -MemberType noteproperty -name 'MAName' -value $maName
                $rule | Add-Member -MemberType noteproperty -name 'CDObjectType' -value $joinRule.'cd-object-type'
                $rule | Add-Member -MemberType noteproperty -name 'JoinCriterion' -value $joinCriterion
                $rules += $rule                
            }
        }
        Write-Output $rules
    }
}