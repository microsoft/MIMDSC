function Format-MimSynchronizationConfigurationFiles
{
<#
   	.SYNOPSIS 
   	Formats the XML in the MIM Sync configuration files 

   	.DESCRIPTION
   	The MIM synchronization XMLs are not formatted when created by MIM.  This makes source control a little ugly when diffing the files.
	This function simply formats the XML files to make them easier to diff.

   	.OUTPUTS
   	None.  the function operates on the existing files.
   
   	.EXAMPLE
   	Format-MIMSynchronizationConfigurationFiles c:\MyMIMSyncConfigFolder
#>
   Param
   	(       
   		<#
		Specifies the folder containing the MA and MV XML files 
		(defaults to the current folder)
		#>		
        [parameter(Mandatory=$false)]
		[String]
		[ValidateScript({Test-Path $_})]
		$ServerConfigurationFolder = (Get-Location),
        <# Set to false if you do not want to rename files to friendly names #>
        [parameter()]
        [Switch]
        $RenameFiles = $true
   	) 
	###Change to $ServerConfigurationFolder
	Write-Verbose "Changing to the directory: $ServerConfigurationFolder" 
	Set-Location $ServerConfigurationFolder
   
	###Process each of the MA XML files
    foreach ($maData in Select-Xml -Path (Join-Path $ServerConfigurationFolder '*.xml') -XPath "//ma-data")
    {
        Write-Verbose "Processing MA XML file: $($maData.Path)" 

        ###Clear the ReadOnly Flag
	    (get-item $maData.Path).Set_IsReadOnly($false)

        ###Format the XML File
	    Format-XML $maData.Path

        if ($RenameFiles)
        {
	        ###Only rename the file if it doesn't already contain the MA Name
	        if($maData.Path -inotcontains $maData.Node.name)
	        {
	            Rename-Item $maData.Path -NewName "Connector_$($maData.Node.name).xml"
	        }
        }
    }

    foreach ($synchronizationRule in Select-Xml -Path (Join-Path $ServerConfigurationFolder '*.xml') -XPath "/synchronizationRule")
    {
        Write-Verbose "Processing SynchronizationRule XML file: $($synchronizationRule.Path)"

        ###Clear the ReadOnly Flag
	    (get-item $synchronizationRule.Path).Set_IsReadOnly($false)

        ###Format the XML File
	    Format-XML $synchronizationRule.Path

        if ($RenameFiles)
        {
	        ###Only rename the file if it doesn't already contain the SynchronizationRule Name
	        if($synchronizationRule.Path -inotcontains $synchronizationRule.Node.name)
	        {
	            Rename-Item $synchronizationRule.Path -NewName "SynchronizationRule_$($synchronizationRule.Node.id)-$($synchronizationRule.Node.name).xml"
	        }
        }
    }

	Write-Verbose "Processing MV.XML file"

	###Clear the ReadOnly Flag
	(get-item "MV.xml").Set_IsReadOnly($false)
	###Format the MV XML file
	Format-XML "MV.xml"   
}