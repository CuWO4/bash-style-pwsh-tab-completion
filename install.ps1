$profileSource = Join-Path $PSScriptRoot "profile.ps1"
if (-not (Test-Path $profileSource)) {
    Write-Host "error: profile.ps1 not found" -ForegroundColor Red
    exit 1
}
$profileContent = Get-Content $profileSource -Raw -Encoding UTF8

if (-not (Get-Module -ListAvailable -Name PSReadLine)) {
  try {
    if ((Get-PSRepository -Name PSGallery).InstallationPolicy -ne 'Trusted') {
      Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -Force
    }

    Install-Module PSReadLine -Force -AllowClobber -Scope CurrentUser
    Write-Host "PSReadLine installed" -ForegroundColor Green
  }
  catch {
    Write-Host "installation failed: $_" -ForegroundColor Red
    exit 1
  }
}
else {
  Write-Host "PSReadLine satisfied, installation skip" -ForegroundColor Yellow
}

$isProfileExists = Test-Path $PROFILE

if (-not $isProfileExists) {
  New-Item -ItemType File -Path $PROFILE -Force | Out-Null
  Write-Host "new profile created" -ForegroundColor Green
}

$currentContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue

if ((-not $isProfileExists) -or ($currentContent -notmatch [regex]::Escape($profileContent))) {
  $profileContent | Out-File $PROFILE -Append -Encoding UTF8
  Write-Host "configuration has been written to $PROFILE" -ForegroundColor Green
  Write-Host "restart Powershell to take effect"
}
else {
  Write-Host "configuration already exists, skip" -ForegroundColor Yellow
}