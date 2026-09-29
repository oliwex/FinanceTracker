#region CONFIGURATION
#funkcje

#Audio
. "$PSScriptRoot\Audio\New-AudioNotification.ps1"

#Metal
. "$PSScriptRoot\Metal\Get-MetalPrice.ps1"
. "$PSScriptRoot\Metal\Get-MetalFromFile.ps1"

#Money
. "$PSScriptRoot\Money\Get-MoneyFromFile.ps1"
. "$PSScriptRoot\Money\Group-MoneyToUSD.ps1"
. "$PSScriptRoot\Money\Invoke-NBPRestAPI.ps1"

#Registry
. "$PSScriptRoot\Registry\Get-RegistryValue.ps1"
. "$PSScriptRoot\Registry\New-RegistryValue.ps1"
. "$PSScriptRoot\Registry\Test-RegistryKeyValue.ps1"

#Toast
. "$PSScriptRoot\Toast\New-FortuneNotification.ps1"



#sciezki
$MONEY_PATH="E:\GIT\FinanceTracker\Money\money.txt"
$METAL_PATH="E:\GIT\FinanceTracker\Metal\metal.txt"

#zmienne

#endregion CONFIGURATION

#Wczytanie danych z rejestru
$fortuneValueFromRegistry=Get-RegistryValue -RegistryPath "HKCU:\FORTUNE"

#while($false)
#{
    #Odczyt wartości majątku z sieci

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

    #Pobranie danych z pliku dotyczących sztabek złota
    $totalMetalDataFromFile=Get-MetalFromFile -path $METAL_PATH

    #Pobranie cen złota wedle aktualnych kursów
    $goldPriceFromAPI=(Get-MetalPrice -symbol XAU -currency PLN).price #IDEA: W przypadku rozszerzenia skryptu można tutaj pobrać wiecej informacji
    
    $totalFortune=[PSCustomObject]@{
        GOLD = $([Math]::Round($($goldPriceFromAPI*$totalMetalDataFromFile.AMOUNT),2))
        USD = $([Math]::Round($totalMoneyData.USD,2))
        EUR = $([Math]::Round($totalMoneyData.EUR,2))
    }

    New-FortuneNotification -DOLLAR $totalFortune.USD -EURO $totalFortune.EUR -GOLD $totalFortune.GOLD -Sum $($totalFortune.GOLD+$totalFortune.USD+$totalFortune.EUR) #TODO:Jeśli na przestrzni odczytów jest zysk to strzałka w górę, jeśli strata to strzałka w dół

    New-AudioNotification -Text "Kasa to: 14124"

    
   if (($fortuneValueFromRegistry.USD -ne 0) -and ($fortuneValueFromRegistry.EUR -ne 0) -and ($fortuneValueFromRegistry.GOLD -ne 0))
    {
        #Dane są w rejestrze
        "Dane są w rejestrze"
        #Podmiana wartości z rejestru, wartościami odczytanymi z sieci
    }
    else 
    {

        #Danych nie ma w rejestrze
        
        #Zapisanie danych odczytanych z sieci do rejestru
        $totalFortune.PSObject.Properties | New-RegistryValue
    }
   
   
    
#    Start-Sleep -Seconds $(3600) #Odczekanie godziny na kolejny odczyt
#}


#endregion RESULT

