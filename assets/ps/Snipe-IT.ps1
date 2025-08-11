# Definição de Variáveis
Get-Content .\config.ini | ForEach-Object {
    $variable, $value = $_ -split '=', 2
    Set-Variable -Name $variable -Value $value
}

# Verificar se SerialNumber é Válido
$serialNumber = (Get-WmiObject -Class Win32_BIOS).SerialNumber
if ($serialNumber -eq "To be filled by O.E.M." -or "System Serial Number" -or [string]::IsNullOrEmpty($serialNumber) -or $serialNumber -eq "0") {
    $serialNumber = (Get-Date -Format "yyyyMMddHHmmss")
}

# Execução de PUT na API
$dados = @{
    "archived" = '$false'
    "warranty_months" = $null
    "depreciate" = '$false'
    "supplier_id" = $null
    "requestable" = '0'
    "rtd_location_id" = $SnipeItLocalPadrao
    "company_id" = $SnipeItEmpresa
    "assigned_location" = $SnipeItAlocado
    "assigned_user" = $null
    "last_audit_date" = $null
    "location_id" = $SnipeItLocalPadrao
    "model_id" = $SnipeItModelo
    "status_id" = $SnipeItStatus
    "name" = $env:computername
    "asset_tag" = $env:computername
    "serial" = $serialNumber
}

$headers = @{
    "accept" = "application/json"
    "content-type" = "application/json"
    "Authorization" = "Bearer $winSnipeItKey"
}

$corpo = $dados | ConvertTo-Json
Write-Output $corpo > .\logs\device.info
$resposta = Invoke-WebRequest -Uri $winSnipeItUrl/hardware -Method POST -Headers $headers -ContentType 'application/json' -Body $corpo
Write-Output $resposta >> .\logs\device.info