Get-Module -Name AzureRM.CostManagement -All | Remove-Module -Force -ErrorAction Ignore
Import-Module -Name "$PSScriptRoot\..\AzureRM.CostManagement\AzureRM.CostManagement.psd1" -Force -ErrorAction Stop

InModuleScope "AzureRM.CostManagement" {
    Describe "Get-AzureRmComputeCost tests" {
        Context "the VM does not exist" {
            It "returns an empty object" {
                $true | Should -Be $false
            }
        }
        Context "the VM has not changed sizes" {
            It "returns a single object" {
                $true | Should -Be $false
            }
            It "returns an object with the correct properties" {
                $true | Should -Be $false
            }        
        }
        Context "the VM has changed sizes" {
            It "returns multiple objects" {
                $true | Should -Be $false
            }
            It "returns multiple objects with the correct properties" {
                $true | Should -Be $false
            }
            It "returns multiple objects that have different VM sizes listed" {
                $true | Should -Be $false
            }
        }
    }
}
