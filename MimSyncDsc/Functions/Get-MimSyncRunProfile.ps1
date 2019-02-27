function Get-MimSyncRunProfile
{
<#
   .SYNOPSIS 
   Gets the Run Profiles from Sync Server Configuration

   .DESCRIPTION
   Reads the server configuration from the XML files, and outputs the run profiles as PSObjects

   .OUTPUTS
   PSObjects containing the synchronization server run profiles
   
   .EXAMPLE
   Get-MimSyncRunProfile -ServerConfigurationFolder "C:\Temp\Zoomit\ServerConfiguration"

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
		### run profiles are contained in the ma-data nodes of the MA*.XML files
		$maFiles = @(get-item (Join-Path $ServerConfigurationFolder "MA-*.xml"))
				
		foreach ($maFile in $maFiles)
		{
			### Get the MA Name and MA ID
		   	$maName = (select-xml $maFile -XPath "//ma-data/name").Node.InnerText
		   
            foreach($runProfileXml in (Select-Xml -path $maFile -XPath "//ma-run-data/run-configuration" | Select-Object -ExpandProperty Node))
            {
                $runSteps = $runProfileXml.configuration.step | Convert-MimSyncRunStepToCimInstance

                $runProfile = [PSCustomObject]@{
                    Name                       = $runProfileXml.name
                    ManagementAgentName        = $maName
                    CreationTime               = $runProfileXml.'creation-time'
                    LastModificationTime       = $runProfileXml.'last-modification-time'
                    Version                    = $runProfileXml.version
                    RunSteps                   = $runSteps
                } 

                Write-Output $runProfile
            } 
        }       
    }
}