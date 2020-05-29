# Update for your Env

$ResourceGroupName = "cis-prod-va-demo-01-rg"
$Location = "usgovvirginia"
$VNetName = "cis-vnet"
$SubnetName = "cis-subnet01"
$Instance = "01"
$VMName = "acmerescuevm$($Instance)"

# Create user object
$cred = Get-Credential -Message "Enter a username and password for the virtual machine."

# Network pieces
$VNet = Get-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Name $VNetName
$Pip = New-AzPublicIpAddress -ResourceGroupName $ResourceGroupName -Location $Location `
  -Name "$($VMName)-public-dns$(Get-Random)" -AllocationMethod Static -IdleTimeoutInMinutes 4
$NsgRuleRDP = New-AzNetworkSecurityRuleConfig -Name "$($VMName)-NSG-RuleRDP"  -Protocol Tcp `
  -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * `
  -DestinationPortRange 3389 -Access Allow
$Nsg = New-AzNetworkSecurityGroup -ResourceGroupName $ResourceGroupName -Location $Location `
  -Name "$($VMName)-nsg" -SecurityRules $NsgRuleRDP
$Subnet = Get-AzVirtualNetworkSubnetConfig -Name $SubnetName -VirtualNetwork $VNet
$Nic = New-AzNetworkInterface -Name "$($VMName)-nic" -ResourceGroupName $ResourceGroupName -Location $Location -SubnetId $Subnet.id -PublicIpAddressId $Pip.Id -NetworkSecurityGroupId $Nsg.Id

# Build VM Config
$VMConfig = New-AzVMConfig -VMName $VMName -VMSize Standard_D4s_v3 -LicenseType Windows_Server   | `
    Set-AzVMOperatingSystem -Windows -ComputerName $VMName -Credential $cred | `
    Set-AzVMSourceImage -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2016-Datacenter" -Version "latest" | `
    Add-AzVMNetworkInterface -Id $Nic.Id | `
    Set-AzVMBootDiagnostic -Disable # | `

# Create a virtual machine
New-AzVM -ResourceGroupName $ResourceGroupName -Location $Location -VM $VMConfig -Verbose

#TODO:  Add download for eval versions of Windows Server ISO into VM

# Add Hyper-V Feature and Reboot
Invoke-AzVMRunCommand -ResourceGroupName $ResourceGroupName -Name $VMName -CommandId 'RunPowerShellScript' -ScriptPath .\Install-HyperV.ps1




