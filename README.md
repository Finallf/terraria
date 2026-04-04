<h4 align="center">
  <img alt="TShock Logo" style="width: 25%" src="https://tshock.s3.us-west-001.backblazeb2.com/newlogo.png">&emsp;
  <img alt="Terraria Logo" style="width: 30%" src="https://static.wikia.nocookie.net/terraria_gamepedia/images/a/a4/NewPromoLogo.png">&emsp;
  <img alt="TShock Logo" style="width: 30%" src="https://upload.wikimedia.org/wikipedia/commons/1/1e/Docker_Logo.png">
</h4>

<p align="center">
 <a href="#-about-the-project">About</a> •
 <a href="#%EF%B8%8F-features">Features</a> •
 <a href="#-technologies-">Technologies</a> • 
 <a href="#-why-use-this-image">Why use this image</a> • 
 <a href="#%EF%B8%8F-variáveis-de-ambiente-environment-variables">Environment Variables</a> • 
 <a href="#-instalação-no-windows">Instalação no Windows</a> • 
 <a href="#-rodando-o-backend-servidor">Rodando o Backend (servidor)</a> •
 <a href="#%E2%80%8D-contributors">Contributors</a> •
 <a href="#-autor">Autor</a> •
 <a href="#user-content--licença">Licença</a>
</p>

---
## 💻 About the project
This is a high-performance Docker image for Terraria (TShock) servers, designed with a focus on automation, data security, and detailed monitoring. This image utilizes a robust architecture, ensuring that every server event is accurately logged and that configurations are precisely set.

<div align="center">
  <a href="https://hub.docker.com/r/finallf/terraria"><img alt="Static Badge" src="https://img.shields.io/badge/Docker Hub-finallf/terraria-blue?style=plastic&logo=docker"></a>
  &nbsp;
  <a href="https://hub.docker.com/r/finallf/terraria"><img alt="Docker Image Version" src="https://img.shields.io/docker/v/finallf/terraria?style=plastic"></a>
  &nbsp;
  <a href="https://hub.docker.com/r/finallf/terraria"><img alt="Docker Image Size (tag)" src="https://img.shields.io/docker/image-size/finallf/terraria/v3.1?style=plastic"></a>
  &nbsp;
  <a href="https://hub.docker.com/r/finallf/terraria"><img alt="Docker Pulls" src="https://img.shields.io/docker/pulls/finallf/terraria?style=plastic"></a>
  <br><p></p>
  <a href="https://github.com/finallf/terraria"><img alt="Static Badge" src="https://img.shields.io/badge/GitHub-finallf/terraria-blue?style=plastic&logo=github"></a>
  &nbsp;
  <a href="https://github.com/finallf/terraria"><img alt="GitHub License" src="https://img.shields.io/github/license/finallf/terraria?style=plastic"></a>
  &nbsp;
  <a href="https://github.com/finallf/terraria"><img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/finallf/terraria?style=plastic"></a>
  &nbsp;
  <a href="https://github.com/finallf/terraria"><img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/finallf/terraria"></a>
  <br><p></p>
  <a href="https://forum.reloaded.com.br"><img alt="Static Badge" src="https://img.shields.io/badge/Forum-ReloadeD-blue?style=plastic"></a>
  &nbsp;
  <a href="https://discord.gg/HxmqAEkY"><img alt="Static Badge" src="https://img.shields.io/badge/Made by-Finallf-purple?style=plastic&logo=discord"></a>
</div>

---
## ⚙️ Features
### Internal Architecture (Without Supervisor):
 - [x] Native and lightweight execution, optimized for high-performance Linux and container environments, completely rootless.

### Robust Logging System:
 - [x] Full log capture (STDOUT/STDERR) with highly accurate timestamps, allowing for complete auditing from boot to shutdown.

### Configuration Management:
 - [x] It uses jq for manipulating JSON files, ensuring that your settings (such as the initial inventory) can be changed without risk of file corruption.

### Interactivity via Named Pipe:
 - [x] It allows commands to be sent to the server console externally and securely, facilitating integration with scripts and web interfaces.

### Graceful Shutdown:
 - [x] A signal capture system (SIGTERM) that ensures the server saves the world's progress before being terminated by Docker.

<br>

---

## 🛠 Technologies 🛠

The following tools were used in the construction of the project:

