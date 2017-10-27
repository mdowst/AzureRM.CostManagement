Get-Module -Name AzureRM.CostManagement -All | Remove-Module -Force -ErrorAction Ignore
Import-Module -Name "$PSScriptRoot\..\AzureRM.CostManagement\AzureRM.CostManagement.psd1" -Force -ErrorAction Stop

Describe "Get-AzureRmCost" {
    It "fails. yep. it fails." {
        $false | Should Be $true
    }
}
