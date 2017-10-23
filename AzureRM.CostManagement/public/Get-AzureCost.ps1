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

    [CmdletBinding(DefaultParameterSetName='')]
    
        Param(
        )


    Begin {
    }

    Process {
        $quantity = 0;
        $vms = $(Get-UsageAggregates -ReportedStartTime 2017-10-21T00:00:00Z -ReportedEndTime 2017-10-22T00:00:00Z -AggregationGranularity Daily).UsageAggregations | Where-Object {$_.Properties.MeterCategory -eq 'Virtual Machines'}

        foreach ($vm in $vms) {
            $json = ConvertFrom-Json -InputObject $vm.Properties.InstanceData
            if ($json.'Microsoft.Resources'.resourceUri -like '*test-azure-vda*') {
                $quantity += $vm.Properties.Quantity
            }
        }

        $quantity
    }

    End {
    }
}
