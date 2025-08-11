:::::::::::::::::::::::::::::::::::::::::::::::
:::     Desenvolvido por Bruno Barreto      :::
:::      Todos os Direitos Reservados       :::
:::::::::::::::::::::::::::::::::::::::::::::::

:: <=== Controle de STEPs ===>
:: step99 - Definicao de Variaveis
:: step00 - Display
:: step01 - Validacao de Versao
:: step02 - Validacao de Hostname
:: step03 - Autoinicializacao no Logon
:: step04 - Validacao de Domínio
:: step05 - Validacao de Inventario Snipe-IT
:: step06 - Validacao de Auto Desligamento do Sistema
:: step07 - Personalizacao do Sistema (REG / BGINFO / Atalhos / Servicos)
:: step08 - Validacao RustDesk
:: step09 - Mapeamento de Diretório Compartilhado
:: step010 - Fim do script
:: <=== Controle de STEPs ===>

:: <=== Inicio Elevacao de Autoridade ===>
ECHO.
ECHO =============================
ECHO Running Admin shell
ECHO =============================
:init
@REM setlocal DisableDELayedExpansion
set cmdInvoke=1
set winSysFolder=System32
set "batchPath=%~0"
for %%k in (%0) do set batchName=%%~nk
set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
setlocal EnableDELayedExpansion
:checkPrivileges
NET FILE 1>NUL 2>NUL
IF '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )
:getPrivileges
IF '%1'=='ELEV' (ECHO ELEV & shift /1 & goto gotPrivileges)
ECHO.
ECHO **************************************
ECHO Invoking UAC for Privilege Escalation
ECHO **************************************
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
ECHO args = "ELEV " >> "%vbsGetPrivileges%"
ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
ECHO Next >> "%vbsGetPrivileges%"
IF '%cmdInvoke%'=='1' goto InvokeCmd 
ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
goto ExecElevation.
:InvokeCmd
ECHO args = "/c """ + "!batchPath!" + """ " + args >> "%vbsGetPrivileges%"
ECHO UAC.ShellExecute "%SystemRoot%\%winSysFolder%\cmd.exe", args, "", "runas", 1 >> "%vbsGetPrivileges%"
:ExecElevation
"%SystemRoot%\%winSysFolder%\WScript.exe" "%vbsGetPrivileges%" %*
exit /B
:gotPrivileges
setlocal & cd /d %~dp0
IF '%1'=='ELEV' (DEL "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)
ECHO %batchName% Arguments: P1=%1 P2=%2 P3=%3 P4=%4 P5=%5 P6=%6 P7=%7 P8=%8 P9=%9
cls
:: <=== Fim Elevacao de Autoridade ===>

:: <=== STEP99 ===>
@ECHO off
setlocal EnableDelayedExpansion
FOR /f %%S IN (.\config.ini) DO (SET %%S)
SET winLOG=%winFOLDER%\logs\log-%date:~6,10%%date:~3,2%%date:~0,2%.log
IF NOT EXIST "%winFOLDER%\logs" MKDIR "%winFOLDER%\logs"
TITLE WinDefault %winVERSION%

:: Cabelho LOG
ECHO WinDefault %winVERSION%>%winLOG%
ECHO EMPRESA: %winCOMPANY%>>%winLOG%
ECHO Iniciado em %DATE% as %time:~0,2%:%time:~3,2%>>%winLOG%

:: <=== STEP00 ===>
:step00
CLS
ECHO  _    _ _      ______      __            _ _   
ECHO ^| ^|  ^| (_)     ^|  _  \    / _^|          ^| ^| ^|  
ECHO ^| ^|  ^| ^|_ _ __ ^| ^| ^| ^|___^| ^|_ __ _ _   _^| ^| ^|_ 
ECHO ^| ^|/\^| ^| ^| '_ \^| ^| ^| / _ \  _/ _` ^| ^| ^| ^| ^| __^|
ECHO \  /\  / ^| ^| ^| ^| ^|/ /  __/ ^|^| (_^| ^| ^|_^| ^| ^| ^|_ 
ECHO  \/  \/^|_^|_^| ^|_^|___/ \___^|_^| \__,_^|\__,_^|_^|\__^| %winVERSION%
ECHO.
ECHO *******************************************************
ECHO **       Script de Automacao de Servicos de TI       **
ECHO **               www.saobarreto.com.br               **
ECHO *******************************************************
ECHO ****        USO EXCLUSIVO EM ATIVOS DE TI         *****
ECHO *******************************************************
ECHO.
ECHO.>>%winLOG%
SET /a stepX+=1
GOTO step0%stepX%

:: <=== STEP01 ===>
:step01
ECHO STEP01 - VALIDACAO DE VERSAO>>%winLOG%
ECHO # VERIFICANDO A VERSAO DO SISTEMA.
ECHO - VERIFICACAO DE DEPENDENCIAS>>%winLOG%

PowerShell winget -v  >NUL 2>&1
IF %ErrorLevel% EQU 0 (
    ECHO -- WinGet ja instalado>>%winLOG%
) ELSE (
    ECHO Instalando WinGet...
    PowerShell -command "&([ScriptBlock]::Create((irm winget.pro))) -Force"  >NUL 2>&1
    IF %ErrorLevel% EQU 0 (
        ECHO -- WinGet instalado com sucesso>>%winLOG%
    ) ELSE (
        ECHO -- Erro ao instalar o WinGet>>%winLOG%
    )
)

PowerShell git -v  >NUL 2>&1
IF %ErrorLevel% EQU 0 (
    ECHO -- Git ja instalado>>%winLOG%
) ELSE (
    ECHO Instalando Git...
    PowerShell -command "&{ winget install --id Git.Git -e --source winget --accept-package-agreements --accept-source-agreements }"  >NUL 2>&1
    IF %ErrorLevel% EQU 0 (
        ECHO -- Git instalado com sucesso>>%winLOG%
    ) ELSE (
        ECHO -- Erro ao instalar o Git>>%winLOG%
    )
)

ECHO.>>%winLOG%
ECHO - VERIFICACAO DE ATUALIZACAO>>%winLOG%
SET GIT_TERMINAL_PROMPT=0
SET GCM_INTERACTIVE=Never
cd /d %winFOLDER%

:: Fetch para buscar atualizacoes
git -c credential.helper= fetch origin >>%winLOG%
SET RC=%ErrorLevel%
IF %RC% NEQ 0 ( ECHO -- Erro na atualizacao do sistema.>>%winLOG% && GOTO step00 )

:: Verificar se existe atualizacao
for /f "tokens=* delims=" %%A in ('git rev-parse HEAD') do (set GitLOCAL=%%A)
for /f "tokens=* delims=" %%A in ('git rev-parse origin/master') do (set GitREMOTE=%%A)
IF NOT "%GitLOCAL%"=="%GitREMOTE%" (
    ECHO -- Atualizacao pendente.>>%winLOG%
    XCOPY "%winFOLDER%\Update.bat" /H /C /I /Y "%temp%\">>%winLOG%
    START %temp%\Update.bat
    EXIT
) ELSE (
    ECHO -- Sistema esta atualizado.>>%winLOG%
)
GOTO step00

:: <=== STEP02 ===>
:step02
ECHO STEP02 - VALIDACAO DE HOSTNAME>>%winLOG%
ECHO VERIFICANDO NOME DO COMPUTADOR.
ECHO - Nome do Computador: %ComputerName%>>%winLOG%
ECHO %ComputerName% | FINDSTR /i "%winHOST%">nul
IF %ERRORLEVEL% equ 0 (
    ECHO -- Hostname padronizado.>>%winLOG%
    SET RenamePC=False
    GOTO step00
) ELSE (
    FOR /f "tokens=5 delims=:," %%S IN ( '%winFOLDER%\assets\exe\curl.exe -s %winSnipeItUrl%/hardware -H "Authorization: Bearer %winSnipeItKey%" -H "Accept: application/json" -H "Content-Type: application/json"' ) DO (
        SET "PcNome=%%S"
        SET /a PcNome+=1
        ECHO -- Hostname Incorreto. Novo Hostname: !winHOST!!PcNome!>>%winLOG%
        SET RenamePC=True
    )
)
GOTO step00

:: <=== STEP03 ===>
:step03
ECHO STEP03 - AUTO INICIALIZACAO>>%winLOG%
ECHO VERIFICANDO AUTO INICIALIZACAO DO SISTEMA.
SCHTASKS /query /FO LIST /TN "WinDefault" | findstr /I /C:"WinDefault" >NUL 2>&1
IF %ERRORLEVEL% EQU 0 (
    ECHO -- Autoinicializacao Ativada.>>%winLOG%
) ELSE (
    PowerShell -executionpolicy bypass -file %winFOLDER%\assets\ps\AutoStart.ps1 >NUL 2>&1
    IF %ErrorLevel% EQU 0 (
        ECHO -- Autoinicializacao do Sistema configurada com sucesso.>>%winLOG%
    ) ELSE (
        ECHO -- Erro na configuracao da Autoinicializacao do Sistema.>>%winLOG%
    )
)

IF %RenamePC%==True (
    ECHO -- Dispositivo reiniciado para alteracao de Hostname.>>%winLOG%
    ECHO ### ATENCAO! O COMPUTADOR SERA REINICIADO EM ALGUNS SEGUNDOS PARA ATUALIZACAO. ###
    TIMEOUT /T 10 /NOBREAK >NUL 2>&1
    PowerShell Rename-Computer -NewName "%winHOST%%PcNome%" -Restart
    EXIT 0
)
GOTO step00

:: <=== STEP04 ===>
:step04
ECHO STEP04 - VALIDACAO DO DOMINIO/GRUPO DE TRABALHO>>%winLOG%
ECHO VERIFICANDO DOMINIO/GRUPO DE TRABALHO
FOR /F "tokens=6 delims= " %%D IN (' net config workstation ^| findstr /I /C:"nio de esta" ') DO (
    IF %%D==%winAD% ( 
        ECHO -- Computador ja esta ingressado em %winAD%.>>%winLOG%
    ) ELSE (
        PowerShell Add-Computer -WorkGroupName "%winAD%"
        IF %ErrorLevel% EQU 0 (
            ECHO -- Computador ingressado no grupo de trabalho %winAD% com sucesso.>>%winLOG%
        ) ELSE (
            ECHO -- Erro ao ingressar o computador no grupo de trabalho %winAD%.>>%winLOG%
        )
    )
)
GOTO step00

:: <=== STEP05 ===>
:step05
ECHO STEP05 - VALIDACAO DE INVENTARIO>>%winLOG%
ECHO VERIFICANDO INVENTARIO DO EQUIPAMENTO
%winFOLDER%\assets\exe\curl.exe -s %winSnipeItUrl%/hardware/bytag/%ComputerName% -H "Authorization: Bearer %winSnipeItKey%" -H "Accept: application/json" -H "Content-Type: application/json"  | findstr /I /C:"%ComputerName%" >NUL 2>&1
IF %ErrorLevel% EQU 0 (
    ECHO -- Ativo ja cadastrado no Snipe-IT.>>%winLOG%
) ELSE (
    PowerShell -executionpolicy bypass -file %winFOLDER%\assets\ps\Snipe-IT.ps1 >NUL 2>&1
    IF %ErrorLevel% EQU 0 (
        ECHO -- Ativo cadastrado no Snipe-IT com sucesso.>>%winLOG%
    ) ELSE (
        ECHO -- Erro ao cadastrar o ativo no Snipe-IT.>>%winLOG%
    )
)
GOTO step00

:: <=== STEP06 ===>
:step06
ECHO STEP06 - AUTO DESLIGAMENTO DIARIO>>%winLOG%
ECHO VERIFICANDO AUTO DESLIGAMENTO DIARIO
IF %taskAutoShutdown%==N (
    ECHO -- Auto Desligamento Desativado.>>%winLOG%
    SCHTASKS /query /FO LIST /TN "DesligamentoDiario" | findstr /I /C:"DesligamentoDiario" >NUL 2>&1
    IF %ErrorLevel% EQU 0 (
        schtasks /delete /tn "DesligamentoDiario" /f >nul
    )
    GOTO step00
)

SCHTASKS /query /FO LIST /TN "DesligamentoDiario" | findstr /I /C:"DesligamentoDiario" >NUL 2>&1
IF %ErrorLevel% EQU 0 (
    ECHO -- Auto Desligamento ja Ativado.>>%winLOG%
) ELSE (
    PowerShell -executionpolicy bypass -file %winFOLDER%\assets\ps\AutoShutdown.ps1 >NUL
    IF %ErrorLevel% EQU 0 (
        ECHO -- Auto Desligamento do Sistema configurado com sucesso.>>%winLOG%
    ) ELSE (
        ECHO -- Erro na configuracao do Auto Desligamento do Sistema.>>%winLOG%
    )
)
GOTO step00

:: <=== STEP07 ===>
:step07
ECHO STEP07 - PERSONALIZACAO DO SISTEMA>>%winLOG%
ECHO PERSONALIZACAO DO SISTEMA
ECHO - Criacao de usuario de SUPORTE>>%winLOG%
IF "%winSupport%" NEQ "N" (
    net user %winSupport% >NUL 2>&1
    IF %ErrorLevel% NEQ 0 (
        net user %winSupport% @dm1nWkS2020 /add >>%winLOG% 2>&1
        net localgroup Administradores %winSupport% /add >>%winLOG% 2>&1
        ECHO -- Criando usuario %winSupport% com sucesso.>>%winLOG% 2>&1
    ) ELSE (
        echo -- Usuario %winSupport% ja existe.>>%winLOG%
    )
) ELSE (
    ECHO -- Criacao de usuario de SUPORTE desativado.>>%winLOG%
)
ECHO.>>%winLOG%

ECHO - Importacao de Arquivos de Registro>>%winLOG%
FOR /F "tokens=4" %%R IN (' dir "%winFOLDER%\assets\reg\" ^| findstr /I /C:".reg" ') DO (
    REG IMPORT %winFOLDER%\assets\reg\%%R >NUL 2>&1
    IF %ErrorLevel% NEQ 0 (
        ECHO %%R Importada com sucesso.>>%winLOG%
    ) ELSE (
        ECHO %%R Falhou na importacao.>>%winLOG%
    )
)
ECHO.>>%winLOG%

ECHO - Padronizacao Wallpaper>>%winLOG%
%winFOLDER%\assets\exe\Bginfo.exe %winFOLDER%\assets\exe\config.bgi /timer:0 /nolicprompt /silent
IF %ErrorLevel% EQU 0 (
    ECHO BGINFO Executado com sucesso.>>%winLOG%
) ELSE (
    ECHO BGINFO Falhou a execucao.>>%winLOG%
)
ECHO.>>%winLOG%

ECHO Execucao de VBS>>%winLOG%
IF %winAtalhos%==S (
    FOR /F "tokens=4" %%V IN (' dir "%winFOLDER%\assets\vbs\" ^| findstr /I /C:".vbs" ') DO (
        cscript //nologo "%winFOLDER%\assets\vbs\%%V" "%WinShared%" "%winFOLDER%" >NUL 2>&1
        IF %ErrorLevel% EQU 0 (
            ECHO -- Atalhos criados com sucesso.>>%winLOG%
        ) ELSE (
            ECHO -- Atalhos nao foram criados.>>%winLOG%
        )
    )
) ELSE (
    ECHO -- Criacao de atalhos desativada.>>%winLOG%
)
ECHO.>>%winLOG%

ECHO - Verificacao de Servicos Nativos>>%winLOG%
sc query  WSearch | find "RUNNING"  >NUL 2>&1
IF %ErrorLevel% EQU 0 (
    ECHO -- WSearch ja esta ativo.>>%winLOG%    
) ELSE (
    SC config WSearch start=auto >NUL 2>&1
    SC start WSearch >NUL 2>&1
    ECHO -- WSearch foi Ativado com sucesso.>>%winLOG%
)

sc query  SysMain | find "STOPPED"  >NUL 2>&1
IF %ErrorLevel% EQU 0 (
    ECHO -- SysMain ja desativado.>>%winLOG%
) ELSE (
    SC stop WSearch >NUL 2>&1
    SC config SysMain start=disabled >NUL 2>&1
    ECHO -- SysMain foi Desativado com sucesso.>>%winLOG%
)
ECHO.>>%winLOG%

ECHO - Validacao Google Chrome>>%winLOG%
PowerShell -command "&{ winget upgrade Google.Chrome --force --accept-package-agreements --accept-source-agreements >>%winLOG% 2>&1}"
GOTO step00

:: <=== STEP08 ===>
:step08
ECHO STEP08 - VERIFICACAO RUSTDESK>>%winLOG%
ECHO VERIFICANDO ACESSO RUSTDESK
IF EXIST "%ProgramFiles%\RustDesk\RustDesk.exe" (
    ECHO - Validacao RustDesk>>%winLOG%
    PowerShell -command "&{ winget upgrade RustDesk.RustDesk --force --accept-package-agreements --accept-source-agreements >>%winLOG% 2>&1}"
    ECHO -- RustDesk ja instalado. >>%winLOG%
) ELSE (
    FOR /F "eol= tokens=2 delims=, " %%R IN (' %winFOLDER%\assets\exe\curl.exe -s https://api.github.com/repos/rustdesk/rustdesk/releases/latest ^| findstr /I "browser_download_url" ^| findstr /I ".msi" ') DO (
        PowerShell -command "& { iwr %%R -OutFile %temp%\RustDesk.msi }" >NUL 2>&1
        IF %ErrorLevel% EQU 0 (
            ECHO -- Download do RustDesk realizado com sucesso.>>%winLOG%
            msiexec /i %temp%\RustDesk.msi /qn INSTALLFOLDER="%ProgramFiles%\RustDesk" CREATESTARTMENUSHORTCUTS="Y" CREATEDESKTOPSHORTCUTS="Y" >NUL 2>&1
            IF %ErrorLevel% EQU 0 (
                ECHO -- Instalacao do RustDesk realizada com sucesso.>>%winLOG%
                DEL %temp%\RustDesk.msi >NUL 2>&1
            ) ELSE (
                ECHO -- Erro na instalacao do RustDesk.>>%winLOG%
                DEL %temp%\RustDesk.msi >NUL 2>&1
                GOTO step00
            )
        ) ELSE (
            ECHO -- Erro ao baixar o RustDesk.>>%winLOG%
            GOTO step00
        )
    )
)

PowerShell -executionpolicy bypass -file "%winFOLDER%\assets\ps\RustDesk.ps1" >NUL 2>&1
IF %ErrorLevel% EQU 0 (
    ECHO -- Configuracao do RustDesk realizada com sucesso.>>%winLOG%
) ELSE (
    ECHO -- Erro na configuracao do RustDesk.>>%winLOG%
)
GOTO step00

:: <=== STEP09 ===>
:step09
ECHO STEP09 - MAPEANDO DIRETORIO COMPARTILHADO>>%winLOG%
ECHO MAPEANDO DIRETORIO COMPARTILHADO
IF "%WinShared%"=="N" (
    ECHO -- Mapeamento de Compartilhamento desativado.>>%winLOG%
    GOTO step00
)
ECHO -- Criando a Task do Mapeamento>>%winLOG%
schtasks /Create /TN "MapeamentoS" /TR "\"%winFOLDER%\assets\batch\mapear.bat\" %winShared%" /SC ONCE /ST 00:00 /RL LIMITED /F >>%winLOG% 2>&1
ECHO -- Criando a Task do Mapeamento>>%winLOG%
schtasks /Run /TN "MapeamentoS" >>%winLOG% 2>&1
TIMEOUT /T 5 /NOBREAK >NUL
ECHO -- Excluindo a Task do Mapeamento>>%winLOG%
schtasks /Delete /TN "MapeamentoS" /F >>%winLOG% 2>&1
IF EXIST S: ( ECHO -- Mapeamento de S: realizado com sucesso. >>%winLOG% )
GOTO step00

:step010
ECHO Finalizado em %DATE% as %time:~0,2%:%time:~3,2%>>%winLOG%
ECHO *** FIM DA EXECUCAO DO WINDOWS DEFAULT ***>>%winLOG%
EXIT
