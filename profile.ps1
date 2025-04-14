
# pwsh tab completion configuration begin

Set-PSReadLineOption -PredictionSource None

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

    $newLine = $newCursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$newLine, [ref]$newCursor)
    if ($newLine -eq $line) {
        [Microsoft.PowerShell.PSConsoleReadLine]::PossibleCompletions()
    }
}

# pwsh tab completion configuration end
