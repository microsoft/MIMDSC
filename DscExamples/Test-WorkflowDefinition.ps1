Set-Location c:\MimDsc

#region Call the Set and Test methods directly - allows for setting a breakpoint for debuggering
Search-Resources -XPath "/WorkflowDefinition" -ExpectedObjectType WorkflowDefinition -MaxResults 5

$randomNumber = Get-Random -Minimum 100 -Maximum 999
$administrator = New-Resource -ObjectType Person
$administrator.AccountName = "TestPerson$randomNumber"
$administrator.DisplayName = 'Administrator'
$administrator | Save-Resource

Get-Resource Person DisplayName Administrator

ipmo MimDsc -Force
ipmo 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcWorkflowDefinition\MimSvcWorkflowDefinition.psm1' -Force
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcWorkflowDefinition\MimSvcWorkflowDefinition.psm1'
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\Functions\Test-MimSvcTargetResource.ps1'
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\Functions\Set-MimSvcTargetResource.ps1'

$resourceProperties = @{
            DisplayName                 = "TestWorkflowDefinition$randomNumber"
            RequestPhase                = 'Authorization'
            XOML                        = @'
<ns0:SequentialWorkflow 
  ActorId                             ="00000000-0000-0000-0000-000000000000" 
  RequestId                           ="00000000-0000-0000-0000-000000000000" 
  x:Name                              ="SequentialWorkflow" 
  TargetId                            ="00000000-0000-0000-0000-000000000000" 
  WorkflowDefinitionId                ="00000000-0000-0000-0000-000000000000" 
  xmlns                               ="http://schemas.microsoft.com/winfx/2006/xaml/workflow" 
  xmlns:ns1                           ="clr-namespace:System.Workflow.Activities;Assembly=System.WorkflowServices, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" 
  xmlns:x                             ="http://schemas.microsoft.com/winfx/2006/xaml" 
  xmlns:ns0                           ="clr-namespace:Microsoft.ResourceManagement.Workflow.Activities;Assembly=Microsoft.ResourceManagement, Version=4.1.3114.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
>
  <ns0:ApprovalActivity 
    ApprovalTimeoutEmailTemplate      ="{ObjectType:"EmailTemplate",AttributeName:"DisplayName",AttributeValue:"Default timed out request email template"}" 
    ApprovalDeniedEmailTemplate       ="{ObjectType:"EmailTemplate",AttributeName:"DisplayName",AttributeValue:"Default rejected request email template"}" 
    CurrentApprovalResponse           ="{x:Null}" 
    ApprovalObjectId                  ="00000000-0000-0000-0000-000000000000" 
    x:Name                            ="authenticationGateActivity1" 
    ApprovalEmailTemplate             ="{ObjectType:"EmailTemplate",AttributeName:"DisplayName",AttributeValue:"Default pending approval email template"}" 
    Escalation                        ="" 
    ReceivedApprovals                 ="0" 
    Duration                          ="7.00:00:00" 
    Threshold                         ="1" 
    ApprovalCompleteEmailTemplate     ="{ObjectType:"EmailTemplate",AttributeName:"DisplayName",AttributeValue:"Default completed approval email template"}" 
    RequestTimedOut                   ="False" 
    IsApproved                        ="{x:Null}" 
    Approvers                         ="{ObjectType:"Person",AttributeName:"DisplayName",AttributeValue:"Administrator"};" 
    AutomatedResponseObjectId         ="00000000-0000-0000-0000-000000000000" 
    CurrentApprovalResponseActorId    ="00000000-0000-0000-0000-000000000000" 
    EscalationEmailTemplate           ="{ObjectType:"EmailTemplate",AttributeName:"DisplayName",AttributeValue:"Default pending approval escalation email template"}" 
    ApproverId                        ="00000000-0000-0000-0000-000000000000" 
    RejectedReason                    ="{x:Null}" 
    ApprovalObject                    ="{x:Null}" 
    ApprovalResponseCreateParameters  ="{x:Null}" 
    Request                           ="{x:Null}"
    >
    <ns1:ReceiveActivity.WorkflowServiceAttributes>
      <ns1:WorkflowServiceAttributes 
        ConfigurationName             ="Microsoft.ResourceManagement.Workflow.Activities.ApprovalActivity" 
        Name                          ="ApprovalActivity" />
    </ns1:ReceiveActivity.WorkflowServiceAttributes>
  </ns0:ApprovalActivity>
</ns0:SequentialWorkflow>
'@
    Ensure						= 'Present'
}

