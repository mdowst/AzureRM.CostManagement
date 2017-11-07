Get-Module -Name AzureRM.CostManagement -All | Remove-Module -Force -ErrorAction Ignore
Import-Module -Name "$PSScriptRoot\..\AzureRM.CostManagement\AzureRM.CostManagement.psd1" -Force -ErrorAction Stop

InModuleScope "AzureRM.CostManagement" {
    Describe "Get-AzureRmResourcePrice tests" {
        It "downloads the json price list" {
            $true | Should -Be $false
        }
        It "returns the price for the specified resource if it exists" {
            $true | Should -Be $false
        }
        It "returns nothing if the specified resource does not exist" {
            $true | Should -Be $false
        }
    }    
}
