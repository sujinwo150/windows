# Windows Dev Setup

Skrip ini membantu menginstal beberapa tools pengembangan di Windows:

- VS Code  
- XAMPP  
- Node.js  
- Composer  
---

## ⚡ Langkah 1: Jalankan Skrip Dev Setup

Buka **PowerShell sebagai Administrator** lalu jalankan:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
iwr -useb https://raw.githubusercontent.com/sujinwo150/windows/refs/heads/main/win.ps1 | iex
```

Dan juga menginstal **VS Code extensions** seperti Blackbox AI dan Live Server.🔥

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
iwr -useb https://raw.githubusercontent.com/sujinwo150/windows/refs/heads/main/ext.ps1 | iex
```
