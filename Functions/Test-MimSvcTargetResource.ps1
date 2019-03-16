function Test-MimSvcTargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[HashTable]
		$DscBoundParameters,

		[System.String]
		$ObjectType,

		[System.String]
		$KeyAttributeName
	)
    if ($DscBoundParameters['Verbose'] -eq $true)
    {
        $VerbosePreference = 'Continue'
    }
    Write-Verbose "PSBoundParameters:"
    Write-VerboseHashTable $DscBoundParameters
    
    ### Initialize our return value
    $returnValue = $false

    ##HACK
    if ($DscBoundParameters.ContainsKey('GroupScope'))
    {
        $DscBoundParameters.Add('Scope', $DscBoundParameters['GroupScope']) | Out-Null
        $DscBoundParameters.Remove('GroupScope') | Out-Null
    }

    $keyAttributeValue = $DscBoundParameters[$KeyAttributeName]
    Write-Verbose "MIM Attribute Key: $KeyAttributeName, $keyAttributeValue"

    ###
    ### Build an XPath Filter to find the target object
    ###
    if ($ObjectType -eq 'SearchScopeConfiguration')
    {
        $xpathFilter = "/$ObjectType[$KeyAttributeName='$keyAttributeValue' and Order='$($DscBoundParameters['Order'])']"
    }
    elseif ($ObjectType -eq 'BindingDescription')
    {
        $xpathFilter = "/$ObjectType[BoundAttributeType=/AttributeTypeDescription[Name='$($DscBoundParameters['BoundAttributeType'])'] and BoundObjectType=/ObjectTypeDescription[Name='$($DscBoundParameters['BoundObjectType'])']]"
    }
    else
    {
        $xpathFilter = "/$ObjectType[$KeyAttributeName=""$keyAttributeValue""]"
    }
    Write-Verbose "Searching using XPath: $xpathFilter"

    ###
    ### If a credential was supplied, then do the first search as that credentials
    ### the FimAutomation PS-Snapin caches the credential so we don't have to supply 
    ### the credential again in this function.
    ###
    if ($DscBoundParameters['Credential'])
    {
        Write-Verbose "Searching as $($DscBoundParameters['Credential'].UserName)."
        $mimSvcObject = Get-MimSvcObjectByXPath -Filter $xpathFilter  -Credential $DscBoundParameters['Credential']
    }
    else
    {
        Write-Verbose "Searching as LocalSystem (NOTE: this will fail if LocalSystem has not been granted permissions)."
        $mimSvcObject = Get-MimSvcObjectByXPath -Filter $xpathFilter
    }
    
    ###
    ### Check the schema cache and update if necessary
    ### NOTE: it is important that this function gets called AFTER the first MIM Service search so that credentials get cached by the FimAutomation Snap-In
    ###
    Write-MimSvcSchemaCache
    
    if ($DscBoundParameters['Ensure'] -eq 'Present')
    {
        if ($mimSvcObject -eq $null)
        {
            Write-Verbose "$ObjectType '$keyAttributeValue' not found."
            $returnValue = $false
        }
        elseif ($mimSvcObject -is [array])
        {
            Write-Verbose "Mulitple $ObjectType objects found.  This will be corrected by deleting the MPRs then creating a new one based on the desirable state."
            $returnValue = $false
        }
        else
        {
            Write-Verbose "$ObjectType found, diffing the properties: $($mimSvcObject.ObjectID)"
            $objectsAreTheSame = $true

            $fimAttributeTypes = Get-MimSvcSchemaCache -ObjectType $ObjectType | Convert-MimSvcExportToPSObject

            ### Note the syntax to label the loop, used in the switch statement to continue the for loop which to PowerShell is the outer loop
            :FimAttributeTypes foreach ($attributeType in $fimAttributeTypes)
            {
                if ($attributeType.Name -in 'Assistant','AuthNWFLockedOut','AuthNWFRegistered','AuthNLockoutRegistrationID','ComputedMember','ConnectedSystem','Dependency','DomainConfiguration','ObjectID','CreatedTime','Creator','ResourceTime','DeletedTime','ObjectType','Precedence','DetectedRulesList','ExpectedRulesList','ExpirationTime','MVObjectID','Temporal')
                {
                    Write-Verbose " Skipping system-owned attribute: $($attributeType.Name)"
                    continue
                }
                if ($attributeType.Name -in 'ExplicitMember','Manager','Assistant')
                {
                    Write-Verbose " Skipping user-owned attribute: $($attributeType.Name)"
                    continue
                }

                ### Process References before comparing
                if ($attributeType.DataType -eq 'Reference')
                {
                    $targetObjectType = ''
                    $searchAttribute = 'DisplayName'

                    switch ($attributeType.Name)
                    {
                        {$_ -in 'PrincipalSet','ResourceCurrentSet','ResourceFinalSet','AllowedMembershipReferences'} {$targetObjectType = 'Set'}
                        {$_ -in 'AuthenticationWorkflowDefinition','AuthorizationWorkflowDefinition','ActionWorkflowDefinition'} {$targetObjectType = 'WorkflowDefinition'}
                        {$_ -in 'BoundAttributeType','AllowedAttributes'} {$targetObjectType = 'AttributeTypeDescription'; $searchAttribute = 'Name'}
                        {$_ -eq 'BoundObjectType'} {$targetObjectType = 'ObjectTypeDescription'; $searchAttribute = 'Name'}
                        {$_ -in 'ExplicitMember','Manager','Owner','DisplayedOwner'} {$targetObjectType = 'Person'; $searchAttribute = 'AccountName'}
                        {$_ -eq 'TimeZone'} {$targetObjectType = 'TimeZoneConfiguration'; $searchAttribute = 'TimeZoneId'}
                        {$_ -eq 'SynchronizeObjectType'} {$targetObjectType = 'ObjectTypeDescription'; $searchAttribute = 'Name'}
                        {$_ -eq 'ManagementAgentID'} {$targetObjectType = 'ma-data';}
                        Default {Write-Warning "Skipping a reference attribute we don't know how to resolve: $($attributeType.Name).";continue FimAttributeTypes}
                    }

                    ### Is there a value on both the MIM object and DSC object? if yes then we need to convert the value from DSC to an ObjectID
                    if ($mimSvcObject.($attributeType.Name) -and $DscBoundParameters[$attributeType.Name])
                    {
                        if ($attributeType.Multivalued -eq 'True')
                        {
                            $mimSvcObjectIDs = $DscBoundParameters[$attributeType.Name] | 
                            ForEach-Object {
                                Write-Verbose " Resolving $($attributeType.Name) to a GUID: $_"
                                "urn:uuid:{0}" -F (Get-MimSvcObjectID -ObjectType $targetObjectType -AttributeName $searchAttribute -AttributeValue $_)
                            }
                            $DscBoundParameters[$attributeType.Name] = $mimSvcObjectIDs
                        }
                        else
                        {
                            Write-Verbose " Resolving $($attributeType.Name) to a GUID: $($DscBoundParameters[$attributeType.Name])"
                            $DscBoundParameters[$attributeType.Name] = "urn:uuid:{0}" -F (Get-MimSvcObjectID -ObjectType $targetObjectType -AttributeName $searchAttribute -AttributeValue $DscBoundParameters[$attributeType.Name])
                        }
                    }
                }

                ### Process Strings with References
                if ($attributeType.Name -in 'Filter','XOML')
                {
                    Write-Verbose " Processing references in the '$($attributeType.Name)' attribute"

                    ### Regex for finding JSON strings
                    $regexJsons = [regex]'\{ObjectType:".+?",AttributeName:".+?",AttributeValue:".+?"}'

                    ### Replace the JSON string with a GUID
                    foreach ($jsonString in $regexJsons.Matches($DscBoundParameters[$attributeType.Name]))
                    {
                        Write-Verbose "  Converting '$jsonString' to a FIM ObjectID"
                        $jsonObject = ConvertFrom-Json -InputObject $jsonString

                        $mimSvcObjectID = Get-MimSvcObjectID -ObjectType $jsonObject.ObjectType -AttributeName $jsonObject.AttributeName -AttributeValue $jsonObject.AttributeValue

                        $DscBoundParameters[$attributeType.Name] = $DscBoundParameters[$attributeType.Name] -replace $jsonString, $mimSvcObjectID 
                    }
                }

                Write-Verbose " Comparing $($attributeType.Name)"
                if ($attributeType.Multivalued -eq 'True')
                {
                    Write-Verbose "  From DSC: $($DscBoundParameters[$attributeType.Name] -join ',')"
                    Write-Verbose "  From FIM: $($mimSvcObject.($attributeType.Name) -join ',')"

                    if ($DscBoundParameters[$attributeType.Name] -eq $null -and $mimSvcObject.($attributeType.Name) -eq $null)
                    {
                        ### do nothing.  done.
                    }
                    elseif ($DscBoundParameters[$attributeType.Name] -eq $null -and $mimSvcObject.($attributeType.Name) -ne $null)
                    {
                        ### need to delete all attribute values in MIM
                        Write-Warning "  '$($attributeType.Name)' property is not the same."
                        $objectsAreTheSame = $false
                    }
                    elseif ($DscBoundParameters[$attributeType.Name] -ne $null -and $mimSvcObject.($attributeType.Name) -eq $null)
                    {
                        ### need to add all attribute values in MIM
                        Write-Warning "  '$($attributeType.Name)' property is not the same."
                        $objectsAreTheSame = $false
                    }
                    elseif (Compare-Object $DscBoundParameters[$attributeType.Name] $mimSvcObject.($attributeType.Name))
                    {
                        Write-Warning "  '$($attributeType.Name)' property is not the same."
                        $objectsAreTheSame = $false
                    }
                }
                elseif ($attributeType.DataType -eq 'Boolean')
                {
                    Write-Verbose "  From DSC: $($DscBoundParameters[$attributeType.Name])"
                    Write-Verbose "  From FIM: $($mimSvcObject.($attributeType.Name))"
                    if ([Convert]::ToBoolean($DscBoundParameters[$attributeType.Name]) -ne [Convert]::ToBoolean($mimSvcObject.($attributeType.Name)))
                    {
                        Write-Warning "  '$($attributeType.Name)' property is not the same."
                        $objectsAreTheSame = $false
                    }
                }
                else
                {
                    Write-Verbose "  From DSC: $($DscBoundParameters[$attributeType.Name])"
                    Write-Verbose "  From FIM: $($mimSvcObject.($attributeType.Name))"

                    if ($DscBoundParameters[$attributeType.Name] -ne $mimSvcObject.($attributeType.Name))
                    {
                        Write-Warning "  '$($attributeType.Name)' property is not the same."
                        $objectsAreTheSame = $false
                    }
                }
            }

            $returnValue = $objectsAreTheSame 
        }
    }
    elseif($DscBoundParameters['Ensure'] -eq 'Absent')
    {
        if ($mimSvcObject -ne $null)
        {
            $returnValue = $false
        }
        else
        {
            $returnValue = $true
        }
    }
    else
    {
        Write-Error "Expected the 'Ensure' parameter to be 'Present' or 'Absent'"
    }

    ## Return the value
    return $returnValue
}