Test-MimSvcTargetResource -ObjectType WorkflowDefinition -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

Set-MimSvcTargetResource -ObjectType WorkflowDefinition -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

#endregion

#region: Test for an existing WorkflowDefinition
Configuration TestWorkflowDefinition 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        WorkflowDefinition 'Owner Approval Workflow'
        {
            DisplayName                 = 'Owner Approval Workflow'
            RequestPhase                = 'Authorization'
            XOML                        = '<ns0:SequentialWorkflow x:Name="SequentialWorkflow" ActorId="00000000-0000-0000-0000-000000000000" WorkflowDefinitionId="00000000-0000-0000-0000-000000000000" RequestId="00000000-0000-0000-0000-000000000000" TargetId="00000000-0000-0000-0000-000000000000" xmlns="http://schemas.microsoft.com/winfx/2006/xaml/workflow" xmlns:ns1="clr-namespace:System.Workflow.Activities;Assembly=System.WorkflowServices, Version=3.5.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:ns0="clr-namespace:Microsoft.ResourceManagement.Workflow.Activities;Assembly=Microsoft.ResourceManagement, Version=4.1.3114.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35">  <ns0:GroupValidationActivity x:Name="groupValidationActivity1" ValidationSemantics="All" />  <ns0:ApprovalActivity IsApproved="{x:Null}" Escalation="{x:Null}" ReceivedApprovals="0" CurrentApprovalResponse="{x:Null}" RequestTimedOut="False" Approvers="[//Target/Owner];" RejectedReason="{x:Null}" Request="{x:Null}" ApprovalObject="{x:Null}" Threshold="1" x:Name="approvalActivity1" Duration="3.00:00:00" CurrentApprovalResponseActorId="00000000-0000-0000-0000-000000000000">   <ns1:ReceiveActivity.WorkflowServiceAttributes>    <ns1:WorkflowServiceAttributes Name="ApprovalActivity" ConfigurationName="Microsoft.ResourceManagement.Workflow.Activities.ApprovalActivity" />   </ns1:ReceiveActivity.WorkflowServiceAttributes>  </ns0:ApprovalActivity>  <ns0:GroupValidationActivity x:Name="groupValidationActivity2" ValidationSemantics="All" /></ns0:SequentialWorkflow>'
            Ensure						= 'Present'
        }
    } 
} 

TestWorkflowDefinition

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestWorkflowDefinition" -Force
#endregion

#region: New WorkflowDefinition
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestWorkflowDefinition 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        WorkflowDefinition "TestWorkflowDefinition$randomNumber"
        {
            DisplayName                 = "TestWorkflowDefinition$randomNumber"
            RequestPhase                = 'Authorization'
            XOML                        = '<ns0:SequentialWorkflow x:Name="SequentialWorkflow" ActorId="00000000-0000-0000-0000-000000000000" WorkflowDefinitionId="00000000-0000-0000-0000-000000000000" RequestId="00000000-0000-0000-0000-000000000000" TargetId="00000000-0000-0000-0000-000000000000" xmlns="http://schemas.microsoft.com/winfx/2006/xaml/workflow" xmlns:ns1="clr-namespace:System.Workflow.Activities;Assembly=System.WorkflowServices, Version=3.5.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:ns0="clr-namespace:Microsoft.ResourceManagement.Workflow.Activities;Assembly=Microsoft.ResourceManagement, Version=4.1.3114.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35">  <ns0:GroupValidationActivity x:Name="groupValidationActivity1" ValidationSemantics="All" />  <ns0:ApprovalActivity IsApproved="{x:Null}" Escalation="{x:Null}" ReceivedApprovals="0" CurrentApprovalResponse="{x:Null}" RequestTimedOut="False" Approvers="[//Target/Owner];" RejectedReason="{x:Null}" Request="{x:Null}" ApprovalObject="{x:Null}" Threshold="1" x:Name="approvalActivity1" Duration="3.00:00:00" CurrentApprovalResponseActorId="00000000-0000-0000-0000-000000000000">   <ns1:ReceiveActivity.WorkflowServiceAttributes>    <ns1:WorkflowServiceAttributes Name="ApprovalActivity" ConfigurationName="Microsoft.ResourceManagement.Workflow.Activities.ApprovalActivity" />   </ns1:ReceiveActivity.WorkflowServiceAttributes>  </ns0:ApprovalActivity>  <ns0:GroupValidationActivity x:Name="groupValidationActivity2" ValidationSemantics="All" /></ns0:SequentialWorkflow>'
            Ensure						= 'Present'
        }
    } 
} 

