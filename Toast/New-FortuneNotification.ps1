function New-FortuneNotification
{
    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "3 Strings to pass to Notification")]
        [Alias("DOLLAR")]
        $dollarValue,
        [Parameter(HelpMessage = "3 Strings to pass to Notification")]
        [Alias("EURO")]
        $euroValue,
        [Parameter(HelpMessage = "3 Strings to pass to Notification")]
        [Alias("GOLD")]
        $goldValue
    )

$logo = New-BTImage -Source "money.png"
$header = New-BTHeader -Title "Informacja o twoich pieniądzach"

$sum=$dollarValue+$euroValue+$goldValue

New-BurntToastNotification -Text "Zysk w DOLLARACH: $dollarValue","Zysk w EURO: $euroValue","Zysk w ZŁOCIE: $goldValue" -AppLogo $logo -Header $header -Attribution "Sumaryczna wartość: $sum"
}
