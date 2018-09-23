function Get-GreenShotURL {
    [cmdletbinding()]
    [outputtype([string])]
    $GreenshotURL="http://getgreenshot.org/downloads/"
    $raw = (wget -Uri $GreenshotURL).content
    #we are looking for the github download
    $pattern = "https:\/\/github\.com.+\.exe"
    #split into lines, then split into tags, #$%^ is arbitrary
    $multiline = $raw.split("`n").trim().replace("<","#$%^<").split("#$%^")
    #find the html tag containing the github url
    $urlline = ($multiline | select-string -Pattern $pattern).tostring().trim()
    #url line now looks like this
    #<a href="https://github.com/greenshot/greenshot/releases/download/Greenshot-RELEASE-1.2.10.6/Greenshot-INSTALLER-1.2.10.6-RELEASE.exe">
    #strip out the html tags
    $greenshotURL = $urlline.replace('<a href="','').replace('">','')
    Write-Output $GreenshotURL    
}

function Get-GreenShotVersion {
    [cmdletbinding()]
    [outputtype([Version])]
    $GreenshotURL = Get-GreenShotURL
    $versionPattern = "\d+\.\d+\.\d+\.\d+"
    #get the URL and split it on the forward slash, then look for the version pattern
    $productTitle=($GreenshotURL.split("/") | select-string -Pattern $versionPattern | Select-Object -First 1).tostring().trim()
    #there will be two because they put the version in the EXE and also in the path as a subfolder.
    $GreenshotVersion = [VERSION]::new(($productTitle.split('-') | select-string -Pattern $versionPattern | Select-Object -First 1).tostring().trim())
    write-output $GreenshotVersion
}

#usage 
Get-GreenShotURL
Get-GreenShotVersion

