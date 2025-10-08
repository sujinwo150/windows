# Windows Dev Setup

Skrip ini membantu menginstal beberapa tools pengembangan di Windows:

- VS Code  
- XAMPP  
- Node.js  
- Composer  
---

## ⚡ Langkah 1: Jalankan Skrip Dev Setup

Buka **PowerShell sebagai Administrator** lalu jalankan:

Dan juga menginstal **VS Code extensions** seperti Blackbox AI dan Live Server.🔥

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/sujinwo150/windows/main/install.ps1'))
