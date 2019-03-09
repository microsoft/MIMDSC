function Get-MimSyncExportAttributeFlow
{
<#
   .SYNOPSIS 
   Gets the Export Attribute Flow Rules from Sync Server Configuration

   .DESCRIPTION
   Reads the server configuration from the XML files, and outputs the Export Attribute Flow rules as PSObjects

   .OUTPUTS
   PSObjects containing the synchronization server export attribute flow rules
   
   .EXAMPLE
   Get-MimSyncExportAttributeFlow -ServerConfigurationFolder "C:\Temp\Zoomit\ServerConfiguration"

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
		
		### Export attribute flow rules are contained in the ma-data nodes of the MA*.XML files
		$maFiles = @(get-item (Join-Path $ServerConfigurationFolder "MA-*.xml"))
		
		
		foreach ($maFile in $maFiles)
		{
			### Get the MA Name and MA ID
		   	$maName = (select-xml $maFile -XPath "//ma-data/name").Node.InnerText
		   
		    foreach($exportFlowSet in (Select-Xml -path $maFile -XPath "//export-flow-set" | select -ExpandProperty Node))
		    {
		        $mvObjectType = $exportFlowSet.'mv-object-type'
		        $cdObjectType = $exportFlowSet.'cd-object-type'
		        
		        foreach($exportFlow in $exportFlowSet.'export-flow')
		        {
		            $cdAttribute = $exportFlow.'cd-attribute'
		            [bool]$allowNulls = $false
					[bool]::TryParse($exportFlow.'suppress-deletions', [ref]$allowNulls) | Out-Null	

                    [string]$initialFlowOnly = $null
                    [string]$isExistenceTest = $null
		          
		            if ($exportFlow.'direct-mapping' -ne $null)
		            {
                        ###
                        ### Handle src-attribute that are intrinsic (<src-attribute intrinsic="true">object-id</src-attribute>)
                        ###
                        if ($exportFlow.'direct-mapping'.'src-attribute'.intrinsic)
                        {
                            $srcAttribute = "{0}" -F $exportFlow.'direct-mapping'.'src-attribute'.'#text'
                        }
                        else
                        {
		                    $srcAttribute = $exportFlow.'direct-mapping'.'src-attribute'
                        }
		                
						$rule = New-Object PSObject
						$rule | Add-Member -MemberType NoteProperty -Name 'ID' -Value $exportFlow.id
		                $rule | Add-Member -MemberType NoteProperty -Name 'RuleType' -Value 'direct-mapping'
		                $rule | Add-Member -MemberType NoteProperty -Name 'MAName' -Value $maName                
		                $rule | Add-Member -MemberType NoteProperty -Name 'MVObjectType' -Value $mvObjectType
		                $rule | Add-Member -MemberType NoteProperty -Name 'MVAttribute' -Value $srcAttribute
		                $rule | Add-Member -MemberType NoteProperty -Name 'CDObjectType' -Value $cdObjectType
		                $rule | Add-Member -MemberType NoteProperty -Name 'CDAttribute' -Value $cdAttribute
						$rule | Add-Member -MemberType NoteProperty -Name 'ScriptContext' -Value $null
						$rule | Add-Member -MemberType NoteProperty -Name 'AllowNulls' -Value $allowNulls
                        $rule | Add-Member -MemberType NoteProperty -Name 'InitialFlowOnly' -Value $initialFlowOnly
                        $rule | Add-Member -MemberType NoteProperty -Name 'IsExistenceTest' -Value $isExistenceTest
		                
		                $rules += $rule
					}
					elseif ($exportFlow.'constant-mapping' -ne $null)
		            {
						$constantValue = $exportFlow.'constant-mapping'.'constant-value'
						$rule = New-Object PSObject
						$rule | Add-Member -MemberType NoteProperty -Name 'ID' -Value $exportFlow.id
		                $rule | Add-Member -MemberType NoteProperty -Name 'RuleType' -Value 'constant-mapping'
		                $rule | Add-Member -MemberType NoteProperty -Name 'MAName' -Value $maName                
		                $rule | Add-Member -MemberType NoteProperty -Name 'MVObjectType' -Value $mvObjectType
		                $rule | Add-Member -MemberType NoteProperty -Name 'MVAttribute' -Value $null
		                $rule | Add-Member -MemberType NoteProperty -Name 'CDObjectType' -Value $cdObjectType
		                $rule | Add-Member -MemberType NoteProperty -Name 'CDAttribute' -Value $cdAttribute
						$rule | Add-Member -MemberType NoteProperty -Name 'ScriptContext' -Value $null
						$rule | Add-Member -MemberType NoteProperty -Name 'AllowNulls' -Value $null
                        $rule | Add-Member -MemberType NoteProperty -Name 'InitialFlowOnly' -Value $null
						$rule | Add-Member -MemberType NoteProperty -Name 'IsExistenceTest' -Value $null
						$rule | Add-Member -MemberType NoteProperty -Name 'ConstantValue' -Value $constantValue

						$rules += $rule
					}
		            elseif ($exportFlow.'scripted-mapping' -ne $null)
		            {                
		                $scriptContext = $exportFlow.'scripted-mapping'.'script-context'		                
						$srcAttributes = @()
						
                        ###
                        ### Handle src-attribute that are intrinsic (<src-attribute intrinsic="true">object-id</src-attribute>)
                        ###
                        $exportFlow.'scripted-mapping'.'src-attribute' | ForEach-Object {
                            if ($_.intrinsic)
                            {
                                $srcAttributes += "{0}" -F $_.'#text'
                            }
                            else
                            {
		                        $srcAttributes += $_
                            }
                        }
                        if ($srcAttributes.Count -eq 1)
                        {
                            $srcAttributes = $srcAttributes -as [String]
                        }
		                    
						$rule = New-Object PSObject
						$rule | Add-Member -MemberType NoteProperty -Name 'ID' -Value $exportFlow.id
		                $rule | Add-Member -MemberType NoteProperty -Name 'RuleType' -Value 'scripted-mapping'
		                $rule | Add-Member -MemberType NoteProperty -Name 'MAName' -Value $maName
						$rule | Add-Member -MemberType NoteProperty -Name 'MVObjectType' -Value $mvObjectType
		                $rule | Add-Member -MemberType NoteProperty -Name 'MVAttribute' -Value $srcAttributes
		                $rule | Add-Member -MemberType NoteProperty -Name 'CDObjectType' -Value $cdObjectType
		                $rule | Add-Member -MemberType NoteProperty -Name 'CDAttribute' -Value $cdAttribute	
		                $rule | Add-Member -MemberType NoteProperty -Name 'ScriptContext' -Value $scriptContext
						$rule | Add-Member -MemberType NoteProperty -Name 'AllowNulls' -Value $allowNulls
                        $rule | Add-Member -MemberType NoteProperty -Name 'InitialFlowOnly' -Value $initialFlowOnly
                        $rule | Add-Member -MemberType NoteProperty -Name 'IsExistenceTest' -Value $isExistenceTest
		                                
		                $rules += $rule                        
		            }
					elseif ($exportFlow.'sync-rule-mapping' -ne $null)
					{
						$srcAttribute = $exportFlow.'sync-rule-mapping'.'src-attribute'
                        $initialFlowOnly = $exportFlow.'sync-rule-mapping'.'initial-flow-only'
                        $isExistenceTest = $exportFlow.'sync-rule-mapping'.'is-existence-test'

						if($exportFlow.'sync-rule-mapping'.'mapping-type' -eq 'direct')
						{
							$rule = New-Object PSObject
							$rule | Add-Member -MemberType NoteProperty -Name 'ID' -Value $exportFlow.id
							$rule | Add-Member -MemberType NoteProperty -Name 'RuleType' -Value 'sync-rule-mapping'
							$rule | Add-Member -MemberType NoteProperty -Name 'MAName' -Value $maName
							$rule | Add-Member -MemberType NoteProperty -Name 'MVObjectType' -Value $mvObjectType
							$rule | Add-Member -MemberType NoteProperty -Name 'MVAttribute' -Value $srcAttribute
							$rule | Add-Member -MemberType NoteProperty -Name 'CDObjectType' -Value $cdObjectType
							$rule | Add-Member -MemberType NoteProperty -Name 'CDAttribute' -Value $cdAttribute														
							$rule | Add-Member -MemberType NoteProperty -Name 'ScriptContext' -Value $null
							$rule | Add-Member -MemberType NoteProperty -Name 'AllowNulls' -Value $allowNulls
                            $rule | Add-Member -MemberType NoteProperty -Name 'InitialFlowOnly' -Value $initialFlowOnly
							$rule | Add-Member -MemberType NoteProperty -Name 'IsExistenceTest' -Value $isExistenceTest
							$rule | Add-Member -MemberType NoteProperty -Name 'MappingType' -Value $exportFlow.'sync-rule-mapping'.'mapping-type'
											
							$rules += $rule             
						}
						elseif ($exportFlow.'sync-rule-mapping'.'mapping-type' -eq 'expression')
						{
							$scriptContext = $exportFlow.'sync-rule-mapping'.'sync-rule-value'.'export-flow'.InnerXml
							$cdAttribute  = $exportFlow.'sync-rule-mapping'.'sync-rule-value'.'export-flow'.dest

							$rule = New-Object PSObject
							$rule | Add-Member -MemberType NoteProperty -Name 'ID' -Value $exportFlow.id
							$rule | Add-Member -MemberType NoteProperty -Name 'RuleType' -Value 'sync-rule-mapping'
							$rule | Add-Member -MemberType NoteProperty -Name 'MAName' -Value $maName
							$rule | Add-Member -MemberType NoteProperty -Name 'MVObjectType' -Value $mvObjectType
							$rule | Add-Member -MemberType NoteProperty -Name 'MVAttribute' -Value $srcAttribute
							$rule | Add-Member -MemberType NoteProperty -Name 'CDObjectType' -Value $cdObjectType
							$rule | Add-Member -MemberType NoteProperty -Name 'CDAttribute' -Value $cdAttribute														
							$rule | Add-Member -MemberType NoteProperty -Name 'ScriptContext' -Value $scriptContext
							$rule | Add-Member -MemberType NoteProperty -Name 'AllowNulls' -Value $allowNulls
                            $rule | Add-Member -MemberType NoteProperty -Name 'InitialFlowOnly' -Value $initialFlowOnly
                            $rule | Add-Member -MemberType NoteProperty -Name 'IsExistenceTest' -Value $isExistenceTest
                            $rule | Add-Member -MemberType NoteProperty -Name 'InitialFlowOnly' -Value $initialFlowOnly
							$rule | Add-Member -MemberType NoteProperty -Name 'IsExistenceTest' -Value $isExistenceTest
							$rule | Add-Member -MemberType NoteProperty -Name 'MappingType' -Value $exportFlow.'sync-rule-mapping'.'mapping-type'
											
							$rules += $rule             
						}
						else
						{
							throw "Unsupported Export Flow type"
						}
			           
					}
		        }
		    }
		}
		
		Write-Output $rules
   }#End
}