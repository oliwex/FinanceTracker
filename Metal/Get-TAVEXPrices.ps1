function Get-TAVEXPrices 
{
    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "URL to get data from Tavex Website",Position=0,ValueFromPipeline)]
        [Alias("TavexURL")]
        $url
    )

    Import-Module PSParseHTML

    $html = Invoke-WebRequest -Uri $url -UseBasicParsing
    $doc  = ConvertFrom-Html -Content $html.Content -Engine AngleSharp

    $selector = @'
    .js-product-archive-results
    .product.js-product:has(.product__price-value[data-type="sell"])
'@
    $doc.QuerySelectorAll($selector) | ForEach-Object {
        [pscustomobject]@{
            Name  = $_.QuerySelector('.product__title-inner').TextContent.Trim()
            Price = $_.QuerySelector(
                '.product__price--single .product__price-value[data-type="sell"]'
            ).TextContent.Trim()
        }
    } | Format-Table -AutoSize
}