<a href="https://www.docker.com"><img alt="Docker" src="https://img.shields.io/badge/Docker-blue?&style=for-the-badge&logo=docker&logoColor=white"></a>
<a href="https://www.gnu.org/software/bash"><img alt="Bash" src="https://img.shields.io/badge/Bash-gray?&style=for-the-badge&logo=GNUbash&logoColor=white"></a>
<a href="https://github.com/Pryaxis/TShock"><img alt="TShock" src="https://img.shields.io/badge/TShock-%23777BB4?&style=for-the-badge"></a>
<a href="https://www.debian.org/"><img alt="Debian" src="https://img.shields.io/badge/Debian-white?&style=for-the-badge&logo=Debian&logoColor=red"/></a>
<a href="https://terraria.org"><img alt="Terraria" src="https://img.shields.io/badge/Terraria-blue?&style=for-the-badge&logo=Terraria&logoColor=white"/></a>
<a href="https://dev.w3.org/html5/spec-LC"><img alt="HTML5" src="https://img.shields.io/badge/html5%20-%23E34F26.svg?&style=for-the-badge&logo=html5&logoColor=white"/></a>
<a href="https://www.w3.org/Style/CSS"><img alt="CSS3" src="https://img.shields.io/badge/css3%20-%231572B6.svg?&style=for-the-badge&logo=css3&logoColor=white"/></a>

---

> [!NOTE] Minimum Requirements

✔️ Instalação do Docker

<br>

---

## ❓ Why use this image❓
 
 - If you manage servers in any professional Docker environment, you know that visibility is everything.

 - This image was built for administrators who need reliable logs and dynamic configurations via environment variables, without sacrificing the simplicity of docker-compose.

<br>

---

### ⚙️ Environment Variables

You can configure the server behavior using the variables below in your docker-compose.yml file or via the -e flag in docker run:

| Variable | Description | Default |
|:---------|:-----------:|--------:|
| SERVER_PASSWORD | The server password required to join the server. | (Empty) |
| MAX_SLOTS | Maximum number of clients connected at once. | 8 |
| REST_API_ENABLED | If true, activate the REST API. | false |
| LOG_REST | If true, enables logging of REST API connections. | false |
| DISABLE_UUID_LOGIN | If true, prevents users from logging in with the client's UUID. | false |
| SSC_ENABLED | If true, enables server-side character, causing client data to be saved on the server instead of the client. | false |
| SERVER_SIDE_CHARACTER_SAVE | How often SSC should save, in minutes. | 5 |
| KEEP_PLAYER_APPEARANCE | If true, it allows players to retain the local appearance of their characters in SSC. | false |
| STARTINGINVENTORY | If true, adds some items to the Inventory for new players when SSC is enabled. Click here for more information. | (Empty) |
| WORLD_NAME | Give your World a friendly name. | (Empty)?????????? |
| WORLD_FILE | Specifies a name for the world file. | terraria_world.wld |
| AUTO_CREATE | Creates the world file with the specified size (1: Small, 2: Medium, 3: Large). | 1 |
| DIFFICULTY | Sets the world's difficulty (0: normal, 1: expert, 2: master, 3: journey). This only affects new worlds. | 0???????????? |
| WORLD_EVIL | Sets the world's evil state (random, corrupt, or crimson). | random????????? |
| SEED | Specifies the world seed when using -autocreate. | random |
| FORCE_UPDATE | If true, prevents the server from entering hibernation mode when there are no players. | false |
| MOTD | Sets the Message of the Day. | (Empty) |
| SECURE | If true, activates the base game's "antispam" feature. | false |
| LANG | Sets the server language (en-US, de-DE, it-IT, fr-FR, es-ES, ru-RU, zh-Hans, pt-BR, pl-PL). | (Empty) |
| TZ | Set your local time zone. - See https://en.wikipedia.org/wiki/List_of_tz_database_time_zones | UTC |




> [!NOTE]
> Highlights information that users should take into account.

> [!TIP]
> Optional information to help a user be more successful.

> [!IMPORTANT]
> Crucial information necessary for users to succeed.

> [!WARNING]
> Critical content demanding immediate user attention.

> [!CAUTION]
> Negative potential consequences of an action.







## 🔵 Instalação no Windows.

### Pré-requisitos

