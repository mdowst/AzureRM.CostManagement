Function Get-AzureRmResourcePrice {

    <#
    .SYNOPSIS
    Obtains Azure Resource price list and returns the price for a specific resource.

    .DESCRIPTION
    Queries the Azure RateCard API to obtain a full price list of all Azure resource availables in a region. After
    the list is downloaded, it is filtered to return a specific price/unit for a resource.

    .NOTES
    Author:        Kilian Arjona
    Version:       v0.1.0
    Date released: 27/10/2017

    .LINK
    https://github.com/karjona/AzureRM.CostManagement

    .PARAMETER Category
    Specifies the category to filter: 'Virtual Machines', 'Storage', 'Network'...

    .PARAMETER Region
    Specifies the region that hosts the resource.

    .PARAMETER Resource
    Specifies the resource name (VM Size, Storage disk type...).

    .EXAMPLE
    Get-AzureRmResourcePrice -Category 'Virtual Machines' -Region 'EU West' -Resource 'Standard_D1_v2 VM'
    Returns the price per hour of the VM size D1_v2 on EU West region.

    .COMPONENT
    AzureRM.CostManagement
    #>

    [CmdletBinding()]
    [OutputType([decimal])]
    
        Param(
            [Parameter(Mandatory=$true)][string]$Category,
            [Parameter(Mandatory=$true)][string]$Region,
            [Parameter(Mandatory=$true)][string]$Resource
        )

    Process {
        $header = @{
            'Authorization' = "Bearer $(Get-AzureRmCachedAccessToken)"
        }
        $subscriptionid = $(Get-AzureRmSubscription -WarningAction SilentlyContinue).Id.ToString()
        $prices = Invoke-WebRequest -Uri "https://management.azure.com/subscriptions/$subscriptionid/providers/Microsoft.Commerce/RateCard?api-version=2016-08-31-preview&`$filter=OfferDurableId eq 'MS-AZR-0003P' and Currency eq 'EUR' and Locale eq 'en-US' and RegionInfo eq 'ES'" -ContentType "application/json" -Method Get -Headers $header
        $json   = ConvertFrom-Json -InputObject $prices
        $($json.Meters | Where-Object {$_.MeterCategory -eq $Category -and $_.MeterRegion -eq $Region -and $_.MeterSubCategory -eq $Resource}).MeterRates.0
    }
}
