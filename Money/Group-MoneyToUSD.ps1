function Group-MoneyToUSD {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline,HelpMessage = "FilePath to get computernames")]
        [Alias("MoneyData")]
        $moneyDataFromFile
    )
    begin {

        $usdTotal = 0
        $eurTotal = 0
        $gbpTotal = 0
        $chfTotal = 0
    }

    process {

        switch ($moneyDataFromFile.CURRENCY) {

            "USD" {
                $usdTotal += $moneyDataFromFile.AMOUNT
            }
            "EUR" {
                $eurTotal += $moneyDataFromFile.AMOUNT
            }
            "GBP" {
                $gbpTotal += $moneyDataFromFile.AMOUNT
            }
            "CHF" {
                $chfTotal += $moneyDataFromFile.AMOUNT
            }
            default {
                Write-Warning "Nieznana waluta!"
            }
        }
    }

    end {

        [PSCustomObject]@{
            USD  = $usdTotal
            EUR  = $eurTotal
            GBP  = $gbpTotal
            CHF  = $chfTotal
        }
    }
}