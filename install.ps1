# ===============================================================
# Windows Auto Installer (Offline + Online Fallback)
# By: sujinwo150 —  by Jay Ras
# ===============================================================

Write-Host "`n===========================================" -ForegroundColor Cyan
Write-Host "  Windows Auto Installer by sujinwo150       " -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""

# --- Setup Folder dan URL ---
$InstallerPath = Join-Path $PSScriptRoot "exe"
if (!(Test-Path $InstallerPath)) { New-Item -ItemType Directory -Path $InstallerPath | Out-Null }
$BaseURL = "https://raw.githubusercontent.com/sujinwo150/windows/main/exe"

# --- Daftar Software ---
$Installers = @(
    @{ Name = "Node.js"; File = "node-v22.20.0-x64.msi"; Args = "/qn"; Cmd = "node" },
    @{ Name = "XAMPP"; File = "xampp-windows-x64-8.1.25-0-VS16-installer.exe"; Args = "--mode unattended --disable-components xampp_devdocs,xampp_perl"; Cmd = "xampp-control" },
    @{ Name = "Visual Studio Code"; File = "VSCodeUserSetup-arm64-1.104.3.exe"; Args = "/silent"; Cmd = "code" },
    @{ Name = "Composer"; File = "Composer-Setup.exe"; Args = "/VERYSILENT /NORESTART"; Cmd = "composer" }
)

# --- Fungsi: Cek apakah aplikasi sudah ada ---
function Is-Installed($cmd) {
    return (Get-Command $cmd -ErrorAction SilentlyContinue) -ne $null
}

# --- Fungsi: Download file jika belum ada ---
function Download-IfMissing($fileName) {
    $dest = Join-Path $InstallerPath $fileName
    if (Test-Path $dest) {
        Write-Host "✅ $fileName sudah ada, skip download." -ForegroundColor Green
    } else {
        $url = "$BaseURL/$fileName"
        Write-Host "⬇️ Mengunduh $fileName ..." -ForegroundColor Cyan
        try {
            (New-Object System.Net.WebClient).DownloadFile($url, $dest)
            Write-Host "✅ Berhasil diunduh: $fileName" -ForegroundColor Green
        } catch {
            Write-Host "❌ Gagal mengunduh $fileName dari $url" -ForegroundColor Red
        }
    }
}

# --- Jalankan proses utama ---
foreach ($item in $Installers) {
    $filePath = Join-Path $InstallerPath $item.File
    Download-IfMissing $item.File

    if (Is-Installed $item.Cmd) {
        Write-Host "✅ $($item.Name) sudah terpasang, skip instalasi." -ForegroundColor Green
        continue
    }

    if (Test-Path $filePath) {
        Write-Host "🚀 Menginstal $($item.Name) ..." -ForegroundColor Yellow
        try {
            Start-Process -FilePath $filePath -ArgumentList $item.Args -Wait -NoNewWindow
            Write-Host "✅ Selesai instalasi: $($item.Name)" -ForegroundColor Green
        } catch {
            Write-Host "❌ Gagal menginstal $($item.Name) - $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        Write-Host "⚠️ File tidak ditemukan: $filePath" -ForegroundColor Red
    }

    Write-Host ""
}

# --- Instal Extensions VSCode ---
Write-Host "`n===========================================" -ForegroundColor Cyan
Write-Host "  Mengecek & Menginstal VSCode Extensions   " -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan

if (Is-Installed "code") {
    $extensions = @(
        "blackboxapp.blackbox",
        "blackboxapp.blackboxagent",
        "ritwickdey.liveserver"
    )

    $installedExt = code --list-extensions
    foreach ($ext in $extensions) {
        if ($installedExt -contains $ext) {
            Write-Host "✅ $ext sudah terpasang" -ForegroundColor Green
        } else {
            Write-Host "⬇️ Menginstal $ext ..." -ForegroundColor Cyan
            code --install-extension $ext --force
            Write-Host "✅ $ext terpasang" -ForegroundColor Green
        }
    }
} else {
    Write-Host "⚠️ VSCode belum tersedia di PATH, restart dulu lalu jalankan ulang bagian extension." -ForegroundColor Red
}

# --- Cek versi ---
Write-Host "`n===========================================" -ForegroundColor Cyan
Write-Host "  Mengecek versi software yang terpasang     "
Write-Host "===========================================" -ForegroundColor Cyan

try {
    Write-Host "`nVS Code:" -ForegroundColor Yellow
    code -v
} catch { Write-Host "VS Code belum terpasang." -ForegroundColor Red }

try {
    Write-Host "`nNode.js:" -ForegroundColor Yellow
    node -v
} catch { Write-Host "Node.js belum terpasang." -ForegroundColor Red }

try {
    Write-Host "`nComposer:" -ForegroundColor Yellow
    composer -V
} catch { Write-Host "Composer belum terpasang." -ForegroundColor Red }

Write-Host "`n=== Instalasi selesai ✅ Silakan restart komputer Anda. ===" -ForegroundColor Magenta
pause
