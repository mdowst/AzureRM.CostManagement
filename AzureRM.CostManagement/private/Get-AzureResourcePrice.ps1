Function Get-AzureResourcePrice {

    <#
    .SYNOPSIS
    .

    .DESCRIPTION
    .
    .

    .NOTES
    Author:        Kilian Arjona
    Version:       v0.1.0
    Date released: 27/10/2017

    .LINK
    https://github.com/karjona/AzureRM.CostManagement

    .PARAMETER X
    .

    .EXAMPLE
    
    

    .COMPONENT
    AzureRM.CostManagement
    #>

    [CmdletBinding()]
    [OutputType([decimal])]
    
        Param(
            [Parameter(Mandatory=$false)][string]$Category,
            [Parameter(Mandatory=$false)][string]$Region,
            [Parameter(Mandatory=$false)][string]$Resource
        )

    Process {
        $header = @{
            'Authorization' = "Bearer $(Get-AzureRmCachedAccessToken)"
        }
        $subscriptionid = $(Get-AzureRmSubscription).Id.ToString()
        $prices = Invoke-WebRequest -Uri "https://management.azure.com/subscriptions/$subscriptionid/providers/Microsoft.Commerce/RateCard?api-version=2016-08-31-preview&`$filter=OfferDurableId eq 'MS-AZR-0003P' and Currency eq 'EUR' and Locale eq 'en-US' and RegionInfo eq 'ES'" -ContentType "application/json" -Method Get -Headers $header
        $json   = ConvertFrom-Json -InputObject $prices
        $($json.Meters | Where-Object {$_.MeterCategory -eq $Category -and $_.MeterRegion -eq $Region -and $_.MeterSubCategory -eq $Resource}).MeterRates.0
    }
}
