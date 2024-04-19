function Set-MimSvcTargetResource
{
	[CmdletBinding()]
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

    Write-Verbose "Searching as LocalSystem (NOTE: this will fail if LocalSystem has not been granted permissions)."
    $mimSvcObject = Search-Resources -XPath $xpathFilter -ExpectedObjectType $ObjectType

    if ($DscBoundParameters['Ensure'] -eq 'Present')
    {
        Write-Verbose "Ensure -eq 'Present'"

        if ($mimSvcObject -eq $null)
        {
            Write-Verbose "$ObjectType is missing, so adding it: $DisplayName" 
            $mimSvcObject = New-Resource -ObjectType $ObjectType            
        }
        elseif ($mimSvcObject -is [array])
        {
            Write-Verbose "Mulitple $ObjectType objects found.  This will be corrected by deleting the existing objects then creating a new one based on the desirable state."
            foreach($m in $mimSvcObject)
            {
                Write-Verbose "  Deleting $ObjectType : $($m.ObjectID)"
                $m | Remove-Resource
            }
            
            $mimSvcObject = New-Resource -ObjectType $ObjectType
        }
        else
        {
            Write-Verbose "$ObjectType is present, so updating it: $DisplayName, $($mimSvcObject.ObjectID)"
        }
    }
    elseif($DscBoundParameters['Ensure'] -eq 'Absent')
    {
        Write-Verbose "Ensure -eq 'Absent'"
        if ($mimSvcObject -ne $null)
        {
            Write-Verbose "$ObjectType is present, so removing it: $DisplayName"
            $mimSvcObject | Remove-WmiObject
        }
    }
    else
    {
        Write-Error "Expected the 'Ensure' parameter to be 'Present' or 'Absent'"
    }
    
    $mimAttributeTypes = Get-MimSvcSchemaCache -ObjectType $ObjectType

    $fimImportChanges = @()
    foreach ($attributeType in $mimAttributeTypes)
    {
        if ($attributeType.Name -in 'Assistant','AuthNWFLockedOut','AuthNWFRegistered','AuthNLockoutRegistrationID','ComputedMember','ConnectedSystem','Dependency','DomainConfiguration','ObjectID','Precedence','CreatedTime','Creator','ResourceTime','DeletedTime','ObjectType','DetectedRulesList','ExpectedRulesList','ExpirationTime','MVObjectID','Temporal')
        {
            Write-Verbose " Skipping system-owned attribute: $($attributeType.Name)"
            continue
        }

        if ($attributeType.Name -in 'ExplicitMember','Manager','Assistant')
        {
            Write-Verbose " Skipping user-owned attribute: $($attributeType.Name)"
            continue
        }

        ###
        ### Process References before comparing
        ### Only do this when a value exists on the DSC side
        ###
        if ($attributeType.DataType -eq 'Reference' -and $DscBoundParameters.ContainsKey($attributeType.Name))
        {
            $mimTargetObjectType = ''
            $mimSearchAttribute = 'DisplayName'

            switch ($attributeType.Name)
            {
                {$_ -in 'PrincipalSet','ResourceCurrentSet','ResourceFinalSet','AllowedMembershipReferences'} {$mimTargetObjectType = 'Set'}
                {$_ -in 'AuthenticationWorkflowDefinition','AuthorizationWorkflowDefinition','ActionWorkflowDefinition'} {$mimTargetObjectType = 'WorkflowDefinition'}
                {$_ -in 'BoundAttributeType','AllowedAttributes'} {$mimTargetObjectType = 'AttributeTypeDescription'; $mimSearchAttribute = 'Name'}
                {$_ -eq 'BoundObjectType'} {$mimTargetObjectType = 'ObjectTypeDescription'; $mimSearchAttribute = 'Name'}
                {$_ -in 'ExplicitMember','Manager','Assistant','Owner','DisplayedOwner'} {$mimTargetObjectType = 'Person'; $mimSearchAttribute = 'AccountName'}
                {$_ -eq 'TimeZone'} {$mimTargetObjectType = 'TimeZoneConfiguration'; $mimSearchAttribute = 'TimeZoneId'}
                {$_ -eq 'SynchronizeObjectType'} {$mimTargetObjectType = 'ObjectTypeDescription'; $mimSearchAttribute = 'Name'}
                {$_ -eq 'ManagementAgentID'} {$mimTargetObjectType = 'ma-data';}
                Default {Write-Error "Found a reference attribute we don't know how to resolve: $($attributeType.Name)."}
            }

            if ($attributeType.Multivalued -eq 'True')
            {
                $mimObjectIDs = @()
                foreach($searchValue in $DscBoundParameters[$attributeType.Name])
                {
                    Write-Verbose " Resolving $($attributeType.Name) to a GUID: $searchValue"
                    $mimObjectIDs += "urn:uuid:{0}" -F (Get-Resource -ObjectType $mimTargetObjectType -AttributeName $mimSearchAttribute -AttributeValue $searchValue -AttributesToGet ObjectID | Select-Object -ExpandProperty ObjectID | Select-Object -ExpandProperty Value)
                }

                $DscBoundParameters[$attributeType.Name] = $mimObjectIDs
            }
            else 
            {
                Write-Verbose " Resolving $($attributeType.Name) to a GUID: $($DscBoundParameters[$attributeType.Name])"
                $DscBoundParameters[$attributeType.Name] = "urn:uuid:{0}" -F (Get-Resource -ObjectType $mimTargetObjectType -AttributeName $mimSearchAttribute -AttributeValue $DscBoundParameters[$attributeType.Name] -AttributesToGet ObjectID | Select-Object -ExpandProperty ObjectID | Select-Object -ExpandProperty Value)
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

                $mimObjectID = Get-Resource -ObjectType $jsonObject.ObjectType -AttributeName $jsonObject.AttributeName -AttributeValue $jsonObject.AttributeValue -AttributesToGet ObjectID | Select-Object -ExpandProperty ObjectID | Select-Object -ExpandProperty Value

                $DscBoundParameters[$attributeType.Name] = $DscBoundParameters[$attributeType.Name] -replace $jsonString, $mimObjectID 
            }
        }

        Write-Verbose " Comparing $($attributeType.Name)"
        if ($attributeType.Multivalued -eq 'True')
        {
            Write-Verbose "  From DSC: $($DscBoundParameters[$attributeType.Name] -join ',')"
            Write-Verbose "  From MIM: $($mimSvcObject.($attributeType.Name) -join ',')"

            if ($DscBoundParameters[$attributeType.Name] -eq $null -and $mimSvcObject.($attributeType.Name) -eq $null)
            {
                ### do nothing.  done.
            }
            elseif ($DscBoundParameters[$attributeType.Name] -eq $null -and $mimSvcObject.($attributeType.Name) -ne $null)
            {
                ### need to delete all attribute values in MIM
                $mimSvcObject.($attributeType.Name) | ForEach-Object {
                    Write-Warning "  Deleting $($attributeType.Name) value: $($_)"                    
                }
                $mimSvcObject.($attributeType.Name).Clear()
            }
            elseif ($DscBoundParameters[$attributeType.Name] -ne $null -and $mimSvcObject.($attributeType.Name) -eq $null)
            {
                ### need to add all attribute values to MIM
                $DscBoundParameters[$attributeType.Name] | ForEach-Object {
                    Write-Warning "  Adding   $($attributeType.Name) value: $($_)"
                    $mimSvcObject.($attributeType.Name).Add($_)                    
                }
            }
            else
            {
                Compare-Object $DscBoundParameters[$attributeType.Name] $mimSvcObject.($attributeType.Name) | ForEach-Object {
                    if ($_.SideIndicator -eq '<=')
                    {
                        Write-Warning "  Adding   $($attributeType.Name) value: $($_.InputObject)"
                        $mimSvcObject.($attributeType.Name).Add($_.InputObject) 
                    }
                    elseif ($_.SideIndicator -eq '=>')
                    {
                        Write-Warning "  Deleting $($attributeType.Name) value: $($_.InputObject)"
                        $mimSvcObject.($attributeType.Name).Remove($_.InputObject) 
                    }
                }
            }
        }
        elseif ($attributeType.DataType -eq 'Boolean')
        {
            Write-Verbose "  From DSC: $($DscBoundParameters[$attributeType.Name])"
            Write-Verbose "  From MIM: $($mimSvcObject.($attributeType.Name))"
            if ([Convert]::ToBoolean($DscBoundParameters[$attributeType.Name]) -ne [Convert]::ToBoolean($mimSvcObject.($attributeType.Name)) -or ($DscBoundParameters.ContainsKey($attributeType.Name) -and -not $mimSvcObject.($attributeType.Name)))
            {
                Write-Warning "  Updating $($attributeType.Name) value: $($DscBoundParameters[$attributeType.Name])"
                $mimSvcObject.($attributeType.Name) = ($DscBoundParameters[$attributeType.Name] -as [Boolean])                
            }
        }
        elseif ($attributeType.DataType -eq 'Integer')
        {
            Write-Verbose "  From DSC: $($DscBoundParameters[$attributeType.Name])"
            Write-Verbose "  From MIM: $($mimSvcObject.($attributeType.Name))"
            if ($DscBoundParameters[$attributeType.Name] -ne $mimSvcObject.($attributeType.Name))
            {
                Write-Warning "  Updating $($attributeType.Name) value: $($DscBoundParameters[$attributeType.Name])"
                $mimSvcObject.($attributeType.Name) = ($DscBoundParameters[$attributeType.Name] -as [String])                   
            }
        }
        else
        {
            Write-Verbose "  From DSC: $($DscBoundParameters[$attributeType.Name])"
            Write-Verbose "  From MIM: $($mimSvcObject.($attributeType.Name))"

            if ($DscBoundParameters[$attributeType.Name] -ne $mimSvcObject.($attributeType.Name))
            {
                if ($DscBoundParameters[$attributeType.Name])
                {
                    Write-Warning "  Updating $($attributeType.Name) value: $($DscBoundParameters[$attributeType.Name])"
                    $mimSvcObject.($attributeType.Name) = $DscBoundParameters[$attributeType.Name]
                }
                else
                {
                    Write-Warning "  Updating $($attributeType.Name) with no value"
                    $mimSvcObject.($attributeType.Name) = $null
                }
            }
        }
    }

    if ($DscBoundParameters['Ensure'] -eq 'Present')
    {
        Write-Verbose "Saving the object to MIM"
        Save-Resource -Resources $mimSvcObject
    }
}