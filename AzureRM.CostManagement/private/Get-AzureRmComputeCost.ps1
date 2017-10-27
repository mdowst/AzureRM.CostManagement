Function Get-AzureRmComputeCost {
    
    <#
    .SYNOPSIS
    Returns the cost for the compute part of an Azure Virtual Machine.

    .DESCRIPTION
    This cmdlet queries Azure Usage APIs to return the price of the compute part of an Azure VM over a period of time.
    To extract this information this cmdlet parses the usage data extracted from the Get-AzureRmCostData.

    .NOTES
    Author:        Kilian Arjona
    Version:       v0.1.0
    Date released: 27/10/2017

    .LINK
    https://github.com/karjona/AzureRM.CostManagement

    .PARAMETER UsageData
    Specifies the resource cost data to use. This data can be acquired using Get-AzureRmCostData.

    .PARAMETER VMName
    Specifies the VM to filter.

    .EXAMPLE
    Get-AzureRmComputeCost -UsageData $(Get-AzureRmCostData -StartDate 2017-08-01 -EndDate 2017-10-01) -VMName "myvm"
    Returns the incurred total cost for the compute part of the VM "myvm" from the 1st of Agust to the 1st of October of 2017.

    .COMPONENT
    AzureRM.CostManagement
    #>

    [CmdletBinding(DefaultParameterSetName='VMName')]
    #[OutputType([])]
    
        Param(
            [Parameter(Mandatory=$true)]$UsageData,
            [Parameter(Mandatory=$false, ParameterSetName="VMName")][string]$VMName
        )

    Process {
        $ComputeCost = @()
        $vms = $UsageData | Where-Object {$_.Properties.MeterCategory -eq 'Virtual Machines'}
        foreach ($vm in $vms) {
            $json = ConvertFrom-Json -InputObject $vm.Properties.InstanceData
            if ($json.'Microsoft.Resources'.resourceUri -like "*$VMName*") {
                $CostEntry = [PSCustomObject]@{
                    Size     = $vm.Properties.MeterSubCategory
                    Region   = $vm.Properties.MeterRegion
                    Quantity = $vm.Properties.Quantity
                }
                $ComputeCost += $CostEntry
            }
        }
        $ComputeCost = $ComputeCost | Group-Object 'Size', 'Region'
        foreach ($g in $ComputeCost) {
            $total = 0
            $g.group.Quantity | ForEach-Object {
                $total += $_
            }
            $price = Get-AzureRmResourcePrice -Category 'Virtual Machines' -Region $($g.group[0].Region.ToString()) -Resource $($g.group[0].Size.ToString())
            Write-Output "Quantity for size $($g.group[0].Size.ToString()) in region $($g.group[0].Region.ToString()): $total"
            Write-Output "Price is: $price"
            Write-Output "Total is: $($total*$price)"
        }
    }
}
