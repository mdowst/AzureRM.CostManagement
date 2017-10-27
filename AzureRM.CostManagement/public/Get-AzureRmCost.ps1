Function Get-AzureRmCost {

    <#
    .SYNOPSIS
    

    .DESCRIPTION


    .NOTES
    Author:        Kilian Arjona
    Version:       v0.1.0
    Date released: 27/10/2017

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

    Process {
        #TODO: Add Storage costs
        #TODO: Get costs for all resources in Resource Group
    }
}
