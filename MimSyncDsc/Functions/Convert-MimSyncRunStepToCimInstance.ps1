function Convert-MimSyncRunStepToCimInstance
{
<#
.Synopsis
   Converts the Sync XML to a CIM Instance
.DESCRIPTION
   MIM Sync uses XML to represent the configuration objects
   DSC uses CIM instances to work with custom MOF classes
   It is necessary for the DSC resource to create CIM instances from the MIM Sync XML 
.EXAMPLE
   $fimSyncObject = Select-Xml -Path $svrexportPath -XPath "//ma-data[name='TinyHR']/ma-run-data/run-configuration[name='Delta Import']"
   $fimSyncObject.Node.configuration.step | Convert-MimSyncRunStepToCimInstance
.EXAMPLE
   [xml]@'
<step>
    <step-type type="delta-import">
    <import-subtype>to-cs</import-subtype>
    </step-type>
    <threshold>
    <batch-size>1</batch-size>
    </threshold>
    <partition>{18A58F00-7B2D-4D9F-BA97-C17C4FDD11C4}</partition>
    <custom-data>
    <adma-step-data>
        <batch-size>100</batch-size>
        <page-size>500</page-size>
        <time-limit>120</time-limit>
    </adma-step-data>
    </custom-data>
</step>
'@ | Select-Object -ExpandProperty Step | Convert-MimSyncRunStepToCimInstance
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
        # Run Step to Convert
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   Position=0)]
        [Alias("RunSteps")] 
        $RunStep
    )
    Process
    {
        $StepSubtypes = @()
        $RunStep.'step-type'.ChildNodes | Where-Object NodeType -ne Whitespace | ForEach-Object {$StepSubtypes += $_.InnerText}

        $cimInstance = New-CimInstance -ClassName cFimSyncRunStep -ClientOnly -Namespace root/microsoft/windows/desiredstateconfiguration -Property @{
            StepType            = $RunStep.'step-type'.type -as [String]
            PartitionIdentifier = $RunStep.partition -as [String]
            StepSubtype         = '' -as [String[]]
            BatchSize           = $RunStep.threshold.'batch-size' -as [UInt32]
            InputFile           = $RunStep.'custom-data'.'run-config'.'input-file' -as [String]
            PageSize            = $RunStep.'custom-data'.'adma-step-data'.'page-size' -as [UInt32]
            Timeout             = $RunStep.'custom-data'.'adma-step-data'.'time-limit' -as [UInt32]
            LogFilePath         = $RunStep.'custom-data'.'run-config'.'input-file' -as [String] #TODO - this takes the wrong input
            DropFileName        = $RunStep.'dropfile-name' -as [String]
            ObjectDeleteLimit   = $RunStep.threshold.delete -as [UInt32]
            ObjectProcessLimit  = $RunStep.threshold.object -as [UInt32]
            FakeIdentifier      = [Guid]::NewGuid().ToString() -as [String]
        }

        if ($StepSubtypes.Count -gt 0)
        {
            $cimInstance.StepSubtype = $StepSubtypes
        }
        else
        {
            $cimInstance.StepSubtype = $null
        }

        Write-Output -InputObject $cimInstance
    }
}