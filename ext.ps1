# install-extensions.ps1
# ===============================================================
# Auto install VS Code extensions if not already installed
# ===============================================================

# Daftar extensions yang ingin dipastikan terpasang
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

Write-Host "`nAll extensions checked and installed if missing!" -ForegroundColor Yellow
