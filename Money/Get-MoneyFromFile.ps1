#TODO:W ostatnim else zrobić parser dla waluty

function Get-MoneyFromFile
{
    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "FilePath to get computernames",Position=0)]
        [Alias("FilePath")]
        [string]$path
    )
    foreach($line in [System.IO.File]::ReadLines($path))
    {
        if ($line -like "*Element:Money*")
        {
            "Pieniądze"
        }
        elseif  ($line -like "*Group*")
        {
            $groupName=$line
        }
        else
        {
            [PSCustomObject]@{
                GROUP = $groupName
                AMOUNT = $line.Substring(0,$line.Length-3)
                CURRENCY = $line.Substring($line.Length-3)
            }
        }

    }
}
