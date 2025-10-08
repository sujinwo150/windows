# setup-dev.ps1
# ==============================================================
# Auto install VSCode, XAMPP, Node.js, Composer (Windows)
# Menambahkan semua ke PATH otomatis + Cek versi setelah selesai
# Jalankan PowerShell sebagai Administrator
# ==============================================================

Write-Host "=== DEV SETUP STARTED ===" -ForegroundColor Cyan

# Pastikan dijalankan sebagai admin
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Script harus dijalankan sebagai Administrator!" -ForegroundColor Red
    exit
}

# Buat folder sementara
$temp = "$env:TEMP\devsetup"
New-Item -ItemType Directory -Force -Path $temp | Out-Null
Set-Location $temp

# --- Download URLs ---
$vscodeUrl = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
$xamppUrl = "https://downloadsapachefriends.global.ssl.fastly.net/8.2.12/xampp-windows-x64-8.2.12-0-VS16-installer.exe"
$nodeUrl = "https://nodejs.org/dist/v20.17.0/node-v20.17.0-x64.msi"
$composerUrl = "https://getcomposer.org/Composer-Setup.exe"

# --- File Paths ---
$vscodeInstaller = "VSCodeSetup.exe"
$xamppInstaller = "xampp-installer.exe"
$nodeInstaller = "node-installer.msi"
$composerInstaller = "composer-setup.exe"

Write-Host "Downloading installers..." -ForegroundColor Yellow
Invoke-WebRequest -Uri $vscodeUrl -OutFile $vscodeInstaller
Invoke-WebRequest -Uri $xamppUrl -OutFile $xamppInstaller
Invoke-WebRequest -Uri $nodeUrl -OutFile $nodeInstaller
Invoke-WebRequest -Uri $composerUrl -OutFile $composerInstaller
Write-Host "All installers downloaded!" -ForegroundColor Green

# --- Install Semua ---
Write-Host "Installing VS Code..."
Start-Process -FilePath .\$vscodeInstaller -ArgumentList "/silent" -Wait

Write-Host "Installing XAMPP..."
Start-Process -FilePath .\$xamppInstaller -ArgumentList "--mode unattended" -Wait

Write-Host "Installing Node.js..."
Start-Process "msiexec.exe" -ArgumentList "/i $nodeInstaller /qn" -Wait

Write-Host "Installing Composer..."
Start-Process -FilePath .\$composerInstaller -ArgumentList "/VERYSILENT /NORESTART" -Wait

# --- Tambahkan ke PATH Environment Variable ---
Write-Host "Updating system PATH..." -ForegroundColor Yellow

# Lokasi default instalasi
$vscodePath = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin"
$xamppPath = "C:\xampp"
$nodePath = "C:\Program Files\nodejs"
$composerPath = "C:\ProgramData\ComposerSetup\bin"

# Ambil PATH sekarang
$path = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)

# Tambah jika belum ada
foreach ($p in @($vscodePath, $xamppPath, $nodePath, $composerPath)) {
    if (-not ($path -like "*$p*")) {
        $path += ";$p"
    }
}

# Simpan perubahan PATH
[Environment]::SetEnvironmentVariable("Path", $path, [EnvironmentVariableTarget]::Machine)
Write-Host "PATH updated successfully!" -ForegroundColor Green

# --- Tes versi aplikasi ---
Write-Host "`nChecking installed versions..." -ForegroundColor Cyan

# Refresh PATH untuk sesi PowerShell ini
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")

try {
    Write-Host "`nVS Code:" -ForegroundColor Yellow
    code --version
} catch { Write-Host "VS Code not detected!" -ForegroundColor Red }

try {
    Write-Host "`nNode.js:" -ForegroundColor Yellow
    node -v
    npm -v
} catch { Write-Host "Node.js not detected!" -ForegroundColor Red }

try {
    Write-Host "`nComposer:" -ForegroundColor Yellow
    composer -V
} catch { Write-Host "Composer not detected!" -ForegroundColor Red }

Write-Host "`n=== INSTALLATION COMPLETE ===" -ForegroundColor Green
Write-Host "VS Code, XAMPP, Node.js, and Composer installed successfully!" -ForegroundColor Cyan
Write-Host "You may need to restart PowerShell or your PC for PATH changes to fully apply." -ForegroundColor Yellow
