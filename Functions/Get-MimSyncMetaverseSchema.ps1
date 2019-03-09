function Get-MimSyncMetaverseSchema
{
<#
   .SYNOPSIS 
   Gets the MV Attributes and Object Types

   .DESCRIPTION
   Reads the MV configuration from the XML file, and outputs the MV Attributes and Object Types

   .OUTPUTS
   PSObjects containing the synchronization server MV Attributes and Object Types
   
   .EXAMPLE
   Get-MimSyncMetaverseSchema .\ServerConfig\001\mv.xml | Out-GridView
   
#>
 	param
   	(        
        [parameter(Mandatory=$false)]
		[String]		         
        [ValidateScript({(test-path -path $_ -PathType Leaf)})]
		$MVSchemaFile = 'mv.xml'
   	) 
	end
	{
		[xml]$mvXML = get-content $MVSchemaFile
		
		$namespace = @{dsml="http://www.dsml.org/DSML"; 'ms-dsml'="http://www.microsoft.com/MMS/DSML"}
		
		###
		### Attribute Types
		###
		$mvAttributeTypes = select-xml $mvXML -XPath "//dsml:directory-schema/dsml:attribute-type" -Namespace $namespace | select -ExpandProperty Node 
		
		$attributes = @()
		foreach ($mvAttributeType in $mvAttributeTypes)
		{
			switch($mvAttributeType.syntax)
			{
				'1.3.6.1.4.1.1466.115.121.1.12' 
                {
                    $syntax = 'Reference';
                    break
                }
				'1.3.6.1.4.1.1466.115.121.1.15' 
                {
                    $syntax = 'String';
                    break
                }
				'1.3.6.1.4.1.1466.115.121.1.5' 
                {
                    $syntax = 'Binary';
                    break
                }
				'1.3.6.1.4.1.1466.115.121.1.27' 
                {
                    $syntax = 'Number';
                    break
                }
				'1.3.6.1.4.1.1466.115.121.1.7' 
                {
                    $syntax = 'Boolean';
                    break
                }
                default 
                {
                    $syntax = "Unknown"; 
                    break
                }
			}
		
			$attribute = New-Object PSObject
			$attribute | Add-Member -MemberType NoteProperty -Name 'AttributeName' -Value $mvAttributeType.name
			$attribute | Add-Member -MemberType NoteProperty -Name 'Syntax' -Value $syntax
            $attribute | Add-Member -MemberType NoteProperty -Name 'Indexable' -Value ($mvAttributeType.'indexable' -eq 'true')
			$attribute | Add-Member -MemberType NoteProperty -Name 'Indexed' -Value ($mvAttributeType.indexed -ne $null)
			$attribute | Add-Member -MemberType NoteProperty -Name 'MultiValued' -Value ($mvAttributeType.'single-value' -ne 'true' -or $mvAttributeType.'single-value' -eq $null)
			$attributes += $attribute
		}
		
		###
		### Bindings
		###
		$mvObjectTypes = select-xml $mvXML -XPath "//dsml:directory-schema/dsml:class" -Namespace $namespace | select -ExpandProperty node
		
		### Loop through the Source Class items, then output an attribute with the object type
		foreach ($mvObjectType in $mvObjectTypes)
		{
			Write-Verbose ("`nProcessing Bindings for {0}" -F $mvObjectType.name)			
			$bindings = $mvObjectType | select -expandproperty attribute | select -ExpandProperty ref
			foreach($binding in $bindings)
			{
				#$attributes | Where-Object {$_.Name -eq $binding.Replace("#",'')} | foreach {$_.ObjectType = $mvObjectType.name; Write-Output $_}
                $attributes | 
                    Where-Object {$_.AttributeName -eq $binding.Replace("#",'')} |
                    Select-Object -Property @{Name="ObjectType";Expression={$mvObjectType.name}},* |
                    Write-Output
			}
		}
	}
}