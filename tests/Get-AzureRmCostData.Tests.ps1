Get-Module -Name AzureRM.CostManagement -All | Remove-Module -Force -ErrorAction Ignore
Import-Module -Name "$PSScriptRoot\..\AzureRM.CostManagement\AzureRM.CostManagement.psd1" -Force -ErrorAction Stop

InModuleScope "AzureRM.CostManagement" {
    Describe "Get-AzureRmCostData tests" {
        Context "no existing data" {
            It "returns an empty object" {
                $true | Should -Be $false
            }
        }
        Context "data must be collected in multiple runs" {
            It "filters data and runs the function again" {
                $true | Should -Be $false
            }
            It "returns an object with the correct properties" {
                #only vms and storage
                $true | Should -Be $false
            }
        }
        Context "data can be collected in a single run" {
            It "returns an object with the correct properties" {
                #only vms and storage
                $true | Should -Be $false
            }
        }
    }
}
