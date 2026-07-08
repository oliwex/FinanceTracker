#region CONFIGURATION
#funkcje
. "$PSScriptRoot\Money\Get-MoneyFromFile.ps1"
. "$PSScriptRoot\Money\Group-MoneyToUSD.ps1"
#sciezki
$MONEY_PATH="E:\GIT\FinanceTracker\Money\money.txt"

#zmienne
$staticRates=[PSCustomObject]@{ #IDEA:Konfiguracja aktualna na 26.12.2023 - https://nbp.pl/archiwum-kursow/tabela-nr-248-a-nbp-2023-z-dnia-2023-12-22/
    EUR_TO_PLN = 4.35
    USD_TO_PLN = 4.00
    GBP_TO_PLN = 5.00
    CHF_TO_PLN = 4.60
}

#endregion CONFIGURATION

#Pobranie danych z pliku txt i pogrupowanie wedle walut
$totalMoney=Get-MoneyFromFile -Path $MONEY_PATH | Group-MoneyToUSD

#Przeliczenie pieniędzy wedle kursów z dnia 26.12.2023
$totalMoneyStatic=[PSCustomObject]@{
    EUR = $totalMoney.EUR * $staticRates.EUR_TO_PLN
    USD = $totalMoney.USD * $staticRates.USD_TO_PLN
    GBP = $totalMoney.GBP * $staticRates.GBP_TO_PLN
    CHF = $totalMoney.CHF * $staticRates.CHF_TO_PLN

}

#Zapytania do kursów walut
$moneyDataFromApi=[PSCustomObject]@{
    EUR_TO_PLN = Invoke-NBPRestAPI -PathToApi "https://api.nbp.pl/api/exchangerates/rates/A/EUR?format=json" 
    USD_TO_PLN = Invoke-NBPRestAPI -PathToApi "https://api.nbp.pl/api/exchangerates/rates/A/USD?format=json" 
    GBP_TO_PLN = Invoke-NBPRestAPI -PathToApi "https://api.nbp.pl/api/exchangerates/rates/A/GBP?format=json" 
    CHF_TO_PLN = Invoke-NBPRestAPI -PathToApi "https://api.nbp.pl/api/exchangerates/rates/A/CHF?format=json" 
}
#Przeliczenie pieniędzy wedle aktualnych kursów
$totalMoneyDynamic=[PSCustomObject]@{
    EUR = $totalMoney.EUR * $moneyDataFromApi.EUR_TO_PLN
    USD = $totalMoney.USD * $moneyDataFromApi.USD_TO_PLN
    GBP = $totalMoney.GBP * $moneyDataFromApi.GBP_TO_PLN
    CHF = $totalMoney.CHF * $moneyDataFromApi.CHF_TO_PLN

}
#Sumaryczna ilość pieniedzy

#PODSUMOWANIE
$totalMoneyStatic

"--------------"


$totalMoneyDynamic

#>
