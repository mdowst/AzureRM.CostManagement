Get-Module -Name AzureRM.CostManagement -All | Remove-Module -Force -ErrorAction Ignore
Import-Module -Name "$PSScriptRoot\..\AzureRM.CostManagement\AzureRM.CostManagement.psd1" -Force -ErrorAction Stop

InModuleScope "AzureRM.CostManagement" {
    Describe "Get-AzureRmCachedAccessToken tests" {
        It "fails if Azure account is not logged in" {
            $true | Should -Be $false
        }

        It "returns an Access Token if the Azure account is logged in" {
            $true | Should -Be $false
        }
    }    
}
