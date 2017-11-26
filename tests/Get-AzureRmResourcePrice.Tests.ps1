Get-Module -Name AzureRM.CostManagement -All | Remove-Module -Force -ErrorAction Ignore
Import-Module -Name "$PSScriptRoot\..\AzureRM.CostManagement\AzureRM.CostManagement.psd1" -Force -ErrorAction Stop

InModuleScope "AzureRM.CostManagement" {
    Describe "Get-AzureRmResourcePrice tests" {

        $Sub            = Import-Clixml -Path "$PSScriptRoot\mock-data\Azure.Subscription.xml"
        $PriceList      = Import-Clixml -Path "$PSScriptRoot\mock-data\Azure.PriceList.xml"

        Mock Get-AzureRmCachedAccessToken { return "Jm8nEuaIqOrvJmCOigmf4hyhNzggPnFdfEnZ_K0GFJYVq2R0gMIPZ5peQCmJlGKzZFZFIlu7m2NZTNSPnGVvwCNRwKq1Qe4cN5Q09E6xb2VsI6xA-5zfMvjx9AplWGVt04CpAL6ebxLqVSQEUz1SMZ2bESfqx1Nk0i3M7owzJZIolzQsDBfwMhVOIUUSQTgz8-dG0BTHCfMutF3J8ld6EN4XBwYHTxCoEV9CcVer1x0ygLq4fW8-d9Ksu2lp71cY1bqQdXvpXKee_nRpnfN6-9LATpINeuDScxBjVLoja51UtUN98Wr2G8jmWKXuN8A2I5rfLJ7EQeQdUO-gsJYrecGunRYt8_buP5zbu0Y7k81H0PDf7Np8eQmHNECG0lvkIxHL_6F1mK6zNK5jzhNKnebj5Al0pFX3ykfKeklX1PSKOmtMfEneF96jRE2E82kAaAnrj2SVz8mb-SdmKCHKqm0bNhR9sBlQj7Dsm2cngYLt1r1aFfrV4PGrbDo_tzkD8X5N31Sj944HTFW-lYP5UMKoIZWZ5iX_kHdAI958HT1ZqG_vn-Y077BV4HOrL20mAAhW39NhjtK_EvDOs0Sd44UsNhK1KbYw5QRBsRyUojj9BJ_uCDfhCqu83tW13M1G23MsJbR-eJXob5BykdHpX-24-iGwZMjEA2utlfSoAe0riCR04p229vdlrPUhELYEb6GtrXeqUkVYhjQJWfXSXIYSAnbdM78pZQzsMwVc3FQ_B5FDJLQvjy0l-u6obPCIXD6j3u-mdSVG3E71KtwXykYyPkW4pEtcnC8gBx8qBBdaQykpf6LBp2JfBGjjPYGi32KrGtBbHC4XWg6eK58LlTDt5tkvk6Ul4r159DFOGji_dbFmsPXI4Wa4OEiyElZ8C1SY-B5g0pgjSsNE54SsTFWBlz2WGAEosrrYfqHvXcwrZj5tJ_DPcksvgJFQ0vb6UZXh-4ElHxMY2YZhq5p4r5Df0vOW4Je388FqvkPPUh5X73c7Aw_GCmuVQ4BralrBK-qst_k5a2JnXJC1l8VulkQnno80V7nUsyyXh4j_1vNdlOeTDv_ylbDbaMoHLMBfNqQAr1k4clVY1DdBbWo3haHl8fRZh2qfGZLM6onsXbybjdirM5uMZ7hu5x_CXb4qrpJPXJmNanl6meukslH_l9bvo93vmy7i6Ipo2glKWKiSaBfuSqFYUeYqzcDogxMDQJyRw4QORUXEiW79gKac3BEtlSIFCpyjxE0xUceyiq6SovFE_SP0jyk6xmzrpATiLK5tTfoig_sldqjil9Tf9fwkNSDj-TZntAmjcBcHjRJ__3ZrhUl48U27JWNL7v5DS2HJv6rx0hUOCTfah_YjGLD9_kaaEW5sj6ZyjNHPMD8RYGXG-rbjq4aBRfMEBNt4J0lt3FBtrKorvwXf8oBSCqVMM5VWKT1Cvuh1oNC3RwfzTJWyciQFG38lJqflGnCynlHhXED1xpt3dBotWzHZYGkIsjpI3xEA2-4G3arYDdDU_vCaTiMwFpMIyw5hrSrT5LH2p_DLHF2eluvirtNkufOKDdBCDGtz04zs3r5geUea0g2KgyaXTRAdgS_hcIWZMI90nxcdreCk9ubbhQr8LpQd_Y7K5OEY7YaYSL_0FBLBeI5aYkak_MsST7g5c4nkBXKL" }
        Mock Get-AzureRmSubscription      { return $Sub }
        Mock Invoke-WebRequest            { return $PriceList }

        Context "requested resource exists in price list" {
            It "returns the price for the specified resource" {
                $VMPrice = Get-AzureRmResourcePrice -Category 'Virtual Machines' -Region 'EU West' -Resource 'BASIC.A2 VM'

                $VMPrice | Should -BeOfType [decimal]
                $VMPrice | Should -Not -BeNullOrEmpty
            }
        }

        Context "requested resource does not exists in price list" {
            It "returns nothing" {
                Get-AzureRmResourcePrice -Category 'Bad Category' -Region 'Bad Region' -Resource 'Bad Resource' | Should -BeNullOrEmpty
            }
        }
    }
}
