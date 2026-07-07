function Group-MoneyToUSD {
    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "FilePath to get computernames",Position=0,ValueFromPipeline)]
        [Alias("MoneyData")]
        $moneyDataFromFile
    )
    begin {
        # Możesz tu przygotować zmienne, liczniki, bufor itd.
        $usdTotal = 0
        $eurTotal = 0
        $gbpTotal = 0
        $chfTotal = 0
    }

    process {
        # Każdy rekord z pipeline trafia tutaj
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
        # Wynik końcowy po przetworzeniu całego pipeline
        [PSCustomObject]@{
            USD  = $usdTotal
            EUR  = $eurTotal
            GBP  = $gbpTotal
            CHF  = $chfTotal
        }
    }
}