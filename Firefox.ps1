
function get-LatestFirefoxURL {
[cmdletbinding()]
[outputtype([String])]
param(
    [ValidateSet("bn-BD","bn-IN","en-CA","en-GB","en-ZA","es-AR","es-CL","es-ES","es-MX")][string]$culture = "en-US",
    [ValidateSet("win32","win64")][string]$architecture="win32"

)

# JSON that provide details on Firefox versions
$uriSource = "https://product-details.mozilla.org/1.0/firefox_versions.json"

# Read the JSON and convert to a PowerShell object
$firefoxVersions = (Invoke-WebRequest -uri $uriSource).Content | ConvertFrom-Json

$VersionURL = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/$($firefoxVersions.LATEST_FIREFOX_VERSION)/$($architecture)/$($culture)/Firefox%20Setup%20$($FFLatestVersion).exe"
Write-Output $VersionURL
}

get-LatestFirefoxURL