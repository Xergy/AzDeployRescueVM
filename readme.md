# Deploy Azure Rescue VM 

## Overview
This is a simple script that deploys a Azure Marketplace VM configured for Hyper-V nested virtualization for the purpose of quickly recovering a faulty VM that will not boot.

## Details

- See the below article for supporting procedures:  
  **Troubleshoot a faulty Azure VM by using nested virtualization in Azure**
  https://docs.microsoft.com/en-us/azure/virtual-machines/troubleshooting/troubleshoot-vm-by-use-nested-virtualization
- Deployed VM has these attributes:
  - OS: Windows Server 2016
  - Deployed as a Dv3 VM, which is required for Nested Hyper-V
  - Deployed with HUB Licensing
    > Please relax this setting if you do not have this type of Windows Server licensing.
- Script expects the RG, VNet, and Subnet to already be in place.
- Script requires the below inputs:
  - ResourceGroupName
  - Location
  - VNetName
  - SubnetName
  - Instance
    > Increment, if you want deploy a second VM quickly.
  - VMName


## Detailed Steps
1. Clone this repo down to a workstations that has Az cmdlets
2. Update variables listed above from your environment.  
3. Execute ```DeployRescueVM.ps1```
> My preferred method of execution is from VS code because it automatically puts you in the folder where the script lives (which is required).

## TODO

- I'd like to add a download for common Windows Server ISOs for versions 2012R2, 2016, 2019, etc.  This could speed up recovery efforts.