TestWorkflowDefinition

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestWorkflowDefinition" -Force
#endregion

#region: New WorkflowDefinition with References
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestWorkflowDefinition 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        WorkflowDefinition "TestWorkflowDefinition$randomNumber"
        {
            DisplayName                 = "TestWorkflowDefinition$randomNumber"
            RequestPhase                = 'Authorization'
            XOML                        = @'
<ns0:SequentialWorkflow 
  ActorId                             ="00000000-0000-0000-0000-000000000000" 
  RequestId                           ="00000000-0000-0000-0000-000000000000" 
  x:Name                              ="SequentialWorkflow" 
  TargetId                            ="00000000-0000-0000-0000-000000000000" 
  WorkflowDefinitionId                ="00000000-0000-0000-0000-000000000000" 
  xmlns                               ="http://schemas.microsoft.com/winfx/2006/xaml/workflow" 
  xmlns:ns1                           ="clr-namespace:System.Workflow.Activities;Assembly=System.WorkflowServices, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" 
  xmlns:x                             ="http://schemas.microsoft.com/winfx/2006/xaml" 
  xmlns:ns0                           ="clr-namespace:Microsoft.ResourceManagement.Workflow.Activities;Assembly=Microsoft.ResourceManagement, Version=4.1.3114.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
>
  <ns0:ApprovalActivity 
    ApprovalTimeoutEmailTemplate      ="{ObjectType:"EmailTemplate",AttributeName:"DisplayName",AttributeValue:"Default timed out request email template"}" 
    ApprovalDeniedEmailTemplate       ="{ObjectType:"EmailTemplate",AttributeName:"DisplayName",AttributeValue:"Default rejected request email template"}" 
    CurrentApprovalResponse           ="{x:Null}" 
    ApprovalObjectId                  ="00000000-0000-0000-0000-000000000000" 
    x:Name                            ="authenticationGateActivity1" 
    ApprovalEmailTemplate             ="{ObjectType:"EmailTemplate",AttributeName:"DisplayName",AttributeValue:"Default pending approval email template"}" 
    Escalation                        ="" 
    ReceivedApprovals                 ="0" 
    Duration                          ="7.00:00:00" 
    Threshold                         ="1" 
    ApprovalCompleteEmailTemplate     ="{ObjectType:"EmailTemplate",AttributeName:"DisplayName",AttributeValue:"Default completed approval email template"}" 
    RequestTimedOut                   ="False" 
    IsApproved                        ="{x:Null}" 
    Approvers                         ="{ObjectType:"Person",AttributeName:"DisplayName",AttributeValue:"Administrator"};" 
    AutomatedResponseObjectId         ="00000000-0000-0000-0000-000000000000" 
    CurrentApprovalResponseActorId    ="00000000-0000-0000-0000-000000000000" 
    EscalationEmailTemplate           ="{ObjectType:"EmailTemplate",AttributeName:"DisplayName",AttributeValue:"Default pending approval escalation email template"}" 
    ApproverId                        ="00000000-0000-0000-0000-000000000000" 
    RejectedReason                    ="{x:Null}" 
    ApprovalObject                    ="{x:Null}" 
    ApprovalResponseCreateParameters  ="{x:Null}" 
    Request                           ="{x:Null}"
    >
    <ns1:ReceiveActivity.WorkflowServiceAttributes>
      <ns1:WorkflowServiceAttributes 
        ConfigurationName             ="Microsoft.ResourceManagement.Workflow.Activities.ApprovalActivity" 
        Name                          ="ApprovalActivity" />
    </ns1:ReceiveActivity.WorkflowServiceAttributes>
  </ns0:ApprovalActivity>
</ns0:SequentialWorkflow>
'@
            Ensure						= 'Present'
        }
    } 
} 

TestWorkflowDefinition

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestWorkflowDefinition" -Force
#endregion

