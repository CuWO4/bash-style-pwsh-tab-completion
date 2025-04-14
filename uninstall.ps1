if (Test-Path $PROFILE) {
    $content = Get-Content $PROFILE -Raw
    $newContent = $content

    if ($content -ne $null) {
      while ($true) {
        $beginMarker = "# pwsh tab completion configuration begin"
        $endMarker = "# pwsh tab completion configuration end"
        $pattern = [regex]::Escape($beginMarker) + '.*?' + [regex]::Escape($endMarker)

        $newContent = $content -replace "(?s)$pattern", ""

        if ($newContent -ne $content) {
            $content = $newContent
        } else {
            break
        }
      }
      Set-Content -Path $PROFILE -Value $newContent -Force
    }
    Write-Host "scripts in $PROFILE removed" -ForegroundColor Green
} else {
    Write-Host "$PROFILE not found" -ForegroundColor Red
}

$varName = "PWSH_TAB_COMPLETION"
try {
    [Environment]::SetEnvironmentVariable($varName, $null, "User")
    Write-Host "environment variable $varName removed" -ForegroundColor Green
} catch {
    Write-Host "uninstall> error: $_" -ForegroundColor Red
}

Write-Host "restart Powershell to take effect"