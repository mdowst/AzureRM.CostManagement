Function Get-AzureCostData {
    
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

    .PARAMETER EndDate
    Specifies the end date for the usage entries.

    .PARAMETER Continuation
    Specifies the continuation token returned by Azure used to collect the rest of the entries when the query
    had to be fragmented by the RateCard API.

    .PARAMETER ExistingData
    Provides the previous data to aggregate to the current record set to achieve a full result in a fragmented query.

    .EXAMPLE
    Get-AzureCostData -StartDate 2017-08-01 -EndDate 2017-10-01
    Returns all VM and Storage usage entries from the specified date range.

    .COMPONENT
    AzureRM.CostManagement
    #>

    [CmdletBinding()]
    #[OutputType([Azure.CostData])]
    
        Param(
            [Parameter(Mandatory=$false)][datetime]$StartDate,
            [Parameter(Mandatory=$false)][datetime]$EndDate,
            [Parameter(Mandatory=$false)][string]$Continuation,
            [Parameter(Mandatory=$false)]$ExistingData
        )


    Process {
        if (-not($Continuation)) { # First run
            $data = Get-UsageAggregates -ReportedStartTime $StartDate -ReportedEndTime $EndDate -AggregationGranularity Daily
            if ($data.ContinuationToken) { # First run didn't return all data. We have to run this function again
                Get-AzureCostData -StartDate $StartDate -EndDate $EndDate -Continuation $data.ContinuationToken -ExistingData $data.UsageAggregations
            } else { # Only one run needed. No continuations
                $vms = $data.UsageAggregations | Where-Object {$_.Properties.MeterCategory -eq 'Virtual Machines'}
                $storages = $data.UsageAggregations | Where-Object {$_.Properties.MeterCategory -eq 'Storage' -and $_.Properties.MeterName -like '*Managed Disk*'}
                $vms + $storages
            }
        } else { # Continuing from previous query
            $data = Get-UsageAggregates -ReportedStartTime $StartDate -ReportedEndTime $EndDate -AggregationGranularity Daily -ContinuationToken $Continuation
            if ($data.ContinuationToken) { # This run, continued from a previous one, didn't return all data. We have to run this function again
                $ExistingData += $data.UsageAggregations
                Get-AzureCostData -StartDate $StartDate -EndDate $EndDate -Continuation $data.ContinuationToken -ExistingData $ExistingData
            } else { # We finished after the recursion. Finally!
                $cost = $data.UsageAggregations + $ExistingData
                $vms = $cost | Where-Object {$_.Properties.MeterCategory -eq 'Virtual Machines'}
                $storages = $cost | Where-Object {$_.Properties.MeterCategory -eq 'Storage' -and $_.Properties.MeterName -like '*Managed Disk*'}
                $vms + $storages
            }
        }
    }
}
