# Changelog
Todas as mudanças notáveis para este projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
O Projeto adere ao [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
Projeto desenvolvido por [Bruno Barreto da Silva ] (https://saobarreto.com.br/).

## [v6.9.1] - 2025/08/07
#### Alterado
- Fix: corrigido renomear computador conforme inventário.

## [v6.8.1] - 2025/06/19
#### Adicionado
- Validação de atualização do RustDesk.

## [v5.8.1] - 2025/04/27
#### Adicionado
- Instalação de dependência WinGet.
- Instalação de dependência Git.
- Possibilidade de configurar remotamente um usuario de suporte padrão.

#### Alterado
- Alteração do repositorio do FTP para Git.
- Otimizado log de instalação, execução e update.
- Correção do mapeamento de diretório de rede.
- Atalho de diretorio compartilhado

## [v4.7.1] - 2025/04/24
### Alterado
- Exclusão de atalho SysmaTech e inclusão de atalho São Barreto.
- Atualização Wallpaper
- Rede compartilhada via servidor local SharedCenter

## [v4.6.1] - 2025/03/29
### Alterado
- Ajuste de hostname do dispositivo

## [v4.5.1] - 2025/03/17
### Alterado
- Alterado método de configuração do RustDesk
- Atualização de chave e URL do Servidor RustDesk

## [v4.4.1] - 2025/03/06
### Alterado
- Novo Display do sistema.

## [v4.3.1] - 2024/11/04
### Alterado
- Forçar ativação do serviço wSearch.
- Validação e instalação RustDesk MSI
- Alterado metodo de conexão FTP para SFTP via cURL
- Limpeza do hosts SSH do usuário

### Removido
- Start RustDesk ao final do script.

## [v4.2.0] - 2024/10/30
### Corrigido
- Atualização forçada Google Chrome via WinGet (CVE-202-10487 / CVE-2024-10488)

## [v4.1.0] - 2024/08/26
### Adicionado
- Automapeamento de unidade compartilhada em rede, configurável pelo parâmetro `winShared` no `config.ini` e executado na `Step07`.
- Arquivo `CHANGEDLOG.MD` para controle de versionamento e histórico de alterações.

### Corrigido
- Ajuste no critério de cadastro de equipamentos no Snipe-IT, que gera um Serial Number aleatório quando o "System Serial Number" é retornado.

### Alterado
- Modificado o formato do controle de versionamento do projeto para `v0.0.0 (vADD.FIXED.CHANGED/REMOVE)`.
- Atualizado o Wallpaper padrão.
- Mudança da URL, Usuário e Senha do FTP.
- Display `SysmaTech` -> `São Barreto`.
- Novo script de instalação e configuração RustDesk

### Removido
- Ícone não utilizado `intranet.ico`.
