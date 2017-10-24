Get-Module -Name AzureRM.CostManagement -All | Remove-Module -Force -ErrorAction Ignore
Import-Module -Name "$PSScriptRoot\..\AzureRM.CostManagement\AzureRM.CostManagement.psd1" -Force -ErrorAction Stop

Describe "Get-AzureCost" {
    It "returns an object with vm statistics" {
        Get-AzureCost | Should BeOfType System.Collections.Hashtable
    }
}
