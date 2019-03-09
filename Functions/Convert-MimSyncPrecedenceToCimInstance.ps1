
function Convert-MimSyncPrecedenceToCimInstance
{
<#
.Synopsis
   Converts the MIM Sync XML to a CIM Instance
.DESCRIPTION
   MIM Sync uses XML to represent the configuration objects
   DSC uses CIM instances to work with custom MOF classes
   It is necessary for the DSC resource to create CIM instances from the MIM Sync XML 
.EXAMPLE
Get-MimSyncServerXml -Path (Get-MimSyncConfigCache) -Force
$fimSyncObject = Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) *.xml)-XPath "//mv-data/import-attribute-flow/import-flow-set[@mv-object-type='computer']/import-flows[@mv-attribute='domain']"

ipmo MimSyncDsc
$fimSyncObject.Node | Convert-MimSyncPrecedenceToCimInstance
.EXAMPLE
$importFlows = [xml]@'
  <import-flows mv-attribute="domain" type="ranked">
    <import-flow src-ma="{30E0A4F7-54E1-4B3A-87B0-082DE2F32858}" cd-object-type="computer" id="{6F790854-207D-45C1-864F-15E05483374B}"/>
    <import-flow src-ma="{30E0A4F7-54E1-4B3A-87B0-082DE2F32858}" cd-object-type="msDS-ManagedServiceAccount" id="{B7BD8790-4C50-4071-B327-0DEB9953B607}"/>
    <import-flow src-ma="{8B264FDE-96CE-4C60-ABFA-1C7AB83E697A}" cd-object-type="computer" id="{F49F9768-D93B-47F5-879D-92C1E6F7BA4F}"/>
    <import-flow src-ma="{8B264FDE-96CE-4C60-ABFA-1C7AB83E697A}" cd-object-type="msDS-ManagedServiceAccount" id="{F931015E-DB47-44FC-8C80-864F16782607}"/>
    <import-flow src-ma="{9928BF4E-A2A3-4460-8338-9069106EB6D7}" cd-object-type="computer" id="{3B9682B6-2F82-4E80-980F-F87F2E588F4A}"/>
    <import-flow src-ma="{9928BF4E-A2A3-4460-8338-9069106EB6D7}" cd-object-type="msDS-ManagedServiceAccount" id="{192E1F26-AFCE-46AA-A264-E606BB4EEBA2}"/>
    <import-flow src-ma="{8F38FA8C-84CD-4B16-B750-9770A2B4E999}" cd-object-type="computer" id="{0809478E-A0BF-487B-8DDA-4833C1D64243}"/>
    <import-flow src-ma="{8F38FA8C-84CD-4B16-B750-9770A2B4E999}" cd-object-type="msDS-ManagedServiceAccount" id="{D5C58F7B-44D5-485A-A1E7-8982FCA460AE}"/>
    <import-flow src-ma="{22748291-AFC0-480D-B84A-B1C6A5CAA8DF}" cd-object-type="computer" id="{D3B79CBE-A83D-4FD9-95C1-2D8DBF1D9EF5}"/>
    <import-flow src-ma="{22748291-AFC0-480D-B84A-B1C6A5CAA8DF}" cd-object-type="msDS-ManagedServiceAccount" id="{7BD5B54F-E86F-4592-8C55-98971E5E93A8}"/>
    <import-flow src-ma="{C2B18EE3-95C0-44BB-9717-57801819E05C}" cd-object-type="computer" id="{7222A10F-EA35-4E85-B48E-BE73639107F9}"/>
    <import-flow src-ma="{C2B18EE3-95C0-44BB-9717-57801819E05C}" cd-object-type="msDS-ManagedServiceAccount" id="{28A354BB-6B5F-4987-AC0D-6D6A0FFF3774}"/>
    <import-flow src-ma="{77040D9F-E3F3-49EF-BB23-4E4AC192445C}" cd-object-type="computer" id="{1F987F98-3ABD-47EF-881E-27CE5D1C942B}"/>
  </import-flows>
'@
$importFlows.'import-flows' | Convert-MimSyncPrecedenceToCimInstance
.INPUTS
   XML of the RunSteps from the RunProfile
.OUTPUTS
   a CIM Instance for the RunStep
.COMPONENT
   The component this cmdlet belongs to
#>
    [CmdletBinding()]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    Param
    (
        # Join Criterion to Convert
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true, 
                   Position=0)] 
        $ImportFlows
    )
    Begin{
        $maNameToGuidMap = @{}
        foreach ($maDataXml in Select-Xml -Path (Join-Path (Get-MimSyncConfigCache) *.xml) -XPath "//ma-data")
        {   
            $maNameToGuidMap.Add($maDataXml.node.id, $maDataXml.node.name)
        }

        $RankedPrecedenceOrder = @()

        $rank = 0
    }

    Process{
        foreach($ImportFlow in $ImportFlows.'import-flow')
        {
            $RankedPrecedenceOrder += New-CimInstance -ClassName MimSyncRankedPrecedenceOrder -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
                Order               = $rank                                  -as [Uint16]
                CDObjectType        = $ImportFlow.'cd-object-type'           -as [String]
                ID                  = $ImportFlow.id                         -as [String]
                ManagementAgentName = $maNameToGuidMap[$ImportFlow.'src-ma'] -as [String]
            }
            $rank++
        }
    }

    End{
        Write-Output -InputObject $RankedPrecedenceOrder
    }
}
