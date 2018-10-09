function get-NPPCurrentVersion {
    [cmdletbinding()]
    [outputtype([version])]
    $url = "https://notepad-plus-plus.org/"
    $content = wget -Uri $url
    #pipe this match to out-null so it does not corrupt the pipeline
    ($content.allelements | ? id -eq "download").innerText -match "\d+\.\d+\.\d+" | out-null
    $ver = [version]::new($Matches[0])
    Write-Output $ver
}

function get-NPPCurrentDownloadURL {
    [cmdletbinding()]
    [outputtype([string])]
    param (
        [validateSet("x86","x64")][string]$Architecture = "x64"
    )
    $version = get-NPPCurrentVersion
    if ("x86" -eq $Architecture) { $archcode = "" } else { $archcode = ".x64" }
    $url = "https://notepad-plus-plus.org/repository/$($version.major).x/$version/npp.$($version).Installer$($archcode).exe"
    Write-Output $url
}

#Example get-NPPCurrentDownloadURL -Architecture x64

#Example wget -uri (get-NPPCurrentDownloadURL) -OutFile .\npp.exe