#region: Update WorkflowDefinition - XOML
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestWorkflowDefinition 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        WorkflowDefinition "TestWorkflowDefinition$randomNumber"
        {
            DisplayName                 = "TestWorkflowDefinition$randomNumber"
            RequestPhase                = 'Authorization'
            XOML                        = '<ns0:SequentialWorkflow x:Name="SequentialWorkflow" ActorId="00000000-0000-0000-0000-000000000000" WorkflowDefinitionId="00000000-0000-0000-0000-000000000000" RequestId="00000000-0000-0000-0000-000000000000" TargetId="00000000-0000-0000-0000-000000000000" xmlns="http://schemas.microsoft.com/winfx/2006/xaml/workflow" xmlns:ns1="clr-namespace:System.Workflow.Activities;Assembly=System.WorkflowServices, Version=3.5.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:ns0="clr-namespace:Microsoft.ResourceManagement.Workflow.Activities;Assembly=Microsoft.ResourceManagement, Version=4.1.3114.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35">  <ns0:GroupValidationActivity x:Name="groupValidationActivity1" ValidationSemantics="All" />  <ns0:ApprovalActivity IsApproved="{x:Null}" Escalation="{x:Null}" ReceivedApprovals="0" CurrentApprovalResponse="{x:Null}" RequestTimedOut="False" Approvers="[//Target/Owner];" RejectedReason="{x:Null}" Request="{x:Null}" ApprovalObject="{x:Null}" Threshold="1" x:Name="approvalActivity1" Duration="3.00:00:00" CurrentApprovalResponseActorId="00000000-0000-0000-0000-000000000000">   <ns1:ReceiveActivity.WorkflowServiceAttributes>    <ns1:WorkflowServiceAttributes Name="ApprovalActivity" ConfigurationName="Microsoft.ResourceManagement.Workflow.Activities.ApprovalActivity" />   </ns1:ReceiveActivity.WorkflowServiceAttributes>  </ns0:ApprovalActivity>  <ns0:GroupValidationActivity x:Name="groupValidationActivity2" ValidationSemantics="All" /></ns0:SequentialWorkflow>'
            Ensure						= 'Present'
        }
    } 
} 

TestWorkflowDefinition

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestWorkflowDefinition"

Configuration TestWorkflowDefinition 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        WorkflowDefinition "TestWorkflowDefinition$randomNumber"
        {
            DisplayName                 = "TestWorkflowDefinition$randomNumber"
            RequestPhase                = 'Authorization'
            XOML                        = @'
'<ns0:SequentialWorkflow 
	x:Name			="SequentialWorkflow" 
	ActorId			="00000000-0000-0000-0000-000000000000" 
	WorkflowDefinitionId	="00000000-0000-0000-0000-000000000000" 
	RequestId		="00000000-0000-0000-0000-000000000000" 
	TargetId		="00000000-0000-0000-0000-000000000000" 
	xmlns			="http://schemas.microsoft.com/winfx/2006/xaml/workflow" 
	xmlns:ns1		="clr-namespace:System.Workflow.Activities;Assembly=System.WorkflowServices, Version=3.5.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" 
	xmlns:x			="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:ns0="clr-namespace:Microsoft.ResourceManagement.Workflow.Activities;Assembly=Microsoft.ResourceManagement, Version=4.1.3114.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
>  
<ns0:GroupValidationActivity 
	x:Name				="groupValidationActivity1" 
	ValidationSemantics		="All" 
/>  
<ns0:ApprovalActivity 
	IsApproved			="{x:Null}" 
	Escalation			="{x:Null}" 
	ReceivedApprovals		="0" 
	CurrentApprovalResponse		="{x:Null}" 
	RequestTimedOut			="False" 
	Approvers			="[//Target/Owner];" 
	RejectedReason			="{x:Null}" 
	Request				="{x:Null}" 
	ApprovalObject			="{x:Null}" 
	Threshold			="1" 
	x:Name				="approvalActivity1" 
	Duration			="3.00:00:00" 
	CurrentApprovalResponseActorId	="00000000-0000-0000-0000-000000000000"
>   
<ns1:ReceiveActivity.WorkflowServiceAttributes>    
<ns1:WorkflowServiceAttributes 
	Name				="ApprovalActivity" 
	ConfigurationName		="Microsoft.ResourceManagement.Workflow.Activities.ApprovalActivity" 
/>   
</ns1:ReceiveActivity.WorkflowServiceAttributes>  
</ns0:ApprovalActivity>  
<ns0:GroupValidationActivity 
	x:Name				="groupValidationActivity2" 
	ValidationSemantics		="All" 
/>
</ns0:SequentialWorkflow>'
'@            
            Ensure						= 'Present'
        }
    } 
} 

TestWorkflowDefinition

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestWorkflowDefinition" -Force
#endregion

