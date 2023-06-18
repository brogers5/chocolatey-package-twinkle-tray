$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$installerFileName = 'Twinkle.Tray.v1.15.4.exe'
$filePath = Join-Path -Path $toolsDir -ChildPath $installerFileName
$softwareNamePattern = 'Twinkle Tray*'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'EXE'
  file64         = $filePath
  softwareName   = $softwareNamePattern
  silentArgs     = '/S'
  validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @packageArgs

$appInstallLocation = Get-AppInstallLocation -AppNamePattern $softwareNamePattern
if ($null -ne $appInstallLocation) {
  $installedApplicationPath = Join-Path -Path $appInstallLocation -ChildPath 'Twinkle Tray.exe'
}
else {
  Write-Warning 'Install location not detected'
}

$shimName = 'twinkletray'

$pp = Get-PackageParameters
if ($pp.NoShim) {
  Uninstall-BinFile -Name $shimName
}
else {
  if ($null -ne $installedApplicationPath) {
    Install-BinFile -Name $shimName -Path $installedApplicationPath
  }
  else {
    Write-Warning 'Skipping shim creation - install location not detected'
  }
}

#Remove installer binary post-install to prevent disk bloat
Remove-Item $filePath -Force -ErrorAction SilentlyContinue

#If installer binary removal fails for some reason, prevent an installer shim from being generated
if (Test-Path -Path $filePath) {
  Set-Content -Path "$filePath.ignore" -Value $null -ErrorAction SilentlyContinue
}

if ($pp.Start) {
  if ($null -ne $installedApplicationPath) {
    #Spawn a separate temporary PowerShell instance to prevent display of debug output
    $statement = "Start-Process -FilePath ""$installedApplicationPath"""
    Start-ChocolateyProcessAsAdmin -Statements $statement -NoSleep -ErrorAction SilentlyContinue
  }
  else {
    Write-Warning 'Skipping application start - install location not detected'
  }
}
