
Set-Location c:\MimDsc

#region Call the Set and Test methods directly - allows for setting a breakpoint for debuggering
Search-Resources -XPath "/Resource" -ExpectedObjectType Resource -MaxResults 5

ipmo MimDsc -Force
ipmo 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcResource\MimSvcResource.psm1' -Force
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcResource\MimSvcResource.psm1'
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\Functions\Test-MimSvcTargetResource.ps1'
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\Functions\Set-MimSvcTargetResource.ps1'

$resourceProperties = @{
	DisplayName = 'Anonymous User'
    Ensure		= 'Present'
}

Test-MimSvcTargetResource -ObjectType Resource -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

Set-MimSvcTargetResource -ObjectType Resource -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

#endregion

#region: Test for an existing Resource

Configuration TestResource 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        Resource AnonymousUser
        {
            DisplayName = 'Anonymous User'
            Ensure		= 'Present'
        }
    } 
} 

TestResource

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestResource" -Force
#endregion

