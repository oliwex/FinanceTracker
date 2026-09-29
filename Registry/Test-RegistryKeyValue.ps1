#IDEA https://www.powershellgallery.com/packages/Carbon/2.1.0/Content/Functions%5CTest-RegistryKeyValue.ps1

function Test-RegistryKeyValue
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $path,
        [Parameter(Mandatory=$true)]
        [string]
        $name
    )

    if( -not (Test-Path -Path $path -PathType Container) ) #Sprawdzenie, czy istnieje folder w danej ścieżce
    {
        return $false
    }
    $properties = Get-ItemProperty -Path $path 
    if( -not $properties )
    {
        return $false
    }

    $member = Get-Member -InputObject $properties -Name $name
    if( $member ) #Sprawdzenie, czy istnieje element na samym końcu ścieżki
    {
        return $true
    }
    else
    {
        return $false
    }

}

#Test-RegistryKeyValue -Path 'HKCU:\FORTUNE\EUR' -Name 'EUR'
#Test-RegistryKeyValue -Path 'HKCU:\FORTUNE\GOLD' -Name 'GOLD'
#Test-RegistryKeyValue -Path 'HKCU:\FORTUNE\USD' -Name 'USD'