# ==========================================
# Windows Offline Auto Installer
# By: sujinwo150
# ==========================================

# Pastikan bisa jalan
Set-ExecutionPolicy Bypass -Scope Process -Force

# Lokasi folder installer
$InstallerPath = "$PSScriptRoot\exe"

Write-Host ""
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "  Windows Offline Installer by sujinwo150  " -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""

# ------------------------------------------
# Daftar installer offline
# ------------------------------------------
$Installers = @(
    @{ Name = "Node.js 22.20.0"; File = "node-v22.20.0-x64.msi"; Args = "/qn" },
    @{ Name = "XAMPP 8.1.25"; File = "xampp-windows-x64-8.1.25-0-VS16-installer.exe"; Args = "--mode unattended --disable-components xampp_devdocs,xampp_perl" },
    @{ Name = "Visual Studio Code ARM64"; File = "VSCodeUserSetup-arm64-1.104.3.exe"; Args = "/silent" },
    @{ Name = "Composer PHP"; File = "Composer-Setup.exe"; Args = "/VERYSILENT /NORESTART" }
)

# ------------------------------------------
# Jalankan instalasi
# ------------------------------------------
foreach ($item in $Installers) {
    $filePath = Join-Path $InstallerPath $item.File

    if (Test-Path $filePath) {
        Write-Host ">> Installing $($item.Name)..." -ForegroundColor Yellow
        try {
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

# ------------------------------------------
# Setelah VSCode terinstall → tambah extensions
# ------------------------------------------
Write-Host ""
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "  Checking & Installing VSCode Extensions  " -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan

# Pastikan perintah 'code' tersedia
$codeCmd = (Get-Command "code" -ErrorAction SilentlyContinue)

if ($null -eq $codeCmd) {
    Write-Host "❌ VS Code CLI (code) belum tersedia di PATH. Restart dulu, lalu jalankan bagian extensions secara manual." -ForegroundColor Red
    Write-Host "   Manual command: code --install-extension blackboxapp.blackbox" -ForegroundColor Yellow
}
else {
    # Daftar extensions yang ingin dipasang
    $extensions = @(
        "blackboxapp.blackbox",
        "blackboxapp.blackboxagent",
        "ritwickdey.liveserver"
    )

    # Ambil daftar extensions yang sudah terpasang
    $installed = code --list-extensions

    foreach ($ext in $extensions) {
        if ($installed -contains $ext) {
            Write-Host "$ext already installed ✅" -ForegroundColor Green
        } else {
            Write-Host "Installing $ext..." -ForegroundColor Cyan
            code --install-extension $ext --force
            Write-Host "$ext installed successfully ✅" -ForegroundColor Green
        }
    }

    Write-Host "`nAll VSCode extensions checked and installed!" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "  Semua software sudah terinstall!         "
Write-Host "  Disarankan restart komputer Anda.        "
Write-Host "===========================================" -ForegroundColor Cyan            Write-Host "❌ Failed: $($item.Name) - $($_.Exception.Message)" -ForegroundColor Red
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
