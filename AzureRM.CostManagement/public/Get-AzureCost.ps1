Function Get-AzureCost {

    <#
    .SYNOPSIS
    

    .DESCRIPTION


    .NOTES
    Author:        Kilian Arjona
    Version:       v0.1.0
    Date released: 23/10/2017

    .LINK
    https://github.com/karjona/AzureRM.CostManagement

    .PARAMETER 
    

    .EXAMPLE



    .COMPONENT
    AzureRM.CostManagement
    #>

    [CmdletBinding(DefaultParameterSetName='VMName')]
    [OutputType([decimal], ParameterSetName="VMName")]
    
        Param(
            [Parameter(Mandatory=$true, ParameterSetName="VMName")][string]$VMName
        )


    Begin {
    }

    Process {
        $cost     = @{}
        $computeq = 0;
        $diskq    = 0;
        $data     = $(Get-UsageAggregates -ReportedStartTime 2017-10-21T00:00:00Z -ReportedEndTime 2017-10-22T00:00:00Z -AggregationGranularity Daily).UsageAggregations
        $vms      = $data | Where-Object {$_.Properties.MeterCategory -eq 'Virtual Machines'}
        $storages = $data | Where-Object {$_.Properties.MeterCategory -eq 'Storage' -and $_.Properties.MeterName -like '*Managed Disk*'}

        foreach ($vm in $vms) {
            $json = ConvertFrom-Json -InputObject $vm.Properties.InstanceData
            if ($json.'Microsoft.Resources'.resourceUri -like '*$VMName*') {
                $computeq += $vm.Properties.Quantity
            }
        }

        foreach ($storage in $storages) {
            $json = ConvertFrom-Json -InputObject $storage.Properties.InstanceData
            if ($json.'Microsoft.Resources'.resourceUri -like "*$disk*") {
                $diskq += $storage.Properties.Quantity
            }
        }

        $cost = @{
            "VMName"       = "test-azure-vda";
            "ComputeHours" = $computeq;
            "DiskUnits"    = $diskq;
        }

        $cost
    }

    End {
    }
}
