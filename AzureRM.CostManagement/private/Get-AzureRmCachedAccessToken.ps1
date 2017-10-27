# Portions of this code (c) Stéphane Lapointe
# Licensed under MIT license, used with permission
# https://gallery.technet.microsoft.com/scriptcenter/Easily-obtain-AccessToken-3ba6e593
Function Get-AzureRmCachedAccessToken {

    <#
    .SYNOPSIS
    Returns the cached Access Token from an existing Azure Authentication Context.

    .DESCRIPTION
    This cmdlets returns a string with the Access Token cached by the standard Azure RM cmdlets. We can use this token
    to to send REST API requests to Azure without creating a new Service Principal.
    The string can be added to an Authorization header.

    .NOTES
    Author:        Kilian Arjona
    Version:       v0.1.0
    Date released: 25/10/2017

    .LINK
    https://github.com/karjona/AzureRM.CostManagement

    .COMPONENT
    AzureRM.CostManagement
    #>

    [CmdletBinding()]
    [OutputType([string])]

    $ErrorActionPreference = 'Stop'
    if (-not (Get-Module AzureRm.Profile)) {
        Import-Module AzureRm.Profile
    }
    $azureRmProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
    if (-not $azureRmProfile.Accounts.Count) {
        Write-Error 'No account found in the context. Please login using Login-AzureRMAccount.'
    }
    $currentAzureContext = Get-AzureRmContext
    $profileClient = New-Object Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient($azureRmProfile)
    $token = $profileClient.AcquireAccessToken($currentAzureContext.Subscription.TenantId)
    $token.AccessToken
}
