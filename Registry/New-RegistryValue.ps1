function New-RegistryValue 
{
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        $fortune
    )

    begin {
        if (-not (Test-Path "HKCU:\FORTUNE")) 
        {
            New-Item -Path HKCU:\ -Name "FORTUNE" -ItemType Directory | Out-Null
        }
    }

    process {

        New-Item -Path "HKCU:\FORTUNE" -Name $fortune.Name -ItemType RegistryKey | Out-Null
        
        New-ItemProperty -Path "HKCU:\FORTUNE\$($fortune.Name)" -Name $($fortune.Name) -Value $fortune.Value -PropertyType String | Out-Null

    }
}


$total=[PSCustomObject]@{
    USD = 123
    EUR = 456
    GOLD = 789
}

#$total.PsObject.Properties
#$total.PsObject.Members.Value



$total.PSObject.Properties | New-RegistryValue