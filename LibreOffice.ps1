
function Get-CurrentLibreOfficeVersion {
    [cmdletbinding()]
    [outputType([version])]
    param (
        [validateset("Latest","Business")][string]$Release = "Latest"
    )
    $LOFrontPage = "https://www.libreoffice.org/download/download/"
    $response = wget -UseBasicParsing -Uri $LOFrontPage
    $content = $response.Content
    #Search for their big green logo version number '<span class="dl_version_number">*</span>'
    $spans = $content.replace('<span','#$%^<span').replace('</span>','</span>#$%^').split('#$%^') | where {$_ -like '<span class="dl_version_number">*</span>'}
    $verblock = ($spans).replace('<span class="dl_version_number">','').replace('</span>','')
    if ($Release -eq "Latest") {
        $version = [version]::new( $( $verblock | Select-Object -First 1 ) )
    } else { 
        $version = [version]::new( $( $verblock | Select-Object -Last 1 ) )
    }
    Write-Output $version
}

#Example Get-CurrentLibreOfficeVersion -Release Business
function Get-CurrentLibreOfficeDownloadUrl {
    [cmdletbinding()]
    [outputType([string])]
    param (
        [validateset("Latest","Business")][string]$Release = "Latest"
    )
    $CurrentVersion = Get-CurrentLibreOfficeVersion -Release $Release
    $DownloadURL = "https://download.documentfoundation.org/libreoffice/stable/$($CurrentVersion.tostring())/win/x86_64/LibreOffice_$($CurrentVersion.tostring())_Win_x64.msi"
    Write-Output $DownloadURL
}


#Examples
# wget -Uri (Get-CurrentLibreOfficeDownloadUrl) -OutFile .\LibreOffice.msi
# wget -Uri (Get-CurrentLibreOfficeDownloadUrl -release Business) -OutFile .\LibreOffice.msi