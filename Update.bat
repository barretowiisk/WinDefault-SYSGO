:::::::::::::::::::::::::::::::::::::::::::::::
:::     Desenvolvido por Bruno Barreto      :::
:::      Todos os Direitos Reservados       :::
:::::::::::::::::::::::::::::::::::::::::::::::

:: <=== Script Update ===>
@ECHO off
setlocal EnableDelayedExpansion
FOR /f %%S IN (%winFOLDER%\config.ini) DO (SET %%S)
SET winGitUser=barretowiisk
SET winGitToken=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
SET winLOG=%temp%\log-update-%date:~6,10%%date:~3,2%%date:~0,2%.log
TITLE Atualizando WinDefault
ECHO EMPRESA: %winCOMPANY%>%winLOG%
ECHO Iniciado em %DATE% as %time:~0,2%:%time:~3,2%>>%winLOG%

CLS
ECHO  _    _ _      ______      __            _ _   
ECHO ^| ^|  ^| (_)     ^|  _  \    / _^|          ^| ^| ^|  
ECHO ^| ^|  ^| ^|_ _ __ ^| ^| ^| ^|___^| ^|_ __ _ _   _^| ^| ^|_ 
ECHO ^| ^|/\^| ^| ^| '_ \^| ^| ^| / _ \  _/ _` ^| ^| ^| ^| ^| __^|
ECHO \  /\  / ^| ^| ^| ^| ^|/ /  __/ ^|^| (_^| ^| ^|_^| ^| ^| ^|_ 
ECHO  \/  \/^|_^|_^| ^|_^|___/ \___^|_^| \__,_^|\__,_^|_^|\__^|
ECHO.
ECHO *******************************************************
ECHO **       Script de Automacao de Servicos de TI       **
ECHO **               www.saobarreto.com.br               **
ECHO *******************************************************
ECHO ****        USO EXCLUSIVO EM ATIVOS DE TI         *****
ECHO *******************************************************
ECHO.
ECHO.>>%winLOG%

ECHO # ATUALIZANDO O SISTEMA
ECHO # ATUALIZACAO DO SISTEMA VIA GITHUB>>%winLOG%
IF EXIST %winFOLDER% RMDIR /S /Q %winFOLDER% >NUL 2>&1 && ECHO -- Removido versao anterior>>%winLOG%
SET GIT_TERMINAL_PROMPT=0
SET GCM_INTERACTIVE=Never
git clone "https://%winGitUser%:%winGitToken%@github.com/%winGitUser%/WinDefault-%winCOMPANY%.git" "%winFOLDER%" >>%winLOG% 2>&1
IF %ErrorLevel% EQU 0 (
    ECHO -- Atualizacao finalizada com sucesso.
    ECHO -- Atualizacao finalizada com sucesso.>>%winLOG%
) ELSE (
    ECHO -- Erro ao atualizar o sistema, solicite a instalacao do WinDefault novamente.
    ECHO -- Erro ao clonar o repositorio WinDefault-%winCOMPANY%>>%winLOG%
    TIMEOUT /T 10 >nul 2>&1
)
ECHO.>>%winLOG%

ECHO Finalizado em %DATE% as %time:~0,2%:%time:~3,2%>>%winLOG%
ECHO *** FIM DA ATUALIZACAO DO WINDOWS DEFAULT ***>>%winLOG%
SET stepX=0
MOVE %temp%\log-update-*.log %winFOLDER%\logs\ >nul 2>&1
IF %RC%==0 ( %winFOLDER%\WinDefault.bat )
EXIT %RC%
