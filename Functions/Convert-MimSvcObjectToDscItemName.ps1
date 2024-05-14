function Convert-MimSvcObjectToDscItemName
{
	param
	( 
	<#
	A MIM Service Object to convert
	#>
    [parameter(Mandatory=$true, ValueFromPipeline = $true)]
    $MimObject
	) 
    
    ###
    ### Get the attribute that is unique for this object type
    if ($MimObject.ObjectType -in 'ObjectTypeDescription','AttributeTypeDescription')
    {
        $mimKeyAttributeValue = $MimObject.Name
    }
    elseif($MimObject.ObjectType  -eq 'BindingDescription')
    {
        ### Custom Configuration AttributeName for BindingDescription 
        $BoundAttribute = Get-Resource -ID $MimObject.BoundAttributeType
        $BoundObject    = Get-Resource -ID $MimObject.BoundObjectType

        $mimKeyAttributeValue = "{0}{1}" -F $BoundObject.Name, $BoundAttribute.Name
    }
    elseif($MimObject.ObjectType -in 'HomePageConfiguration','SearchScopeConfiguration')
    {
        $mimKeyAttributeValue = "{0}{1}" -F $MimObject.DisplayName, $MimObject.Order
    }
    else
    {
        $mimKeyAttributeValue = $MimObject.DisplayName
    }
    ## Do some sanitizing for the DSC item name
    Write-Output ($mimKeyAttributeValue -replace ' ' -replace '\)' -replace '\(' -replace '-' -replace "'" -replace ':' -replace "’" -replace '&' -replace '/' -replace ',')
}