function Get-MimSyncMVDeletionRule
{
<#
   .SYNOPSIS 
   Gets the MV Deletion Rules from Sync Server Configuration

   .DESCRIPTION
   Reads the server configuration from the XML files, and outputs the MV deletion rules as PSObjects

   .OUTPUTS
   PSObjects containing the synchronization server MV deletion rules
   
   .EXAMPLE
   Get-MimSyncMVDeletionRule -ServerConfigurationFolder "C:\Temp\Zoomit\ServerConfiguration"

#>
   Param
   (        
        [parameter(Mandatory=$false)]
		[String]
		[ValidateScript({Test-Path $_})]
		$ServerConfigurationFolder = (Get-MimSyncConfigCache)
   ) 
   End
   {   	
        $maNameToGuidMap = @{}
        foreach ($maDataXml in Select-Xml -Path (Join-Path $ServerConfigurationFolder *.xml) -XPath "//ma-data")
        {   
            $maNameToGuidMap.Add($maDataXml.node.id, $maDataXml.node.name)
        }

        ### Get the object XML from the server configuration files
        Write-Verbose "Finding the MV Deletion Rules..."
        $xPathFilter = "//mv-data/mv-deletion/mv-deletion-rule"
        Write-Verbose "  Using XPath: $xPathFilter"
        $deletionRules = Select-Xml -Path (Join-Path $ServerConfigurationFolder mv.xml) -XPath $xPathFilter

        foreach($deletionRule in $deletionRules)
        {
            $outputObject = [PSCustomObject]@{
                MVObjectType       = $deletionRule.Node.'mv-object-type'
                Type               = $deletionRule.Node.type
            }
            if ($deletionRule.Node.type -eq 'declared-any')
            {
                $srcMANames = @()
                foreach ($srcMAID in $deletionRule.Node.'src-ma')
                {
                    $srcMANames += $maNameToGuidMap[$srcMAID]
                }
                $outputObject | Add-Member -MemberType NoteProperty -Name ManagementAgentName -Value $srcMANames
            }

            if ($deletionRule.Node.type -eq 'declared-last')
            {
                $srcMANames = @()
                foreach ($srcMAID in $deletionRule.Node.'exclude-ma')
                {
                    $srcMANames += $maNameToGuidMap[$srcMAID]
                }
                $outputObject | Add-Member -MemberType NoteProperty -Name ManagementAgentName -Value $srcMANames                
            }

            Write-Output $outputObject
        }
    }
}