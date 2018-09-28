
function Get-CurrentControlUpAgentVersion {
    [cmdletbinding()]
    [outputType([version])]
    param()
    $agentURL = "http://www.controlup.com/products/controlup/agent/"
    #ControlUP forces TLS 1.2 and rejects TLS 1.1
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $webrequest = wget -Uri $agentURL -UseBasicParsing
    $content = $webrequest.Content
    #clean up the code into paragraph blocks
    $paragraphSections = $content.replace("`n","").replace("  ","").replace("`t","").replace("<p>","#$%^<p>").split("#$%^").trim()
    #now we are looking for the pattern <p><strong>Current agent version:</strong> 7.2.1.6</p>
    $versionLine = $paragraphSections  | where {$_ -like "*Current*agent*"}
    $splitlines = ($versionLine.replace('<','#$%^<').replace('>','>#$%^').split('#$%^')).trim()
    $pattern = "(\d+\.){3}\d+"
    $version = [Version]::new(($splitlines | select-string -Pattern $pattern).tostring())
    Write-Output $version
}

function Get-CurrentControlUpAgentURL {
    [cmdletBinding()]
    [outputType([string])]
    param(
        [validateSet("net45","net35")]
        [string]$netversion = "net45",
        [validateSet("x86","x64")]
        [string]$architecture = "x64"
    )
    $version = Get-CurrentControlUpAgentVersion
    $DownloadURL = "https://downloads.controlup.com/agent/$($version.tostring())/ControlUpAgent-$($netversion)-$($architecture).msi"
    Write-Output $DownloadURL
}

#Example
#Get-CurrentControlUpAgentURL -netversion net45 -architecture x64

