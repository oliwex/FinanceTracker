function New-FortuneNotification
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,HelpMessage = "USD Fortune")]
        [Alias("DOLLAR")]
        $dollarValue,
        [Parameter(Mandatory,HelpMessage = "EURO Fortune")]
        [Alias("EURO")]
        $euroValue,
        [Parameter(Mandatory,HelpMessage = "GOLD Fortune")]
        [Alias("GOLD")]
        $goldValue,
        [Parameter(Mandatory,HelpMessage = "All Fortune")]
        [Alias("Sum")]
        $all

    )

$logo = New-BTImage -Source "$([System.Environment]::CurrentDirectory)\Toast\money.png"
$header = New-BTHeader -Title "Informacja o twoich pieniądzach"

New-BurntToastNotification -Text "Zysk w DOLLARACH: $dollarValue","Zysk w EURO: $euroValue","Zysk w ZŁOCIE: $goldValue" -AppLogo $logo -Header $header -Attribution "Sumaryczna wartość: $all"
}

