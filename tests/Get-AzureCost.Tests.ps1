Get-Module -Name AzureRM.CostManagement -All | Remove-Module -Force -ErrorAction Ignore
Import-Module -Name "$PSScriptRoot\..\AzureRM.CostManagement\AzureRM.CostManagement.psd1" -Force -ErrorAction Stop

Describe "Get-AzureCost" {
    It "returns number of hours test-azure-vda was running a static day where it was always powered on" {
        Get-AzureCost | Should Be 24
    }
}
