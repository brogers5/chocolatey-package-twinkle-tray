Import-Module PowerShellForGitHub

$installerFileNameRegex = 'Twinkle\.Tray\.v([\d\.]+(-beta\d)?)\.exe'
$owner = 'xanderfrangos'
$repository = 'twinkle-tray'

function Get-LatestVersionInfo {
    $releases = Get-GitHubRelease -OwnerName $owner -RepositoryName $repository

    $latestStableRelease = $releases | Where-Object { $_.PreRelease -eq $false } | Select-Object -First 1
    $latestStableVersion = $latestStableRelease.tag_name.Substring(1)

    $latestPreRelease = $releases | Where-Object { $_.PreRelease -eq $true } | Select-Object -First 1
    $latestPreReleaseVersion = $latestPreRelease.tag_name.Substring(1)

    $stableVersionInfo = @{
        Url64           = Get-SoftwareAssetUriFromRelease -Release $latestStableRelease
        Version         = $latestStableVersion #This may change if building a package fix version
        SoftwareVersion = $latestStableVersion
    }

    if ($latestPreReleaseVersion -notmatch '-beta\d$') {
        #Pad package version with pre-release string to respect user's update channel preferences
        $preReleasePackageVersion = "$latestPreReleaseVersion-beta"
    }
    else {
        $preReleasePackageVersion = $latestPreReleaseVersion
    }

    $betaVersionInfo = @{
        Url64           = Get-SoftwareAssetUriFromRelease -Release $latestPreRelease
        Version         = $preReleasePackageVersion #This may change if building a package fix version
        SoftwareVersion = $latestPreReleaseVersion
    }

    return [Ordered] @{
        Beta   = $betaVersionInfo
        Stable = $stableVersionInfo
    }
}

function Get-SoftwareAssetUriFromRelease($Release) {
    $releaseAssets = Get-GitHubReleaseAsset -OwnerName $owner -RepositoryName $repository -Release $release.ID

    $windowsInstallerAsset = $null
    foreach ($asset in $releaseAssets) {
        if ($asset.name -match $installerFileNameRegex) {
            $windowsInstallerAsset = $asset
            break;
        }
        else {
            continue;
        }
    }

    if ($null -eq $windowsInstallerAsset) {
        throw "Cannot find published Windows installer asset!"
    }

    return $windowsInstallerAsset.browser_download_url
}

function Get-SoftwareUri($Version) {
    #TODO: Add entries for any package version deviations from the software version (e.g. pre-release versions without a trailing string, package fix versions)
    switch ($Version) {
        '1.15.3-beta' { $softwareVersion = '1.15.3' }
        default { $softwareVersion = $Version }
    }
    
    $release = Get-GitHubRelease -OwnerName $owner -RepositoryName $repository -Tag "v$($softwareVersion.ToString())"

    return Get-SoftwareAssetUriFromRelease -Release $release
}
