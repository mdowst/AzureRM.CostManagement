Function Get-AzureRmCost {

    <#
    .SYNOPSIS
    Returns the total cost of an Azure Virtual Machine over a period of time.

    .DESCRIPTION
    Returns an object with the compute and storage cost of an Azure Virtual Machine over a period of time. The object
    includes the sum of both components as the total cost.

    .NOTES
    Author:        Kilian Arjona
    Version:       v0.1.0
    Date released: 27/10/2017

    .LINK
    https://github.com/karjona/AzureRM.CostManagement

    .PARAMETER VMName
    Specifies the name of the Azure Virtual Machine to report the cost of.

    .PARAMETER StartDate
    Specifies the start date for the cost report.

    .PARAMETER EndDate
    Specifies the end date for the cost report.

    .EXAMPLE
    Get-AzureRmCost -VMName "myvm"
    Returns the cost incurred by the Azure Virtual Machine "myvm" from the first day of the current month until today.

    .EXAMPLE
    Get-AzureRmCost -VMName "myvm" -StartDate 2017-08-03 -EndDate 2017-09-15
    Returns the cost incurred by the Azure Virtual Machine "myvm" from the 3rd of August until the 15th of September of 2017.

    .COMPONENT
    AzureRM.CostManagement
    #>

    [CmdletBinding(DefaultParameterSetName='VMName')]
    [OutputType('Azure.TotalCostObject')]
    
        Param(
            [Parameter(Mandatory=$true, ParameterSetName="VMName")][string]$VMName,
            [Parameter(Mandatory=$false, ParameterSetName="VMName")][datetime]$StartDate = $(Get-Date -Day 1 -UFormat "%Y-%m-%d"),
            [Parameter(Mandatory=$false, ParameterSetName="VMName")][datetime]$EndDate = $(Get-Date -UFormat "%Y-%m-%d")
        )

    Process {
        #TODO: Add Storage costs
        #TODO: Get costs for all resources in Resource Group
        $data    = Get-AzureRmCostData -StartDate $StartDate -EndDate $EndDate
        $compute = Get-AzureRmComputeCost -UsageData $data -VMName $VMName
        $total = [PSCustomObject]@{
            PSTypeName = 'Azure.TotalCostObject'
            Name       = $VMName
            StartDate  = $StartDate
            EndDate    = $EndDate
            Compute    = $compute
            Storage    = $storage
            Cost       = "{0:N2}" -f $compute.Cost + $storage.Cost
            Currency   = 'EUR'
        }
        $total
    }
}
