Import-Module PowerShellForGitHub

$installerFileNameRegex = 'Twinkle\.Tray\.v([\d\.]+(-beta\d)?)\.exe'
$owner = 'xanderfrangos'
$repository = 'twinkle-tray'

function Get-LatestVersionInfo
{
    $releases = Get-GitHubRelease -OwnerName $owner -RepositoryName $repository

    $latestStableRelease = $releases | Where-Object { $_.PreRelease -eq $false } | Select-Object -First 1
    $latestStableVersion = $latestStableRelease.tag_name.Substring(1)

    $latestPreRelease = $releases | Where-Object { $_.PreRelease -eq $true } | Select-Object -First 1
    $latestPreReleaseVersion = $latestPreRelease.tag_name.Substring(1)

    $stableVersionInfo = @{
        Url64 = Get-SoftwareAssetUriFromRelease -Release $latestStableRelease
        Version = $latestStableVersion #This may change if building a package fix version
        SoftwareVersion = $latestStableVersion
    }

    $betaVersionInfo = @{
        Url64 = Get-SoftwareAssetUriFromRelease -Release $latestPreRelease
        Version = $latestPreReleaseVersion #This may change if building a package fix version
        SoftwareVersion = $latestPreReleaseVersion
    }

    return [Ordered] @{
        Beta = $betaVersionInfo
        Stable = $stableVersionInfo
    }
}

function Get-SoftwareAssetUriFromRelease($Release)
{
    $releaseAssets = Get-GitHubReleaseAsset -OwnerName $owner -RepositoryName $repository -Release $release.ID

    $windowsInstallerAsset = $null
    foreach ($asset in $releaseAssets)
    {
        if ($asset.name -match $installerFileNameRegex)
        {
            $windowsInstallerAsset = $asset
            break;
        }
        else {
            continue;
        }
    }

    if ($null -eq $windowsInstallerAsset)
    {
        throw "Cannot find published Windows installer asset!"
    }

    return $windowsInstallerAsset.browser_download_url
}

function Get-SoftwareUri($Version)
{
    $release = Get-GitHubRelease -OwnerName $owner -RepositoryName $repository -Tag "v$($Version.ToString())"

    return Get-SoftwareAssetUriFromRelease -Release $release
}
