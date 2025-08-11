$ErrorActionPreference = 'SilentlyContinue'
function RunAsAdmin {
    if (-Not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        if ($int -ge 6000) {
            Start-Process PowerShell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`""
            Exit
        }
    }
}

$ServiceName = 'RustDesk'
$ConfigPathUser = "C:\Users\$username\AppData\Roaming\RustDesk\config\RustDesk2.toml"
$ConfigPathService = "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config\RustDesk2.toml"
$ConfigContent = @"
rendezvous_server = 'rustdesk.saobarreto.com.br'
nat_type = 1
serial = 0

[options]
key =  'YZmRkqYt1K1+7Hk89x4brLExH2ZnSvWAcjoe6O9NgKs='
custom-rendezvous-server = 'rustdesk.saobarreto.com.br'
direct-server = 'Y'
relay-server = 'rustdesk.saobarreto.com.br'
api-server = 'https://rustdesk.saobarreto.com.br'
enable-audio = 'N'
"@

net stop RustDesk > $null

$username = ((Get-WMIObject -ClassName Win32_ComputerSystem).Username).Split('\')[1]
Remove-Item $ConfigPathUser -ErrorAction SilentlyContinue
New-Item -Path $ConfigPathUser -ItemType File -Force
Set-Content -Path $ConfigPathUser -Value $ConfigContent
Remove-Item $ConfigPathService -ErrorAction SilentlyContinue
New-Item -Path $ConfigPathService -ItemType File -Force
Set-Content -Path $ConfigPathService -Value $ConfigContent

net start RustDesk > $null
