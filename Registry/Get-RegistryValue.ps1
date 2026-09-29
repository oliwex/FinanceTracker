. "$PSScriptRoot\Test-RegistryKeyValue.ps1"

function Get-RegistryValue
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,HelpMessage="RegistryPath to save fortune data")]
        [Alias("RegistryPath")]
        $fortunePath
    )
    $fortuneObject=[PSCustomObject]@{}
    $fortuneValueUSD=if(Test-RegistryKeyValue -Path "$fortunePath\USD" -Name "USD")
    {
        $(Get-ItemPropertyValue -Path "$fortunePath\USD" -Name USD)
    }
    else 
    {
        0
    }
    $fortuneObject | Add-Member -MemberType NoteProperty -Name USD -Value $fortuneValueUSD

    $fortuneValueEUR=if(Test-RegistryKeyValue -Path "$fortunePath\EUR" -Name "EUR")
    {
        $(Get-ItemPropertyValue -Path "$fortunePath\EUR" -Name EUR)
    }
    else 
    {
        0
    }
    $fortuneObject | Add-Member -MemberType NoteProperty -Name EUR -Value $fortuneValueEUR
    
    $fortuneValueGOLD=if(Test-RegistryKeyValue -Path "$fortunePath\GOLD" -Name "GOLD")
    {
        $(Get-ItemPropertyValue -Path "$fortunePath\GOLD" -Name GOLD)
    }
    else 
    {
        0
    }
    $fortuneObject | Add-Member -MemberType NoteProperty -Name GOLD -Value $fortuneValueGOLD

    $fortuneObject
}


#Get-RegistryValue -RegistryPath "HKCU:\FORTUNE"