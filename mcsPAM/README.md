# Introduction 
The purpose of this project is to automate the deployment of the Microsoft Consulting Services (**MCS**) Microsoft Identity Manager (**MIM**) Privilege Access Management (**PAM**) Managed Intellectual Property (**MIP**) offering into Azure for both Infrastructure as as Service (**IAAS**) and Platforms as a Service (**PAAS**).

# Getting Started
The MCS PAM offering current release can be found on [Services Portfolio](http://aka.ms/portfolio-pam) for the pre-sales materials and on [Campus](https://aka.ms/pamipkit) for the IP Kit.

This repository includes only the technical assets required to deploy the MCS PAM Offering. We have set up a [Documentation Repository](https://aka.ms/pamdocs) for instructions, presentations and other non-technical artifacts. The Azure Board in this repository will include work items tied to non-technical artifacts but the **Documentation Repository** will contain those changes.

The only non-technical artifact that spans both repositories is the Delivery Customization Variables xlsm file which contains document properties as well as infrastructure details. Be sure this file is up to date before generating documents or running deployment scripts.

The Azure Integration will produce this spreadsheet from an Azure DevOps [Variable Group](https://docs.microsoft.com/azure/devops/pipelines/library/variable-groups) for use during the build and deployment process as well as during documentation creation.

TODO: Guide users through getting your code up and running on their own system. In this section you can talk about:
1.	Installation process
2.	Software dependencies
3.	Latest releases
4.	API references

# Architecture Design
The MIM PAM Offering relies on the [Design and Implement Active Direcotry](http://aka.ms/portfolio-diad) (**DIAD**) solution to deploy an Active Directory to host both the Corporate (Production) and Privilege (PAM) forests. The MIM PAM solution does not modify DIAD and leverages the lastest public release of that solution.

This solution includes four architectures, Tiny, Small, Medium and Large. Each architecture includes all required services for the MIM PAM solution but High Availability (**HA**) and Disaster Recovery (**DR**) configurations change with each architecture.

|Architecture|HA|DR|Resource Groups|Design
|------------|--|--|--------------|------
|Tiny|MIM Installed on the Domain Controller|None|1 (Corp and Priv)|![Tiny Design](Graphics/TinyDesign.jpg)
|Small|MIM on its own server|None|2 (Corp; Priv)|![Small Design](Graphics/SmallDesign.jpg)
|Medium|MIM on different servers for Web\App\DB|None|3(Corp; Priv Domain; Priv MIM PAM) |![Medium Design](Graphics/MediumDesign.jpg)
|Large|MIM on different servers for Web\App\DB|Load balanced Web, Active\Passive Sync, Clustered DB|6 (Corp; Priv Domain; Priv DB; Priv App; Priv Web|![Large Design](Graphics/LargeDesign.jpg)

# Azure Integration
The MCS PAM solution leverages Azure as a baseline for deploying the solution. This section describes the Azure IAAS and PAAS integrations. Customers who deploy this soultion should have a basic understanding of these components.

## Azure Infrastructure as a Service

**TODO:** Add all Azure IAAS services used in the solution

### Storage
**TODO:** Complete this Storage section

### Network
**TODO:** Complete this Network section

### Compute
**TODO:** Complete this Compute section

## Azure Platform as a Service

### DNS
**TODO:** Complete this DNS section

### Application Gateway
**TODO:** Complete this Application Gateway section

### Managed Applications
**TODO:** Complete this Managed Applications section

### Key Vault
**TODO:** Complete this Key Vault section

### Load Balancer
**TODO:** Complete this Load Balancer section

### Monitor
**TODO:** Complete this Monitor section

#Automated Deployment
The MIM PAM Azure Integration automatically deploys the Azure IAAS and PAAS services and the MIM infrastructure required for the PAM Offering.

##Automated Infrastructure as a Service
The Azure IAAS deployment heavily relies on Azure Resource Manager (**ARM**) tempaltes to deploy the resources necessary for the MIM PAM Solution. This deployment assumes three ARM Resource Groups:
-Production Domain
-Privilege Domain
-MIM PAM Soxlution

See the [IAAS artifacts](IAAS/README.md) in the solution for more details.

##Automated Platforms as a Service
MIM PAM relies on a few Azure Platforms as a Service providers. Each of these providers gets set up automatically. The MIM PAM solution also configures these services to (whenever possible) comply with a least privilege model.

See the [PAAS artifacts](PAAS/README.md) in the solution for more details.

##Automated Microsoft Consulting Services Privilege Access Managment
MIM PAM includes some automation scripts for deploying the solution out of the box. The MCS PAM solution tailors those scripts to follow Least Privileged best practices. The Azure integration of MIM PAM will include the configuration of MIM PAM in the deployed IAAS and PAAS enviornments.

# Build and Test
TODO: Describe and show how to build your code and run the tests. 

# Contribute
TODO: Explain how other users and developers can contribute to make your code better. 

If you want to learn more about creating good readme files then refer the following [guidelines](https://www.visualstudio.com/en-us/docs/git/create-a-readme). You can also seek inspiration from the below readme files:
- [ASP.NET Core](https://github.com/aspnet/Home)
- [Visual Studio Code](https://github.com/Microsoft/vscode)
- [Chakra Core](https://github.com/Microsoft/ChakraCore) 
