function get-LatestFirefoxESRURL {
[cmdletbinding()]
[outputtype([String])]
param(
    [ValidateSet("bn-BD","bn-IN","en-CA","en-GB","en-ZA","es-AR","es-CL","es-ES","es-MX")][string]$culture = "en-US",
    [ValidateSet("win32","win64")][string]$architecture="win64"

)

# JSON that provide details on Firefox versions
$uriSource = "https://product-details.mozilla.org/1.0/firefox_versions.json"

# Read the JSON and convert to a PowerShell object
$firefoxVersions = (Invoke-WebRequest -uri $uriSource).Content | ConvertFrom-Json

$VersionURL = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/$($firefoxVersions.FIREFOX_ESR)/$($architecture)/$($culture)/Firefox%20Setup%20$($firefoxVersions.FIREFOX_ESR).exe"
Write-Output $VersionURL
}

function get-LatestFirefoxESRVersion {
[cmdletbinding()]
[outputtype([String])]
param(
    [ValidateSet("bn-BD","bn-IN","en-CA","en-GB","en-ZA","es-AR","es-CL","es-ES","es-MX")][string]$culture = "en-US",
    [ValidateSet("win32","win64")][string]$architecture="win64"

)

# JSON that provide details on Firefox versions
$uriSource = "https://product-details.mozilla.org/1.0/firefox_versions.json"

# Read the JSON and convert to a PowerShell object
$firefoxVersions = (Invoke-WebRequest -uri $uriSource).Content | ConvertFrom-Json

$Version = [Version]$firefoxVersions.FIREFOX_ESR.replace("esr","")
Write-Output $Version
}

get-LatestFirefoxESRURL
get-LatestFirefoxESRVersion

