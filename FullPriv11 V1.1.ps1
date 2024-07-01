[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8

[System.Globalization.CultureInfo]::DefaultThreadCurrentCulture = [System.Globalization.CultureInfo]::GetCultureInfo("pt-BR")
[System.Globalization.CultureInfo]::DefaultThreadCurrentUICulture = [System.Globalization.CultureInfo]::GetCultureInfo("pt-BR")

function ContagemRegressiva {
    param (
        [int]$segundos
    )
    
    for ($i = $segundos; $i -ge 0; $i--) {
        Write-Host "Reiniciando em $i" -NoNewline
        Start-Sleep -Seconds 1
        # Limpa a linha para a próxima contagem
        Write-Host "`r" -NoNewline
    }
    
    Write-Host "Reiniciando!"
}


Clear-Host
    Write-Host "
     _____           _           __   __ 
    |  __ \         (_)         /_ | /_ |
    | |__) |  _ __   _  __   __  | |  | |
    |  ___/  | '__| | | \ \ / /  | |  | |
    | |      | |    | |  \ V /   | |  | |
    |_|      |_|    |_|   \_/    |_|  |_|
                                         
                                                                                                                                                                                                            
     By: Henry
     " -ForegroundColor Green -BackgroundColor Black

Write-Host ""
Write-Host "Ajustes para melhorar a privacidade no Windows 11, desativando formas de coleta de dados e rastreamento de atividades."
Write-Host ""

Write-Host ""
Read-Host -Prompt "Pressione Enter para continuar"

#Desativar a Telemetria:
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Type DWord

#Desativar o ID de Publicidade:
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0

#Desativar Sugestões na Tela de Bloqueio:
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Value 0
#Desativar Sugestões do Cortana:

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Value 0
#Desativar o Rastreamento de Atividade:

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Activity History" -Name "StateFlags0001" -Value 0
#Desativar a Localização:

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Value "Deny"
#Desativar Diagnóstico de Erros:

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Value 1
#Desativar Atualizações Peer-to-Peer (P2P):

Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name "DODownloadMode" -Value 0
#Desativar a Personalização de Entrada:

Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Value 1

#Desativar a Sincronização de Configurações:
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SettingSync" -Name "SyncSettings" -Value 2

#Desativa histórico de area de transferência
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Clipboard" -Name "EnableClipboardHistory" -Value 0 -Type DWord

#Personalização de tinta e digitação
New-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore" -Name "HarvestContacts" -Value 0 -PropertyType DWORD -Force

#Experiências personalizadas com dados de diagnóstico para usuário atual
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy" -Name "TailoredExperiencesWithDiagnosticDataEnabled" -Value 0 -PropertyType DWORD -Force

#Melhore o reconhecimento de tinta e digitação
New-ItemProperty -Path "HKCU:\Software\Microsoft\Input\TIPC" -Name "Enabled" -Value 0 -PropertyType DWORD -Force

#Online Speech Recognition
New-ItemProperty -Path "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" -Name "HasAccepted" -Value 0 -PropertyType DWORD -Force

#Desativar Permitir que o Windows melhore os resultados de inicialização e pesquisa rastreando lançamentos de aplicativos
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackProgs" -Value 0 -PropertyType DWORD -Force


Write-Host ""
Write-Host ""
Write-Host ""
Write-Host "Etapa 1 finalizada!"
Write-Host ""
Read-Host -Prompt "Pressione Enter para iniciar a etapa 2"


# Lista de serviços para desativar
$servicos = @(
    "DiagTrack", #serviço coleta dados de diagnóstico e uso
    "WbioSrvc", #Desativa o serviço de biometria
    "dmwappushservice", #Device Management Wireless Application Protocol (WAP) Push message Routing Service
    "WMPNetworkSvc", #Windows Media Player Network Sharing Service
    "RemoteRegistry", #Registro remoto
    "RetailDemo", #Usado para demonstrações de varejo e não é necessário para usuários finais
    "SysMain", #Superfetch serve para preenche a RAM do sistema com dados frequentemente usados, desativar para economizar recursos e privacidade.
    "OneSyncSvc", #Sincroniza emails, contatos, calendários e outras informações do usuário.
    "lfsvc", #Permite que aplicativos usem a sua localização.
    "WerSvc" #Serviço de Relatórios de Erro do Windows

)

foreach ($servico in $servicos) {
    try {
        # Parar o serviço
        Stop-Service -Name $servico -Force -ErrorAction Stop
        Write-Host "Serviço $servico parado com sucesso."
        
        # Desativar o serviço
        Set-Service -Name $servico -StartupType Disabled -ErrorAction Stop
        Write-Host "Serviço $servico desativado com sucesso."
    } catch {
        Write-Host "Erro ao parar/desativar o serviço $servico"
    }
}


Write-Host ""
Write-Host ""
Write-Host ""
Write-Host "Necessário reiniciar o computador para garantir que todas as configurações sejam aplicadas corretamente!"
Write-Host ""
Read-Host -Prompt "Pressione Enter para reiniciar"

Restart-Computer -Force


# Chamar a função com o tempo desejado (exemplo: 10 segundos)
ContagemRegressiva -segundos 10