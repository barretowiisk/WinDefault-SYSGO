Set WshShell = WScript.CreateObject("WScript.Shell")
strDesktop = WshShell.SpecialFolders("Desktop")

' Recebendo os argumentos passados
Dim WinShared, WinFOLDER
WinShared = WScript.Arguments.Item(0)
WinFOLDER = WScript.Arguments.Item(1)

' Criando atalho para o suporte
Set oUrlLink = WshShell.CreateShortcut(strDesktop & "\SysGO Soluções.lnk")
oUrlLink.TargetPath = "https://sysgo.com.br/"
oUrlLink.IconLocation = WinFOLDER & "\assets\vbs\sysgo.ico"
oUrlLink.Save

' ' Criando atalho para o servidor de arquivos
' Set oUrlLink2 = WshShell.CreateShortcut(strDesktop & "\Servidor de Arquivos.lnk")
' oUrlLink2.TargetPath = WinShared
' ' oUrlLink2.TargetPath = "\\server\"
' oUrlLink2.IconLocation = WinFOLDER & "\assets\vbs\diretorio.ico"
' oUrlLink2.Save
