﻿function Get-VMWareToolsVersion {
    [cmdletbinding()]
    [outputtype([Version])]
    $vmwaretools = "https://packages.vmware.com/tools/esx/latest/windows/x64/index.html"
    $pattern = "[0-9]+\.[0-9]+\.[0-9]+\-[0-9]+\-x86_64"
    #get the raw page content
    $pagecontent=(wget -Uri $vmwaretools).content
    #change one big string into many strings, then find only the line with the version number
    $interestingLine = ($pagecontent.split("`n") | Select-string -Pattern $pattern).tostring().trim()
    #remove the whitespace and split on the assignment operator, then split on the double quote and select the correct item
    $filename = (($interestingLine.replace(" ","").split("=") | Select-string -Pattern $pattern).tostring().trim().split("`""))[1]
    #file name is in the format "VMware-tools-10.2.1-8267844-x86_64.exe"
    #convert to a .NET version class, that can be used to compare against other version objects
    $version = [version]$filename.Replace("VMware-tools-","").replace("-x86_64.exe","").replace("-",".")
    #return the version object
    Write-Output $version
}

function Get-VMWareToolsURL {
    [cmdletbinding()]
    [outputtype([string])]
    $vmwaretools = "https://packages.vmware.com/tools/esx/latest/windows/x64/index.html"
    $pattern = "[0-9]+\.[0-9]+\.[0-9]+\-[0-9]+\-x86_64"
    #get the raw page content
    $pagecontent=(wget -Uri $vmwaretools).content
    #change one big string into many strings, then find only the line with the version number
    $interestingLine = ($pagecontent.split("`n") | Select-string -Pattern $pattern).tostring().trim()
    #remove the whitespace and split on the assignment operator, then split on the double quote and select the correct item
    $filename = (($interestingLine.replace(" ","").split("=") | Select-string -Pattern $pattern).tostring().trim().split("`""))[1]
    $url = "https://packages.vmware.com/tools/esx/latest/windows/x64/$($filename)"
    Write-Output $url
}

function Check-ForLatestVMWareTools {
[cmdletbinding()]
[outputtype([boolean])]
param (
    [parameter(mandatory=$true)]
    [validateNotNullOrEmpty()]
    [string]$path
)
    $fileversion = [version](Get-ChildItem -Path $path | Select-Object -ExpandProperty versioninfo).fileversion
    $currentversion = Get-VMWareToolsVersion
    if ($currentversion -gt $fileversion) {
        return $false
    } else {
        return $true
    }
}


#Example: Check-ForLatestVMWareTools -path .\tools.exe

