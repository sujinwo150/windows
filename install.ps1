# ==========================================
# Windows Offline Auto Installer
# By: sujinwo150
# ==========================================

# Izinkan script dijalankan (untuk pertama kali)
Set-ExecutionPolicy Bypass -Scope Process -Force

# Lokasi folder installer
$InstallerPath = "$PSScriptRoot\exe"

Write-Host ""
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "  Windows Offline Installer by sujinwo150  " -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""

# Daftar installer yang akan dieksekusi
$Installers = @(
    @{ Name = "Node.js 22.20.0"; File = "node-v22.20.0-x64.msi"; Args = "/qn" },
    @{ Name = "XAMPP 8.1.25"; File = "xampp-windows-x64-8.1.25-0-VS16-installer.exe"; Args = "--mode unattended --disable-components xampp_devdocs,xampp_perl" },
    @{ Name = "Visual Studio Code ARM64"; File = "VSCodeUserSetup-arm64-1.104.3.exe"; Args = "/silent" },
    @{ Name = "Composer PHP"; File = "Composer-Setup.exe"; Args = "/VERYSILENT /NORESTART" }
)

foreach ($item in $Installers) {
    $filePath = Join-Path $InstallerPath $item.File

    if (Test-Path $filePath) {
        Write-Host ">> Installing $($item.Name)..." -ForegroundColor Yellow
        try {
            # Jalankan installer
            Start-Process -FilePath $filePath -ArgumentList $item.Args -Wait -NoNewWindow
            Write-Host "✅ Installed: $($item.Name)" -ForegroundColor Green
        }
        catch {
            Write-Host "❌ Failed: $($item.Name) - $($_.Exception.Message)" -ForegroundColor Red
        }
        Write-Host ""
    }
    else {
        Write-Host "⚠️ File not found: $filePath" -ForegroundColor Red
    }
}

Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "  Semua software sudah terinstall!"
Write-Host "  Disarankan restart komputer Anda."
Write-Host "===========================================" -ForegroundColor Cyan$path = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)

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
