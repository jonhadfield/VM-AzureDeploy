# VM-AzureDeploy
# Create a VM from a specialized BSI VHD disk

Click the button below to deploy directly using the Azure Portal

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fbsi-group%2FVM-AzureDeploy%2Fmaster%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>


## Prerequisite 
- VHD file that you want to create a VM from already exists in a storage account.


## VHD Image Copy
There are two options to copy the BSI testing image.
1. Download the VHD from the BSI sftp/https server then upload to Azure.
2. Directly copy the VHD from BSI to your storage account using AzureCLI or PowerShell.

#### Method One - Download/Upload Image
The consultant will provide a username, password, and hostname to download the Azure VHD image over sftp or https. 
1. Download the image.
2. Upload the image to Azure storage account where the virtual machine will run.
3. Deploy a virtual machine based on the VHD disk. 

#### Method Two - Direct Copy Image
Perform a background transfer of the VHD disk image directly in Azure.
   * Using Azure CLI
     * The SAS_URL will be provided by the consultant, this will be a time-limited custom URL of our testing image.
     * Once loged into the Azure CLI (https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli?view=azure-cli-latest) run the following command:	
     
        ```az storage blob copy start --source-uri [SAS_URL] --destination-container [VM Container Name] --destination-blob [BSI-azure-kali.vhd] --account-name [Azure Account Name]```

---
   * Using PowerShell
     * The SAS_URL will be provided by the consultant, this will be a time-limited custom URL of our testing image.
     * Once loged into the Azure PowerShell (https://github.com/Azure/azure-powershell#log-in-to-azure) run the following commands:
	
        ```
        $DestinationResourceGroupName = "[Enter your Resource Group here]"
        $DestinationStorageAccountName = "[Enter your Storage Account Name here]"
        $DestinationBlobName = "[BSI-Kali-image.vhd]"
        $DestinationStorageContainer = "[vhds]"
        $SAS_URL = "[PROVIDED URL]"

        $storage = Get-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountName

        Start-AzureStorageBlobCopy -AbsoluteUri $SAS_URL -DestContainer $DestinationStorageContainer -DestBlob $DestinationBlobName -DestContext $storage.Context
        ```
        
     * Check the status of the copy:
        ```
        Get-AzureStorageBlobCopyState -Blob $DestinationBlobName -Container $DestinationStorageContainer -Context $storage.Context
        ```
---
   * Using AzCopy
     * Further information here: https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy
     
