$Path = "$PSScriptRoot\..\AzureRM.CostManagement\"
Get-Module -Name AzureRM.CostManagement -All | Remove-Module -Force -ErrorAction Ignore
$ModuleInfo = Import-Module "$Path`AzureRM.CostManagement.psd1" -PassThru -ErrorAction Stop

Describe "AzureRM.CostManagement module tests" -Tags ('Unit', 'Acceptance') {
    Context "Module setup" {
        It "contains the root module script" {
            $ModuleInfo.RootModule | Should -Not -BeNullOrEmpty
        }

        It "root module does not contain any syntax errors" {
            $MyRootModule = Get-Content -Path "$Path`AzureRM.CostManagement.psm1" -ErrorAction Stop
            $errors       = $null
            $null         = [System.Management.Automation.PSParser]::Tokenize($MyRootModule, [ref]$errors)
            $errors.Count | Should -Be 0
        }

        It "has the AzureRM module as a dependency" {
            $ModuleInfo.RequiredModules -Match "AzureRM" | Should -Be $true
        }

        It "exports the correct cmdlets" {
            $PublicFunctions = Get-ChildItem -Path "$Path\public\*.ps1"
            $Compare         = Compare-Object -ReferenceObject $PublicFunctions.BaseName -DifferenceObject $ModuleInfo.ExportedFunctions.Values.Name
            $Compare.InputObject -join ',' | Should -BeNullOrEmpty
        }
    }
}
