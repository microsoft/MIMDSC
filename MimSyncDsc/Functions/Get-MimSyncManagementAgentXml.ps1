function Get-MimSyncManagementAgentXml
{
<#
.Synopsis
   Gets the MA XML
.DESCRIPTION
   Uses maexport.exe to return the MA XML
.EXAMPLE
   Get-ManagementAgentXml myMAName
.EXAMPLE
   Get-ManagementAgent | Get-ManagementAgentXml myMAName
.EXAMPLE
   Get-ManagementAgent myMAName | Get-ManagementAgentXml myMAName
#>
    [CmdletBinding()]
    Param
    (
        # param1 help description
        [Parameter(Position=0, ValueFromPipelineByPropertyName=$true)]
        $Name
    )
    Process
    {
        ##TODO - do this better such that we handle failures in the command
        ##TODO - output the command output and send to Write-Verbose
        ##TODO - add a -Force parameter which will overwrite an existing file
        & (join-path (Get-MimSyncPath) \bin\maexport.exe) $Name 
    }
}##Closing: function Get-MimSyncManagementAgentXml