#region: Update WorkflowDefinition - RequstPhase
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestWorkflowDefinition 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        WorkflowDefinition "TestWorkflowDefinition$randomNumber"
        {
            DisplayName                 = "TestWorkflowDefinition$randomNumber"
            RequestPhase                = 'Authorization'
            XOML                        = '<ns0:SequentialWorkflow x:Name="SequentialWorkflow" ActorId="00000000-0000-0000-0000-000000000000" WorkflowDefinitionId="00000000-0000-0000-0000-000000000000" RequestId="00000000-0000-0000-0000-000000000000" TargetId="00000000-0000-0000-0000-000000000000" xmlns="http://schemas.microsoft.com/winfx/2006/xaml/workflow" xmlns:ns1="clr-namespace:System.Workflow.Activities;Assembly=System.WorkflowServices, Version=3.5.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:ns0="clr-namespace:Microsoft.ResourceManagement.Workflow.Activities;Assembly=Microsoft.ResourceManagement, Version=4.1.3114.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35">  <ns0:GroupValidationActivity x:Name="groupValidationActivity1" ValidationSemantics="All" />  <ns0:ApprovalActivity IsApproved="{x:Null}" Escalation="{x:Null}" ReceivedApprovals="0" CurrentApprovalResponse="{x:Null}" RequestTimedOut="False" Approvers="[//Target/Owner];" RejectedReason="{x:Null}" Request="{x:Null}" ApprovalObject="{x:Null}" Threshold="1" x:Name="approvalActivity1" Duration="3.00:00:00" CurrentApprovalResponseActorId="00000000-0000-0000-0000-000000000000">   <ns1:ReceiveActivity.WorkflowServiceAttributes>    <ns1:WorkflowServiceAttributes Name="ApprovalActivity" ConfigurationName="Microsoft.ResourceManagement.Workflow.Activities.ApprovalActivity" />   </ns1:ReceiveActivity.WorkflowServiceAttributes>  </ns0:ApprovalActivity>  <ns0:GroupValidationActivity x:Name="groupValidationActivity2" ValidationSemantics="All" /></ns0:SequentialWorkflow>'
            Ensure						= 'Present'
        }
    } 
} 

TestWorkflowDefinition

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestWorkflowDefinition" -Force

Configuration TestWorkflowDefinition 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        WorkflowDefinition "TestWorkflowDefinition$randomNumber"
        {
            DisplayName                 = "TestWorkflowDefinition$randomNumber"
            RequestPhase                = 'Action'
            XOML                        = '<ns0:SequentialWorkflow x:Name="SequentialWorkflow" ActorId="00000000-0000-0000-0000-000000000000" WorkflowDefinitionId="00000000-0000-0000-0000-000000000000" RequestId="00000000-0000-0000-0000-000000000000" TargetId="00000000-0000-0000-0000-000000000000" xmlns="http://schemas.microsoft.com/winfx/2006/xaml/workflow" xmlns:ns1="clr-namespace:System.Workflow.Activities;Assembly=System.WorkflowServices, Version=3.5.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:ns0="clr-namespace:Microsoft.ResourceManagement.Workflow.Activities;Assembly=Microsoft.ResourceManagement, Version=4.1.3114.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35">  <ns0:GroupValidationActivity x:Name="groupValidationActivity1" ValidationSemantics="All" />  <ns0:ApprovalActivity IsApproved="{x:Null}" Escalation="{x:Null}" ReceivedApprovals="0" CurrentApprovalResponse="{x:Null}" RequestTimedOut="False" Approvers="[//Target/Owner];" RejectedReason="{x:Null}" Request="{x:Null}" ApprovalObject="{x:Null}" Threshold="1" x:Name="approvalActivity1" Duration="3.00:00:00" CurrentApprovalResponseActorId="00000000-0000-0000-0000-000000000000">   <ns1:ReceiveActivity.WorkflowServiceAttributes>    <ns1:WorkflowServiceAttributes Name="ApprovalActivity" ConfigurationName="Microsoft.ResourceManagement.Workflow.Activities.ApprovalActivity" />   </ns1:ReceiveActivity.WorkflowServiceAttributes>  </ns0:ApprovalActivity>  <ns0:GroupValidationActivity x:Name="groupValidationActivity2" ValidationSemantics="All" /></ns0:SequentialWorkflow>'
            Ensure						= 'Present'
        }
    } 
} 

TestWorkflowDefinition

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestWorkflowDefinition" -Force
#endregion

