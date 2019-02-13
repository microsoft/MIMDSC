function Get-MimSyncImportAttributeFlow
{
<#
   	.SYNOPSIS 
   	Gets the Import Attribute Flow Rules from Sync Server Configuration

   	.DESCRIPTION
   	Reads the server configuration from the XML files, and outputs the Import Attribute Flow rules as PSObjects

   	.OUTPUTS
   	PSObjects containing the synchronization server import attribute flow rules
   
   	.EXAMPLE
   	Get-ImportAttributeFlow -ServerConfigurationFolder "C:\Temp\MIIS\ServerConfiguration" | out-gridview
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

		###
		### Loop through the management agent XMLs to get the Name:GUID mapping
		###
		$maList = @{}
		$maFiles = (get-item (join-path $ServerConfigurationFolder "*.xml"))
		foreach ($maFile in $maFiles)
		{
		   ### Skip the file if it does NOT contain an ma-data node
			if (select-xml $maFile -XPath "//ma-data" -ErrorAction 0)
			{
			   ### Get the MA Name and MA ID
			   $maName = (select-xml $maFile -XPath "//ma-data/name").Node.InnerText
			   $maID = (select-xml $maFile -XPath "//ma-data/id").Node.InnerText  
			   
			   $maList.Add($maID,$maName)
			}
		}

		###
		### Get:
		###    mv-object-type
		###      mv-attribute
		###        src-ma
		###        cd-object-type
		###          src-attribute
		###
		[xml]$mv = get-content (join-path $ServerConfigurationFolder "MV.xml")
 
		foreach($importFlowSet in $mv.selectNodes("//import-flow-set"))
		{
		    $mvObjectType = $importFlowSet.'mv-object-type'
		             
		    foreach($importFlows in $importFlowSet.'import-flows')
		    {
		        $mvAttribute = $importFlows.'mv-attribute'        
				$precedenceType = $importFlows.type
				$precedenceRank = 0
		           
		        foreach($importFlow in $importFlows.'import-flow')
		        {
		            $cdObjectType = $importFlow.'cd-object-type'
		            $srcMA = $maList[$importFlow.'src-ma']
		            $maID = $importFlow.'src-ma'
		            $maName = $maList[$maID]			
		                        
		            if ($importFlow.'direct-mapping' -ne $null)
		            {
						if ($precedenceType -eq 'ranked')
						{
						 $precedenceRank += 1
						}
						else
						{
						 $precedenceRank = $null
						}
					
                        ###
                        ### Handle src-attribute that are intinsic (<src-attribute intrinsic="true">dn</src-attribute>)
                        ###
                        if ($importFlow.'direct-mapping'.'src-attribute'.intrinsic)
                        {
                            $srcAttribute = "<{0}>" -F $importFlow.'direct-mapping'.'src-attribute'.'#text'
                        }
                        else
                        {
		                    $srcAttribute = $importFlow.'direct-mapping'.'src-attribute'
                        }
		                $rule = New-Object PSObject
		                $rule | Add-Member -MemberType noteproperty -name 'RuleType' -value 'DIRECT'
		                $rule | Add-Member -MemberType noteproperty -name 'SourceMA' -value $srcMA
		                $rule | Add-Member -MemberType noteproperty -name 'CDObjectType' -value $cdObjectType
		                $rule | Add-Member -MemberType noteproperty -name 'CDAttribute' -value $srcAttribute
		                $rule | Add-Member -MemberType noteproperty -name 'MVObjectType' -value $mvObjectType
		                $rule | Add-Member -MemberType noteproperty -name 'MVAttribute' -value $mvAttribute
		                $rule | Add-Member -MemberType noteproperty -name 'ScriptContext' -value $null
						$rule | Add-Member -MemberType noteproperty -name 'PrecedenceType' -value $precedenceType
						$rule | Add-Member -MemberType noteproperty -name 'PrecedenceRank' -value $precedenceRank
		                
		                $rules += $rule                               
		            }
		            elseif ($importFlow.'scripted-mapping' -ne $null)
		            {                
		                $scriptContext = $importFlow.'scripted-mapping'.'script-context'  

                        ###
                        ### Handle src-attribute that are intrinsic (<src-attribute intrinsic="true">dn</src-attribute>)
                        ###              
		                $srcAttributes = @()
                        $importFlow.'scripted-mapping'.'src-attribute' | ForEach-Object {
                            if ($_.intrinsic)
                            {
                                $srcAttributes += "<{0}>" -F $_.'#text'
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
						
						if ($precedenceType -eq 'ranked')
						{
						  $precedenceRank += 1
						}
						else
						{
						  $precedenceRank = $null
						}
		                
		                $rule = New-Object PSObject
		                $rule | Add-Member -MemberType noteproperty -name 'RuleType' -value 'SCRIPTED'
		                $rule | Add-Member -MemberType noteproperty -name 'SourceMA' -value $srcMA
		                $rule | Add-Member -MemberType noteproperty -name 'CDObjectType' -value $cdObjectType
		                $rule | Add-Member -MemberType noteproperty -name 'CDAttribute' -value $srcAttributes
		                $rule | Add-Member -MemberType noteproperty -name 'MVObjectType' -value $mvObjectType
		                $rule | Add-Member -MemberType noteproperty -name 'MVAttribute' -value $mvAttribute
						$rule | Add-Member -MemberType noteproperty -name 'ScriptContext' -value $scriptContext
						$rule | Add-Member -MemberType noteproperty -name 'PrecedenceType' -value $precedenceType
						$rule | Add-Member -MemberType noteproperty -name 'PrecedenceRank' -value $precedenceRank
		                                
		                $rules += $rule                        
		            }   
					elseif ($importFlow.'sync-rule-mapping' -ne $null)
		            {                
		                $scriptContext = $null 
						$ruleType = ("ISR - {0}" -f $importFlow.'sync-rule-mapping'.'mapping-type')
		                $srcAttributes = $importFlow.'sync-rule-mapping'.'src-attribute'    
						
						if ($precedenceType -eq 'ranked')
						{
						  $precedenceRank += 1
						}
						else
						{
						  $precedenceRank = $null
						}
						
						if ($importFlow.'sync-rule-mapping'.'mapping-type' -ieq 'expression')
						{
							$scriptContext = $importFlow.'sync-rule-mapping'.'sync-rule-value'.'import-flow'.InnerXml
						}
		                
		                $rule = New-Object PSObject
		                $rule | Add-Member -MemberType noteproperty -name 'RuleType' -value $ruleType
		                $rule | Add-Member -MemberType noteproperty -name 'SourceMA' -value $srcMA
		                $rule | Add-Member -MemberType noteproperty -name 'CDObjectType' -value $cdObjectType
		                $rule | Add-Member -MemberType noteproperty -name 'CDAttribute' -value $srcAttributes
		                $rule | Add-Member -MemberType noteproperty -name 'MVObjectType' -value $mvObjectType
		                $rule | Add-Member -MemberType noteproperty -name 'MVAttribute' -value $mvAttribute
						$rule | Add-Member -MemberType noteproperty -name 'ScriptContext' -value $scriptContext
						$rule | Add-Member -MemberType noteproperty -name 'PrecedenceType' -value $precedenceType
						$rule | Add-Member -MemberType noteproperty -name 'PrecedenceRank' -value $precedenceRank
		                                
		                $rules += $rule                        
		            }
					elseif ($importFlow.'constant-mapping' -ne $null)
					{
						if ($precedenceType -eq 'ranked')
						{
							 $precedenceRank += 1
						}
						else
						{
							 $precedenceRank = $null
						}

					
						$constantValue = $importFlow.'constant-mapping'.'constant-value'
						
		                $rule = New-Object PSObject
		                $rule | Add-Member -MemberType noteproperty -name 'RuleType' -value "CONSTANT"
		                $rule | Add-Member -MemberType noteproperty -name 'SourceMA' -value $srcMA
		                $rule | Add-Member -MemberType noteproperty -name 'CDObjectType' -value $cdObjectType
		                $rule | Add-Member -MemberType noteproperty -name 'CDAttribute' -value $null
		                $rule | Add-Member -MemberType noteproperty -name 'MVObjectType' -value $mvObjectType
		                $rule | Add-Member -MemberType noteproperty -name 'MVAttribute' -value $mvAttribute
						$rule | Add-Member -MemberType noteproperty -name 'ScriptContext' -value $null
						$rule | Add-Member -MemberType noteproperty -name 'PrecedenceType' -value $precedenceType
						$rule | Add-Member -MemberType noteproperty -name 'PrecedenceRank' -value $precedenceRank
						$rule | Add-Member -MemberType noteproperty -name 'ConstantValue' -value $constantValue
		                                
		                $rules += $rule                        
						
					}
		        }#foreach($importFlow in $importFlows.'import-flow')
		    }#foreach($importFlows in $importFlowSet.'import-flows')
		}#foreach($importFlowSet in $mv.selectNodes("//import-flow-set"))
		
		Write-Output $rules
   }#End
}