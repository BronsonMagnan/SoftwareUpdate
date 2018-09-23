Function Get-PaintDotNetURl {
    [cmdletbinding()]
    [outputType([string])]
    $sourceUrl = "https://www.dotpdn.com/downloads/pdn.html"
    $raw = (wget -UseBasicParsing -Uri $sourceUrl)
    $multiline = $raw.content.split("`n").trim()
    $justtags = $multiline.replace("<","#$%^<").split("#$%^")
    $pattern = "paint\.net\S*(\d+\.)+\d\S*\.(zip|exe)"
    #https://www.dotpdn.com/files/paint.net.4.1.1.install.zip
    $relativehtml = ($justtags | Select-String -Pattern $pattern | Select-Object -First 1).tostring().trim()
    $relativeURL = $relativehtml.replace('<a href="','').replace('">','')
    $dotdotreplacement = "https://www.dotpdn.com"
    $finalurl = $relativeURL.replace("..",$dotdotreplacement)
    Write-Output $finalurl
}


function Get-PaintDotNetVersion {
    [cmdletbinding()]
    [outputType([Version])]
    $downloadurl = Get-PaintDotNetURl
    $filename = ($downloadurl.split('/') | select-string -Pattern "(\d+\.)+\d+" | select-object -first 1).tostring().trim()
    $filename -match "(\d+\.)+\d+" | Out-Null
    $fileversion = [Version]::new($matches[0])
    Write-Output $fileversion
}

Get-PaintDotNetURl
Get-PaintDotNetVersion

