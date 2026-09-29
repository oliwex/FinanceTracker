. "$PSScriptRoot\Test-RegistryKeyValue.ps1"

function Get-RegistryValue
{
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        $fortunePath
    )
    $result=[PSCustomObject]@{}
    if(Test-RegistryKeyValue -Path "$fortunePath\USD" -Name "USD")
    {
       $result | Add-Member -MemberType NoteProperty -Name USD -Value $(Get-ItemPropertyValue -Path "$fortunePath\USD" -Name USD)
    }
    if(Test-RegistryKeyValue -Path "$fortunePath\EUR" -Name "EUR")
    {
        $result | Add-Member -MemberType NoteProperty -Name EUR -Value $(Get-ItemPropertyValue -Path "$fortunePath\EUR" -Name EUR)
    }
    if(Test-RegistryKeyValue -Path "$fortunePath\GOLD" -Name "GOLD")
    {
        $result | Add-Member -MemberType NoteProperty -Name GOLD -Value $(Get-ItemPropertyValue -Path "$fortunePath\GOLD" -Name GOLD)
    }
    $result
}


#Get-RegistryValue -path "HKCU:\FORTUNE"