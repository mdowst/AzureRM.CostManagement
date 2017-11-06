Get-Module -Name AzureRM.CostManagement -All | Remove-Module -Force -ErrorAction Ignore
Import-Module -Name "$PSScriptRoot\..\AzureRM.CostManagement\AzureRM.CostManagement.psd1" -Force -ErrorAction Stop

Describe "default test" {
    It "fails" {
        $true | Should -Be $false
    }
}
