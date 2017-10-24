Function Get-AzureComputeCost {
    
    <#
    .SYNOPSIS
    Collects large amounts of Azure usage data and returns VM and Storage entries.

    .DESCRIPTION
    To recover large sets of Azure usage data multiple calls to the Azure RateCard API must be made.
    This cmdlet automates these calls and returns only the VM and Storage entries.

    .NOTES
    Author:        Kilian Arjona
    Version:       v0.1.0
    Date released: 24/10/2017

    .LINK
    https://github.com/karjona/AzureRM.CostManagement

    .PARAMETER StartDate
    Specifies the start date for the usage entries.

    .EXAMPLE
    Get-AzureCostData -StartDate 2017-08-01 -EndDate 2017-10-01
    Returns all VM and Storage usage entries from the specified date range.

    .COMPONENT
    AzureRM.CostManagement
    #>

    [CmdletBinding(DefaultParameterSetName='VMName')]
    #[OutputType([])]
    
        Param(
            [Parameter(Mandatory=$true)]$UsageData,
            [Parameter(Mandatory=$false, ParameterSetName="VMName")][string]$VMName
        )

    # Implement test changes
    Process {
        $ComputeCost = @{}
        $vms = $UsageData | Where-Object {$_.Properties.MeterCategory -eq 'Virtual Machines'}
        foreach ($vm in $vms) {
            $json = ConvertFrom-Json -InputObject $vm.Properties.InstanceData
            if ($json.'Microsoft.Resources'.resourceUri -like "*$VMName*") {
                $computeq += $vm.Properties.Quantity
            }
        }
        $computeq
    }
}
