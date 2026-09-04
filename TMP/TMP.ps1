
$staticRates=[PSCustomObject]@{ #IDEA:Konfiguracja aktualna na 26.12.2023 - https://nbp.pl/archiwum-kursow/tabela-nr-248-a-nbp-2023-z-dnia-2023-12-22/
    EUR_TO_PLN = 4.35
    USD_TO_PLN = 4.00
    GBP_TO_PLN = 5.00
    CHF_TO_PLN = 4.60
}

#Przeliczenie pieniędzy wedle kursów z dnia 26.12.2023
$totalMoneyStatic=[PSCustomObject]@{
    EUR = $totalMoney.EUR * $staticRates.EUR_TO_PLN
    USD = $totalMoney.USD * $staticRates.USD_TO_PLN
    GBP = $totalMoney.GBP * $staticRates.GBP_TO_PLN
    CHF = $totalMoney.CHF * $staticRates.CHF_TO_PLN

}

#Sumaryczna ilość pieniedzy
$totalMoneyStatic


$totalMoneyDynamic

#Pobranie cen sztabek złota 1oz ze sklepu TAVEX
$urlGoldBar = 'https://tavex.pl/zloto/zlote-monety-bulionowe/page/1?filter%5Bweight%5D%5B0%5D=1&meta%5B0%5D=tax-gold%3Azlote-monety-bulionowe&sorting=recommended'

Get-TAVEXPrices -TavexURL $urlGoldBar

#Pobranie cen monet złotych 1oz ze sklepu TAVEX
$urlCoin = 'https://tavex.pl/zloto/zlote-sztabki/?filter%5Bweight%5D%5B0%5D=1&meta%5B0%5D=tax-gold%3Azlote-sztabki&sorting=recommended'

Get-TAVEXPrices -TavexURL $urlCoin