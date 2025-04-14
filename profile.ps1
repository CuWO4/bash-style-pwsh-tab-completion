
# pwsh tab completion configuration begin

Set-PSReadLineOption -PredictionSource None

$pwshTabCompletion = [Environment]::GetEnvironmentVariable("PWSH_TAB_COMPLETION", "USER")

if ($pwshTabCompletion -eq $null -or $pwshTabCompletion -eq "CIRCULATION") {
    # circulation competion by default
}
elseif ($pwshTabCompletion -eq "BASH_STYLE") {
    Set-PSReadLineKeyHandler -Key Tab -ScriptBlock {
        $line = $cursor = $null
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

        $quotationCount = 0
        for ($idx = 0; $idx -le $cursor; $idx++) {
            if ($line[$idx] -match '[''"]') {
                $quotationCount++
            }
        }
        if ($quotationCount % 2 -ne 0) { # in quatation environment
            return
        }

        $wordStart = $cursor
        while ($wordStart -gt 0 -and $line[$wordStart-1] -notmatch '\s') {
            $wordStart--
        }
        $currentWord = $line.Substring($wordStart, $cursor - $wordStart)

        if ($wordStart -eq 0) {
            [Microsoft.PowerShell.PSConsoleReadLine]::Complete()
            return
        }

        if ($wordStart -ne 0 -and ($currentWord -notmatch '^([''"]|((\.|\.\.)(\\|/))|[a-zA-Z]:|~[\\/]|\\\\|//)')) {
            $originalCursor = $cursor
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($wordStart)
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert('.\')
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($originalCursor + 2)
        }

        [Microsoft.PowerShell.PSConsoleReadLine]::Complete()
    }
}
else {
    Write-Host "pwsh tab completion> error: unrecognized environment variable PWSH_TAB_COMPLETION = $pwshTabCompletion"
}

# pwsh tab completion configuration end
