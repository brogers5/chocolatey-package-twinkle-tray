Import-Module PowerShellForGitHub

$installerFileNameRegex = 'Twinkle\.Tray\.v([\d\.]+(-beta\d)?)\.exe'
$owner = 'xanderfrangos'
$repository = 'twinkle-tray'

function Get-LatestVersionInfo {
    $releases = Get-GitHubRelease -OwnerName $owner -RepositoryName $repository

    $latestStableRelease = $releases | Where-Object { $_.PreRelease -eq $false } | Select-Object -First 1
    $latestStableVersion = $latestStableRelease.tag_name.Substring(1)

    $latestNonCanaryBeta = $releases | Where-Object { $_.PreRelease -eq $true -and $_.tag_name -match 'v.*-beta\d$' } | Select-Object -First 1
    $latestBetaVersion = $latestNonCanaryBeta.tag_name.Substring(1)

    $stableVersionInfo = @{
        Url64           = Get-SoftwareAssetUriFromRelease -Release $latestStableRelease
        Version         = $latestStableVersion #This may change if building a package fix version
        SoftwareVersion = $latestStableVersion
    }

    $betaVersionInfo = @{
        Url64           = Get-SoftwareAssetUriFromRelease -Release $latestNonCanaryBeta
        Version         = $latestBetaVersion #This may change if building a package fix version
        SoftwareVersion = $latestBetaVersion
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
