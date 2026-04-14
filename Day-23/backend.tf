terraform {
  backend "azurerm" {
    storage_account_name = "sravansg"
    container_name = "sravanterraform"
    key = "terraform.tfstate"
    access_key = ""
  }
}