Antes de começar, você vai precisar ter instalado em sua máquina as seguintes ferramentas:
[GIT](https://git-scm.com/download/win), [Apache](https://httpd.apache.org/docs/2.4/platform/windows.html), [Mysql](https://dev.mysql.com/downloads/installer/) (Ou qualquer outro tipo de banco de dados), [Composer](https://getcomposer.org/download/)

Se você não sabe instalar e configurar um ambiente de servidor, pode utilizar ferramentas que já vem tudo pronto como:
[Apache](https://www.apachefriends.org/pt_br/download.html) [Wamp](https://www.wampserver.com/en/)

Além disto é bom ter um editor para trabalhar com o código como [VSCode](https://code.visualstudio.com/)

#### 🎲 Rodando o Backend (servidor)

```bash

# Clone este projeto
$ 

# Ou baixe o projeto direto do repositório: https://github.com/rscodexx/ragpainel

# Renomeie o arquivo .env-example(está na pasta raiz do projeto) para .env e configure.

APP_NAME=Laravel #Nome do seu servidor
APP_URL=/ # Url do seu servidor

DB_CONNECTION=mysql #Tipo de banco de dados.
DB_HOST=127.0.0.1 #IP do banco de dados.
DB_PORT=3306 #Porta do banco de dados.
DB_DATABASE= #Tabela do banco de dados.
DB_USERNAME= #Usuário do banco de dados
DB_PASSWORD= #Senha do banco de dados.
TIMEZONE=America/Sao_Paulo #Horário
LOCALE=pt-BR #Idioma geral.
FALLBACK_LOCALE=pt-BR #Idioma das mensagens de erro.

MAIL_MAILER=smtp #Tipo de e-mail
MAIL_HOST=mailhog #Host do e-mail
MAIL_PORT=1025 # Porta do e-mail
MAIL_USERNAME=null #Seu e-mail
MAIL_PASSWORD=null #Senha do seu e-mail
MAIL_ENCRYPTION=null # Tipo de encriptação do e-mail.
MAIL_FROM_NAME="${APP_NAME}"

# Acesse a pasta do projeto em seu terminal/cmd
$ cd 

# Após entrar no diretório do projeto instale o composer e suas dependências.
$ composer install

# Aguarde a instalação.

# Instale todas tabelas do painel, ainda com cmd aberto no diretório do projeto utilize:
$ php artisan migrate

# Pronto, o seu servidor está instalado e configurado.

```

#### 🧭 Rodando a aplicação web (Frontend)

```bash

# Inicie o seu servidor, para acessar o painel é necessário acessar a pasta public, um exemplo abaixo:

$ http://localhos

# Você também pode rodar a aplicação sem precisar de um servidor apache configurado através do php artisan.

# Acesse a pasta do projeto em seu terminal/cmd
$ cd 

# Digite o comando:
$ php 

# Basta clicar no link gerado para iniciar o painel.

# Use o comando CTRL + C para desligar o servidor.

```

---

## 👨‍💻 Contributors

💜 Thank you to everyone who contributed to improving the project :)

<table>
  <tr>
    <td align="center">
      <a href="https://github.com/finallf">
        <img style="border-radius: 50%;" src="https://avatars.githubusercontent.com/u/8967685" width="100px;" alt=""/><br />
          <sub><b>Regis Vieira Delgado</b></sub>
      </a><br />
      <a href="https://github.com/finallf" title="Regis Vieira Delgado"></a>
    </td>
  </tr>
</table>

## 💪 Como contribuir para o projeto

1. Faça um **fork** do projeto.
2. Crie uma nova branch com as suas alterações: `git checkout -b my-feature`
3. Salve as alterações e crie uma mensagem de commit contando o que você fez: `git commit -m "feature: My new feature"`
4. Envie as suas alterações: `git push origin my-feature`
> Caso tenha alguma dúvida confira este [guia de como contribuir no GitHub](./CONTRIBUTING.md)

---

## 🦸 Author

<table>
  <tr>
    <td align="center">
      <a href="https://reloaded.com.br">
        <img alt="Finallf" style="border-radius: 50%;" width="100px;" src="https://avatars.githubusercontent.com/u/8967685"><br>
      </a>
      <a href="mailto:finallf@gmail.com">
        <img alt="Gmail" src="https://img.shields.io/badge/-finallf@gmail.com-c14438?style=plastic&logo=gmail&logoColor=white"><br>
      </a>
        <img alt="Twitter" src="https://img.shields.io/badge/@ReloadeDtec-blue?style=plastic&logo=X"><br>
    </td>
  </tr>
</table>


---
## 📝 Licença

Este projeto esta sobe a licença ([GPL-3.0 license](https://github.com/Finallf/terraria?tab=GPL-3.0-1-ov-file)).

Feito com ❤️ por Regis Vieira Delgado.

👋🏽 [Entre em contato!](https://reloaded.com.br)
