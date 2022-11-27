$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$installerFileName = 'Twinkle.Tray.v1.15.0-beta1.exe'
$filePath = Join-Path -Path $toolsDir -ChildPath $installerFileName

$pp = Get-PackageParameters

$packageArgs = @{
  packageName = $env:ChocolateyPackageName
  fileType = 'EXE'
  file64 = $filePath
  softwareName = 'Twinkle Tray*'
  silentArgs = '/S'
  validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @packageArgs

$installedApplicationPath = Join-Path -Path $env:LOCALAPPDATA -ChildPath 'Programs' |
                            Join-Path -ChildPath 'twinkle-tray' |
                            Join-Path -ChildPath 'Twinkle Tray.exe'
$shimName = 'twinkletray'

if ($pp.NoShim)
{
  Uninstall-BinFile -Name $shimName -Path $installedApplicationPath
}
else
{
  Install-BinFile -Name $shimName -Path $installedApplicationPath
}

#Remove installer binary post-install to prevent disk bloat
Remove-Item $filePath -Force -ErrorAction SilentlyContinue

#If installer binary removal fails for some reason, prevent an installer shim from being generated
if (Test-Path -Path $filePath)
{
  Set-Content -Path "$filePath.ignore" -Value $null -ErrorAction SilentlyContinue
}

if ($pp.Start)
{
  #Spawn a separate temporary PowerShell instance to prevent display of debug output
  $statement = "Start-Process -FilePath ""$installedApplicationPath"""
  Start-ChocolateyProcessAsAdmin -Statements $statement -NoSleep -ErrorAction SilentlyContinue
}
