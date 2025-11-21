# ==========================================================
# PowerShell Dependency and Directory Checker
# ==========================================================

# Function for color-coded output
function Write-OK($msg) {
    Write-Host "[OK] $msg" -ForegroundColor Green
}
function Write-ERR($msg) {
    Write-Host "[ERR] $msg" -ForegroundColor Red
}

Write-Host "===== Checking Dependencies and Paths ====="

# --------------------
# Directory Checks
# --------------------
$dirsToCheck = @(
    "C:\ECEN20",
    "C:\ECEN20\bins",
    "C:\ECEN20\qorc-sdk"
)

foreach ($dir in $dirsToCheck) {
    if (Test-Path $dir) {
        Write-OK "Directory exists: $dir"
    } else {
        Write-ERR "Directory NOT found: $dir"
    }
}

# --------------------
# Git Bash Check
# --------------------
$gitBashExePaths = @(
    "C:\Program Files\Git\bin\bash.exe",
    "C:\Program Files\Git\usr\bin\bash.exe",
    "C:\Program Files\Git\git-bash.exe"
)

$foundGitBash = $false
$gitBashProfile = "$env:USERPROFILE\.bash_profile"

foreach ($p in $gitBashExePaths) {
    if (Test-Path $p) {
        Write-OK "Git Bash found at: $p"
        $foundGitBash = $true
        break
    }
}

if (-not $foundGitBash) {
    Write-ERR "Git Bash NOT found"
} else {
    # Print general Git Bash info
    Write-Host "`n===== Git Bash Information ====="
    Write-Host "Git Bash installation detected at: $p"
    
    # Print bash_profile if it exists
    if (Test-Path $gitBashProfile) {
        Write-Host "`n===== Git Bash ~/.bash_profile ====="
        Get-Content $gitBashProfile
    } else {
        Write-Host "(No ~/.bash_profile found in Git Bash home directory: $gitBashProfile)"
    }
}

Write-Host "`n"

# --------------------
# VS Code Check
# --------------------
$vsCodePaths = @(
    "C:\Users\$env:USERNAME\AppData\Local\Programs\Microsoft VS Code\Code.exe",
    "C:\Program Files\Microsoft VS Code\Code.exe",
    "C:\Program Files (x86)\Microsoft VS Code\Code.exe"
)

$foundVSCode = $false
foreach ($p in $vsCodePaths) {
    if (Test-Path $p) {
        Write-OK "VS Code found at: $p"
        $foundVSCode = $true
        break
    }
}
if (-not $foundVSCode) { Write-ERR "VS Code NOT found" }

# --------------------
# SensiML Data Studio Check
# --------------------
$sensimlPaths = @(
    "C:\Program Files\SensiML Corporation\Data Studio\DataStudio.exe",
    "C:\Program Files (x86)\SensiML Corporation\Data Studio\DataStudio.exe",
    "C:\Users\$env:USERNAME\AppData\Local\SensiML Corporation\Data Studio\DataStudio.exe"
)

$foundSensiML = $false
foreach ($p in $sensimlPaths) {
    if (Test-Path $p) {
        Write-OK "SensiML Data Studio found at: $p"
        $foundSensiML = $true
        break
    }
}
if (-not $foundSensiML) { Write-ERR "SensiML Data Studio NOT found" }

# --------------------
# Windows Terminal Check
# --------------------
$winTerminalPaths = @(
    "$env:LOCALAPPDATA\Microsoft\WindowsApps\wt.exe",
    "C:\Program Files\WindowsApps\Microsoft.WindowsTerminal*\wt.exe"
)

$foundWT = $false
foreach ($p in $winTerminalPaths) {
    if (Test-Path $p) {
        Write-OK "Windows Terminal found at: $p"
        $foundWT = $true
        break
    }
}
if (-not $foundWT) { Write-ERR "Windows Terminal NOT found" }

# --------------------
# Python Check
# --------------------
$python3 = Get-Command python3 -ErrorAction SilentlyContinue
if ($python3) { Write-OK "Python3 found: $($python3.Source)" }
else {
    $python = Get-Command python -ErrorAction SilentlyContinue
    if ($python) { Write-OK "Python found: $($python.Source)" }
    else { Write-ERR "Python NOT found" }
}

# --------------------
# make.exe Check
# --------------------
$makePath = "C:\ECEN20\make.exe"
if (Test-Path $makePath) { 
    Write-OK "make.exe found: $makePath" 
    Write-Host "`n"
    & $makePath --version
} else {
    Write-ERR "make.exe NOT found: $makePath"
    Write-Host "`n"
    }

Write-Host "`n"

# --------------------
# arm-none-eabi-gcc Check
# --------------------
$gcc = Get-Command arm-none-eabi-gcc -ErrorAction SilentlyContinue
if ($gcc) {
    Write-OK "arm-none-eabi-gcc found: $($gcc.Source)"
    $QORC_TC_PATH = Split-Path $gcc.Source
    Write-Host "QORC_TC_PATH = $QORC_TC_PATH"
} else { Write-ERR "arm-none-eabi-gcc NOT found in PATH" }

Write-Host "`n"
