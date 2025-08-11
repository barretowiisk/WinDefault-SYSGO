@ECHO OFF
cls

IF "%1"=="N" (
    IF EXIST S:\ net use S: /del /yes
) ELSE (
    IF NOT EXIST S:\ ( 
        ECHO Mapeando a unidade compartilhada S:\
        ECHO Se solicitado digite o seu nome de usuario e senha.
        net use S: "%1" /persistent:yes
    )
)

EXIT