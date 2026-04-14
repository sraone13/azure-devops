# Install Azure CLI


### Installation Overview
https://learn.microsoft.com/en-us/cli/azure/install-azure-cli

### Install on Windows
https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli

### Install on Linux
https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt

### Install on Mac
https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-macos


$ProgressPreference = 'SilentlyContinue' Invoke-WebRequest -Uri https://aka.ms/installazurecliwindowsx64 -OutFile .\AzureCLI.msi Start-Process msiexec.exe -Wait -ArgumentList '/I', 'AzureCLI.msi', '/quiet' Remove-Item .\AzureCLI.msi
