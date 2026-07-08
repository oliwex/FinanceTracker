function Invoke-NBPRestAPI {
    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "Api Path to get rates from NBP",Position=0,ValueFromPipeline)]
        [Alias("PathToApi")]
        $url        
    )
    begin {}
    process {
        try 
        {
            (Invoke-RestMethod -Uri $url -Method Get).rates.mid
        }
        catch {
            Write-Warning "Brak możliwości dostępu do API NBP"
        }
        
        
    }
    end {}
}