#CHANGE THESE
########################
$subscriptionId = 'yourSubscriptionId'
$resourceGroupName ='yourResourceGroupName'
$location = 'ukwest'
$sourceImageUri = 'https://mystorage.blob.core.windows.net/vhds/gold-azure-kali.vhd' 
$virtualNetworkName = 'yourVNETName'
$subnetNetworkName = 'yourVNETName'
$virtualMachineName = 'BSI-Kali'
########################

$osDiskName = $virtualMachineName + "_osDisk"
$nicName = $virtualMachineName + "_nic"
$virtualMachineSize = 'Standard_A2'
 
$VirtualMachine = New-AzureRmVMConfig -VMName $virtualMachineName -VMSize $virtualMachineSize
Set-AzureRmVMPlan -VM $VirtualMachine -Publisher kali-linux -Product kali-linux -Name kali

#Attach uploaded VHD to the virtual machine.
$VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -Name $osDiskName -VhdUri $sourceImageUri -Linux -CreateOption Attach

#Get the virtual network where virtual machine will be hosted
$vnet = Get-AzureRmVirtualNetwork -Name $virtualNetworkName -ResourceGroupName $resourceGroupName
$subnet = Get-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name $subnetNetworkName

# Create NIC in the subnet of the virtual network 
$nic = New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $resourceGroupName -Subnet $subnet -Location $location

$VirtualMachine = Add-AzureRmVMNetworkInterface -VM $VirtualMachine -Id $nic.Id

#Create the virtual machine
New-AzureRmVM -VM $VirtualMachine -ResourceGroupName $resourceGroupName -Location $location -Verbose
