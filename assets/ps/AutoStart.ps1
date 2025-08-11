# Definição de Variáveis
Get-Content .\config.ini | ForEach-Object {
    $variable, $value = $_ -split '=', 2
    Set-Variable -Name $variable -Value $value
}

# Criação do Agendador de Tarefas
# Get-Variable


$action = New-ScheduledTaskAction $winFOLDER'\WinDefault.bat' -WorkingDirectory $winFOLDER
$trigger = New-ScheduledTaskTrigger -AtLogon
Register-ScheduledTask -TaskName "WinDefault" -Description "Projeto WinDefault desenvolvido por Sao Barreto Tecnologia." -Trigger $trigger -Action $action -RunLevel Highest