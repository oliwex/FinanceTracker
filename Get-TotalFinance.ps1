#region CONFIGURATION
#funkcje
. "$PSScriptRoot\Money\Get-MoneyFromFile.ps1"
. "$PSScriptRoot\Money\Group-MoneyToUSD.ps1"
. "$PSScriptRoot\Money\Invoke-NBPRestAPI.ps1"

. "$PSScriptRoot\Metal\Get-TavexPrices.ps1"
. "$PSScriptRoot\Metal\Get-MetalPrice.ps1"
. "$PSScriptRoot\Metal\Get-MetalFromFile.ps1"

. "$PSScriptRoot\Toast\New-FortuneNotification.ps1"

#sciezki
$MONEY_PATH="E:\GIT\FinanceTracker\Money\money.txt"
$METAL_PATH="E:\GIT\FinanceTracker\Metal\metal.txt"

#zmienne
<#
$staticRates=[PSCustomObject]@{ #IDEA:Konfiguracja aktualna na 26.12.2023 - https://nbp.pl/archiwum-kursow/tabela-nr-248-a-nbp-2023-z-dnia-2023-12-22/
    EUR_TO_PLN = 4.35
    USD_TO_PLN = 4.00
    GBP_TO_PLN = 5.00
    CHF_TO_PLN = 4.60
}
#>
#endregion CONFIGURATION

#region MONEY
#Pobranie danych z pliku txt i pogrupowanie wedle walut
$totalMoney=Get-MoneyFromFile -Path $MONEY_PATH | Group-MoneyToUSD
<#
#Przeliczenie pieniędzy wedle kursów z dnia 26.12.2023
$totalMoneyStatic=[PSCustomObject]@{
    EUR = $totalMoney.EUR * $staticRates.EUR_TO_PLN
    USD = $totalMoney.USD * $staticRates.USD_TO_PLN
    GBP = $totalMoney.GBP * $staticRates.GBP_TO_PLN
    CHF = $totalMoney.CHF * $staticRates.CHF_TO_PLN

}
#>

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

#PODSUMOWANIE pieniędzy
#$totalMoneyStatic

"-------------------------"
#$totalMoneyDynamic


#endregion MONEY

#region GOLD

#Sztabki złota
#Pobranie danych z pliku dotyczących sztabek złota
$result=Get-MetalFromFile -path $METAL_PATH


#Pobranie cen złota wedle aktualnych kursów
$goldPrice=Get-MetalPrice -symbol XAU -currency PLN | Select-Object timestamp,metal,currency,exchange,price,ch,ask,bid,price_gram_24k



#Pobranie cen sztabek złota 1oz ze sklepu TAVEX
#$urlGoldBar = 'https://tavex.pl/zloto/zlote-monety-bulionowe/page/1?filter%5Bweight%5D%5B0%5D=1&meta%5B0%5D=tax-gold%3Azlote-monety-bulionowe&sorting=recommended'

#Get-TAVEXPrices -TavexURL $urlGoldBar

#Pobranie cen monet złotych 1oz ze sklepu TAVEX
#$urlCoin = 'https://tavex.pl/zloto/zlote-sztabki/?filter%5Bweight%5D%5B0%5D=1&meta%5B0%5D=tax-gold%3Azlote-sztabki&sorting=recommended'

#Get-TAVEXPrices -TavexURL $urlCoin
#>

#endregion GOLD

#region RESULT


#$sum=([Math]::Round($($goldPrice.price*$([double]$result.AMOUNT)),2))

New-FortuneNotification -DOLLAR $totalMoneyDynamic.USD -EURO $totalMoneyDynamic.EUR -GOLD $([Math]::Round($($goldPrice.price*$result.AMOUNT),2))

#endregion RESULT
