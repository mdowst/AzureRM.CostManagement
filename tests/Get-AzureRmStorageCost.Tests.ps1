Get-Module -Name AzureRM.CostManagement -All | Remove-Module -Force -ErrorAction Ignore
Import-Module -Name "$PSScriptRoot\..\AzureRM.CostManagement\AzureRM.CostManagement.psd1" -Force -ErrorAction Stop

InModuleScope "AzureRM.CostManagement" {
    Describe "Get-AzureRmStorageCost tests" {
        It "fails" {
            $true | Should -Be $false
        }
    }    
}
