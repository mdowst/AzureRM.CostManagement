Function Get-AzureRmCost {

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
    #[OutputType()]
    
        Param(
            [Parameter(Mandatory=$true, ParameterSetName="VMName")][string]$VMName
        )


    Begin {
    }

    Process {
    }

    End {
    }
}
