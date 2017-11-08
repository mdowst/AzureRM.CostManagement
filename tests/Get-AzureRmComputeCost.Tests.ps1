Get-Module -Name AzureRM.CostManagement -All | Remove-Module -Force -ErrorAction Ignore
Import-Module -Name "$PSScriptRoot\..\AzureRM.CostManagement\AzureRM.CostManagement.psd1" -Force -ErrorAction Stop

InModuleScope "AzureRM.CostManagement" {

    $UsageData = Import-Clixml -Path "$PSScriptRoot\mock-data\Azure.CostData.xml"

    Describe "Get-AzureRmComputeCost tests" {
        Context "the VM does not exist" {
            Mock Get-AzureRmResourcePrice {}

            It "returns an empty object" {
                Get-AzureRmComputeCost -UsageData $UsageData -VMName 'nothing' | Should -BeNullOrEmpty
            }
        }

        Context "Single entry for this VM" {
            Mock Get-AzureRmResourcePrice { return [decimal]0.0657774 }
            $ComputeCost = Get-AzureRmComputeCost -UsageData $UsageData -VMName 'VMSingle'

            It "returns an object with the correct properties" {
                $ComputeCost | Should -BeOfType 'System.Management.Automation.PSCustomObject'
                $ComputeCost.Name | Should -Be 'VMSingle'
                $ComputeCost.Category | Should -Be 'Virtual Machines'
                $ComputeCost.Region | Should -Not -BeNullOrEmpty
                $ComputeCost.Resource | Should -Not -BeNullOrEmpty
                $ComputeCost.Quantity | Should -BeGreaterThan 0
                $ComputeCost.Cost | Should -Be $($ComputeCost.Quantity * 0.0657774)
                $ComputeCost.Currency | Should -Not -BeNullOrEmpty
            }            
        }

        Context "multiple entries for this VM" {
            Context "the VM has not changed sizes" {
                Mock Get-AzureRmResourcePrice { return [decimal]0.0573444 }
                $ComputeCost = Get-AzureRmComputeCost -UsageData $UsageData -VMName 'VMMultiple'

                It "returns a single object" {
                    $ComputeCost.Count | Should -BeNullOrEmpty
                }
                It "returns an object with the correct properties" {
                    $ComputeCost | Should -BeOfType 'System.Management.Automation.PSCustomObject'
                    $ComputeCost.Name | Should -Be 'VMMultiple'
                    $ComputeCost.Category | Should -Be 'Virtual Machines'
                    $ComputeCost.Region | Should -Not -BeNullOrEmpty
                    $ComputeCost.Resource | Should -Not -BeNullOrEmpty
                    $ComputeCost.Quantity | Should -BeGreaterThan 0
                    $ComputeCost.Cost | Should -Be $($ComputeCost.Quantity * 0.0573444)
                    $ComputeCost.Currency | Should -Not -BeNullOrEmpty
                }
            }

            Context "the VM has changed sizes" {
                Mock Get-AzureRmResourcePrice { return [decimal]0.1787796 } -Verifiable -ParameterFilter { $Resource -eq 'Standard_D2_v3 VM (Windows)' }
                Mock Get-AzureRmResourcePrice { return [decimal]0.3575592 } -Verifiable -ParameterFilter { $Resource -eq 'Standard_D4_v3 VM (Windows)' }
                $ComputeCost = Get-AzureRmComputeCost -UsageData $UsageData -VMName 'VMChangedSizes'

                It "returns multiple objects" {
                    $ComputeCost.Count | Should -BeGreaterThan 1
                }
                It "returns multiple objects with the correct properties" {
                    foreach ($c in $ComputeCost) {
                        $c | Should -BeOfType 'System.Management.Automation.PSCustomObject'
                        $c.Name | Should -Be 'VMChangedSizes'
                        $c.Category | Should -Be 'Virtual Machines'
                        $c.Region | Should -Not -BeNullOrEmpty
                        $c.Resource | Should -Not -BeNullOrEmpty
                        $c.Quantity | Should -BeGreaterThan 0
                        $c.Cost | Should -BeGreaterThan 0
                        $c.Currency | Should -Not -BeNullOrEmpty
                    }
                }
                It "returns multiple objects that have different VM sizes listed" {
                    $($ComputeCost[0].Resource -eq $ComputeCost[1].Resource) | Should -Be $false
                }

                Assert-VerifiableMock
            }
        }
    }
}
