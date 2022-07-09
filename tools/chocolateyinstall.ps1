$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$installerFileName = 'Twinkle.Tray.v1.13.11.exe'
$filePath = Join-Path -Path "$toolsDir" -ChildPath "$installerFileName"

$packageArgs = @{
  packageName = $env:ChocolateyPackageName
  fileType = 'EXE'
  file64 = $filePath
  softwareName = 'Twinkle Tray*'
  silentArgs = '/S'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs

#Remove installer binary post-install to prevent disk bloat
Remove-Item $filePath -Force -ErrorAction SilentlyContinue

#If installer binary removal fails for some reason, prevent a shim from being generated
if (Test-Path -Path $filePath)
{
  Set-Content -Path "$filePath.ignore" -Value $null -ErrorAction SilentlyContinue
}
