Import-Module au

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition)
. $currentPath\helpers.ps1

$toolsPath = Join-Path -Path $currentPath -ChildPath "tools"
$softwareRepo = 'xanderfrangos/twinkle-tray'

function global:au_GetLatest {
    return @{
        Url64 = Get-SoftwareUri
        Version = Get-LatestStableVersion
    }
}

function global:au_BeforeUpdate ($Package)  {
    Get-RemoteFiles -Purge -NoSuffix -Algorithm sha256

    Copy-Item -Path "$toolsPath\VERIFICATION.txt.template" -Destination "$toolsPath\VERIFICATION.txt" -Force

    Set-DescriptionFromReadme -Package $Package -ReadmePath ".\DESCRIPTION.md"
}

function global:au_AfterUpdate ($Package)  {
    $licenseUri = "https://raw.githubusercontent.com/$($softwareRepo)/v$($Latest.Version)/LICENSE"
    $licenseContents = Invoke-WebRequest -Uri $licenseUri -UseBasicParsing

    Set-Content -Path 'tools\LICENSE.txt' -Value "From: $licenseUri`r`n`r`n$licenseContents"
}

function global:au_SearchReplace {
    @{
        "$($Latest.PackageName).nuspec" = @{
            "<packageSourceUrl>[^<]*</packageSourceUrl>" = "<packageSourceUrl>https://github.com/brogers5/chocolatey-package-$($Latest.PackageName)/tree/v$($Latest.Version)</packageSourceUrl>"
            "<licenseUrl>[^<]*</licenseUrl>" = "<licenseUrl>https://github.com/$($softwareRepo)/blob/v$($Latest.Version)/LICENSE</licenseUrl>"
            "<projectSourceUrl>[^<]*</projectSourceUrl>" = "<projectSourceUrl>https://github.com/$($softwareRepo)/tree/v$($Latest.Version)</projectSourceUrl>"
            "<releaseNotes>[^<]*</releaseNotes>" = "<releaseNotes>https://github.com/$($softwareRepo)/releases/tag/v$($Latest.Version)</releaseNotes>"
            "<copyright>[^<]*</copyright>" = "<copyright>$((Get-Item "$toolsPath\$($Latest.FileName64)").VersionInfo.LegalCopyright)</copyright>"
        }
        'tools\VERIFICATION.txt' = @{
            '%checksumValue%' = "$($Latest.Checksum64)"
            '%checksumType%' = "$($Latest.ChecksumType64.ToUpper())"
            '%tagReleaseUrl%' = "https://github.com/$($softwareRepo)/releases/tag/v$($Latest.Version)"
            '%binaryUrl%' = "$($Latest.Url64)"
            '%binaryFileName%' = "$($Latest.FileName64)"
        }	
        'tools\chocolateyinstall.ps1' = @{
            "(^[$]installerFileName\s*=\s*)('.*')" = "`$1'$($Latest.FileName64)'"
        }
    }
}

Update-Package -ChecksumFor None -NoReadme
