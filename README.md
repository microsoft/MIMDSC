# DSC Module for MIM
MIMDSC is a PowerShell Desired State Configuration (DSC) module for Microsoft Identity Manager (MIM).
MIM is a powerful on-premises solution for identity integration.  Great power can result in great complexity, and keeping a MIM deployment in a known state can be challenging.  PowerShell DSC provides an elegant separation of state (the what) from ensuring that state (the how), resulting in a system of:
* Configuration - declarations of what the system should look like
* Resources - code that is able to transition the system to the desired state
The MIMDSC module contains DSC resources for MIM Service and MIM Synchronization Service.  

## MIM Service and Portal
The DSC resources for MIM Service and Portal depend on the MIM PowerShell snap-in, so can read and write any configuration item exposed through that snap-in.

## MIM Synchronization Service
The DSC resources for MIM Synchronization Service depend on the miisexport.exe utility, so can only read configuration items and report on items that are not in the desired state.

# Supported Product Versions
The DSC resources in this module should work with FIM on Windows Server 2012 R2 but so far are only tested on:
* MIM 2016
* Windows Server 2016
* SQL Server 2016
* SharePoint ???

# Support
The MIMDSC module is not part of the MIM product, and is supported similar to the MIMWAL project.

# Contributing to MIMDSC
This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
