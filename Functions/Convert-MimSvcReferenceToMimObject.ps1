function Convert-MimSvcReferenceToMimObject
{
	param
	( 
	<#
	A String the MIM ObjectID(s) to convert
	This is typically a single ID such as 'urn:uuid:1ef3d501-3c7b-42ad-8407-2c51cbb7a09b' 
	or a more complex string containing multiple IDs, such as a XOML or Filter
	#>
    [parameter(Mandatory=$true, ValueFromPipeline = $true)]
    $ReferenceString,
    [Switch]$SkipDependsOnForSchema
	) 
	process
	{
		###
		### Value will either be a GUID or a STRING containing multiple GUIDS
		###
		if ($ReferenceString -match "^urn:uuid:[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}")
		{
			###
			### Get the MIM object
			###
            if ($global:mimConfigHashTable)
            {
                $mimObject = $global:fimConfigHashTable[$ReferenceString]
            }
            else
            {
                $mimObjectType = Get-Resource -ID ($ReferenceString -replace 'urn:uuid:') -AttributesToGet ObjectType | Select -ExpandProperty ObjectType

                $attributesToGet = Get-MimSvcSchemaCache -ObjectType $mimObjectType | Select -Expand Name | Where {$_ -notin @('ComputedMember','ExplicitMember','DetectedRulesList','ExpectedRulesList','MVObjectID','ExpirationTime')} | Where {$_ -notlike 'syncconfig-*'}
                
                $mimObject = Get-Resource -ID ($ReferenceString -replace 'urn:uuid:') -AttributesToGet $attributesToGet
            }

            ###
            ### Return if the referenced object is not found
            ###
            if (-not $mimObject)
            {
                Write-Warning "Could not find MIM object for this ObjectID: $ReferenceString"
                return
            }

            ###
            ### Skip if Person or Group object type to avoid (StrongConnect : DependsOn link exceeded max depth limitation '1024')
            ###
            if ($mimObject.ObjectType -in 'Person','Group','Computer','ma-data','ForestConfiguration')
            {
                return
            }
            
            ###
            ### Skip if Schema
            ###
            if ($SkipDependsOnForSchema -and $mimObject.ObjectType -in 'ObjectTypeDescription','AttributeTypeDescription','BindingDescription')
            {
                return
            }

            $mimObject | Write-Output
        }
        else
        {
            $dependsOnStrings = @()
        	$regex = [regex]"[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}"
            foreach($regexMatch in $regex.Matches($ReferenceString))
            {
                if ($regexMatch.Value -eq [Guid]::Empty)
				{
					continue
				}

                if ($global:mimConfigHashTable)
                {
                    $refObject = $global:mimConfigHashTable["urn:uuid:$($regexMatch.Value)"]
                }
                else
                {
                    $refObjectType = Get-Resource -ID $regexMatch.Value -AttributesToGet ObjectType | Select -ExpandProperty ObjectType

                    $attributesToGet = Get-MimSvcSchemaCache -ObjectType $refObjectType | Select -Expand Name | Where {$_ -notin @('ComputedMember','ExplicitMember','DetectedRulesList','ExpectedRulesList','MVObjectID','ExpirationTime')} | Where {$_ -notlike 'syncconfig-*'}
                    
                    $refObject = Get-Resource -ID $regexMatch.Value -AttributesToGet $attributesToGet
                }

                ###
                ### Skip this loop iteration if the referenced object is not found
                ###
                if (-not $refObject)
                {
                    Write-Warning "Could not find MIM object for this ObjectID: $($regexMatch.Value)"
                    continue
                }

                ###
                ### Skip if Person or Group object type to avoid (StrongConnect : DependsOn link exceeded max depth limitation '1024')
                ###
                if ($refObject.ObjectType -in 'Person','Group','Computer')
                {
                    continue
                }

                ###
                ### Skip if Schema
                ###
                if ($SkipDependsOnForSchema -and $refObject.ObjectType -in 'ObjectTypeDescription','AttributeTypeDescription','BindingDescription')
                {
                    return
                }

                $refObject | Write-Output
            }
        }
    }
}