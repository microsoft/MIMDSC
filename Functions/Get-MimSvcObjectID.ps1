Function Get-MimSvcObjectID
{
   	Param
    (       
        $ObjectType,
		
        [parameter(Mandatory=$true)]
        [String]
        $AttributeName = 'DisplayName',
		
        [parameter(Mandatory=$true)]
        [alias('searchValue')]
        [String]
        $AttributeValue,

        <#
	    .PARAMETER Uri
	    The Uniform Resource Identifier (URI) of MIM Service. The following example shows how to set this parameter: -uri "http://localhost:5725"
	    #>
	    [String]
	    $Uri = "http://localhost:5725"
    )
    Process
    {   
		$resolver = New-Object Microsoft.ResourceManagement.Automation.ObjectModel.ImportObject
        $resolver.SourceObjectIdentifier = [Guid]::Empty
        $resolver.TargetObjectIdentifier = [Guid]::Empty
        $resolver.ObjectType 			 = $ObjectType
        $resolver.State 				 = 'Resolve'
		
        $anchorPair = New-Object Microsoft.ResourceManagement.Automation.ObjectModel.JoinPair
        $anchorPair.AttributeName  = $AttributeName
        $anchorPair.AttributeValue = $AttributeValue
                    
        $resolver.AnchorPairs = $anchorPair
        
        try
        {
            Import-FIMConfig $resolver -Uri $Uri -ErrorAction Stop | Out-Null
     
            if ($resolver.TargetObjectIdentifier -eq [Guid]::Empty)
            {
                ### This did NOT resolve to an object on the target system
                Write-Error ("An object was not found with this criteria: '{0}:{1}:{2}'"   -F  $ObjectType, $AttributeName,  $AttributeValue)
            }
            else
            {
                ### This DID resolve to an object on the target system
                Write-Output ($resolver.TargetObjectIdentifier -replace 'urn:uuid:')
            }         
        }
        catch
        {
            if ($_.Exception.Message -ilike '*the target system returned no matching object*')
            {
                ### This did NOT resolve to an object on the target system
                Write-Error ("An object was not found with this criteria: '{0}:{1}:{2}'" -F  $ObjectType, $AttributeName,  $AttributeValue)
            }
            elseif ($_.Exception.Message -ilike '*cannot filter as requested*')
            {
                ### This is a bug in Import-FIMConfig whereby it does not escape single quotes in the XPath filter
                ### Try again using Export-FIMConfig
                $exportResult = Export-FIMConfig -Uri $Uri -OnlyBaseResources -CustomConfig ("/{0}[{1}=`"{2}`"]" -F $resolver.ObjectType, $resolver.AnchorPairs[0].AttributeName, $resolver.AnchorPairs[0].AttributeValue ) -ErrorAction SilentlyContinue
                
                if ($exportResult -eq $null)
                {
                    Write-Error ("An object was not found with this criteria: '{0}:{1}:{2}'" -F  $ObjectType, $AttributeName,  $AttributeValue)
                }
                else
                {
                    Write-Output ($exportResult.ResourceManagementObject.ObjectIdentifier -replace 'urn:uuid:' )
                }            
            }
            else
            {
               Write-Error ("Import-FimConfig produced an error while resolving this object in the target system. The exception thrown was: {0}" -F $_.Exception.Message)
            } 
        }
    }
}