#region: Remove WorkflowDefinition
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestWorkflowDefinition 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        WorkflowDefinition "TestWorkflowDefinition$randomNumber"
        {
            DisplayName                 = "TestWorkflowDefinition$randomNumber"
            RequestPhase                = 'Authorization'
            XOML                        = '<ns0:SequentialWorkflow x:Name="SequentialWorkflow" ActorId="00000000-0000-0000-0000-000000000000" WorkflowDefinitionId="00000000-0000-0000-0000-000000000000" RequestId="00000000-0000-0000-0000-000000000000" TargetId="00000000-0000-0000-0000-000000000000" xmlns="http://schemas.microsoft.com/winfx/2006/xaml/workflow" xmlns:ns1="clr-namespace:System.Workflow.Activities;Assembly=System.WorkflowServices, Version=3.5.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:ns0="clr-namespace:Microsoft.ResourceManagement.Workflow.Activities;Assembly=Microsoft.ResourceManagement, Version=4.1.3114.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35">  <ns0:GroupValidationActivity x:Name="groupValidationActivity1" ValidationSemantics="All" />  <ns0:ApprovalActivity IsApproved="{x:Null}" Escalation="{x:Null}" ReceivedApprovals="0" CurrentApprovalResponse="{x:Null}" RequestTimedOut="False" Approvers="[//Target/Owner];" RejectedReason="{x:Null}" Request="{x:Null}" ApprovalObject="{x:Null}" Threshold="1" x:Name="approvalActivity1" Duration="3.00:00:00" CurrentApprovalResponseActorId="00000000-0000-0000-0000-000000000000">   <ns1:ReceiveActivity.WorkflowServiceAttributes>    <ns1:WorkflowServiceAttributes Name="ApprovalActivity" ConfigurationName="Microsoft.ResourceManagement.Workflow.Activities.ApprovalActivity" />   </ns1:ReceiveActivity.WorkflowServiceAttributes>  </ns0:ApprovalActivity>  <ns0:GroupValidationActivity x:Name="groupValidationActivity2" ValidationSemantics="All" /></ns0:SequentialWorkflow>'
            Ensure						= 'Present'
        }
    } 
} 

TestWorkflowDefinition

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestWorkflowDefinition" -Force

Configuration TestWorkflowDefinition 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        WorkflowDefinition "TestWorkflowDefinition$randomNumber"
        {
            DisplayName                 = "TestWorkflowDefinition$randomNumber"
            RequestPhase                = 'Authorization'
            XOML                        = '<ns0:SequentialWorkflow x:Name="SequentialWorkflow" ActorId="00000000-0000-0000-0000-000000000000" WorkflowDefinitionId="00000000-0000-0000-0000-000000000000" RequestId="00000000-0000-0000-0000-000000000000" TargetId="00000000-0000-0000-0000-000000000000" xmlns="http://schemas.microsoft.com/winfx/2006/xaml/workflow" xmlns:ns1="clr-namespace:System.Workflow.Activities;Assembly=System.WorkflowServices, Version=3.5.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:ns0="clr-namespace:Microsoft.ResourceManagement.Workflow.Activities;Assembly=Microsoft.ResourceManagement, Version=4.1.3114.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35">  <ns0:GroupValidationActivity x:Name="groupValidationActivity1" ValidationSemantics="All" />  <ns0:ApprovalActivity IsApproved="{x:Null}" Escalation="{x:Null}" ReceivedApprovals="0" CurrentApprovalResponse="{x:Null}" RequestTimedOut="False" Approvers="[//Target/Owner];" RejectedReason="{x:Null}" Request="{x:Null}" ApprovalObject="{x:Null}" Threshold="1" x:Name="approvalActivity1" Duration="3.00:00:00" CurrentApprovalResponseActorId="00000000-0000-0000-0000-000000000000">   <ns1:ReceiveActivity.WorkflowServiceAttributes>    <ns1:WorkflowServiceAttributes Name="ApprovalActivity" ConfigurationName="Microsoft.ResourceManagement.Workflow.Activities.ApprovalActivity" />   </ns1:ReceiveActivity.WorkflowServiceAttributes>  </ns0:ApprovalActivity>  <ns0:GroupValidationActivity x:Name="groupValidationActivity2" ValidationSemantics="All" /></ns0:SequentialWorkflow>'
            Ensure						= 'Absent'
        }
    } 
} 

TestWorkflowDefinition

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestWorkflowDefinition" -Force
#endregion