
function get-LatestFirefoxURL {
[cmdletbinding()]
[outputtype([String])]
param(
    [ValidateSet("bn-BD","bn-IN","en-CA","en-GB","en-ZA","es-AR","es-CL","es-ES","es-MX")][string]$culture = "en-US",
    [ValidateSet("win32","win64")][string]$architecture="win32"

)

$FFReleaseNoticeURL = "https://www.mozilla.org/en-US/firefox/releases/"
$FFLatestVersion = ((wget -uri $FFReleaseNoticeURL | % content).split() | Select-String -Pattern 'data-latest-firefox="*"').tostring().split('"')[1]
$VersionURL = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/$($FFLatestVersion)/$($architecture)/$($culture)/Firefox%20Setup%20$($FFLatestVersion).exe"
Write-Output $VersionURL
}

get-LatestFirefoxURL