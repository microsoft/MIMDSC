
Set-Location c:\MimDsc

#region Call the Set and Test methods directly - allows for setting a breakpoint for debuggering
Search-Resources -XPath "/ObjectVisualizationConfiguration" -ExpectedObjectType ObjectTypeDescription -MaxResults 2

ipmo MimDsc -Force
ipmo 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcObjectVisualizationConfiguration\MimSvcObjectVisualizationConfiguration.psm1' -Force
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcObjectVisualizationConfiguration\MimSvcObjectVisualizationConfiguration.psm1'

$testResourceProperties = @{
    AppliesToCreate             = $false
    AppliesToEdit               = $true
    AppliesToView               = $false
    ConfigurationData           = @'
<my:ObjectControlConfiguration my:TypeName="UocGroupCodeBehind"
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xmlns:my="http://schemas.microsoft.com/2006/11/ResourceManagement"
 xmlns:xd="http://schemas.microsoft.com/office/infopath/2003">
  <my:ObjectDataSource my:TypeName="PrimaryResourceObjectDataSource" my:Name="object" my:Parameters=""/>
  <my:ObjectDataSource my:TypeName="ReferenceDeltaDataSource" my:Name="delta"/>
  <my:ObjectDataSource my:TypeName="SchemaDataSource" my:Name="schema"/>
  <my:ObjectDataSource my:TypeName="DomainDataSource" my:Name="domain" my:Parameters="%LoginDomain%"/>
  <my:ObjectDataSource my:TypeName="PrimaryResourceRightsDataSource" my:Name="rights"/>
  <my:XmlDataSource my:Name="summaryTransformXsl" my:Parameters="Microsoft.IdentityManagement.WebUI.Controls.Resources.DefaultSummary.xsl"/>
  <my:Panel my:Name="page" my:AutoValidate="true" my:Caption="Caption">
    <my:Grouping my:Name="Caption" my:IsHeader="true" my:Caption="caption" my:Visible="true">
      <my:Control my:Name="Caption" my:TypeName="UocCaptionControl" my:ExpandArea="true" my:Caption="" my:Description="{Binding Source=object, Path=DisplayName}">
        <my:Properties>
          <my:Property my:Name="MaxHeight" my:Value="32"/>
          <my:Property my:Name="MaxWidth" my:Value="32"/>
        </my:Properties>
      </my:Control>
    </my:Grouping>
    <my:Grouping my:Name="GroupingBasicInfo" my:Caption="%SYMBOL_BasicTabCaption_END%">
      <my:Help my:HelpText="%SYMBOL_BasicTabHelpText_END%" my:Link="03e258a0-609b-44f4-8417-4defdb6cb5e9.htm#bkmk_grouping_GroupingBasicInfo"/>
      <my:Control my:Name="Name" my:TypeName="UocTextBox" my:Caption="{Binding Source=schema, Path=DisplayName.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=DisplayName}" 
        my:Description="{Binding Source=schema, Path=DisplayName.Description}">
        <my:Properties>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="MaxLength" my:Value="128"/>
          <my:Property my:Name="Text" my:Value="{Binding Source=object, Path=DisplayName, Mode=TwoWay}"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="EmailEnabling" my:TypeName="UocCheckBox" my:Caption="%SYMBOL_EmailEnablingCaption_END%" my:Description="%SYMBOL_EmailEnablingDescription_END%" my:AutoPostback="true" my:RightsLevel="{Binding Source=rights, Path=Email}">
        <my:Properties>
          <my:Property my:Name="Text" my:Value="%SYMBOL_EmailEnablingValue_END%"/>
        </my:Properties>
        <my:Events>
          <my:Event my:Name="CheckedChanged" my:Handler="OnChangeEmailEnabling"/>
        </my:Events>
      </my:Control>
      <my:Control my:Name="Alias" my:TypeName="UocTextBox" my:Caption="{Binding Source=schema, Path=MailNickname.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=MailNickname}">
        <my:Properties>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="HintPath" my:Value="Hint"/>
          <my:Property my:Name="Text" my:Value="{Binding Source=object, Path=MailNickname, Mode=TwoWay}"/>
          <my:Property my:Name="MaxLength" my:Value="128"/>
          <my:Property my:Name="RegularExpression" my:Value="{Binding Source=schema, Path=MailNickname.StringRegex}"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="EmailAddress" my:TypeName="UocTextBox" my:Caption="{Binding Source=schema, Path=Email.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=Email}">
        <my:Properties>
          <my:Property my:Name="Text" my:Value="{Binding Source=object, Path=Email, Mode=OneWay}"/>
          <my:Property my:Name="ReadOnly" my:Value="true"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="Domain" my:TypeName="UocLabel" my:Caption="{Binding Source=schema, Path=Domain.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=Domain}">
        <my:Properties>
          <my:Property my:Name="Text" my:Value="{Binding Source=object, Path=Domain, Mode=OneWay}"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="AccountName" my:TypeName="UocTextBox" my:Caption="{Binding Source=schema, Path=AccountName.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=AccountName}">
        <my:Properties>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="Text" my:Value="{Binding Source=object, Path=AccountName, Mode=TwoWay}"/>
          <my:Property my:Name="MaxLength" my:Value="64"/>
          <my:Property my:Name="RegularExpression" my:Value="{Binding Source=schema, Path=AccountName.StringRegex}"/>
        </my:Properties>
        <my:Events>
          <my:Event my:Name="TextChanged" my:Handler="OnChangeAccount"/>
        </my:Events>
      </my:Control>
      <my:Control my:Name="Scope" my:TypeName="UocDropDownList" my:Caption="{Binding Source=schema, Path=Scope.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=Scope}">
        <my:Options>
          <my:Option my:Value="DomainLocal" my:Caption="%SYMBOL_DomainLocalCaption_END%" my:Hint="%SYMBOL_DomainLocalHint_END%"/>
          <my:Option my:Value="Global" my:Caption="%SYMBOL_GlobalCaption_END%" my:Hint="%SYMBOL_GlobalHint_END%"/>
          <my:Option my:Value="Universal" my:Caption="%SYMBOL_UniversalCaption_END%" my:Hint="%SYMBOL_UniversalHint_END%"/>
        </my:Options>
        <my:Properties>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="ValuePath" my:Value="Value"/>
          <my:Property my:Name="CaptionPath" my:Value="Caption"/>
          <my:Property my:Name="HintPath" my:Value="Hint"/>
          <my:Property my:Name="ItemSource" my:Value="Custom"/>
          <my:Property my:Name="SelectedValue" my:Value="{Binding Source=object, Path=Scope, Mode=TwoWay}"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="MembershipType" my:TypeName="UocRadioButtonList" my:Caption="%SYMBOL_MembershipCaption_END%" my:RightsLevel="{Binding Source=rights, Path=MembershipLocked}" my:AutoPostback="true">
        <my:Options>
          <my:Option my:Value="Static" my:Caption="%SYMBOL_NamesCaption_END%" my:Hint="%SYMBOL_NamesHint_END%"/>
          <my:Option my:Value="Manager" my:Caption="%SYMBOL_ManagerCaption_END%" my:Hint="%SYMBOL_ManagerHint_END%"/>
          <my:Option my:Value="Calculated" my:Caption="%SYMBOL_CalculatedCaption_END%" my:Hint="%SYMBOL_CalculatedHint_END%"/>
        </my:Options>
        <my:Properties>
          <my:Property my:Name="Required" my:Value="{Binding Source=schema, Path=MembershipLocked.Required}"/>
          <my:Property my:Name="ValuePath" my:Value="Value"/>
          <my:Property my:Name="CaptionPath" my:Value="Caption"/>
          <my:Property my:Name="HintPath" my:Value="Hint"/>
        </my:Properties>
        <my:Events>
          <my:Event my:Name="SelectedIndexChanged" my:Handler="OnChangeMembershipType"/>
        </my:Events>
      </my:Control>
      <my:Control my:Name="Description" my:TypeName="UocTextBox" my:Caption="{Binding Source=schema, Path=Description.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=Description}">
        <my:Properties>
          <my:Property my:Name="Required" my:Value="{Binding Source=schema, Path=DisplayName.Required}"/>
          <my:Property my:Name="Rows" my:Value="3"/>
          <my:Property my:Name="Columns" my:Value="60"/>
          <my:Property my:Name="MaxLength" my:Value="448"/>
          <my:Property my:Name="Text" my:Value="{Binding Source=object, Path=Description, Mode=TwoWay}"/>
        </my:Properties>
      </my:Control>
      <my:Events>
        <my:Event my:Name="BeforeLeave" my:Handler="OnLeaveBasicInfoGrouping"/>
      </my:Events>
    </my:Grouping>
    <my:Grouping my:Name="GroupingMembers" my:Caption="%SYMBOL_MembersTabCaption_END%">
      <my:Help my:HelpText="%SYMBOL_MembersTabHelpText_END%" my:Link="03e258a0-609b-44f4-8417-4defdb6cb5e9.htm#bkmk_grouping_GroupingMembers"/>
      <my:Control my:Name="MemberList" my:TypeName="UocListView" my:Caption="%SYMBOL_CurrentMembershipCaption_END%" my:Description="%SYMBOL_CurrentMembershipDescription_END%" my:RightsLevel="{Binding Source=rights, Path=ExplicitMember}">
        <my:Properties>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName,ObjectType"/>
          <my:Property my:Name="UsageKeywords" my:Value="%Attribute_Type%"/>
          <my:Property my:Name="TargetAttribute" my:Value="ExplicitMember"/>
          <my:Property my:Name="EmptyResultText" my:Value="%SYMBOL_MemberListEmptyResultText_END%"/>
          <my:Property my:Name="PageSize" my:Value="10"/>
          <my:Property my:Name="ShowTitleBar" my:Value="false"/>
          <my:Property my:Name="ShowActionBar" my:Value="false"/>
          <my:Property my:Name="ShowPreview" my:Value="false"/>
          <my:Property my:Name="ShowSearchControl" my:Value="false"/>
          <my:Property my:Name="EnableSelection" my:Value="false"/>
          <my:Property my:Name="SingleSelection" my:Value="false"/>
          <my:Property my:Name="ItemClickBehavior" my:Value="ModelessDialog"/>
          <my:Property my:Name="ReadOnly" my:Value="true"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="InvalidMemberListStatic" my:TypeName="UocListView" my:Caption="%SYMBOL_InvalidMemberCaption_END%" my:Description="%SYMBOL_InvalidMemberHint_END%" my:Visible="false">
        <my:Properties>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName,ObjectType"/>
          <my:Property my:Name="EmptyResultText" my:Value="%SYMBOL_InvalidMemberListEmptyResultText_END%"/>
          <my:Property my:Name="PageSize" my:Value="10"/>
          <my:Property my:Name="ShowTitleBar" my:Value="false"/>
          <my:Property my:Name="ShowActionBar" my:Value="false"/>
          <my:Property my:Name="ShowPreview" my:Value="false"/>
          <my:Property my:Name="ShowSearchControl" my:Value="false"/>
          <my:Property my:Name="EnableSelection" my:Value="false"/>
          <my:Property my:Name="SingleSelection" my:Value="false"/>
          <my:Property my:Name="ItemClickBehavior" my:Value="ModelessDialog"/>
          <my:Property my:Name="ReadOnly" my:Value="true"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="MemberToRemove" my:TypeName="UocIdentityPicker" my:Caption="%SYMBOL_MembersToRemoveCaption_END%" my:Description="%SYMBOL_MembersToRemoveDescription_END%" my:RightsLevel="{Binding Source=rights, Path=ExplicitMember}">
        <my:Properties>
          <my:Property my:Name="Mode" my:Value="MultipleResult"/>
          <my:Property my:Name="Rows" my:Value="3"/>
          <my:Property my:Name="ObjectTypes" my:Value="Person,Group"/>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName,ObjectType"/>
          <my:Property my:Name="AttributesToSearch" my:Value="DisplayName, AccountName"/>
          <my:Property my:Name="Value" my:Value="{Binding Source=delta, Path=ExplicitMember.Remove, Mode=TwoWay}"/>
          <my:Property my:Name="Filter" my:Value="/Group[ObjectID='%ObjectID%']/ExplicitMember"/>
          <my:Property my:Name="ListViewTitle" my:Value="%SYMBOL_MembersPopupListviewTitle_END%"/>
          <my:Property my:Name="PreviewTitle" my:Value="%SYMBOL_MembersToRemovePopupPreviewTitle_END%"/>
          <my:Property my:Name="SearchOnLoad" my:Value="true"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="MemberToAdd" my:TypeName="UocIdentityPicker" my:Caption="%SYMBOL_MembersToAddCaption_END%" my:Description="%SYMBOL_MembersToAddDescription_END%" my:RightsLevel="{Binding Source=rights, Path=ExplicitMember}">
        <my:Properties>
          <my:Property my:Name="Mode" my:Value="MultipleResult"/>
          <my:Property my:Name="Rows" my:Value="3"/>
          <my:Property my:Name="ObjectTypes" my:Value="Person,Group"/>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName, AccountName"/>
          <my:Property my:Name="AttributesToSearch" my:Value="DisplayName, AccountName"/>
          <my:Property my:Name="Value" my:Value="{Binding Source=delta, Path=ExplicitMember.Add, Mode=TwoWay}"/>
          <my:Property my:Name="UsageKeywords" my:Value="%Attribute_Type%"/>
          <my:Property my:Name="ResultObjectType" my:Value="Resource"/>
          <my:Property my:Name="ListViewTitle" my:Value="%SYMBOL_MembersPopupListviewTitle_END%"/>
          <my:Property my:Name="PreviewTitle" my:Value="%SYMBOL_MembersToAddPopupPreviewTitle_END%"/>
          <my:Property my:Name="MainSearchScreenText" my:Value="%SYMBOL_MemberSearchText_END%"/>
        </my:Properties>
      </my:Control>
      <my:Events>
        <my:Event my:Name="AfterEnter" my:Handler="OnEnterMembersGrouping"/>
      </my:Events>
    </my:Grouping>
    <my:Grouping my:Name="GroupingCalculatedMembers" my:Caption="%SYMBOL_GroupingCalculatedMembersTabCaptionTabCaption_END%">
      <my:Help my:HelpText="%SYMBOL_GroupingCalculatedMembersTabHelpText_END%" my:Link="03e258a0-609b-44f4-8417-4defdb6cb5e9.htm#bkmk_grouping_GroupingMembers"/>
      <my:Control my:Name="ManagerialMembershipDescription" my:TypeName="UocTextBox" my:Visible="false">
        <my:Properties>
          <my:Property my:Name="Text" my:Value="%SYMBOL_ManagerialMembershipDescription_END%" /> 
        </my:Properties>
      </my:Control>
      <my:Control my:Name="Manager" my:TypeName="UocIdentityPicker" my:Caption="%SYMBOL_GroupingManagerialMembersManagerCaption_END%" my:RightsLevel="{Binding Source=rights, Path=Filter}">
        <my:Properties>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="ObjectTypes" my:Value="Person"/>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName, MailNickname, Manager"/>
          <my:Property my:Name="AttributesToSearch" my:Value="DisplayName, MailNickname"/>
          <my:Property my:Name="UsageKeywords" my:Value="Person"/>
          <my:Property my:Name="ResultObjectType" my:Value="Person"/>
          <my:Property my:Name="ListViewTitle" my:Value="%SYMBOL_ManagerPopupListviewTitle_END%"/>
          <my:Property my:Name="PreviewTitle" my:Value="%SYMBOL_ManagerPopupPreviewTitle_END%"/>
          <my:Property my:Name="MainSearchScreenText" my:Value="%SYMBOL_ManagerSearchText_END%"/>
        </my:Properties>
        <my:Events>
          <my:Event my:Name="SelectedObjectChanged" my:Handler="OnChangeManagerialMembership"/>
        </my:Events>
      </my:Control>
      <my:Control my:Name="FilterBuilder" my:TypeName="UocFilterBuilder" my:RightsLevel="{Binding Source=rights, Path=Filter}" my:ExpandArea="true">
        <my:Properties>
          <my:Property my:Name="PermittedObjectTypes" my:Value="Person,Group"/>
          <my:Property my:Name="Value" my:Value="{Binding Source=object, Path=Filter, Mode=TwoWay}"/>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="PreviewButtonVisible" my:Value="false"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="Preview" my:TypeName="UocButton" my:ExpandArea="true">
        <my:Properties>
          <my:Property my:Name="Text" my:Value="%SYMBOL_ViewMembers_END%"/>
        </my:Properties>
        <my:Events>
          <my:Event my:Name="Click" my:Handler="OnClickPreview"/>
        </my:Events>
      </my:Control>
      <my:Control my:Name="ComputedMemberList" my:TypeName="UocListView" my:Caption="%SYMBOL_CalculatedMemberCaption_END%" my:ExpandArea="true">
        <my:Properties>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName,ObjectType"/>
          <my:Property my:Name="EmptyResultText" my:Value="%SYMBOL_CalculatedMemberListEmptyResultText_END%"/>
          <my:Property my:Name="PageSize" my:Value="10"/>
          <my:Property my:Name="ShowTitleBar" my:Value="false"/>
          <my:Property my:Name="ShowActionBar" my:Value="false"/>
          <my:Property my:Name="ShowPreview" my:Value="false"/>
          <my:Property my:Name="ShowSearchControl" my:Value="false"/>
          <my:Property my:Name="EnableSelection" my:Value="false"/>
          <my:Property my:Name="SingleSelection" my:Value="false"/>
          <my:Property my:Name="ItemClickBehavior" my:Value="ModelessDialog"/>
          <my:Property my:Name="ReadOnly" my:Value="true"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="InvalidMemberListDynamic" my:TypeName="UocListView" my:Caption="%SYMBOL_InvalidMemberCaption_END%" my:Description="%SYMBOL_InvalidMemberHint_END%" my:ExpandArea="true" my:Visible="false">
        <my:Properties>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName,ObjectType"/>
          <my:Property my:Name="EmptyResultText" my:Value="%SYMBOL_InvalidMemberListEmptyResultText_END%"/>
          <my:Property my:Name="PageSize" my:Value="10"/>
          <my:Property my:Name="ShowTitleBar" my:Value="True"/>
          <my:Property my:Name="ShowActionBar" my:Value="false"/>
          <my:Property my:Name="ShowPreview" my:Value="false"/>
          <my:Property my:Name="ShowSearchControl" my:Value="false"/>
          <my:Property my:Name="EnableSelection" my:Value="false"/>
          <my:Property my:Name="SingleSelection" my:Value="false"/>
          <my:Property my:Name="ItemClickBehavior" my:Value="ModelessDialog"/>
          <my:Property my:Name="ReadOnly" my:Value="true"/>
        </my:Properties>
      </my:Control>
      <my:Events>
        <my:Event my:Name="AfterEnter" my:Handler="OnEnterMembersGrouping"/>
        <my:Event my:Name="BeforeLeave" my:Handler="OnLeaveMembersGrouping"/>
      </my:Events>
    </my:Grouping>
    <my:Grouping my:Name="GroupingOwners" my:Caption="%SYMBOL_OwnersTabCaption_END%">
      <my:Help my:HelpText="%SYMBOL_OwnersTabHelpText_END%" my:Link="03e258a0-609b-44f4-8417-4defdb6cb5e9.htm#bkmk_grouping_GroupingOwners"/>
      <my:Control my:Name="OwnerList" my:TypeName="UocIdentityPicker" my:Caption="{Binding Source=schema, Path=Owner.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=Owner}">
        <my:Properties>
          <my:Property my:Name="Mode" my:Value="MultipleResult"/>
          <my:Property my:Name="Rows" my:Value="3"/>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="ObjectTypes" my:Value="Person"/>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName, AccountName, Department"/>
          <my:Property my:Name="AttributesToSearch" my:Value="DisplayName, AccountName"/>
          <my:Property my:Name="Value" my:Value="{Binding Source=object, Path=Owner, Mode=TwoWay}"/>
          <my:Property my:Name="UsageKeywords" my:Value="Person"/>
          <my:Property my:Name="ResultObjectType" my:Value="Person"/>
          <my:Property my:Name="ListViewTitle" my:Value="%SYMBOL_OwnerListListViewTitle_END%"/>
          <my:Property my:Name="PreviewTitle" my:Value="%SYMBOL_OwnerListPreviewTitle_END%"/>
          <my:Property my:Name="MainSearchScreenText" my:Value="%SYMBOL_OwnerSearchText_END%"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="DisplayedOwner" my:TypeName="UocIdentityPicker" my:Caption="{Binding Source=schema, Path=DisplayedOwner.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=DisplayedOwner}" my:Description="%SYMBOL_DisplayedOwnerDescription_END%">
        <my:Properties>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="ObjectTypes" my:Value="Person"/>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName, AccountName, Department"/>
          <my:Property my:Name="AttributesToSearch" my:Value="DisplayName, AccountName"/>
          <my:Property my:Name="Value" my:Value="{Binding Source=object, Path=DisplayedOwner, Mode=TwoWay}"/>
          <my:Property my:Name="UsageKeywords" my:Value="Person"/>
          <my:Property my:Name="ResultObjectType" my:Value="Person"/>
          <my:Property my:Name="ListViewTitle" my:Value="%SYMBOL_DisplayedOwnerListViewTitle_END%"/>
          <my:Property my:Name="PreviewTitle" my:Value="%SYMBOL_DisplayedOwnerPreviewTitle_END%"/>
          <my:Property my:Name="MainSearchScreenText" my:Value="%SYMBOL_DisplayedOwnerSearchText_END%"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="Join" my:TypeName="UocRadioButtonList" my:Caption="%SYMBOL_JoiningCaption_END%" my:RightsLevel="{Binding Source=rights, Path=MembershipAddWorkflow}">
        <my:Options>
          <my:Option my:Value="Owner Approval" my:Caption="%SYMBOL_OwnerApprovalCaption_END%" my:Hint="%SYMBOL_OwnerApprovalHint_END%"/>
          <my:Option my:Value="None" my:Caption="%SYMBOL_NoneCaption_END%" my:Hint="%SYMBOL_NoneHint_END%"/>
        </my:Options>
        <my:Properties>
          <my:Property my:Name="Required" my:Value="{Binding Source=schema, Path=MembershipAddWorkflow.Required}"/>
          <my:Property my:Name="ValuePath" my:Value="Value"/>
          <my:Property my:Name="CaptionPath" my:Value="Caption"/>
          <my:Property my:Name="HintPath" my:Value="Hint"/>
          <my:Property my:Name="ItemSource" my:Value="Custom"/>
          <my:Property my:Name="SelectedValue" my:Value="{Binding Source=object, Path=MembershipAddWorkflow, Mode=TwoWay}"/>
        </my:Properties>
        <my:Events>
          <my:Event my:Name="SelectedIndexChanged" my:Handler="OnChangeMembershipWorkflow"/>
        </my:Events>
      </my:Control>
      <my:Events>
        <my:Event my:Name="BeforeLeave" my:Handler="OnLeaveOwnersGrouping"/>
      </my:Events>
    </my:Grouping>
    <my:Grouping my:Name="GroupingSummary" my:Caption="%SYMBOL_SummaryTabCaption_END%" my:IsSummary="true">
      <my:Control my:Name="SummaryControl" my:TypeName="UocHtmlSummary" my:ExpandArea="true">
        <my:Properties>
          <my:Property my:Name="ModificationsXml" my:Value="{Binding Source=delta, Path=DeltaXml}"/>
          <my:Property my:Name="TransformXsl" my:Value="{Binding Source=summaryTransformXsl, Path=/}"/>
        </my:Properties>
      </my:Control>
    </my:Grouping>
  </my:Panel>
  <my:Events>
    <my:Event my:Name="Load" my:Handler="OnLoad"/>
  </my:Events>
</my:ObjectControlConfiguration>
'@
    DisplayName                 = 'Configuration for Group Editing'
    IsConfigurationType         = $false
    StringResources             = @'
<SymbolResourcePairs>
  <SymbolResourcePair Symbol="BasicTabCaption" ResourceString="General"/>
  <SymbolResourcePair Symbol="BasicTabHelpText" ResourceString="More information"/>
  <SymbolResourcePair Symbol="EmailEnablingCaption" ResourceString="E-mail Enabled"/>
  <SymbolResourcePair Symbol="EmailEnablingDescription" ResourceString="Enable e-mail on a security group"/>
  <SymbolResourcePair Symbol="EmailEnablingValue" ResourceString="Enabled"/>
  <SymbolResourcePair Symbol="DomainLocalCaption" ResourceString="Domain Local"/>
  <SymbolResourcePair Symbol="DomainLocalHint" ResourceString="Secures resources in a domain.  Members can be in any trusted forest."/>
  <SymbolResourcePair Symbol="GlobalCaption" ResourceString="Global"/>
  <SymbolResourcePair Symbol="GlobalHint" ResourceString="Secures resources in a domain. Members must be in the same domain."/>
  <SymbolResourcePair Symbol="UniversalCaption" ResourceString="Universal"/>
  <SymbolResourcePair Symbol="UniversalHint" ResourceString="Secures resources in a forest. Members must be in the same forest."/>
  <SymbolResourcePair Symbol="MembershipCaption" ResourceString="Member Selection"/>
  <SymbolResourcePair Symbol="NamesCaption" ResourceString="Manual"/>
  <SymbolResourcePair Symbol="NamesHint" ResourceString="Members are manually managed"/>
  <SymbolResourcePair Symbol="ManagerCaption" ResourceString="Manager-based"/>
  <SymbolResourcePair Symbol="ManagerHint" ResourceString="Membership is calculated to include a manager, and all people reporting directly to that manager"/>
  <SymbolResourcePair Symbol="CalculatedCaption" ResourceString="Criteria-based"/>
  <SymbolResourcePair Symbol="CalculatedHint" ResourceString="Membership is calculated based on one or more attributes of the members"/>
  <SymbolResourcePair Symbol="MembersTabCaption" ResourceString="Members"/>
  <SymbolResourcePair Symbol="MembersTabHelpText" ResourceString="More information"/>
  <SymbolResourcePair Symbol="CurrentMembershipCaption" ResourceString="Current Membership"/>
  <SymbolResourcePair Symbol="CurrentMembershipDescription" ResourceString="A read-only view of who is presently in this group."/>
  <SymbolResourcePair Symbol="MemberListEmptyResultText" ResourceString="This group has no members."/>
  <SymbolResourcePair Symbol="MembersToRemoveCaption" ResourceString="Members To Remove"/>
  <SymbolResourcePair Symbol="MembersToRemoveDescription" ResourceString="Choose who to remove from the current members."/>
  <SymbolResourcePair Symbol="MembersToAddCaption" ResourceString="Members To Add"/>
  <SymbolResourcePair Symbol="MembersToAddDescription" ResourceString="Choose new additions to the group."/>
  <SymbolResourcePair Symbol="MembersPopupListviewTitle" ResourceString="Select Members"/>
  <SymbolResourcePair Symbol="MembersToRemovePopupPreviewTitle" ResourceString="Members to be removed:"/>
  <SymbolResourcePair Symbol="MembersToAddPopupPreviewTitle" ResourceString="Members to be added:"/>
  <SymbolResourcePair Symbol="ManagerialMembershipDescription" ResourceString="Group members include the manager and all people reporting directly to the manager."/>
  <SymbolResourcePair Symbol="ManagerPopupListviewTitle" ResourceString="Select Manager"/>
  <SymbolResourcePair Symbol="ManagerPopupPreviewTitle" ResourceString="Manager:"/>
  <SymbolResourcePair Symbol="MemberSearchText" ResourceString="Find the members you want using the Search above."/>
  <SymbolResourcePair Symbol="ManagerSearchText" ResourceString="Find the manager you want using the Search above."/>
  <SymbolResourcePair Symbol="OwnerListListViewTitle" ResourceString="Select Owners"/>
  <SymbolResourcePair Symbol="OwnerListPreviewTitle" ResourceString="Owners:"/>
  <SymbolResourcePair Symbol="OwnerSearchText" ResourceString="Find the owners you want using the Search above."/>
  <SymbolResourcePair Symbol="DisplayedOwnerDescription" ResourceString="The group owner who will be displayed in Outlook or other systems which show only one owner for a group"/>  
  <SymbolResourcePair Symbol="DisplayedOwnerListViewTitle" ResourceString="Select Displayed Owner"/>
  <SymbolResourcePair Symbol="DisplayedOwnerPreviewTitle" ResourceString="Displayed owner:"/>  
  <SymbolResourcePair Symbol="DisplayedOwnerSearchText" ResourceString="Find the displayed owner you want using the Search above."/>
  <SymbolResourcePair Symbol="GroupingManagerialMembersManagerCaption" ResourceString="Manager"/>
  <SymbolResourcePair Symbol="GroupingCalculatedMembersTabCaptionTabCaption" ResourceString="Members"/>
  <SymbolResourcePair Symbol="GroupingCalculatedMembersTabHelpText" ResourceString="More information"/>
  <SymbolResourcePair Symbol="ViewMembers" ResourceString="View Members"/>
  <SymbolResourcePair Symbol="MemberCalculationTabCaption" ResourceString="Member Calculation"/>
  <SymbolResourcePair Symbol="CalculatedMemberCaption" ResourceString="Current Members"/>
  <SymbolResourcePair Symbol="CalculatedMemberListEmptyResultText" ResourceString="There are no members according to the filter definition."/>
  <SymbolResourcePair Symbol="InvalidMemberCaption" ResourceString="Invalid Members"/>
  <SymbolResourcePair Symbol="InvalidMemberHint" ResourceString="Current members who do not meet Active Directory criteria for membership in this group."/>
  <SymbolResourcePair Symbol="InvalidMemberListEmptyResultText" ResourceString="There are no invalid members."/>
  <SymbolResourcePair Symbol="JoiningCaption" ResourceString="Join Restriction"/>
  <SymbolResourcePair Symbol="OwnerApprovalCaption" ResourceString="Owner approval required"/>
  <SymbolResourcePair Symbol="OwnerApprovalHint" ResourceString="A user will become a member of the group only after the group owner has approved the join request."/>
  <SymbolResourcePair Symbol="NoneCaption" ResourceString="None"/>
  <SymbolResourcePair Symbol="NoneHint" ResourceString="Any user can become a member of the group."/>
  <SymbolResourcePair Symbol="OwnersTabCaption" ResourceString="Owners"/>
  <SymbolResourcePair Symbol="OwnersTabHelpText" ResourceString="More information"/>
  <SymbolResourcePair Symbol="SummaryTabCaption" ResourceString="Summary"/>
</SymbolResourcePairs>
'@
    TargetObjectType            = 'Group'
    Ensure						= 'Present'
}

