#region CONFIGURATION
#funkcje
. "$PSScriptRoot\Money\Get-MoneyFromFile.ps1"
. "$PSScriptRoot\Money\Group-MoneyToUSD.ps1"
. "$PSScriptRoot\Money\Invoke-NBPRestAPI.ps1"

. "$PSScriptRoot\Metal\Get-MetalPrice.ps1"
. "$PSScriptRoot\Metal\Get-MetalFromFile.ps1"

. "$PSScriptRoot\Toast\New-FortuneNotification.ps1"

#sciezki
$MONEY_PATH="E:\GIT\FinanceTracker\Money\money.txt"
$METAL_PATH="E:\GIT\FinanceTracker\Metal\metal.txt"

#zmienne

#endregion CONFIGURATION

#region MONEY
#Pobranie danych z pliku txt i pogrupowanie wedle walut
$totalMoneyDataFromFile=Get-MoneyFromFile -Path $MONEY_PATH | Group-MoneyToUSD

#Zapytania do kursów walut
$moneyPriceFromApi=[PSCustomObject]@{
    EUR_TO_PLN = Invoke-NBPRestAPI -CurrencySymbol "EUR" 
    USD_TO_PLN = Invoke-NBPRestAPI -CurrencySymbol "USD"
    GBP_TO_PLN = Invoke-NBPRestAPI -CurrencySymbol "GBP"
    CHF_TO_PLN = Invoke-NBPRestAPI -CurrencySymbol "CHF"
}

#Przeliczenie pieniędzy wedle aktualnych kursów
$totalMoneyData=[PSCustomObject]@{
    EUR = $totalMoneyDataFromFile.EUR * $moneyPriceFromApi.EUR_TO_PLN
    USD = $totalMoneyDataFromFile.USD * $moneyPriceFromApi.USD_TO_PLN
    GBP = $totalMoneyDataFromFile.GBP * $moneyPriceFromApi.GBP_TO_PLN
    CHF = $totalMoneyDataFromFile.CHF * $moneyPriceFromApi.CHF_TO_PLN

}

#endregion MONEY

#region GOLD

#Sztabki złota
#Pobranie danych z pliku dotyczących sztabek złota
$totalMetalDataFromFile=Get-MetalFromFile -path $METAL_PATH

#Pobranie cen złota wedle aktualnych kursów
$goldPriceFromAPI=(Get-MetalPrice -symbol XAU -currency PLN).price #IDEA: W przypadku rozszerzenia skryptu można tutaj pobrać wiecej informacji

#endregion GOLD

#region RESULT

#Wypisanie informacji o obecnie posiadanym majątku

$totalFortune=[PSCustomObject]@{
    GOLD = $([Math]::Round($($goldPriceFromAPI*$totalMetalDataFromFile.AMOUNT),3))
    USD = $totalMoneyData.USD
    EUR = $totalMoneyData.EUR
}

New-FortuneNotification -DOLLAR $totalFortune.USD -EURO $totalFortune.EUR -GOLD $totalFortune.GOLD -Sum $($totalFortune.GOLD+$totalFortune.USD+$totalFortune.EUR) #TODO:Jeśli na przestrzni odczytów jest zysk to strzałka w górę, jeśli strata to strzałka w dół

#endregion RESULT

 