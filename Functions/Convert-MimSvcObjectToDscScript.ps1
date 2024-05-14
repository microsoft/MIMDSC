function Convert-MimSvcObjectToDscScript
{
	param
	(
	[parameter(Mandatory=$true, ValueFromPipeline = $true)]
	$MimObject,
    [Switch]$SkipGuidConversion,
    [Switch]$SkipDependsOnForSchema
	)
    begin
    {
            $includedAttributes = @('Description','Filter','AccountName','DisplayName','FirstName','LastName','DisplayedOwner','MembershipAddWorkflow','MembershipLocked','Owner','Scope','Type','Domain')
            $mimReferenceValues = @()
    }
	process
	{       
        Write-Verbose "[$(Get-Date)] MIM Object: [$($MimObject.ObjectType)]$($MimObject.ObjectID)" 
        $mimObjectType = $MimObject.ObjectType
        
        $supportedObjectTypes = @(
            'ActivityInformationConfiguration'
            'AttributeTypeDescription'
            'BindingDescription'
            'DomainConfiguration'
            'EmailTemplate'
            'FilterScope'
            'ForestConfiguration'
            'Group'
            'HomepageConfiguration'
            #'ma-data'
            'ManagementPolicyRule'
            'msidmSystemConfiguration'
            'NavigationBarConfiguration'
            'ObjectTypeDescription'
            'ObjectVisualizationConfiguration'
            'Person'
            'PortalUIConfiguration'
            'Resource'
            'SearchScopeConfiguration'
            'Set'
            'SynchronizationFilter'
            'SynchronizationRule'
            'SystemResourceRetentionConfiguration'
            'TimeZoneConfiguration'
            'WorkflowDefinition'
        )
        if ($MimObject.ObjectType -notin $supportedObjectTypes)
        {
            Write-Warning "   Object type not currently supported: $($MimObject.ObjectType)"
            return
        }  

        ###
        ### Check to see if we've already processed this item
        ###
        if ($mimObject.ObjectID -in $global:processedObjectIDs)
        {
            Write-Warning ("   This objectID has already been processed already: {0}" -F $mimObject.ObjectID)
            return
        }
        else
        {
            Write-Debug ("   Adding ObjectID to the list of items already processed: {0}" -F $mimObject.ObjectID)
            $global:processedObjectIDs += $mimObject.ObjectID
        }

        ### Get the DSC type and DSC item name for this object
        $dscResourceType = "$($MimObject.ObjectType)" -replace '-'
        $dscItemName = Convert-MimSvcObjectToDscItemName -MimObject $MimObject
        $mimDscString = "$dscResourceType $dscItemName`n{`n" 

        ### Find the longest attribute name to determine the column width
        $columnWidth = $mimObject | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | Select-Object -ExpandProperty Length | Sort-Object| Select-Object -Last 1
        Write-Debug "Using a column width of $columnWidth"

        <#
        ### Get the DSC resource for this object type        
        if ($Script:DscResourceProperties.ContainsKey($dscResourceType))
        {
            $dscResourcePropertyNames = $Script:DscResourceProperties[$dscResourceType]
        }
        else
        {          
            $dscResource = Get-DscResource -Name $dscResourceType
            $dscResourcePropertyNames = $dscResource.Properties | Select-Object -ExpandProperty Name

            $Script:DscResourceProperties.Add($dscResourceType, $dscResourcePropertyNames)
        }
        #>

        ##HACK - rename 'Scope' to 'GroupScope'
        if (($mimObject | Get-Member -MemberType NoteProperty).Name -contains 'Scope')
        {
            #$scopeAttribute = $mimObject | Get-Member -MemberType NoteProperty | Where AttributeName -eq 'Scope'
            #$scopeAttribute.AttributeName = 'GroupScope'
            Write-Warning "Hacked out hack - this could break something"
        }

        $mimDependsOnValues = @()

        foreach($mimAttribute in ($mimObject | Get-Member -MemberType NoteProperty))
        {
            Write-Debug "   Processing attribute: $($mimAttribute.AttributeName)"
            if ($mimAttribute.Name -in 'AuthNWFLockedOut','AuthNWFRegistered','AuthNLockoutRegistrationID','DomainConfiguration','ObjectID','CreatedTime','Creator','ResourceTime','DeletedTime','ObjectType','DetectedRulesList','ExpectedRulesList','ExpirationTime','MVObjectID')
            {
                Write-Debug "  Skipping system-owned attribute: $($mimAttribute.Name)"
                continue
            }

            if ($mimAttribute.Name -in 'ExplicitMember','ComputedMember')
            {
                Write-Debug "   Skipping user-owned attribute: $($mimAttribute.Name)"
                continue
            }

            <#
            if ($mimAttribute.Name -notin $dscResourcePropertyNames)
            {
                Write-Warning "   Skipping attribute because there is no matching property in the DSC resource: $($mimAttribute.Name)"
            }
            #>
            $attributeType = Search-Resources -XPath "/AttributeTypeDescription[Name = '$($mimAttribute.Name)']" -AttributesToGet Name, DataType,Multivalued

            $mimDscAttributeString = ''
            if ($attributeType.MultiValued -and $attributeType.DataType -eq 'Reference')
            {
                $mimAttributeValues = @()
                foreach($mimAttributeValue in $mimObject.($mimAttribute.Name))
                {
                    
                    $mimAttributeValues += Convert-MimSvcReferenceToDscLookupString -ReferenceString $mimAttributeValue
                    $mimDependsOnValues += Convert-MimSvcReferenceToMimObject -ReferenceString $mimAttributeValue -SkipDependsOnForSchema:$SkipDependsOnForSchema | Convert-MimSvcObjectToDscDependsOnString                 
                    $mimReferenceValues += $mimAttributeValue
                }               
                $mimDscAttributeString = $mimAttributeValues -join ','
            }
            elseif ($attributeType.MultiValued)
            {
                $mimAttributeValues = @()
                foreach($mimAttributeValue in $mimObject.($mimAttribute.Name))
                {
                    $mimAttributeValues +=  "'$mimAttributeValue'"
                }
                $mimDscAttributeString = $mimAttributeValues -join ','
            }
            else
            {
                if ($attributeType.DataType -eq 'Reference')
                {
                    if ([String]::IsNullOrEmpty($mimObject.($mimAttribute.Name)))
                    {
                        Write-Debug "   Skipping attribute because there is no attribute value: $($mimAttribute.Name)"
                    }
                    else
                    {                
                        $mimDscAttributeString = Convert-MimSvcReferenceToDscLookupString -ReferenceString $mimObject.($mimAttribute.Name)
                        $mimDependsOnValues   += Convert-MimSvcReferenceToMimObject -ReferenceString $mimObject.($mimAttribute.Name) -SkipDependsOnForSchema:$SkipDependsOnForSchema | Convert-MimSvcObjectToDscDependsOnString 
                        $mimReferenceValues   += $mimObject.($mimAttribute.Name) 
                    }                    
                }
                else
                {
                    $tryParseResult = $false
                    if ([boolean]::TryParse($mimObject.($mimAttribute.Name),[ref]$tryParseResult))
                    {
                        $mimDscAttributeString = '${0}' -F $tryParseResult
                    }
                    else
                    {
                        $mimDscAttributeString = "'$($mimObject.($mimAttribute.Name) -replace "'","''" -replace "’","''")'"
                    }
                }
            }

            ### Only output the property if there is a property value
            if ([String]::IsNullOrEmpty($mimObject.($mimAttribute.Name)))
            {
                Write-Debug "   Skipping attribute because there is no attribute value: $($mimAttribute.Name)"
            }
            else
            {                
                $mimDscString += "`t{0,-$columnWidth} = {1}`n" -F $mimAttribute.Name, $mimDscAttributeString 
            }
        }

        if ($mimDependsOnValues.Count -gt 0)
        {
            $mimDscString += "`t{0,-$columnWidth} = {1}`n" -F 'DependsOn', (($mimDependsOnValues | Select-Object -Unique) -join ',')
        }
        $mimDscString += "`t{0,-$columnWidth} = '{1}'`n" -F 'Ensure', 'Present'        
        $mimDscString += "}`n"
        
		Write-Output ([PSCustomObject]@{
            ObjectType       = $mimObjectType
            ObjectIdentifier = $mimObject.ObjectID
            DscItemScript    = $mimDscString
        })
	}
    end
    {
        $exportsToProcess = $mimReferenceValues | Convert-MimSvcReferenceToMimObject -SkipDependsOnForSchema:$SkipDependsOnForSchema | Sort-Object -Property ObjectID -Unique  
        foreach($exportToProcess in $exportsToProcess)
        {
            if ($exportToProcess.ObjectID -notin $global:processedObjectIDs)
            {
                #Write-Host "   DependsOn [$($exportToProcess.ObjectType)] $($exportToProcess.ObjectID)"
                Convert-MimSvcObjectToDscScript -MimObject $exportToProcess | Write-Output
            }
        }     
    }
}