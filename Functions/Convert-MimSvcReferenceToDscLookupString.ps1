function Convert-MimSvcReferenceToDscLookupString
{
	param
	( 
	<#
	A String the MIM ObjectID(s) to convert
	This is typically a single ID such as 'urn:uuid:1ef3d501-3c7b-42ad-8407-2c51cbb7a09b' 
	or a more complex string containing multiple IDs, such as a XOML or Filter
	#>
    [parameter(Mandatory=$true, ValueFromPipeline = $true)]
    $ReferenceString
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
            $mimObject = Get-Resource -ID $ReferenceString -AttributesToGet ObjectType, Name, TimeZoneId, AccountName, DisplayName

            ###
            ### Return if the referenced object is not found
            ###
            if (-not $mimObject)
            {
                Write-Warning "Could not find MIM object for this ObjectID: $ReferenceString"
                return
            }

            ###
            ### Get the attribute that is unique for this object type
            ###
            if ($mimObject.ObjectType -in 'ObjectTypeDescription','AttributeTypeDescription')
            {
                Write-Output "'$($mimObject.Name -replace "'", "''" -replace "’", "''" -replace "’", "''")'"
            }
            elseif($mimObject.ObjectType -eq 'TimeZoneConfiguration')
            {
                 Write-Output "'$($mimObject.TimeZoneId -replace "'", "''" -replace "’", "''" -replace "’", "''")'"
            }
            elseif($mimObject.ObjectType -eq 'Person')
            {
                 Write-Output "'$($mimObject.AccountName -replace "'", "''" -replace "’", "''" -replace "’", "''")'"
            }
            else
            {
                Write-Output "'$($mimObject.DisplayName -replace "'", "''" -replace "’", "''" -replace "’", "''")'"
            }
        }
        else
        {
        	$regex = [regex]"[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}"
            if ($regex.IsMatch($ReferenceString))
            {
                foreach($regexMatch in $regex.Matches($ReferenceString))
                {
                    $mimObject = Get-Resource -ID $regexMatch.Value -AttributesToGet ObjectType, Name, TimeZoneId, AccountName, DisplayName
                    if ($mimObject)
                    {
                        ###
                        ### Get the attribute that is unique for this object type
                        ###
                        ### TODO - do we really need the string replaces here?
                        if ($mimObject.ObjectType -in 'ObjectTypeDescription','AttributeTypeDescription')
                        {
                            $mimAttributeName  = 'Name'
                            $mimAttributeValue = $mimObject.Name
                        }
                        elseif($mimObject.ObjectType -eq 'Person')
                        {
                            $mimAttributeName  = 'AccountName'
                            $mimAttributeValue = $mimObject.AccountName
                        }
                        else
                        {
                            $mimAttributeName  = 'DisplayName'
                            $mimAttributeValue = $mimObject.DisplayName
                        }
                        $jsonString = '{{ObjectType:"{0}",AttributeName:"{1}",AttributeValue:"{2}"}}' -F $mimObject.ObjectType, $mimAttributeName, $mimAttributeValue
                        $ReferenceString = $ReferenceString -replace $regexMatch.Value, $jsonString
                    }
                }               
            }

            ## Only output if this string was created
            if ($ReferenceString)
            {
                $ReferenceString = $ReferenceString -replace "'","''" -replace "’","''" -replace "´","''"
                Write-Output "'$ReferenceString'"
            }
        }
    }
}