Test-MimSvcTargetResource -ObjectType ObjectVisualizationConfiguration -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

Set-MimSvcTargetResource -ObjectType ObjectVisualizationConfiguration -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

#endregion

#region: Test for an existing ObjectVisualizationConfiguration
Configuration TestObjectVisualizationConfiguration 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ObjectVisualizationConfiguration 'Configuration for Group Editing'
        {
            AppliesToCreate             = $false
            AppliesToEdit               = $true
            AppliesToView               = $false
            ConfigurationData           = @'
<my:ObjectControlConfiguration my:TypeName="UocGroupCodeBehind"
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xmlns:my="http://schemas.microsoft.com/2006/11/ResourceManagement"
 xmlns:xd="http://schemas.microsoft.com/office/infopath/2003">
  <my:ObjectDataSource my:TypeName="PrimaryResourceObjectDataSource" my:Name="object" my:Parameters=""/>
  <my:ObjectDataSource my:TypeName="ReferenceDeltaDataSource" my:Name="delta"/>
  <my:ObjectDataSource my:TypeName="SchemaDataSource" my:Name="schema"/>
  <my:ObjectDataSource my:TypeName="DomainDataSource" my:Name="domain" my:Parameters="%LoginDomain%"/>
  <my:ObjectDataSource my:TypeName="PrimaryResourceRightsDataSource" my:Name="rights"/>
  <my:XmlDataSource my:Name="summaryTransformXsl" my:Parameters="Microsoft.IdentityManagement.WebUI.Controls.Resources.DefaultSummary.xsl"/>
  <my:Panel my:Name="page" my:AutoValidate="true" my:Caption="Caption">
    <my:Grouping my:Name="Caption" my:IsHeader="true" my:Caption="caption" my:Visible="true">
      <my:Control my:Name="Caption" my:TypeName="UocCaptionControl" my:ExpandArea="true" my:Caption="" my:Description="{Binding Source=object, Path=DisplayName}">
        <my:Properties>
          <my:Property my:Name="MaxHeight" my:Value="32"/>
          <my:Property my:Name="MaxWidth" my:Value="32"/>
        </my:Properties>
      </my:Control>
    </my:Grouping>
    <my:Grouping my:Name="GroupingBasicInfo" my:Caption="%SYMBOL_BasicTabCaption_END%">
      <my:Help my:HelpText="%SYMBOL_BasicTabHelpText_END%" my:Link="03e258a0-609b-44f4-8417-4defdb6cb5e9.htm#bkmk_grouping_GroupingBasicInfo"/>
      <my:Control my:Name="Name" my:TypeName="UocTextBox" my:Caption="{Binding Source=schema, Path=DisplayName.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=DisplayName}" 
        my:Description="{Binding Source=schema, Path=DisplayName.Description}">
        <my:Properties>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="MaxLength" my:Value="128"/>
          <my:Property my:Name="Text" my:Value="{Binding Source=object, Path=DisplayName, Mode=TwoWay}"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="EmailEnabling" my:TypeName="UocCheckBox" my:Caption="%SYMBOL_EmailEnablingCaption_END%" my:Description="%SYMBOL_EmailEnablingDescription_END%" my:AutoPostback="true" my:RightsLevel="{Binding Source=rights, Path=Email}">
        <my:Properties>
          <my:Property my:Name="Text" my:Value="%SYMBOL_EmailEnablingValue_END%"/>
        </my:Properties>
        <my:Events>
          <my:Event my:Name="CheckedChanged" my:Handler="OnChangeEmailEnabling"/>
        </my:Events>
      </my:Control>
      <my:Control my:Name="Alias" my:TypeName="UocTextBox" my:Caption="{Binding Source=schema, Path=MailNickname.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=MailNickname}">
        <my:Properties>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="HintPath" my:Value="Hint"/>
          <my:Property my:Name="Text" my:Value="{Binding Source=object, Path=MailNickname, Mode=TwoWay}"/>
          <my:Property my:Name="MaxLength" my:Value="128"/>
          <my:Property my:Name="RegularExpression" my:Value="{Binding Source=schema, Path=MailNickname.StringRegex}"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="EmailAddress" my:TypeName="UocTextBox" my:Caption="{Binding Source=schema, Path=Email.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=Email}">
        <my:Properties>
          <my:Property my:Name="Text" my:Value="{Binding Source=object, Path=Email, Mode=OneWay}"/>
          <my:Property my:Name="ReadOnly" my:Value="true"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="Domain" my:TypeName="UocLabel" my:Caption="{Binding Source=schema, Path=Domain.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=Domain}">
        <my:Properties>
          <my:Property my:Name="Text" my:Value="{Binding Source=object, Path=Domain, Mode=OneWay}"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="AccountName" my:TypeName="UocTextBox" my:Caption="{Binding Source=schema, Path=AccountName.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=AccountName}">
        <my:Properties>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="Text" my:Value="{Binding Source=object, Path=AccountName, Mode=TwoWay}"/>
          <my:Property my:Name="MaxLength" my:Value="64"/>
          <my:Property my:Name="RegularExpression" my:Value="{Binding Source=schema, Path=AccountName.StringRegex}"/>
        </my:Properties>
        <my:Events>
          <my:Event my:Name="TextChanged" my:Handler="OnChangeAccount"/>
        </my:Events>
      </my:Control>
      <my:Control my:Name="Scope" my:TypeName="UocDropDownList" my:Caption="{Binding Source=schema, Path=Scope.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=Scope}">
        <my:Options>
          <my:Option my:Value="DomainLocal" my:Caption="%SYMBOL_DomainLocalCaption_END%" my:Hint="%SYMBOL_DomainLocalHint_END%"/>
          <my:Option my:Value="Global" my:Caption="%SYMBOL_GlobalCaption_END%" my:Hint="%SYMBOL_GlobalHint_END%"/>
          <my:Option my:Value="Universal" my:Caption="%SYMBOL_UniversalCaption_END%" my:Hint="%SYMBOL_UniversalHint_END%"/>
        </my:Options>
        <my:Properties>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="ValuePath" my:Value="Value"/>
          <my:Property my:Name="CaptionPath" my:Value="Caption"/>
          <my:Property my:Name="HintPath" my:Value="Hint"/>
          <my:Property my:Name="ItemSource" my:Value="Custom"/>
          <my:Property my:Name="SelectedValue" my:Value="{Binding Source=object, Path=Scope, Mode=TwoWay}"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="MembershipType" my:TypeName="UocRadioButtonList" my:Caption="%SYMBOL_MembershipCaption_END%" my:RightsLevel="{Binding Source=rights, Path=MembershipLocked}" my:AutoPostback="true">
        <my:Options>
          <my:Option my:Value="Static" my:Caption="%SYMBOL_NamesCaption_END%" my:Hint="%SYMBOL_NamesHint_END%"/>
          <my:Option my:Value="Manager" my:Caption="%SYMBOL_ManagerCaption_END%" my:Hint="%SYMBOL_ManagerHint_END%"/>
          <my:Option my:Value="Calculated" my:Caption="%SYMBOL_CalculatedCaption_END%" my:Hint="%SYMBOL_CalculatedHint_END%"/>
        </my:Options>
        <my:Properties>
          <my:Property my:Name="Required" my:Value="{Binding Source=schema, Path=MembershipLocked.Required}"/>
          <my:Property my:Name="ValuePath" my:Value="Value"/>
          <my:Property my:Name="CaptionPath" my:Value="Caption"/>
          <my:Property my:Name="HintPath" my:Value="Hint"/>
        </my:Properties>
        <my:Events>
          <my:Event my:Name="SelectedIndexChanged" my:Handler="OnChangeMembershipType"/>
        </my:Events>
      </my:Control>
      <my:Control my:Name="Description" my:TypeName="UocTextBox" my:Caption="{Binding Source=schema, Path=Description.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=Description}">
        <my:Properties>
          <my:Property my:Name="Required" my:Value="{Binding Source=schema, Path=DisplayName.Required}"/>
          <my:Property my:Name="Rows" my:Value="3"/>
          <my:Property my:Name="Columns" my:Value="60"/>
          <my:Property my:Name="MaxLength" my:Value="448"/>
          <my:Property my:Name="Text" my:Value="{Binding Source=object, Path=Description, Mode=TwoWay}"/>
        </my:Properties>
      </my:Control>
      <my:Events>
        <my:Event my:Name="BeforeLeave" my:Handler="OnLeaveBasicInfoGrouping"/>
      </my:Events>
    </my:Grouping>
    <my:Grouping my:Name="GroupingMembers" my:Caption="%SYMBOL_MembersTabCaption_END%">
      <my:Help my:HelpText="%SYMBOL_MembersTabHelpText_END%" my:Link="03e258a0-609b-44f4-8417-4defdb6cb5e9.htm#bkmk_grouping_GroupingMembers"/>
      <my:Control my:Name="MemberList" my:TypeName="UocListView" my:Caption="%SYMBOL_CurrentMembershipCaption_END%" my:Description="%SYMBOL_CurrentMembershipDescription_END%" my:RightsLevel="{Binding Source=rights, Path=ExplicitMember}">
        <my:Properties>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName,ObjectType"/>
          <my:Property my:Name="UsageKeywords" my:Value="%Attribute_Type%"/>
          <my:Property my:Name="TargetAttribute" my:Value="ExplicitMember"/>
          <my:Property my:Name="EmptyResultText" my:Value="%SYMBOL_MemberListEmptyResultText_END%"/>
          <my:Property my:Name="PageSize" my:Value="10"/>
          <my:Property my:Name="ShowTitleBar" my:Value="false"/>
          <my:Property my:Name="ShowActionBar" my:Value="false"/>
          <my:Property my:Name="ShowPreview" my:Value="false"/>
          <my:Property my:Name="ShowSearchControl" my:Value="false"/>
          <my:Property my:Name="EnableSelection" my:Value="false"/>
          <my:Property my:Name="SingleSelection" my:Value="false"/>
          <my:Property my:Name="ItemClickBehavior" my:Value="ModelessDialog"/>
          <my:Property my:Name="ReadOnly" my:Value="true"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="InvalidMemberListStatic" my:TypeName="UocListView" my:Caption="%SYMBOL_InvalidMemberCaption_END%" my:Description="%SYMBOL_InvalidMemberHint_END%" my:Visible="false">
        <my:Properties>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName,ObjectType"/>
          <my:Property my:Name="EmptyResultText" my:Value="%SYMBOL_InvalidMemberListEmptyResultText_END%"/>
          <my:Property my:Name="PageSize" my:Value="10"/>
          <my:Property my:Name="ShowTitleBar" my:Value="false"/>
          <my:Property my:Name="ShowActionBar" my:Value="false"/>
          <my:Property my:Name="ShowPreview" my:Value="false"/>
          <my:Property my:Name="ShowSearchControl" my:Value="false"/>
          <my:Property my:Name="EnableSelection" my:Value="false"/>
          <my:Property my:Name="SingleSelection" my:Value="false"/>
          <my:Property my:Name="ItemClickBehavior" my:Value="ModelessDialog"/>
          <my:Property my:Name="ReadOnly" my:Value="true"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="MemberToRemove" my:TypeName="UocIdentityPicker" my:Caption="%SYMBOL_MembersToRemoveCaption_END%" my:Description="%SYMBOL_MembersToRemoveDescription_END%" my:RightsLevel="{Binding Source=rights, Path=ExplicitMember}">
        <my:Properties>
          <my:Property my:Name="Mode" my:Value="MultipleResult"/>
          <my:Property my:Name="Rows" my:Value="3"/>
          <my:Property my:Name="ObjectTypes" my:Value="Person,Group"/>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName,ObjectType"/>
          <my:Property my:Name="AttributesToSearch" my:Value="DisplayName, AccountName"/>
          <my:Property my:Name="Value" my:Value="{Binding Source=delta, Path=ExplicitMember.Remove, Mode=TwoWay}"/>
          <my:Property my:Name="Filter" my:Value="/Group[ObjectID='%ObjectID%']/ExplicitMember"/>
          <my:Property my:Name="ListViewTitle" my:Value="%SYMBOL_MembersPopupListviewTitle_END%"/>
          <my:Property my:Name="PreviewTitle" my:Value="%SYMBOL_MembersToRemovePopupPreviewTitle_END%"/>
          <my:Property my:Name="SearchOnLoad" my:Value="true"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="MemberToAdd" my:TypeName="UocIdentityPicker" my:Caption="%SYMBOL_MembersToAddCaption_END%" my:Description="%SYMBOL_MembersToAddDescription_END%" my:RightsLevel="{Binding Source=rights, Path=ExplicitMember}">
        <my:Properties>
          <my:Property my:Name="Mode" my:Value="MultipleResult"/>
          <my:Property my:Name="Rows" my:Value="3"/>
          <my:Property my:Name="ObjectTypes" my:Value="Person,Group"/>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName, AccountName"/>
          <my:Property my:Name="AttributesToSearch" my:Value="DisplayName, AccountName"/>
          <my:Property my:Name="Value" my:Value="{Binding Source=delta, Path=ExplicitMember.Add, Mode=TwoWay}"/>
          <my:Property my:Name="UsageKeywords" my:Value="%Attribute_Type%"/>
          <my:Property my:Name="ResultObjectType" my:Value="Resource"/>
          <my:Property my:Name="ListViewTitle" my:Value="%SYMBOL_MembersPopupListviewTitle_END%"/>
          <my:Property my:Name="PreviewTitle" my:Value="%SYMBOL_MembersToAddPopupPreviewTitle_END%"/>
          <my:Property my:Name="MainSearchScreenText" my:Value="%SYMBOL_MemberSearchText_END%"/>
        </my:Properties>
      </my:Control>
      <my:Events>
        <my:Event my:Name="AfterEnter" my:Handler="OnEnterMembersGrouping"/>
      </my:Events>
    </my:Grouping>
    <my:Grouping my:Name="GroupingCalculatedMembers" my:Caption="%SYMBOL_GroupingCalculatedMembersTabCaptionTabCaption_END%">
      <my:Help my:HelpText="%SYMBOL_GroupingCalculatedMembersTabHelpText_END%" my:Link="03e258a0-609b-44f4-8417-4defdb6cb5e9.htm#bkmk_grouping_GroupingMembers"/>
      <my:Control my:Name="ManagerialMembershipDescription" my:TypeName="UocTextBox" my:Visible="false">
        <my:Properties>
          <my:Property my:Name="Text" my:Value="%SYMBOL_ManagerialMembershipDescription_END%" /> 
        </my:Properties>
      </my:Control>
      <my:Control my:Name="Manager" my:TypeName="UocIdentityPicker" my:Caption="%SYMBOL_GroupingManagerialMembersManagerCaption_END%" my:RightsLevel="{Binding Source=rights, Path=Filter}">
        <my:Properties>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="ObjectTypes" my:Value="Person"/>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName, MailNickname, Manager"/>
          <my:Property my:Name="AttributesToSearch" my:Value="DisplayName, MailNickname"/>
          <my:Property my:Name="UsageKeywords" my:Value="Person"/>
          <my:Property my:Name="ResultObjectType" my:Value="Person"/>
          <my:Property my:Name="ListViewTitle" my:Value="%SYMBOL_ManagerPopupListviewTitle_END%"/>
          <my:Property my:Name="PreviewTitle" my:Value="%SYMBOL_ManagerPopupPreviewTitle_END%"/>
          <my:Property my:Name="MainSearchScreenText" my:Value="%SYMBOL_ManagerSearchText_END%"/>
        </my:Properties>
        <my:Events>
          <my:Event my:Name="SelectedObjectChanged" my:Handler="OnChangeManagerialMembership"/>
        </my:Events>
      </my:Control>
      <my:Control my:Name="FilterBuilder" my:TypeName="UocFilterBuilder" my:RightsLevel="{Binding Source=rights, Path=Filter}" my:ExpandArea="true">
        <my:Properties>
          <my:Property my:Name="PermittedObjectTypes" my:Value="Person,Group"/>
          <my:Property my:Name="Value" my:Value="{Binding Source=object, Path=Filter, Mode=TwoWay}"/>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="PreviewButtonVisible" my:Value="false"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="Preview" my:TypeName="UocButton" my:ExpandArea="true">
        <my:Properties>
          <my:Property my:Name="Text" my:Value="%SYMBOL_ViewMembers_END%"/>
        </my:Properties>
        <my:Events>
          <my:Event my:Name="Click" my:Handler="OnClickPreview"/>
        </my:Events>
      </my:Control>
      <my:Control my:Name="ComputedMemberList" my:TypeName="UocListView" my:Caption="%SYMBOL_CalculatedMemberCaption_END%" my:ExpandArea="true">
        <my:Properties>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName,ObjectType"/>
          <my:Property my:Name="EmptyResultText" my:Value="%SYMBOL_CalculatedMemberListEmptyResultText_END%"/>
          <my:Property my:Name="PageSize" my:Value="10"/>
          <my:Property my:Name="ShowTitleBar" my:Value="false"/>
          <my:Property my:Name="ShowActionBar" my:Value="false"/>
          <my:Property my:Name="ShowPreview" my:Value="false"/>
          <my:Property my:Name="ShowSearchControl" my:Value="false"/>
          <my:Property my:Name="EnableSelection" my:Value="false"/>
          <my:Property my:Name="SingleSelection" my:Value="false"/>
          <my:Property my:Name="ItemClickBehavior" my:Value="ModelessDialog"/>
          <my:Property my:Name="ReadOnly" my:Value="true"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="InvalidMemberListDynamic" my:TypeName="UocListView" my:Caption="%SYMBOL_InvalidMemberCaption_END%" my:Description="%SYMBOL_InvalidMemberHint_END%" my:ExpandArea="true" my:Visible="false">
        <my:Properties>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName,ObjectType"/>
          <my:Property my:Name="EmptyResultText" my:Value="%SYMBOL_InvalidMemberListEmptyResultText_END%"/>
          <my:Property my:Name="PageSize" my:Value="10"/>
          <my:Property my:Name="ShowTitleBar" my:Value="True"/>
          <my:Property my:Name="ShowActionBar" my:Value="false"/>
          <my:Property my:Name="ShowPreview" my:Value="false"/>
          <my:Property my:Name="ShowSearchControl" my:Value="false"/>
          <my:Property my:Name="EnableSelection" my:Value="false"/>
          <my:Property my:Name="SingleSelection" my:Value="false"/>
          <my:Property my:Name="ItemClickBehavior" my:Value="ModelessDialog"/>
          <my:Property my:Name="ReadOnly" my:Value="true"/>
        </my:Properties>
      </my:Control>
      <my:Events>
        <my:Event my:Name="AfterEnter" my:Handler="OnEnterMembersGrouping"/>
        <my:Event my:Name="BeforeLeave" my:Handler="OnLeaveMembersGrouping"/>
      </my:Events>
    </my:Grouping>
    <my:Grouping my:Name="GroupingOwners" my:Caption="%SYMBOL_OwnersTabCaption_END%">
      <my:Help my:HelpText="%SYMBOL_OwnersTabHelpText_END%" my:Link="03e258a0-609b-44f4-8417-4defdb6cb5e9.htm#bkmk_grouping_GroupingOwners"/>
      <my:Control my:Name="OwnerList" my:TypeName="UocIdentityPicker" my:Caption="{Binding Source=schema, Path=Owner.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=Owner}">
        <my:Properties>
          <my:Property my:Name="Mode" my:Value="MultipleResult"/>
          <my:Property my:Name="Rows" my:Value="3"/>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="ObjectTypes" my:Value="Person"/>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName, AccountName, Department"/>
          <my:Property my:Name="AttributesToSearch" my:Value="DisplayName, AccountName"/>
          <my:Property my:Name="Value" my:Value="{Binding Source=object, Path=Owner, Mode=TwoWay}"/>
          <my:Property my:Name="UsageKeywords" my:Value="Person"/>
          <my:Property my:Name="ResultObjectType" my:Value="Person"/>
          <my:Property my:Name="ListViewTitle" my:Value="%SYMBOL_OwnerListListViewTitle_END%"/>
          <my:Property my:Name="PreviewTitle" my:Value="%SYMBOL_OwnerListPreviewTitle_END%"/>
          <my:Property my:Name="MainSearchScreenText" my:Value="%SYMBOL_OwnerSearchText_END%"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="DisplayedOwner" my:TypeName="UocIdentityPicker" my:Caption="{Binding Source=schema, Path=DisplayedOwner.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=DisplayedOwner}" my:Description="%SYMBOL_DisplayedOwnerDescription_END%">
        <my:Properties>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="ObjectTypes" my:Value="Person"/>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName, AccountName, Department"/>
          <my:Property my:Name="AttributesToSearch" my:Value="DisplayName, AccountName"/>
          <my:Property my:Name="Value" my:Value="{Binding Source=object, Path=DisplayedOwner, Mode=TwoWay}"/>
          <my:Property my:Name="UsageKeywords" my:Value="Person"/>
          <my:Property my:Name="ResultObjectType" my:Value="Person"/>
          <my:Property my:Name="ListViewTitle" my:Value="%SYMBOL_DisplayedOwnerListViewTitle_END%"/>
          <my:Property my:Name="PreviewTitle" my:Value="%SYMBOL_DisplayedOwnerPreviewTitle_END%"/>
          <my:Property my:Name="MainSearchScreenText" my:Value="%SYMBOL_DisplayedOwnerSearchText_END%"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="Join" my:TypeName="UocRadioButtonList" my:Caption="%SYMBOL_JoiningCaption_END%" my:RightsLevel="{Binding Source=rights, Path=MembershipAddWorkflow}">
        <my:Options>
          <my:Option my:Value="Owner Approval" my:Caption="%SYMBOL_OwnerApprovalCaption_END%" my:Hint="%SYMBOL_OwnerApprovalHint_END%"/>
          <my:Option my:Value="None" my:Caption="%SYMBOL_NoneCaption_END%" my:Hint="%SYMBOL_NoneHint_END%"/>
        </my:Options>
        <my:Properties>
          <my:Property my:Name="Required" my:Value="{Binding Source=schema, Path=MembershipAddWorkflow.Required}"/>
          <my:Property my:Name="ValuePath" my:Value="Value"/>
          <my:Property my:Name="CaptionPath" my:Value="Caption"/>
          <my:Property my:Name="HintPath" my:Value="Hint"/>
          <my:Property my:Name="ItemSource" my:Value="Custom"/>
          <my:Property my:Name="SelectedValue" my:Value="{Binding Source=object, Path=MembershipAddWorkflow, Mode=TwoWay}"/>
        </my:Properties>
        <my:Events>
          <my:Event my:Name="SelectedIndexChanged" my:Handler="OnChangeMembershipWorkflow"/>
        </my:Events>
      </my:Control>
      <my:Events>
        <my:Event my:Name="BeforeLeave" my:Handler="OnLeaveOwnersGrouping"/>
      </my:Events>
    </my:Grouping>
    <my:Grouping my:Name="GroupingSummary" my:Caption="%SYMBOL_SummaryTabCaption_END%" my:IsSummary="true">
      <my:Control my:Name="SummaryControl" my:TypeName="UocHtmlSummary" my:ExpandArea="true">
        <my:Properties>
          <my:Property my:Name="ModificationsXml" my:Value="{Binding Source=delta, Path=DeltaXml}"/>
          <my:Property my:Name="TransformXsl" my:Value="{Binding Source=summaryTransformXsl, Path=/}"/>
        </my:Properties>
      </my:Control>
    </my:Grouping>
  </my:Panel>
  <my:Events>
    <my:Event my:Name="Load" my:Handler="OnLoad"/>
  </my:Events>
</my:ObjectControlConfiguration>
'@
            DisplayName                 = 'Configuration for Group Editing'
            IsConfigurationType         = $false
            StringResources             = @'
<SymbolResourcePairs>
  <SymbolResourcePair Symbol="BasicTabCaption" ResourceString="General"/>
  <SymbolResourcePair Symbol="BasicTabHelpText" ResourceString="More information"/>
  <SymbolResourcePair Symbol="EmailEnablingCaption" ResourceString="E-mail Enabled"/>
  <SymbolResourcePair Symbol="EmailEnablingDescription" ResourceString="Enable e-mail on a security group"/>
  <SymbolResourcePair Symbol="EmailEnablingValue" ResourceString="Enabled"/>
  <SymbolResourcePair Symbol="DomainLocalCaption" ResourceString="Domain Local"/>
  <SymbolResourcePair Symbol="DomainLocalHint" ResourceString="Secures resources in a domain.  Members can be in any trusted forest."/>
  <SymbolResourcePair Symbol="GlobalCaption" ResourceString="Global"/>
  <SymbolResourcePair Symbol="GlobalHint" ResourceString="Secures resources in a domain. Members must be in the same domain."/>
  <SymbolResourcePair Symbol="UniversalCaption" ResourceString="Universal"/>
  <SymbolResourcePair Symbol="UniversalHint" ResourceString="Secures resources in a forest. Members must be in the same forest."/>
  <SymbolResourcePair Symbol="MembershipCaption" ResourceString="Member Selection"/>
  <SymbolResourcePair Symbol="NamesCaption" ResourceString="Manual"/>
  <SymbolResourcePair Symbol="NamesHint" ResourceString="Members are manually managed"/>
  <SymbolResourcePair Symbol="ManagerCaption" ResourceString="Manager-based"/>
  <SymbolResourcePair Symbol="ManagerHint" ResourceString="Membership is calculated to include a manager, and all people reporting directly to that manager"/>
  <SymbolResourcePair Symbol="CalculatedCaption" ResourceString="Criteria-based"/>
  <SymbolResourcePair Symbol="CalculatedHint" ResourceString="Membership is calculated based on one or more attributes of the members"/>
  <SymbolResourcePair Symbol="MembersTabCaption" ResourceString="Members"/>
  <SymbolResourcePair Symbol="MembersTabHelpText" ResourceString="More information"/>
  <SymbolResourcePair Symbol="CurrentMembershipCaption" ResourceString="Current Membership"/>
  <SymbolResourcePair Symbol="CurrentMembershipDescription" ResourceString="A read-only view of who is presently in this group."/>
  <SymbolResourcePair Symbol="MemberListEmptyResultText" ResourceString="This group has no members."/>
  <SymbolResourcePair Symbol="MembersToRemoveCaption" ResourceString="Members To Remove"/>
  <SymbolResourcePair Symbol="MembersToRemoveDescription" ResourceString="Choose who to remove from the current members."/>
  <SymbolResourcePair Symbol="MembersToAddCaption" ResourceString="Members To Add"/>
  <SymbolResourcePair Symbol="MembersToAddDescription" ResourceString="Choose new additions to the group."/>
  <SymbolResourcePair Symbol="MembersPopupListviewTitle" ResourceString="Select Members"/>
  <SymbolResourcePair Symbol="MembersToRemovePopupPreviewTitle" ResourceString="Members to be removed:"/>
  <SymbolResourcePair Symbol="MembersToAddPopupPreviewTitle" ResourceString="Members to be added:"/>
  <SymbolResourcePair Symbol="ManagerialMembershipDescription" ResourceString="Group members include the manager and all people reporting directly to the manager."/>
  <SymbolResourcePair Symbol="ManagerPopupListviewTitle" ResourceString="Select Manager"/>
  <SymbolResourcePair Symbol="ManagerPopupPreviewTitle" ResourceString="Manager:"/>
  <SymbolResourcePair Symbol="MemberSearchText" ResourceString="Find the members you want using the Search above."/>
  <SymbolResourcePair Symbol="ManagerSearchText" ResourceString="Find the manager you want using the Search above."/>
  <SymbolResourcePair Symbol="OwnerListListViewTitle" ResourceString="Select Owners"/>
  <SymbolResourcePair Symbol="OwnerListPreviewTitle" ResourceString="Owners:"/>
  <SymbolResourcePair Symbol="OwnerSearchText" ResourceString="Find the owners you want using the Search above."/>
  <SymbolResourcePair Symbol="DisplayedOwnerDescription" ResourceString="The group owner who will be displayed in Outlook or other systems which show only one owner for a group"/>  
  <SymbolResourcePair Symbol="DisplayedOwnerListViewTitle" ResourceString="Select Displayed Owner"/>
  <SymbolResourcePair Symbol="DisplayedOwnerPreviewTitle" ResourceString="Displayed owner:"/>  
  <SymbolResourcePair Symbol="DisplayedOwnerSearchText" ResourceString="Find the displayed owner you want using the Search above."/>
  <SymbolResourcePair Symbol="GroupingManagerialMembersManagerCaption" ResourceString="Manager"/>
  <SymbolResourcePair Symbol="GroupingCalculatedMembersTabCaptionTabCaption" ResourceString="Members"/>
  <SymbolResourcePair Symbol="GroupingCalculatedMembersTabHelpText" ResourceString="More information"/>
  <SymbolResourcePair Symbol="ViewMembers" ResourceString="View Members"/>
  <SymbolResourcePair Symbol="MemberCalculationTabCaption" ResourceString="Member Calculation"/>
  <SymbolResourcePair Symbol="CalculatedMemberCaption" ResourceString="Current Members"/>
  <SymbolResourcePair Symbol="CalculatedMemberListEmptyResultText" ResourceString="There are no members according to the filter definition."/>
  <SymbolResourcePair Symbol="InvalidMemberCaption" ResourceString="Invalid Members"/>
  <SymbolResourcePair Symbol="InvalidMemberHint" ResourceString="Current members who do not meet Active Directory criteria for membership in this group."/>
  <SymbolResourcePair Symbol="InvalidMemberListEmptyResultText" ResourceString="There are no invalid members."/>
  <SymbolResourcePair Symbol="JoiningCaption" ResourceString="Join Restriction"/>
  <SymbolResourcePair Symbol="OwnerApprovalCaption" ResourceString="Owner approval required"/>
  <SymbolResourcePair Symbol="OwnerApprovalHint" ResourceString="A user will become a member of the group only after the group owner has approved the join request."/>
  <SymbolResourcePair Symbol="NoneCaption" ResourceString="None"/>
  <SymbolResourcePair Symbol="NoneHint" ResourceString="Any user can become a member of the group."/>
  <SymbolResourcePair Symbol="OwnersTabCaption" ResourceString="Owners"/>
  <SymbolResourcePair Symbol="OwnersTabHelpText" ResourceString="More information"/>
  <SymbolResourcePair Symbol="SummaryTabCaption" ResourceString="Summary"/>
</SymbolResourcePairs>
'@
            TargetObjectType            = 'Group'
            Ensure						= 'Present'
        }
    } 
} 

TestObjectVisualizationConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestObjectVisualizationConfiguration" -Force
#endregion

#region: New ObjectVisualizationConfiguration
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestObjectVisualizationConfiguration 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ObjectVisualizationConfiguration "TestObjectVisualizationConfiguration$randomNumber"
        {
            AppliesToCreate             = $false
            AppliesToEdit               = $true
            AppliesToView               = $false
            ConfigurationData           = @'
<my:ObjectControlConfiguration my:TypeName="UocGroupCodeBehind"
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xmlns:my="http://schemas.microsoft.com/2006/11/ResourceManagement"
 xmlns:xd="http://schemas.microsoft.com/office/infopath/2003">
  <my:ObjectDataSource my:TypeName="PrimaryResourceObjectDataSource" my:Name="object" my:Parameters=""/>
  <my:ObjectDataSource my:TypeName="ReferenceDeltaDataSource" my:Name="delta"/>
  <my:ObjectDataSource my:TypeName="SchemaDataSource" my:Name="schema"/>
  <my:ObjectDataSource my:TypeName="DomainDataSource" my:Name="domain" my:Parameters="%LoginDomain%"/>
  <my:ObjectDataSource my:TypeName="PrimaryResourceRightsDataSource" my:Name="rights"/>
  <my:XmlDataSource my:Name="summaryTransformXsl" my:Parameters="Microsoft.IdentityManagement.WebUI.Controls.Resources.DefaultSummary.xsl"/>
  <my:Panel my:Name="page" my:AutoValidate="true" my:Caption="Caption">
    <my:Grouping my:Name="Caption" my:IsHeader="true" my:Caption="caption" my:Visible="true">
      <my:Control my:Name="Caption" my:TypeName="UocCaptionControl" my:ExpandArea="true" my:Caption="" my:Description="{Binding Source=object, Path=DisplayName}">
        <my:Properties>
          <my:Property my:Name="MaxHeight" my:Value="32"/>
          <my:Property my:Name="MaxWidth" my:Value="32"/>
        </my:Properties>
      </my:Control>
    </my:Grouping>
    <my:Grouping my:Name="GroupingBasicInfo" my:Caption="%SYMBOL_BasicTabCaption_END%">
      <my:Help my:HelpText="%SYMBOL_BasicTabHelpText_END%" my:Link="03e258a0-609b-44f4-8417-4defdb6cb5e9.htm#bkmk_grouping_GroupingBasicInfo"/>
      <my:Control my:Name="Name" my:TypeName="UocTextBox" my:Caption="{Binding Source=schema, Path=DisplayName.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=DisplayName}" 
        my:Description="{Binding Source=schema, Path=DisplayName.Description}">
        <my:Properties>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="MaxLength" my:Value="128"/>
          <my:Property my:Name="Text" my:Value="{Binding Source=object, Path=DisplayName, Mode=TwoWay}"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="EmailEnabling" my:TypeName="UocCheckBox" my:Caption="%SYMBOL_EmailEnablingCaption_END%" my:Description="%SYMBOL_EmailEnablingDescription_END%" my:AutoPostback="true" my:RightsLevel="{Binding Source=rights, Path=Email}">
        <my:Properties>
          <my:Property my:Name="Text" my:Value="%SYMBOL_EmailEnablingValue_END%"/>
        </my:Properties>
        <my:Events>
          <my:Event my:Name="CheckedChanged" my:Handler="OnChangeEmailEnabling"/>
        </my:Events>
      </my:Control>
      <my:Control my:Name="Alias" my:TypeName="UocTextBox" my:Caption="{Binding Source=schema, Path=MailNickname.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=MailNickname}">
        <my:Properties>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="HintPath" my:Value="Hint"/>
          <my:Property my:Name="Text" my:Value="{Binding Source=object, Path=MailNickname, Mode=TwoWay}"/>
          <my:Property my:Name="MaxLength" my:Value="128"/>
          <my:Property my:Name="RegularExpression" my:Value="{Binding Source=schema, Path=MailNickname.StringRegex}"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="EmailAddress" my:TypeName="UocTextBox" my:Caption="{Binding Source=schema, Path=Email.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=Email}">
        <my:Properties>
          <my:Property my:Name="Text" my:Value="{Binding Source=object, Path=Email, Mode=OneWay}"/>
          <my:Property my:Name="ReadOnly" my:Value="true"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="Domain" my:TypeName="UocLabel" my:Caption="{Binding Source=schema, Path=Domain.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=Domain}">
        <my:Properties>
          <my:Property my:Name="Text" my:Value="{Binding Source=object, Path=Domain, Mode=OneWay}"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="AccountName" my:TypeName="UocTextBox" my:Caption="{Binding Source=schema, Path=AccountName.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=AccountName}">
        <my:Properties>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="Text" my:Value="{Binding Source=object, Path=AccountName, Mode=TwoWay}"/>
          <my:Property my:Name="MaxLength" my:Value="64"/>
          <my:Property my:Name="RegularExpression" my:Value="{Binding Source=schema, Path=AccountName.StringRegex}"/>
        </my:Properties>
        <my:Events>
          <my:Event my:Name="TextChanged" my:Handler="OnChangeAccount"/>
        </my:Events>
      </my:Control>
      <my:Control my:Name="Scope" my:TypeName="UocDropDownList" my:Caption="{Binding Source=schema, Path=Scope.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=Scope}">
        <my:Options>
          <my:Option my:Value="DomainLocal" my:Caption="%SYMBOL_DomainLocalCaption_END%" my:Hint="%SYMBOL_DomainLocalHint_END%"/>
          <my:Option my:Value="Global" my:Caption="%SYMBOL_GlobalCaption_END%" my:Hint="%SYMBOL_GlobalHint_END%"/>
          <my:Option my:Value="Universal" my:Caption="%SYMBOL_UniversalCaption_END%" my:Hint="%SYMBOL_UniversalHint_END%"/>
        </my:Options>
        <my:Properties>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="ValuePath" my:Value="Value"/>
          <my:Property my:Name="CaptionPath" my:Value="Caption"/>
          <my:Property my:Name="HintPath" my:Value="Hint"/>
          <my:Property my:Name="ItemSource" my:Value="Custom"/>
          <my:Property my:Name="SelectedValue" my:Value="{Binding Source=object, Path=Scope, Mode=TwoWay}"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="MembershipType" my:TypeName="UocRadioButtonList" my:Caption="%SYMBOL_MembershipCaption_END%" my:RightsLevel="{Binding Source=rights, Path=MembershipLocked}" my:AutoPostback="true">
        <my:Options>
          <my:Option my:Value="Static" my:Caption="%SYMBOL_NamesCaption_END%" my:Hint="%SYMBOL_NamesHint_END%"/>
          <my:Option my:Value="Manager" my:Caption="%SYMBOL_ManagerCaption_END%" my:Hint="%SYMBOL_ManagerHint_END%"/>
          <my:Option my:Value="Calculated" my:Caption="%SYMBOL_CalculatedCaption_END%" my:Hint="%SYMBOL_CalculatedHint_END%"/>
        </my:Options>
        <my:Properties>
          <my:Property my:Name="Required" my:Value="{Binding Source=schema, Path=MembershipLocked.Required}"/>
          <my:Property my:Name="ValuePath" my:Value="Value"/>
          <my:Property my:Name="CaptionPath" my:Value="Caption"/>
          <my:Property my:Name="HintPath" my:Value="Hint"/>
        </my:Properties>
        <my:Events>
          <my:Event my:Name="SelectedIndexChanged" my:Handler="OnChangeMembershipType"/>
        </my:Events>
      </my:Control>
      <my:Control my:Name="Description" my:TypeName="UocTextBox" my:Caption="{Binding Source=schema, Path=Description.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=Description}">
        <my:Properties>
          <my:Property my:Name="Required" my:Value="{Binding Source=schema, Path=DisplayName.Required}"/>
          <my:Property my:Name="Rows" my:Value="3"/>
          <my:Property my:Name="Columns" my:Value="60"/>
          <my:Property my:Name="MaxLength" my:Value="448"/>
          <my:Property my:Name="Text" my:Value="{Binding Source=object, Path=Description, Mode=TwoWay}"/>
        </my:Properties>
      </my:Control>
      <my:Events>
        <my:Event my:Name="BeforeLeave" my:Handler="OnLeaveBasicInfoGrouping"/>
      </my:Events>
    </my:Grouping>
    <my:Grouping my:Name="GroupingMembers" my:Caption="%SYMBOL_MembersTabCaption_END%">
      <my:Help my:HelpText="%SYMBOL_MembersTabHelpText_END%" my:Link="03e258a0-609b-44f4-8417-4defdb6cb5e9.htm#bkmk_grouping_GroupingMembers"/>
      <my:Control my:Name="MemberList" my:TypeName="UocListView" my:Caption="%SYMBOL_CurrentMembershipCaption_END%" my:Description="%SYMBOL_CurrentMembershipDescription_END%" my:RightsLevel="{Binding Source=rights, Path=ExplicitMember}">
        <my:Properties>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName,ObjectType"/>
          <my:Property my:Name="UsageKeywords" my:Value="%Attribute_Type%"/>
          <my:Property my:Name="TargetAttribute" my:Value="ExplicitMember"/>
          <my:Property my:Name="EmptyResultText" my:Value="%SYMBOL_MemberListEmptyResultText_END%"/>
          <my:Property my:Name="PageSize" my:Value="10"/>
          <my:Property my:Name="ShowTitleBar" my:Value="false"/>
          <my:Property my:Name="ShowActionBar" my:Value="false"/>
          <my:Property my:Name="ShowPreview" my:Value="false"/>
          <my:Property my:Name="ShowSearchControl" my:Value="false"/>
          <my:Property my:Name="EnableSelection" my:Value="false"/>
          <my:Property my:Name="SingleSelection" my:Value="false"/>
          <my:Property my:Name="ItemClickBehavior" my:Value="ModelessDialog"/>
          <my:Property my:Name="ReadOnly" my:Value="true"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="InvalidMemberListStatic" my:TypeName="UocListView" my:Caption="%SYMBOL_InvalidMemberCaption_END%" my:Description="%SYMBOL_InvalidMemberHint_END%" my:Visible="false">
        <my:Properties>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName,ObjectType"/>
          <my:Property my:Name="EmptyResultText" my:Value="%SYMBOL_InvalidMemberListEmptyResultText_END%"/>
          <my:Property my:Name="PageSize" my:Value="10"/>
          <my:Property my:Name="ShowTitleBar" my:Value="false"/>
          <my:Property my:Name="ShowActionBar" my:Value="false"/>
          <my:Property my:Name="ShowPreview" my:Value="false"/>
          <my:Property my:Name="ShowSearchControl" my:Value="false"/>
          <my:Property my:Name="EnableSelection" my:Value="false"/>
          <my:Property my:Name="SingleSelection" my:Value="false"/>
          <my:Property my:Name="ItemClickBehavior" my:Value="ModelessDialog"/>
          <my:Property my:Name="ReadOnly" my:Value="true"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="MemberToRemove" my:TypeName="UocIdentityPicker" my:Caption="%SYMBOL_MembersToRemoveCaption_END%" my:Description="%SYMBOL_MembersToRemoveDescription_END%" my:RightsLevel="{Binding Source=rights, Path=ExplicitMember}">
        <my:Properties>
          <my:Property my:Name="Mode" my:Value="MultipleResult"/>
          <my:Property my:Name="Rows" my:Value="3"/>
          <my:Property my:Name="ObjectTypes" my:Value="Person,Group"/>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName,ObjectType"/>
          <my:Property my:Name="AttributesToSearch" my:Value="DisplayName, AccountName"/>
          <my:Property my:Name="Value" my:Value="{Binding Source=delta, Path=ExplicitMember.Remove, Mode=TwoWay}"/>
          <my:Property my:Name="Filter" my:Value="/Group[ObjectID='%ObjectID%']/ExplicitMember"/>
          <my:Property my:Name="ListViewTitle" my:Value="%SYMBOL_MembersPopupListviewTitle_END%"/>
          <my:Property my:Name="PreviewTitle" my:Value="%SYMBOL_MembersToRemovePopupPreviewTitle_END%"/>
          <my:Property my:Name="SearchOnLoad" my:Value="true"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="MemberToAdd" my:TypeName="UocIdentityPicker" my:Caption="%SYMBOL_MembersToAddCaption_END%" my:Description="%SYMBOL_MembersToAddDescription_END%" my:RightsLevel="{Binding Source=rights, Path=ExplicitMember}">
        <my:Properties>
          <my:Property my:Name="Mode" my:Value="MultipleResult"/>
          <my:Property my:Name="Rows" my:Value="3"/>
          <my:Property my:Name="ObjectTypes" my:Value="Person,Group"/>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName, AccountName"/>
          <my:Property my:Name="AttributesToSearch" my:Value="DisplayName, AccountName"/>
          <my:Property my:Name="Value" my:Value="{Binding Source=delta, Path=ExplicitMember.Add, Mode=TwoWay}"/>
          <my:Property my:Name="UsageKeywords" my:Value="%Attribute_Type%"/>
          <my:Property my:Name="ResultObjectType" my:Value="Resource"/>
          <my:Property my:Name="ListViewTitle" my:Value="%SYMBOL_MembersPopupListviewTitle_END%"/>
          <my:Property my:Name="PreviewTitle" my:Value="%SYMBOL_MembersToAddPopupPreviewTitle_END%"/>
          <my:Property my:Name="MainSearchScreenText" my:Value="%SYMBOL_MemberSearchText_END%"/>
        </my:Properties>
      </my:Control>
      <my:Events>
        <my:Event my:Name="AfterEnter" my:Handler="OnEnterMembersGrouping"/>
      </my:Events>
    </my:Grouping>
    <my:Grouping my:Name="GroupingCalculatedMembers" my:Caption="%SYMBOL_GroupingCalculatedMembersTabCaptionTabCaption_END%">
      <my:Help my:HelpText="%SYMBOL_GroupingCalculatedMembersTabHelpText_END%" my:Link="03e258a0-609b-44f4-8417-4defdb6cb5e9.htm#bkmk_grouping_GroupingMembers"/>
      <my:Control my:Name="ManagerialMembershipDescription" my:TypeName="UocTextBox" my:Visible="false">
        <my:Properties>
          <my:Property my:Name="Text" my:Value="%SYMBOL_ManagerialMembershipDescription_END%" /> 
        </my:Properties>
      </my:Control>
      <my:Control my:Name="Manager" my:TypeName="UocIdentityPicker" my:Caption="%SYMBOL_GroupingManagerialMembersManagerCaption_END%" my:RightsLevel="{Binding Source=rights, Path=Filter}">
        <my:Properties>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="ObjectTypes" my:Value="Person"/>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName, MailNickname, Manager"/>
          <my:Property my:Name="AttributesToSearch" my:Value="DisplayName, MailNickname"/>
          <my:Property my:Name="UsageKeywords" my:Value="Person"/>
          <my:Property my:Name="ResultObjectType" my:Value="Person"/>
          <my:Property my:Name="ListViewTitle" my:Value="%SYMBOL_ManagerPopupListviewTitle_END%"/>
          <my:Property my:Name="PreviewTitle" my:Value="%SYMBOL_ManagerPopupPreviewTitle_END%"/>
          <my:Property my:Name="MainSearchScreenText" my:Value="%SYMBOL_ManagerSearchText_END%"/>
        </my:Properties>
        <my:Events>
          <my:Event my:Name="SelectedObjectChanged" my:Handler="OnChangeManagerialMembership"/>
        </my:Events>
      </my:Control>
      <my:Control my:Name="FilterBuilder" my:TypeName="UocFilterBuilder" my:RightsLevel="{Binding Source=rights, Path=Filter}" my:ExpandArea="true">
        <my:Properties>
          <my:Property my:Name="PermittedObjectTypes" my:Value="Person,Group"/>
          <my:Property my:Name="Value" my:Value="{Binding Source=object, Path=Filter, Mode=TwoWay}"/>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="PreviewButtonVisible" my:Value="false"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="Preview" my:TypeName="UocButton" my:ExpandArea="true">
        <my:Properties>
          <my:Property my:Name="Text" my:Value="%SYMBOL_ViewMembers_END%"/>
        </my:Properties>
        <my:Events>
          <my:Event my:Name="Click" my:Handler="OnClickPreview"/>
        </my:Events>
      </my:Control>
      <my:Control my:Name="ComputedMemberList" my:TypeName="UocListView" my:Caption="%SYMBOL_CalculatedMemberCaption_END%" my:ExpandArea="true">
        <my:Properties>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName,ObjectType"/>
          <my:Property my:Name="EmptyResultText" my:Value="%SYMBOL_CalculatedMemberListEmptyResultText_END%"/>
          <my:Property my:Name="PageSize" my:Value="10"/>
          <my:Property my:Name="ShowTitleBar" my:Value="false"/>
          <my:Property my:Name="ShowActionBar" my:Value="false"/>
          <my:Property my:Name="ShowPreview" my:Value="false"/>
          <my:Property my:Name="ShowSearchControl" my:Value="false"/>
          <my:Property my:Name="EnableSelection" my:Value="false"/>
          <my:Property my:Name="SingleSelection" my:Value="false"/>
          <my:Property my:Name="ItemClickBehavior" my:Value="ModelessDialog"/>
          <my:Property my:Name="ReadOnly" my:Value="true"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="InvalidMemberListDynamic" my:TypeName="UocListView" my:Caption="%SYMBOL_InvalidMemberCaption_END%" my:Description="%SYMBOL_InvalidMemberHint_END%" my:ExpandArea="true" my:Visible="false">
        <my:Properties>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName,ObjectType"/>
          <my:Property my:Name="EmptyResultText" my:Value="%SYMBOL_InvalidMemberListEmptyResultText_END%"/>
          <my:Property my:Name="PageSize" my:Value="10"/>
          <my:Property my:Name="ShowTitleBar" my:Value="True"/>
          <my:Property my:Name="ShowActionBar" my:Value="false"/>
          <my:Property my:Name="ShowPreview" my:Value="false"/>
          <my:Property my:Name="ShowSearchControl" my:Value="false"/>
          <my:Property my:Name="EnableSelection" my:Value="false"/>
          <my:Property my:Name="SingleSelection" my:Value="false"/>
          <my:Property my:Name="ItemClickBehavior" my:Value="ModelessDialog"/>
          <my:Property my:Name="ReadOnly" my:Value="true"/>
        </my:Properties>
      </my:Control>
      <my:Events>
        <my:Event my:Name="AfterEnter" my:Handler="OnEnterMembersGrouping"/>
        <my:Event my:Name="BeforeLeave" my:Handler="OnLeaveMembersGrouping"/>
      </my:Events>
    </my:Grouping>
    <my:Grouping my:Name="GroupingOwners" my:Caption="%SYMBOL_OwnersTabCaption_END%">
      <my:Help my:HelpText="%SYMBOL_OwnersTabHelpText_END%" my:Link="03e258a0-609b-44f4-8417-4defdb6cb5e9.htm#bkmk_grouping_GroupingOwners"/>
      <my:Control my:Name="OwnerList" my:TypeName="UocIdentityPicker" my:Caption="{Binding Source=schema, Path=Owner.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=Owner}">
        <my:Properties>
          <my:Property my:Name="Mode" my:Value="MultipleResult"/>
          <my:Property my:Name="Rows" my:Value="3"/>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="ObjectTypes" my:Value="Person"/>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName, AccountName, Department"/>
          <my:Property my:Name="AttributesToSearch" my:Value="DisplayName, AccountName"/>
          <my:Property my:Name="Value" my:Value="{Binding Source=object, Path=Owner, Mode=TwoWay}"/>
          <my:Property my:Name="UsageKeywords" my:Value="Person"/>
          <my:Property my:Name="ResultObjectType" my:Value="Person"/>
          <my:Property my:Name="ListViewTitle" my:Value="%SYMBOL_OwnerListListViewTitle_END%"/>
          <my:Property my:Name="PreviewTitle" my:Value="%SYMBOL_OwnerListPreviewTitle_END%"/>
          <my:Property my:Name="MainSearchScreenText" my:Value="%SYMBOL_OwnerSearchText_END%"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="DisplayedOwner" my:TypeName="UocIdentityPicker" my:Caption="{Binding Source=schema, Path=DisplayedOwner.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=DisplayedOwner}" my:Description="%SYMBOL_DisplayedOwnerDescription_END%">
        <my:Properties>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="ObjectTypes" my:Value="Person"/>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName, AccountName, Department"/>
          <my:Property my:Name="AttributesToSearch" my:Value="DisplayName, AccountName"/>
          <my:Property my:Name="Value" my:Value="{Binding Source=object, Path=DisplayedOwner, Mode=TwoWay}"/>
          <my:Property my:Name="UsageKeywords" my:Value="Person"/>
          <my:Property my:Name="ResultObjectType" my:Value="Person"/>
          <my:Property my:Name="ListViewTitle" my:Value="%SYMBOL_DisplayedOwnerListViewTitle_END%"/>
          <my:Property my:Name="PreviewTitle" my:Value="%SYMBOL_DisplayedOwnerPreviewTitle_END%"/>
          <my:Property my:Name="MainSearchScreenText" my:Value="%SYMBOL_DisplayedOwnerSearchText_END%"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="Join" my:TypeName="UocRadioButtonList" my:Caption="%SYMBOL_JoiningCaption_END%" my:RightsLevel="{Binding Source=rights, Path=MembershipAddWorkflow}">
        <my:Options>
          <my:Option my:Value="Owner Approval" my:Caption="%SYMBOL_OwnerApprovalCaption_END%" my:Hint="%SYMBOL_OwnerApprovalHint_END%"/>
          <my:Option my:Value="None" my:Caption="%SYMBOL_NoneCaption_END%" my:Hint="%SYMBOL_NoneHint_END%"/>
        </my:Options>
        <my:Properties>
          <my:Property my:Name="Required" my:Value="{Binding Source=schema, Path=MembershipAddWorkflow.Required}"/>
          <my:Property my:Name="ValuePath" my:Value="Value"/>
          <my:Property my:Name="CaptionPath" my:Value="Caption"/>
          <my:Property my:Name="HintPath" my:Value="Hint"/>
          <my:Property my:Name="ItemSource" my:Value="Custom"/>
          <my:Property my:Name="SelectedValue" my:Value="{Binding Source=object, Path=MembershipAddWorkflow, Mode=TwoWay}"/>
        </my:Properties>
        <my:Events>
          <my:Event my:Name="SelectedIndexChanged" my:Handler="OnChangeMembershipWorkflow"/>
        </my:Events>
      </my:Control>
      <my:Events>
        <my:Event my:Name="BeforeLeave" my:Handler="OnLeaveOwnersGrouping"/>
      </my:Events>
    </my:Grouping>
    <my:Grouping my:Name="GroupingSummary" my:Caption="%SYMBOL_SummaryTabCaption_END%" my:IsSummary="true">
      <my:Control my:Name="SummaryControl" my:TypeName="UocHtmlSummary" my:ExpandArea="true">
        <my:Properties>
          <my:Property my:Name="ModificationsXml" my:Value="{Binding Source=delta, Path=DeltaXml}"/>
          <my:Property my:Name="TransformXsl" my:Value="{Binding Source=summaryTransformXsl, Path=/}"/>
        </my:Properties>
      </my:Control>
    </my:Grouping>
  </my:Panel>
  <my:Events>
    <my:Event my:Name="Load" my:Handler="OnLoad"/>
  </my:Events>
</my:ObjectControlConfiguration>
'@
            DisplayName                 = "TestObjectVisualizationConfiguration$randomNumber"
            IsConfigurationType         = $false
            StringResources             = @'
<SymbolResourcePairs>
  <SymbolResourcePair Symbol="BasicTabCaption" ResourceString="General"/>
  <SymbolResourcePair Symbol="BasicTabHelpText" ResourceString="More information"/>
  <SymbolResourcePair Symbol="EmailEnablingCaption" ResourceString="E-mail Enabled"/>
  <SymbolResourcePair Symbol="EmailEnablingDescription" ResourceString="Enable e-mail on a security group"/>
  <SymbolResourcePair Symbol="EmailEnablingValue" ResourceString="Enabled"/>
  <SymbolResourcePair Symbol="DomainLocalCaption" ResourceString="Domain Local"/>
  <SymbolResourcePair Symbol="DomainLocalHint" ResourceString="Secures resources in a domain.  Members can be in any trusted forest."/>
  <SymbolResourcePair Symbol="GlobalCaption" ResourceString="Global"/>
  <SymbolResourcePair Symbol="GlobalHint" ResourceString="Secures resources in a domain. Members must be in the same domain."/>
  <SymbolResourcePair Symbol="UniversalCaption" ResourceString="Universal"/>
  <SymbolResourcePair Symbol="UniversalHint" ResourceString="Secures resources in a forest. Members must be in the same forest."/>
  <SymbolResourcePair Symbol="MembershipCaption" ResourceString="Member Selection"/>
  <SymbolResourcePair Symbol="NamesCaption" ResourceString="Manual"/>
  <SymbolResourcePair Symbol="NamesHint" ResourceString="Members are manually managed"/>
  <SymbolResourcePair Symbol="ManagerCaption" ResourceString="Manager-based"/>
  <SymbolResourcePair Symbol="ManagerHint" ResourceString="Membership is calculated to include a manager, and all people reporting directly to that manager"/>
  <SymbolResourcePair Symbol="CalculatedCaption" ResourceString="Criteria-based"/>
  <SymbolResourcePair Symbol="CalculatedHint" ResourceString="Membership is calculated based on one or more attributes of the members"/>
  <SymbolResourcePair Symbol="MembersTabCaption" ResourceString="Members"/>
  <SymbolResourcePair Symbol="MembersTabHelpText" ResourceString="More information"/>
  <SymbolResourcePair Symbol="CurrentMembershipCaption" ResourceString="Current Membership"/>
  <SymbolResourcePair Symbol="CurrentMembershipDescription" ResourceString="A read-only view of who is presently in this group."/>
  <SymbolResourcePair Symbol="MemberListEmptyResultText" ResourceString="This group has no members."/>
  <SymbolResourcePair Symbol="MembersToRemoveCaption" ResourceString="Members To Remove"/>
  <SymbolResourcePair Symbol="MembersToRemoveDescription" ResourceString="Choose who to remove from the current members."/>
  <SymbolResourcePair Symbol="MembersToAddCaption" ResourceString="Members To Add"/>
  <SymbolResourcePair Symbol="MembersToAddDescription" ResourceString="Choose new additions to the group."/>
  <SymbolResourcePair Symbol="MembersPopupListviewTitle" ResourceString="Select Members"/>
  <SymbolResourcePair Symbol="MembersToRemovePopupPreviewTitle" ResourceString="Members to be removed:"/>
  <SymbolResourcePair Symbol="MembersToAddPopupPreviewTitle" ResourceString="Members to be added:"/>
  <SymbolResourcePair Symbol="ManagerialMembershipDescription" ResourceString="Group members include the manager and all people reporting directly to the manager."/>
  <SymbolResourcePair Symbol="ManagerPopupListviewTitle" ResourceString="Select Manager"/>
  <SymbolResourcePair Symbol="ManagerPopupPreviewTitle" ResourceString="Manager:"/>
  <SymbolResourcePair Symbol="MemberSearchText" ResourceString="Find the members you want using the Search above."/>
  <SymbolResourcePair Symbol="ManagerSearchText" ResourceString="Find the manager you want using the Search above."/>
  <SymbolResourcePair Symbol="OwnerListListViewTitle" ResourceString="Select Owners"/>
  <SymbolResourcePair Symbol="OwnerListPreviewTitle" ResourceString="Owners:"/>
  <SymbolResourcePair Symbol="OwnerSearchText" ResourceString="Find the owners you want using the Search above."/>
  <SymbolResourcePair Symbol="DisplayedOwnerDescription" ResourceString="The group owner who will be displayed in Outlook or other systems which show only one owner for a group"/>  
  <SymbolResourcePair Symbol="DisplayedOwnerListViewTitle" ResourceString="Select Displayed Owner"/>
  <SymbolResourcePair Symbol="DisplayedOwnerPreviewTitle" ResourceString="Displayed owner:"/>  
  <SymbolResourcePair Symbol="DisplayedOwnerSearchText" ResourceString="Find the displayed owner you want using the Search above."/>
  <SymbolResourcePair Symbol="GroupingManagerialMembersManagerCaption" ResourceString="Manager"/>
  <SymbolResourcePair Symbol="GroupingCalculatedMembersTabCaptionTabCaption" ResourceString="Members"/>
  <SymbolResourcePair Symbol="GroupingCalculatedMembersTabHelpText" ResourceString="More information"/>
  <SymbolResourcePair Symbol="ViewMembers" ResourceString="View Members"/>
  <SymbolResourcePair Symbol="MemberCalculationTabCaption" ResourceString="Member Calculation"/>
  <SymbolResourcePair Symbol="CalculatedMemberCaption" ResourceString="Current Members"/>
  <SymbolResourcePair Symbol="CalculatedMemberListEmptyResultText" ResourceString="There are no members according to the filter definition."/>
  <SymbolResourcePair Symbol="InvalidMemberCaption" ResourceString="Invalid Members"/>
  <SymbolResourcePair Symbol="InvalidMemberHint" ResourceString="Current members who do not meet Active Directory criteria for membership in this group."/>
  <SymbolResourcePair Symbol="InvalidMemberListEmptyResultText" ResourceString="There are no invalid members."/>
  <SymbolResourcePair Symbol="JoiningCaption" ResourceString="Join Restriction"/>
  <SymbolResourcePair Symbol="OwnerApprovalCaption" ResourceString="Owner approval required"/>
  <SymbolResourcePair Symbol="OwnerApprovalHint" ResourceString="A user will become a member of the group only after the group owner has approved the join request."/>
  <SymbolResourcePair Symbol="NoneCaption" ResourceString="None"/>
  <SymbolResourcePair Symbol="NoneHint" ResourceString="Any user can become a member of the group."/>
  <SymbolResourcePair Symbol="OwnersTabCaption" ResourceString="Owners"/>
  <SymbolResourcePair Symbol="OwnersTabHelpText" ResourceString="More information"/>
  <SymbolResourcePair Symbol="SummaryTabCaption" ResourceString="Summary"/>
</SymbolResourcePairs>
'@
            TargetObjectType            = 'Group'
            Ensure						= 'Present'
        }
    } 
} 

TestObjectVisualizationConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestObjectVisualizationConfiguration" -Force
#endregion

#region: Update ObjectVisualizationConfiguration
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestObjectVisualizationConfiguration 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ObjectVisualizationConfiguration "TestObjectVisualizationConfiguration$randomNumber"
        {
            AppliesToCreate             = $false
            AppliesToEdit               = $true
            AppliesToView               = $false
            ConfigurationData           = @'
<my:ObjectControlConfiguration my:TypeName="UocGroupCodeBehind"
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xmlns:my="http://schemas.microsoft.com/2006/11/ResourceManagement"
 xmlns:xd="http://schemas.microsoft.com/office/infopath/2003">
  <my:ObjectDataSource my:TypeName="PrimaryResourceObjectDataSource" my:Name="object" my:Parameters=""/>
  <my:ObjectDataSource my:TypeName="ReferenceDeltaDataSource" my:Name="delta"/>
  <my:ObjectDataSource my:TypeName="SchemaDataSource" my:Name="schema"/>
  <my:ObjectDataSource my:TypeName="DomainDataSource" my:Name="domain" my:Parameters="%LoginDomain%"/>
  <my:ObjectDataSource my:TypeName="PrimaryResourceRightsDataSource" my:Name="rights"/>
  <my:XmlDataSource my:Name="summaryTransformXsl" my:Parameters="Microsoft.IdentityManagement.WebUI.Controls.Resources.DefaultSummary.xsl"/>
  <my:Panel my:Name="page" my:AutoValidate="true" my:Caption="Caption">
    <my:Grouping my:Name="Caption" my:IsHeader="true" my:Caption="caption" my:Visible="true">
      <my:Control my:Name="Caption" my:TypeName="UocCaptionControl" my:ExpandArea="true" my:Caption="" my:Description="{Binding Source=object, Path=DisplayName}">
        <my:Properties>
          <my:Property my:Name="MaxHeight" my:Value="32"/>
          <my:Property my:Name="MaxWidth" my:Value="32"/>
        </my:Properties>
      </my:Control>
    </my:Grouping>
    <my:Grouping my:Name="GroupingBasicInfo" my:Caption="%SYMBOL_BasicTabCaption_END%">
      <my:Help my:HelpText="%SYMBOL_BasicTabHelpText_END%" my:Link="03e258a0-609b-44f4-8417-4defdb6cb5e9.htm#bkmk_grouping_GroupingBasicInfo"/>
      <my:Control my:Name="Name" my:TypeName="UocTextBox" my:Caption="{Binding Source=schema, Path=DisplayName.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=DisplayName}" 
        my:Description="{Binding Source=schema, Path=DisplayName.Description}">
        <my:Properties>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="MaxLength" my:Value="128"/>
          <my:Property my:Name="Text" my:Value="{Binding Source=object, Path=DisplayName, Mode=TwoWay}"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="EmailEnabling" my:TypeName="UocCheckBox" my:Caption="%SYMBOL_EmailEnablingCaption_END%" my:Description="%SYMBOL_EmailEnablingDescription_END%" my:AutoPostback="true" my:RightsLevel="{Binding Source=rights, Path=Email}">
        <my:Properties>
          <my:Property my:Name="Text" my:Value="%SYMBOL_EmailEnablingValue_END%"/>
        </my:Properties>
        <my:Events>
          <my:Event my:Name="CheckedChanged" my:Handler="OnChangeEmailEnabling"/>
        </my:Events>
      </my:Control>
      <my:Control my:Name="Alias" my:TypeName="UocTextBox" my:Caption="{Binding Source=schema, Path=MailNickname.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=MailNickname}">
        <my:Properties>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="HintPath" my:Value="Hint"/>
          <my:Property my:Name="Text" my:Value="{Binding Source=object, Path=MailNickname, Mode=TwoWay}"/>
          <my:Property my:Name="MaxLength" my:Value="128"/>
          <my:Property my:Name="RegularExpression" my:Value="{Binding Source=schema, Path=MailNickname.StringRegex}"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="EmailAddress" my:TypeName="UocTextBox" my:Caption="{Binding Source=schema, Path=Email.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=Email}">
        <my:Properties>
          <my:Property my:Name="Text" my:Value="{Binding Source=object, Path=Email, Mode=OneWay}"/>
          <my:Property my:Name="ReadOnly" my:Value="true"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="Domain" my:TypeName="UocLabel" my:Caption="{Binding Source=schema, Path=Domain.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=Domain}">
        <my:Properties>
          <my:Property my:Name="Text" my:Value="{Binding Source=object, Path=Domain, Mode=OneWay}"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="AccountName" my:TypeName="UocTextBox" my:Caption="{Binding Source=schema, Path=AccountName.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=AccountName}">
        <my:Properties>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="Text" my:Value="{Binding Source=object, Path=AccountName, Mode=TwoWay}"/>
          <my:Property my:Name="MaxLength" my:Value="64"/>
          <my:Property my:Name="RegularExpression" my:Value="{Binding Source=schema, Path=AccountName.StringRegex}"/>
        </my:Properties>
        <my:Events>
          <my:Event my:Name="TextChanged" my:Handler="OnChangeAccount"/>
        </my:Events>
      </my:Control>
      <my:Control my:Name="Scope" my:TypeName="UocDropDownList" my:Caption="{Binding Source=schema, Path=Scope.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=Scope}">
        <my:Options>
          <my:Option my:Value="DomainLocal" my:Caption="%SYMBOL_DomainLocalCaption_END%" my:Hint="%SYMBOL_DomainLocalHint_END%"/>
          <my:Option my:Value="Global" my:Caption="%SYMBOL_GlobalCaption_END%" my:Hint="%SYMBOL_GlobalHint_END%"/>
          <my:Option my:Value="Universal" my:Caption="%SYMBOL_UniversalCaption_END%" my:Hint="%SYMBOL_UniversalHint_END%"/>
        </my:Options>
        <my:Properties>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="ValuePath" my:Value="Value"/>
          <my:Property my:Name="CaptionPath" my:Value="Caption"/>
          <my:Property my:Name="HintPath" my:Value="Hint"/>
          <my:Property my:Name="ItemSource" my:Value="Custom"/>
          <my:Property my:Name="SelectedValue" my:Value="{Binding Source=object, Path=Scope, Mode=TwoWay}"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="MembershipType" my:TypeName="UocRadioButtonList" my:Caption="%SYMBOL_MembershipCaption_END%" my:RightsLevel="{Binding Source=rights, Path=MembershipLocked}" my:AutoPostback="true">
        <my:Options>
          <my:Option my:Value="Static" my:Caption="%SYMBOL_NamesCaption_END%" my:Hint="%SYMBOL_NamesHint_END%"/>
          <my:Option my:Value="Manager" my:Caption="%SYMBOL_ManagerCaption_END%" my:Hint="%SYMBOL_ManagerHint_END%"/>
          <my:Option my:Value="Calculated" my:Caption="%SYMBOL_CalculatedCaption_END%" my:Hint="%SYMBOL_CalculatedHint_END%"/>
        </my:Options>
        <my:Properties>
          <my:Property my:Name="Required" my:Value="{Binding Source=schema, Path=MembershipLocked.Required}"/>
          <my:Property my:Name="ValuePath" my:Value="Value"/>
          <my:Property my:Name="CaptionPath" my:Value="Caption"/>
          <my:Property my:Name="HintPath" my:Value="Hint"/>
        </my:Properties>
        <my:Events>
          <my:Event my:Name="SelectedIndexChanged" my:Handler="OnChangeMembershipType"/>
        </my:Events>
      </my:Control>
      <my:Control my:Name="Description" my:TypeName="UocTextBox" my:Caption="{Binding Source=schema, Path=Description.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=Description}">
        <my:Properties>
          <my:Property my:Name="Required" my:Value="{Binding Source=schema, Path=DisplayName.Required}"/>
          <my:Property my:Name="Rows" my:Value="3"/>
          <my:Property my:Name="Columns" my:Value="60"/>
          <my:Property my:Name="MaxLength" my:Value="448"/>
          <my:Property my:Name="Text" my:Value="{Binding Source=object, Path=Description, Mode=TwoWay}"/>
        </my:Properties>
      </my:Control>
      <my:Events>
        <my:Event my:Name="BeforeLeave" my:Handler="OnLeaveBasicInfoGrouping"/>
      </my:Events>
    </my:Grouping>
    <my:Grouping my:Name="GroupingMembers" my:Caption="%SYMBOL_MembersTabCaption_END%">
      <my:Help my:HelpText="%SYMBOL_MembersTabHelpText_END%" my:Link="03e258a0-609b-44f4-8417-4defdb6cb5e9.htm#bkmk_grouping_GroupingMembers"/>
      <my:Control my:Name="MemberList" my:TypeName="UocListView" my:Caption="%SYMBOL_CurrentMembershipCaption_END%" my:Description="%SYMBOL_CurrentMembershipDescription_END%" my:RightsLevel="{Binding Source=rights, Path=ExplicitMember}">
        <my:Properties>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName,ObjectType"/>
          <my:Property my:Name="UsageKeywords" my:Value="%Attribute_Type%"/>
          <my:Property my:Name="TargetAttribute" my:Value="ExplicitMember"/>
          <my:Property my:Name="EmptyResultText" my:Value="%SYMBOL_MemberListEmptyResultText_END%"/>
          <my:Property my:Name="PageSize" my:Value="10"/>
          <my:Property my:Name="ShowTitleBar" my:Value="false"/>
          <my:Property my:Name="ShowActionBar" my:Value="false"/>
          <my:Property my:Name="ShowPreview" my:Value="false"/>
          <my:Property my:Name="ShowSearchControl" my:Value="false"/>
          <my:Property my:Name="EnableSelection" my:Value="false"/>
          <my:Property my:Name="SingleSelection" my:Value="false"/>
          <my:Property my:Name="ItemClickBehavior" my:Value="ModelessDialog"/>
          <my:Property my:Name="ReadOnly" my:Value="true"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="InvalidMemberListStatic" my:TypeName="UocListView" my:Caption="%SYMBOL_InvalidMemberCaption_END%" my:Description="%SYMBOL_InvalidMemberHint_END%" my:Visible="false">
        <my:Properties>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName,ObjectType"/>
          <my:Property my:Name="EmptyResultText" my:Value="%SYMBOL_InvalidMemberListEmptyResultText_END%"/>
          <my:Property my:Name="PageSize" my:Value="10"/>
          <my:Property my:Name="ShowTitleBar" my:Value="false"/>
          <my:Property my:Name="ShowActionBar" my:Value="false"/>
          <my:Property my:Name="ShowPreview" my:Value="false"/>
          <my:Property my:Name="ShowSearchControl" my:Value="false"/>
          <my:Property my:Name="EnableSelection" my:Value="false"/>
          <my:Property my:Name="SingleSelection" my:Value="false"/>
          <my:Property my:Name="ItemClickBehavior" my:Value="ModelessDialog"/>
          <my:Property my:Name="ReadOnly" my:Value="true"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="MemberToRemove" my:TypeName="UocIdentityPicker" my:Caption="%SYMBOL_MembersToRemoveCaption_END%" my:Description="%SYMBOL_MembersToRemoveDescription_END%" my:RightsLevel="{Binding Source=rights, Path=ExplicitMember}">
        <my:Properties>
          <my:Property my:Name="Mode" my:Value="MultipleResult"/>
          <my:Property my:Name="Rows" my:Value="3"/>
          <my:Property my:Name="ObjectTypes" my:Value="Person,Group"/>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName,ObjectType"/>
          <my:Property my:Name="AttributesToSearch" my:Value="DisplayName, AccountName"/>
          <my:Property my:Name="Value" my:Value="{Binding Source=delta, Path=ExplicitMember.Remove, Mode=TwoWay}"/>
          <my:Property my:Name="Filter" my:Value="/Group[ObjectID='%ObjectID%']/ExplicitMember"/>
          <my:Property my:Name="ListViewTitle" my:Value="%SYMBOL_MembersPopupListviewTitle_END%"/>
          <my:Property my:Name="PreviewTitle" my:Value="%SYMBOL_MembersToRemovePopupPreviewTitle_END%"/>
          <my:Property my:Name="SearchOnLoad" my:Value="true"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="MemberToAdd" my:TypeName="UocIdentityPicker" my:Caption="%SYMBOL_MembersToAddCaption_END%" my:Description="%SYMBOL_MembersToAddDescription_END%" my:RightsLevel="{Binding Source=rights, Path=ExplicitMember}">
        <my:Properties>
          <my:Property my:Name="Mode" my:Value="MultipleResult"/>
          <my:Property my:Name="Rows" my:Value="3"/>
          <my:Property my:Name="ObjectTypes" my:Value="Person,Group"/>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName, AccountName"/>
          <my:Property my:Name="AttributesToSearch" my:Value="DisplayName, AccountName"/>
          <my:Property my:Name="Value" my:Value="{Binding Source=delta, Path=ExplicitMember.Add, Mode=TwoWay}"/>
          <my:Property my:Name="UsageKeywords" my:Value="%Attribute_Type%"/>
          <my:Property my:Name="ResultObjectType" my:Value="Resource"/>
          <my:Property my:Name="ListViewTitle" my:Value="%SYMBOL_MembersPopupListviewTitle_END%"/>
          <my:Property my:Name="PreviewTitle" my:Value="%SYMBOL_MembersToAddPopupPreviewTitle_END%"/>
          <my:Property my:Name="MainSearchScreenText" my:Value="%SYMBOL_MemberSearchText_END%"/>
        </my:Properties>
      </my:Control>
      <my:Events>
        <my:Event my:Name="AfterEnter" my:Handler="OnEnterMembersGrouping"/>
      </my:Events>
    </my:Grouping>
    <my:Grouping my:Name="GroupingCalculatedMembers" my:Caption="%SYMBOL_GroupingCalculatedMembersTabCaptionTabCaption_END%">
      <my:Help my:HelpText="%SYMBOL_GroupingCalculatedMembersTabHelpText_END%" my:Link="03e258a0-609b-44f4-8417-4defdb6cb5e9.htm#bkmk_grouping_GroupingMembers"/>
      <my:Control my:Name="ManagerialMembershipDescription" my:TypeName="UocTextBox" my:Visible="false">
        <my:Properties>
          <my:Property my:Name="Text" my:Value="%SYMBOL_ManagerialMembershipDescription_END%" /> 
        </my:Properties>
      </my:Control>
      <my:Control my:Name="Manager" my:TypeName="UocIdentityPicker" my:Caption="%SYMBOL_GroupingManagerialMembersManagerCaption_END%" my:RightsLevel="{Binding Source=rights, Path=Filter}">
        <my:Properties>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="ObjectTypes" my:Value="Person"/>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName, MailNickname, Manager"/>
          <my:Property my:Name="AttributesToSearch" my:Value="DisplayName, MailNickname"/>
          <my:Property my:Name="UsageKeywords" my:Value="Person"/>
          <my:Property my:Name="ResultObjectType" my:Value="Person"/>
          <my:Property my:Name="ListViewTitle" my:Value="%SYMBOL_ManagerPopupListviewTitle_END%"/>
          <my:Property my:Name="PreviewTitle" my:Value="%SYMBOL_ManagerPopupPreviewTitle_END%"/>
          <my:Property my:Name="MainSearchScreenText" my:Value="%SYMBOL_ManagerSearchText_END%"/>
        </my:Properties>
        <my:Events>
          <my:Event my:Name="SelectedObjectChanged" my:Handler="OnChangeManagerialMembership"/>
        </my:Events>
      </my:Control>
      <my:Control my:Name="FilterBuilder" my:TypeName="UocFilterBuilder" my:RightsLevel="{Binding Source=rights, Path=Filter}" my:ExpandArea="true">
        <my:Properties>
          <my:Property my:Name="PermittedObjectTypes" my:Value="Person,Group"/>
          <my:Property my:Name="Value" my:Value="{Binding Source=object, Path=Filter, Mode=TwoWay}"/>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="PreviewButtonVisible" my:Value="false"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="Preview" my:TypeName="UocButton" my:ExpandArea="true">
        <my:Properties>
          <my:Property my:Name="Text" my:Value="%SYMBOL_ViewMembers_END%"/>
        </my:Properties>
        <my:Events>
          <my:Event my:Name="Click" my:Handler="OnClickPreview"/>
        </my:Events>
      </my:Control>
      <my:Control my:Name="ComputedMemberList" my:TypeName="UocListView" my:Caption="%SYMBOL_CalculatedMemberCaption_END%" my:ExpandArea="true">
        <my:Properties>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName,ObjectType"/>
          <my:Property my:Name="EmptyResultText" my:Value="%SYMBOL_CalculatedMemberListEmptyResultText_END%"/>
          <my:Property my:Name="PageSize" my:Value="10"/>
          <my:Property my:Name="ShowTitleBar" my:Value="false"/>
          <my:Property my:Name="ShowActionBar" my:Value="false"/>
          <my:Property my:Name="ShowPreview" my:Value="false"/>
          <my:Property my:Name="ShowSearchControl" my:Value="false"/>
          <my:Property my:Name="EnableSelection" my:Value="false"/>
          <my:Property my:Name="SingleSelection" my:Value="false"/>
          <my:Property my:Name="ItemClickBehavior" my:Value="ModelessDialog"/>
          <my:Property my:Name="ReadOnly" my:Value="true"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="InvalidMemberListDynamic" my:TypeName="UocListView" my:Caption="%SYMBOL_InvalidMemberCaption_END%" my:Description="%SYMBOL_InvalidMemberHint_END%" my:ExpandArea="true" my:Visible="false">
        <my:Properties>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName,ObjectType"/>
          <my:Property my:Name="EmptyResultText" my:Value="%SYMBOL_InvalidMemberListEmptyResultText_END%"/>
          <my:Property my:Name="PageSize" my:Value="10"/>
          <my:Property my:Name="ShowTitleBar" my:Value="True"/>
          <my:Property my:Name="ShowActionBar" my:Value="false"/>
          <my:Property my:Name="ShowPreview" my:Value="false"/>
          <my:Property my:Name="ShowSearchControl" my:Value="false"/>
          <my:Property my:Name="EnableSelection" my:Value="false"/>
          <my:Property my:Name="SingleSelection" my:Value="false"/>
          <my:Property my:Name="ItemClickBehavior" my:Value="ModelessDialog"/>
          <my:Property my:Name="ReadOnly" my:Value="true"/>
        </my:Properties>
      </my:Control>
      <my:Events>
        <my:Event my:Name="AfterEnter" my:Handler="OnEnterMembersGrouping"/>
        <my:Event my:Name="BeforeLeave" my:Handler="OnLeaveMembersGrouping"/>
      </my:Events>
    </my:Grouping>
    <my:Grouping my:Name="GroupingOwners" my:Caption="%SYMBOL_OwnersTabCaption_END%">
      <my:Help my:HelpText="%SYMBOL_OwnersTabHelpText_END%" my:Link="03e258a0-609b-44f4-8417-4defdb6cb5e9.htm#bkmk_grouping_GroupingOwners"/>
      <my:Control my:Name="OwnerList" my:TypeName="UocIdentityPicker" my:Caption="{Binding Source=schema, Path=Owner.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=Owner}">
        <my:Properties>
          <my:Property my:Name="Mode" my:Value="MultipleResult"/>
          <my:Property my:Name="Rows" my:Value="3"/>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="ObjectTypes" my:Value="Person"/>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName, AccountName, Department"/>
          <my:Property my:Name="AttributesToSearch" my:Value="DisplayName, AccountName"/>
          <my:Property my:Name="Value" my:Value="{Binding Source=object, Path=Owner, Mode=TwoWay}"/>
          <my:Property my:Name="UsageKeywords" my:Value="Person"/>
          <my:Property my:Name="ResultObjectType" my:Value="Person"/>
          <my:Property my:Name="ListViewTitle" my:Value="%SYMBOL_OwnerListListViewTitle_END%"/>
          <my:Property my:Name="PreviewTitle" my:Value="%SYMBOL_OwnerListPreviewTitle_END%"/>
          <my:Property my:Name="MainSearchScreenText" my:Value="%SYMBOL_OwnerSearchText_END%"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="DisplayedOwner" my:TypeName="UocIdentityPicker" my:Caption="{Binding Source=schema, Path=DisplayedOwner.DisplayName}" my:RightsLevel="{Binding Source=rights, Path=DisplayedOwner}" my:Description="%SYMBOL_DisplayedOwnerDescription_END%">
        <my:Properties>
          <my:Property my:Name="Required" my:Value="true"/>
          <my:Property my:Name="ObjectTypes" my:Value="Person"/>
          <my:Property my:Name="ColumnsToDisplay" my:Value="DisplayName, AccountName, Department"/>
          <my:Property my:Name="AttributesToSearch" my:Value="DisplayName, AccountName"/>
          <my:Property my:Name="Value" my:Value="{Binding Source=object, Path=DisplayedOwner, Mode=TwoWay}"/>
          <my:Property my:Name="UsageKeywords" my:Value="Person"/>
          <my:Property my:Name="ResultObjectType" my:Value="Person"/>
          <my:Property my:Name="ListViewTitle" my:Value="%SYMBOL_DisplayedOwnerListViewTitle_END%"/>
          <my:Property my:Name="PreviewTitle" my:Value="%SYMBOL_DisplayedOwnerPreviewTitle_END%"/>
          <my:Property my:Name="MainSearchScreenText" my:Value="%SYMBOL_DisplayedOwnerSearchText_END%"/>
        </my:Properties>
      </my:Control>
      <my:Control my:Name="Join" my:TypeName="UocRadioButtonList" my:Caption="%SYMBOL_JoiningCaption_END%" my:RightsLevel="{Binding Source=rights, Path=MembershipAddWorkflow}">
        <my:Options>
          <my:Option my:Value="Owner Approval" my:Caption="%SYMBOL_OwnerApprovalCaption_END%" my:Hint="%SYMBOL_OwnerApprovalHint_END%"/>
          <my:Option my:Value="None" my:Caption="%SYMBOL_NoneCaption_END%" my:Hint="%SYMBOL_NoneHint_END%"/>
        </my:Options>
        <my:Properties>
          <my:Property my:Name="Required" my:Value="{Binding Source=schema, Path=MembershipAddWorkflow.Required}"/>
          <my:Property my:Name="ValuePath" my:Value="Value"/>
          <my:Property my:Name="CaptionPath" my:Value="Caption"/>
          <my:Property my:Name="HintPath" my:Value="Hint"/>
          <my:Property my:Name="ItemSource" my:Value="Custom"/>
          <my:Property my:Name="SelectedValue" my:Value="{Binding Source=object, Path=MembershipAddWorkflow, Mode=TwoWay}"/>
        </my:Properties>
        <my:Events>
          <my:Event my:Name="SelectedIndexChanged" my:Handler="OnChangeMembershipWorkflow"/>
        </my:Events>
      </my:Control>
      <my:Events>
        <my:Event my:Name="BeforeLeave" my:Handler="OnLeaveOwnersGrouping"/>
      </my:Events>
    </my:Grouping>
    <my:Grouping my:Name="GroupingSummary" my:Caption="%SYMBOL_SummaryTabCaption_END%" my:IsSummary="true">
      <my:Control my:Name="SummaryControl" my:TypeName="UocHtmlSummary" my:ExpandArea="true">
        <my:Properties>
          <my:Property my:Name="ModificationsXml" my:Value="{Binding Source=delta, Path=DeltaXml}"/>
          <my:Property my:Name="TransformXsl" my:Value="{Binding Source=summaryTransformXsl, Path=/}"/>
        </my:Properties>
      </my:Control>
    </my:Grouping>
  </my:Panel>
  <my:Events>
    <my:Event my:Name="Load" my:Handler="OnLoad"/>
  </my:Events>
</my:ObjectControlConfiguration>
'@
            DisplayName                 = "TestObjectVisualizationConfiguration$randomNumber"
            IsConfigurationType         = $false
            StringResources             = @'
<SymbolResourcePairs>
  <SymbolResourcePair Symbol="BasicTabCaption" ResourceString="General"/>
  <SymbolResourcePair Symbol="BasicTabHelpText" ResourceString="More information"/>
  <SymbolResourcePair Symbol="EmailEnablingCaption" ResourceString="E-mail Enabled"/>
  <SymbolResourcePair Symbol="EmailEnablingDescription" ResourceString="Enable e-mail on a security group"/>
  <SymbolResourcePair Symbol="EmailEnablingValue" ResourceString="Enabled"/>
  <SymbolResourcePair Symbol="DomainLocalCaption" ResourceString="Domain Local"/>
  <SymbolResourcePair Symbol="DomainLocalHint" ResourceString="Secures resources in a domain.  Members can be in any trusted forest."/>
  <SymbolResourcePair Symbol="GlobalCaption" ResourceString="Global"/>
  <SymbolResourcePair Symbol="GlobalHint" ResourceString="Secures resources in a domain. Members must be in the same domain."/>
  <SymbolResourcePair Symbol="UniversalCaption" ResourceString="Universal"/>
  <SymbolResourcePair Symbol="UniversalHint" ResourceString="Secures resources in a forest. Members must be in the same forest."/>
  <SymbolResourcePair Symbol="MembershipCaption" ResourceString="Member Selection"/>
  <SymbolResourcePair Symbol="NamesCaption" ResourceString="Manual"/>
  <SymbolResourcePair Symbol="NamesHint" ResourceString="Members are manually managed"/>
  <SymbolResourcePair Symbol="ManagerCaption" ResourceString="Manager-based"/>
  <SymbolResourcePair Symbol="ManagerHint" ResourceString="Membership is calculated to include a manager, and all people reporting directly to that manager"/>
  <SymbolResourcePair Symbol="CalculatedCaption" ResourceString="Criteria-based"/>
  <SymbolResourcePair Symbol="CalculatedHint" ResourceString="Membership is calculated based on one or more attributes of the members"/>
  <SymbolResourcePair Symbol="MembersTabCaption" ResourceString="Members"/>
  <SymbolResourcePair Symbol="MembersTabHelpText" ResourceString="More information"/>
  <SymbolResourcePair Symbol="CurrentMembershipCaption" ResourceString="Current Membership"/>
  <SymbolResourcePair Symbol="CurrentMembershipDescription" ResourceString="A read-only view of who is presently in this group."/>
  <SymbolResourcePair Symbol="MemberListEmptyResultText" ResourceString="This group has no members."/>
  <SymbolResourcePair Symbol="MembersToRemoveCaption" ResourceString="Members To Remove"/>
  <SymbolResourcePair Symbol="MembersToRemoveDescription" ResourceString="Choose who to remove from the current members."/>
  <SymbolResourcePair Symbol="MembersToAddCaption" ResourceString="Members To Add"/>
  <SymbolResourcePair Symbol="MembersToAddDescription" ResourceString="Choose new additions to the group."/>
  <SymbolResourcePair Symbol="MembersPopupListviewTitle" ResourceString="Select Members"/>
  <SymbolResourcePair Symbol="MembersToRemovePopupPreviewTitle" ResourceString="Members to be removed:"/>
  <SymbolResourcePair Symbol="MembersToAddPopupPreviewTitle" ResourceString="Members to be added:"/>
  <SymbolResourcePair Symbol="ManagerialMembershipDescription" ResourceString="Group members include the manager and all people reporting directly to the manager."/>
  <SymbolResourcePair Symbol="ManagerPopupListviewTitle" ResourceString="Select Manager"/>
  <SymbolResourcePair Symbol="ManagerPopupPreviewTitle" ResourceString="Manager:"/>
  <SymbolResourcePair Symbol="MemberSearchText" ResourceString="Find the members you want using the Search above."/>
  <SymbolResourcePair Symbol="ManagerSearchText" ResourceString="Find the manager you want using the Search above."/>
  <SymbolResourcePair Symbol="OwnerListListViewTitle" ResourceString="Select Owners"/>
  <SymbolResourcePair Symbol="OwnerListPreviewTitle" ResourceString="Owners:"/>
  <SymbolResourcePair Symbol="OwnerSearchText" ResourceString="Find the owners you want using the Search above."/>
  <SymbolResourcePair Symbol="DisplayedOwnerDescription" ResourceString="The group owner who will be displayed in Outlook or other systems which show only one owner for a group"/>  
  <SymbolResourcePair Symbol="DisplayedOwnerListViewTitle" ResourceString="Select Displayed Owner"/>
  <SymbolResourcePair Symbol="DisplayedOwnerPreviewTitle" ResourceString="Displayed owner:"/>  
  <SymbolResourcePair Symbol="DisplayedOwnerSearchText" ResourceString="Find the displayed owner you want using the Search above."/>
  <SymbolResourcePair Symbol="GroupingManagerialMembersManagerCaption" ResourceString="Manager"/>
  <SymbolResourcePair Symbol="GroupingCalculatedMembersTabCaptionTabCaption" ResourceString="Members"/>
  <SymbolResourcePair Symbol="GroupingCalculatedMembersTabHelpText" ResourceString="More information"/>
  <SymbolResourcePair Symbol="ViewMembers" ResourceString="View Members"/>
  <SymbolResourcePair Symbol="MemberCalculationTabCaption" ResourceString="Member Calculation"/>
  <SymbolResourcePair Symbol="CalculatedMemberCaption" ResourceString="Current Members"/>
  <SymbolResourcePair Symbol="CalculatedMemberListEmptyResultText" ResourceString="There are no members according to the filter definition."/>
  <SymbolResourcePair Symbol="InvalidMemberCaption" ResourceString="Invalid Members"/>
  <SymbolResourcePair Symbol="InvalidMemberHint" ResourceString="Current members who do not meet Active Directory criteria for membership in this group."/>
  <SymbolResourcePair Symbol="InvalidMemberListEmptyResultText" ResourceString="There are no invalid members."/>
  <SymbolResourcePair Symbol="JoiningCaption" ResourceString="Join Restriction"/>
  <SymbolResourcePair Symbol="OwnerApprovalCaption" ResourceString="Owner approval required"/>
  <SymbolResourcePair Symbol="OwnerApprovalHint" ResourceString="A user will become a member of the group only after the group owner has approved the join request."/>
  <SymbolResourcePair Symbol="NoneCaption" ResourceString="None"/>
  <SymbolResourcePair Symbol="NoneHint" ResourceString="Any user can become a member of the group."/>
  <SymbolResourcePair Symbol="OwnersTabCaption" ResourceString="Owners"/>
  <SymbolResourcePair Symbol="OwnersTabHelpText" ResourceString="More information"/>
  <SymbolResourcePair Symbol="SummaryTabCaption" ResourceString="Summary"/>
</SymbolResourcePairs>
'@
            TargetObjectType            = 'Group'
            Ensure						= 'Present'
        }
    } 
} 

TestObjectVisualizationConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestObjectVisualizationConfiguration" -Force

Configuration TestObjectVisualizationConfiguration 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ObjectVisualizationConfiguration "TestObjectVisualizationConfiguration$randomNumber"
        {
            AppliesToCreate             = $false
            AppliesToEdit               = $true
            AppliesToView               = $false
            ConfigurationData           = @'
<my:ObjectControlConfiguration my:TypeName="UocGroupCodeBehind"
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xmlns:my="http://schemas.microsoft.com/2006/11/ResourceManagement"
 xmlns:xd="http://schemas.microsoft.com/office/infopath/2003">
  <my:ObjectDataSource my:TypeName="PrimaryResourceObjectDataSource" my:Name="object" my:Parameters=""/>
  <my:ObjectDataSource my:TypeName="ReferenceDeltaDataSource" my:Name="delta"/>
  <my:ObjectDataSource my:TypeName="SchemaDataSource" my:Name="schema"/>
  <my:ObjectDataSource my:TypeName="DomainDataSource" my:Name="domain" my:Parameters="%LoginDomain%"/>
  <my:ObjectDataSource my:TypeName="PrimaryResourceRightsDataSource" my:Name="rights"/>
  <my:XmlDataSource my:Name="summaryTransformXsl" my:Parameters="Microsoft.IdentityManagement.WebUI.Controls.Resources.DefaultSummary.xsl"/>
  <my:Panel my:Name="page" my:AutoValidate="true" my:Caption="Caption">
    <my:Grouping my:Name="Caption" my:IsHeader="true" my:Caption="caption" my:Visible="true">
      <my:Control my:Name="Caption" my:TypeName="UocCaptionControl" my:ExpandArea="true" my:Caption="" my:Description="{Binding Source=object, Path=DisplayName}">
        <my:Properties>
          <my:Property my:Name="MaxHeight" my:Value="32"/>
          <my:Property my:Name="MaxWidth" my:Value="32"/>
        </my:Properties>
      </my:Control>
    </my:Grouping>
    <my:Grouping my:Name="GroupingSummary" my:Caption="%SYMBOL_SummaryTabCaption_END%" my:IsSummary="true">
      <my:Control my:Name="SummaryControl" my:TypeName="UocHtmlSummary" my:ExpandArea="true">
        <my:Properties>
          <my:Property my:Name="ModificationsXml" my:Value="{Binding Source=delta, Path=DeltaXml}"/>
          <my:Property my:Name="TransformXsl" my:Value="{Binding Source=summaryTransformXsl, Path=/}"/>
        </my:Properties>
      </my:Control>
    </my:Grouping>
  </my:Panel>
  <my:Events>
    <my:Event my:Name="Load" my:Handler="OnLoad"/>
  </my:Events>
</my:ObjectControlConfiguration>
'@
            DisplayName                 = "TestObjectVisualizationConfiguration$randomNumber"
            IsConfigurationType         = $false
            StringResources             = @'
<SymbolResourcePairs>
  <SymbolResourcePair Symbol="BasicTabCaption" ResourceString="General"/>
  <SymbolResourcePair Symbol="BasicTabHelpText" ResourceString="More information"/>
</SymbolResourcePairs>
'@
            TargetObjectType            = 'Group'
            Ensure						= 'Present'
        }
    } 
} 

TestObjectVisualizationConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestObjectVisualizationConfiguration" -Force
#endregion

#region: Delete ObjectVisualizationConfiguration
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestObjectVisualizationConfiguration 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ObjectVisualizationConfiguration "TestObjectVisualizationConfiguration$randomNumber"
        {
             AppliesToCreate             = $false
            AppliesToEdit               = $true
            AppliesToView               = $false
            ConfigurationData           = @'
<my:ObjectControlConfiguration my:TypeName="UocGroupCodeBehind"
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xmlns:my="http://schemas.microsoft.com/2006/11/ResourceManagement"
 xmlns:xd="http://schemas.microsoft.com/office/infopath/2003">
  <my:ObjectDataSource my:TypeName="PrimaryResourceObjectDataSource" my:Name="object" my:Parameters=""/>
  <my:ObjectDataSource my:TypeName="ReferenceDeltaDataSource" my:Name="delta"/>
  <my:ObjectDataSource my:TypeName="SchemaDataSource" my:Name="schema"/>
  <my:ObjectDataSource my:TypeName="DomainDataSource" my:Name="domain" my:Parameters="%LoginDomain%"/>
  <my:ObjectDataSource my:TypeName="PrimaryResourceRightsDataSource" my:Name="rights"/>
  <my:XmlDataSource my:Name="summaryTransformXsl" my:Parameters="Microsoft.IdentityManagement.WebUI.Controls.Resources.DefaultSummary.xsl"/>
  <my:Panel my:Name="page" my:AutoValidate="true" my:Caption="Caption">
    <my:Grouping my:Name="Caption" my:IsHeader="true" my:Caption="caption" my:Visible="true">
      <my:Control my:Name="Caption" my:TypeName="UocCaptionControl" my:ExpandArea="true" my:Caption="" my:Description="{Binding Source=object, Path=DisplayName}">
        <my:Properties>
          <my:Property my:Name="MaxHeight" my:Value="32"/>
          <my:Property my:Name="MaxWidth" my:Value="32"/>
        </my:Properties>
      </my:Control>
    </my:Grouping>
    <my:Grouping my:Name="GroupingSummary" my:Caption="%SYMBOL_SummaryTabCaption_END%" my:IsSummary="true">
      <my:Control my:Name="SummaryControl" my:TypeName="UocHtmlSummary" my:ExpandArea="true">
        <my:Properties>
          <my:Property my:Name="ModificationsXml" my:Value="{Binding Source=delta, Path=DeltaXml}"/>
          <my:Property my:Name="TransformXsl" my:Value="{Binding Source=summaryTransformXsl, Path=/}"/>
        </my:Properties>
      </my:Control>
    </my:Grouping>
  </my:Panel>
  <my:Events>
    <my:Event my:Name="Load" my:Handler="OnLoad"/>
  </my:Events>
</my:ObjectControlConfiguration>
'@
            DisplayName                 = "TestObjectVisualizationConfiguration$randomNumber"
            IsConfigurationType         = $false
            StringResources             = @'
<SymbolResourcePairs>
  <SymbolResourcePair Symbol="BasicTabCaption" ResourceString="General"/>
  <SymbolResourcePair Symbol="BasicTabHelpText" ResourceString="More information"/>
</SymbolResourcePairs>
'@
            TargetObjectType            = 'Group'
            Ensure						= 'Present'
        }
    } 
} 

TestObjectVisualizationConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestObjectVisualizationConfiguration" -Force

Configuration TestObjectVisualizationConfiguration 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        ObjectVisualizationConfiguration "TestObjectVisualizationConfiguration$randomNumber"
        {
            AppliesToCreate             = $false
            AppliesToEdit               = $true
            AppliesToView               = $false
            ConfigurationData           = @'
<my:ObjectControlConfiguration my:TypeName="UocGroupCodeBehind"
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xmlns:my="http://schemas.microsoft.com/2006/11/ResourceManagement"
 xmlns:xd="http://schemas.microsoft.com/office/infopath/2003">
  <my:ObjectDataSource my:TypeName="PrimaryResourceObjectDataSource" my:Name="object" my:Parameters=""/>
  <my:ObjectDataSource my:TypeName="ReferenceDeltaDataSource" my:Name="delta"/>
  <my:ObjectDataSource my:TypeName="SchemaDataSource" my:Name="schema"/>
  <my:ObjectDataSource my:TypeName="DomainDataSource" my:Name="domain" my:Parameters="%LoginDomain%"/>
  <my:ObjectDataSource my:TypeName="PrimaryResourceRightsDataSource" my:Name="rights"/>
  <my:XmlDataSource my:Name="summaryTransformXsl" my:Parameters="Microsoft.IdentityManagement.WebUI.Controls.Resources.DefaultSummary.xsl"/>
  <my:Panel my:Name="page" my:AutoValidate="true" my:Caption="Caption">
    <my:Grouping my:Name="Caption" my:IsHeader="true" my:Caption="caption" my:Visible="true">
      <my:Control my:Name="Caption" my:TypeName="UocCaptionControl" my:ExpandArea="true" my:Caption="" my:Description="{Binding Source=object, Path=DisplayName}">
        <my:Properties>
          <my:Property my:Name="MaxHeight" my:Value="32"/>
          <my:Property my:Name="MaxWidth" my:Value="32"/>
        </my:Properties>
      </my:Control>
    </my:Grouping>
    <my:Grouping my:Name="GroupingSummary" my:Caption="%SYMBOL_SummaryTabCaption_END%" my:IsSummary="true">
      <my:Control my:Name="SummaryControl" my:TypeName="UocHtmlSummary" my:ExpandArea="true">
        <my:Properties>
          <my:Property my:Name="ModificationsXml" my:Value="{Binding Source=delta, Path=DeltaXml}"/>
          <my:Property my:Name="TransformXsl" my:Value="{Binding Source=summaryTransformXsl, Path=/}"/>
        </my:Properties>
      </my:Control>
    </my:Grouping>
  </my:Panel>
  <my:Events>
    <my:Event my:Name="Load" my:Handler="OnLoad"/>
  </my:Events>
</my:ObjectControlConfiguration>
'@
            DisplayName                 = "TestObjectVisualizationConfiguration$randomNumber"
            IsConfigurationType         = $false
            StringResources             = @'
<SymbolResourcePairs>
  <SymbolResourcePair Symbol="BasicTabCaption" ResourceString="General"/>
  <SymbolResourcePair Symbol="BasicTabHelpText" ResourceString="More information"/>
</SymbolResourcePairs>
'@
            TargetObjectType            = 'Group'
            Ensure						= 'Absent'
        }
    } 
} 

TestObjectVisualizationConfiguration

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestObjectVisualizationConfiguration" -Force
#endregion