# Definição de Variáveis
Get-Content .\config.ini | ForEach-Object {
    $variable, $value = $_ -split '=', 2
    Set-Variable -Name $variable -Value $value
}

# Criação do Agendador de Tarefas
$action = New-ScheduledTaskAction -Execute 'shutdown' -Argument '/s /f /t 0'
$trigger = New-ScheduledTaskTrigger -Daily -At $taskAutoShutdown
Register-ScheduledTask -TaskName "DesligamentoDiario" -Description "Desliga o computador diariamente às $taskAutoShutdown." -Trigger $trigger -Action $action -RunLevel Highest