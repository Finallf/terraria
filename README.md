<div align="center">
	<a href="https://terraria.org/"><img alt="Terraria Logo" src="https://static.wikia.nocookie.net/terraria_gamepedia/images/a/a4/NewPromoLogo.png"></a>
</div>

<br>

<p align="center">
	<a href="#-features">Features</a>&nbsp; • &nbsp;
	<a href="#%EF%B8%8F-minimum-requirements">Requirements</a>&nbsp; • &nbsp;
	<a href="#-quick-setup">Quick Setup</a>&nbsp; • &nbsp;
	<a href="#%EF%B8%8F-environment-variables">Environment Variables</a>&nbsp; • &nbsp;
	<a href="#-dynamic-inventory--startinginventory-">Dynamic Inventory</a>&nbsp; • &nbsp;
	<a href="#%E2%80%8D%EF%B8%8F-author">Author</a>
</p>

---
## 🖥️ About the project
### This is a high-performance <a href="https://www.docker.com"><img alt="Docker Logo" style="width: 9%" src="https://upload.wikimedia.org/wikipedia/commons/1/1e/Docker_Logo.png"></a> image for Terraria <a href="https://github.com/Pryaxis/TShock"><img alt="TShock Logo" style="width: 7%" src="https://tshock.s3.us-west-001.backblazeb2.com/newlogo.png"></a> servers. Designed with a focus on automation, data security, detailed monitoring, and is completely rootless.

<br>

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
</div>

<br>

---
## 🪶 Features
### Internal Architecture (Without Supervisor):
 - ✅ Native and lightweight execution, optimized for high-performance Linux and container environments, completely rootless.

### Robust Logging System:
 - ✅ Full log capture (STDOUT/STDERR) with highly accurate timestamps, allowing for complete auditing from boot to shutdown.

### Configuration Management:
 - ✅ It uses jq for manipulating JSON files, ensuring that your settings (such as the initial inventory) can be changed without risk of file corruption.

### Interactivity via Named Pipe:
 - ✅ It allows commands to be sent to the server console externally and securely, facilitating integration with scripts and web interfaces.

### Graceful Shutdown:
 - ✅ A signal capture system (SIGTERM) that ensures the server saves the world's progress before being terminated by Docker.

<br>

---

## ❓ Why use this image?
 
 - If you manage servers in any professional Docker environment, you know that visibility is everything.

 - This image was built for administrators who need reliable logs and dynamic configurations via environment variables, without sacrificing the simplicity of docker-compose.

<br>

---
## ⚒️ Minimum Requirements
> [!IMPORTANT]
> ✔️ Working Docker installation
>
> ✔️ Basic knowledge of Docker.

<br>

---
## 🧰 Quick Setup
If you want to test the container, use the shell command:

```bash
docker run --rm -di --terraria finallf/terraria:latest
```

<br>

For everyday use, it's best to use docker compose.<br>

1. Create a compose.yml file similar to this:
```yml
services:
  terraria:
    image: finallf/terraria:latest
    container_name: terraria
    user: 1000:0
    stdin_open: true
    tty: false
    volumes:
      - ./terraria/config:/tshock/config
      - ./terraria/logs:/tshock/logs
      - ./terraria/crashes:/tshock/crashes
      - ./terraria/plugins:/tshock/plugins
      - ./terraria/worlds:/tshock/worlds
    ports:
      - "7777:7777"
    restart: unless-stopped
```
These are the minimum required settings.<br>
For more refined settings, see the [Environment Variables](#%EF%B8%8F-environment-variables) section for more information.

<br>

2. To begin, run the following command in the terminal, in the directory containing the compose.yml file:
```bash
docker compose up -d
```
Once your Docker container is running, open your Terraria client and connect using the host's IP address and the default port 7777.

If this is the first time running the container, it may take a while due to world creation.

<br>

---
## ⚙️ Environment Variables

You can configure the server behavior using the variables below in your compose.yml file or via the -e flag in docker run:

|  ***Variable*** | ***Description*** | ***Default*** |
|:---------|:-----------:|:-------:|
| SERVER_PASSWORD | The server password required to join the server. | false |
| MAX_SLOTS | Maximum number of clients connected at once. | 8 |
| REST_API_ENABLED | If true, activate the REST API. | false |
| LOG_REST | If true, enables logging of REST API connections. | false |
| DISABLE_UUID_LOGIN | If true, prevents users from logging in with the client's UUID. | false |
| SSC_ENABLED | If true, enables server-side character, causing client data to be saved on the server instead of the client. | false |
| SSC_SAVE | How often SSC should save, in minutes. | 5 |
| KEEP_PLAYER_APPEARANCE | If true, it allows players to retain the local appearance of their characters in SSC. | false |
| STARTINGINVENTORY | If true, adds some items to the Inventory for new players when SSC is enabled.<br>[***Click here 👆 for more information.***](#-dynamic-inventory--startinginventory-) | false |
| WORLD_NAME | Give your World a friendly name. | (Empty) |
| WORLD_FILE | Specifies a name for the world file. | terraria_world.wld |
| AUTO_CREATE | Creates the world file with the specified size (1: Small, 2: Medium, 3: Large). | 1 |
| DIFFICULTY | Sets the world's difficulty (0: normal, 1: expert, 2: master, 3: journey). This only affects new worlds. | 0 |
| WORLD_EVIL | Sets the world's evil state (random, corrupt, or crimson). | random |
| SEED | Specifies the world seed when using -autocreate. | random |
| FORCE_UPDATE | If true, prevents the server from entering hibernation mode when there are no players. | false |
| MOTD | Sets the Message of the Day. | (Empty) |
| SECURE | If true, activates the base game's "antispam" feature. | false |
| LANG | Sets the server language (en-US, de-DE, it-IT, fr-FR, es-ES, ru-RU, zh-Hans, pt-BR, pl-PL). | (Empty) |
| TZ | Set your local time zone. - See https://en.wikipedia.org/wiki/List_of_tz_database_time_zones | UTC |

> [!TIP]
> <details>
>	<summary>Click here for a complete example of the compose.yml and .env files: 👆</summary><br>
>
> compose.yml:
> ```yml
> networks:
>   terraria:
>     external: false
>     name: terraria
> 
> services:
>   terraria:
>     image: finallf/terraria:latest
>     container_name: terraria
>     user: 1000:0
>     stdin_open: true
>     tty: false
>     environment:
>       # World Variables:
>         # - SERVER_PASSWORD - The server password required to join the server.
>         # - MAX_SLOTS - Maximum number of clients connected at once.
>         # - REST_API_ENABLED - Enable or disable the REST API.
>         # - LOG_REST - Whether or not to log REST API connections.
>         # - DISABLE_UUID_LOGIN - Prevents users from being able to login with their client UUID.
>         # - SSC_ENABLED - Enable server side characters, causing client data to be saved on the server instead of the client.
>         # - SSC_SAVE - How often SSC should save, in minutes.
>         # - KEEP_PLAYER_APPEARANCE - If players should keep their local character appearance in SSC.
>         # - STARTINGINVENTORY - The starting default inventory for new players when SSC is enabled. Readme.md for more info.
>         # - WORLD_NAME - Give your World a friendly name.
>         # - WORLD_FILE - Specifies a name for the world file.
>         # - AUTO_CREATE - 1: Small, 2: Medium, 3: Large - create the world file with a given size.
>         # - DIFFICULTY - Sets the world's difficulty (0: normal, 1: expert, 2: master, 3: journey).
>         # - WORLD_EVIL - Sets the world's evil state (random, corrupt, or crimson).
>         # - SEED - Specifies the world seed when using -autocreate.
>         # - FORCE_UPDATE - Forces the server not to hibernate when there are no players.
>         # - MOTD - Sets the Message of the Day.
>         # - SECURE - Turns on the base game's "antispam" feature.
>         # - LANG - Sets the server language (en-US, de-DE, it-IT, fr-FR, es-ES, ru-RU, zh-Hans, pt-BR, pl-PL).
>         # - TZ - Set your local time zone. - See https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
>       - SERVER_PASSWORD=123456
>       - MAX_SLOTS=16
>       - REST_API_ENABLED=true
>       - LOG_REST=true
>       - DISABLE_UUID_LOGIN=true
>       - SSC_ENABLED=true
>       - SSC_SAVE=1
>       - KEEP_PLAYER_APPEARANCE=true
>       - STARTINGINVENTORY=true
>       - WORLD_NAME=ReloadeD Server
>       - WORLD_FILE=my_world.wld
>       - AUTO_CREATE=3
>       - DIFFICULTY=2
>       - WORLD_EVIL=crimson
>       - SEED=fortheworthy
>       - FORCE_UPDATE=true
>       - MOTD=Welcome to My Server!
>       - SECURE=true
>       - LANG=pt-BR
>       - TZ=America/Sao_Paulo
>     volumes:
>       # TShock paths to settings, SQLite database, log files, crash files, plugins, and world files.
>       - ${SSD}/terraria/config:/tshock/config
>       - ${SSD}/terraria/logs:/tshock/logs
>       - ${SSD}/terraria/crashes:/tshock/crashes
>       - ${SSD}/terraria/plugins:/tshock/plugins
>       - ${SSD}/terraria/worlds:/tshock/worlds
>     ports:
>       - "7777:7777"
>       # The port used by the REST API.
>       - "7878:7878"
>     networks:
>       - terraria
>     stop_grace_period: 30s
>     restart: unless-stopped
> ```
> .env
> ```
> SSD=/mnt/ssd
> ```
> </details>

> [!CAUTION]
> Don't forget to adjust the options to suit your specific situation.

<br>

---
## 🎒 Dynamic Inventory ( STARTINGINVENTORY )
The Dynamic Inventory system allows you to define which items new players will receive when they first join the server, without needing to edit files manually.
The script processes this information atomically on boot using jq.

🔹 **Option 1: Basic Kit (Quick Mode)**  
&emsp;&ensp;&nbsp;- If you set the variable to `true`, the server automatically injects a default starter kit:  
&emsp;&emsp;&ensp;(99 Glowsticks, 99 Ironskin Potions, 1 Aglet, 1 Ice Mirror, 1 Gravedigger's Shovel).

```yml
environment:
  - STARTINGINVENTORY=true
```

<br>

🔹 **Option 2: Customized Kit (Advanced Mode)**  
&emsp;&ensp;&nbsp;- To define specific items, use the compact string format:  
&emsp;&emsp;&ensp;ID, PREFIX, QUANTITY separated by a colon ( : ).

&emsp;&emsp;&ensp;Syntax: `netID,prefix,stack:netID,prefix,stack:...`

&emsp;&emsp;&ensp;Practical Example:  
&emsp;&emsp;&ensp;For players to start with a Platinum Axe (netID: 3482), 10 Torches (netID: 8), and 5 Lesser Healing Potion (netID: 28):

```yml
environment:
  - STARTINGINVENTORY=3482,0,1:8,0,10:28,0,5
```
> [!TIP]
> You can find the complete list of Terraria item netIDs on the [Official Wiki](https://terraria.wiki.gg/wiki/Item_IDs).

<br>

---
## 💪 How to contribute to the project

> [!NOTE]
> If you have any questions, check out this guide on how to contribute on GitHub: [📖](https://github.com/Finallf/terraria?tab=contributing-ov-file)<br>
> 1. Fork the project.
> 2. Create a new branch with your changes:<br>
> `git checkout -b my-feature`
> 4. Save the changes and create a commit message describing what you did:<br>
> `git commit -m "feature: My new feature"`
> 6. Send your changes:<br>
> `git push origin my-feature`

<br>

---
## 🛠️ Technologies

The following tools were used in the construction of the project:

<a href="https://www.docker.com"><img alt="Docker" src="https://img.shields.io/badge/Docker-blue?&style=for-the-badge&logo=docker&logoColor=white"></a>
<a href="https://www.gnu.org/software/bash"><img alt="Bash" src="https://img.shields.io/badge/Bash-gray?&style=for-the-badge&logo=GNUbash&logoColor=white"></a>
<a href="https://github.com/Pryaxis/TShock"><img alt="TShock" src="https://img.shields.io/badge/TShock-%23777BB4?&style=for-the-badge"></a>
<a href="https://www.debian.org/"><img alt="Debian" src="https://img.shields.io/badge/Debian-white?&style=for-the-badge&logo=Debian&logoColor=red"/></a>
<a href="https://terraria.org"><img alt="Terraria" src="https://img.shields.io/badge/Terraria-blue?&style=for-the-badge&logo=Terraria&logoColor=white"/></a>
<a href="https://dev.w3.org/html5/spec-LC"><img alt="HTML5" src="https://img.shields.io/badge/html5%20-%23E34F26.svg?&style=for-the-badge&logo=html5&logoColor=white"/></a>
<a href="https://www.w3.org/Style/CSS"><img alt="CSS3" src="https://img.shields.io/badge/css3%20-%231572B6.svg?&style=for-the-badge&logo=css3&logoColor=white"/></a>

<br>

---
## 🧑‍💻 Collaborators:
💜 Thank you to everyone who contributed to the improvement of this project :)

<!-- readme: collaborators,contributors -start -->
<table>
	<tbody>
		<tr>
            <td align="center">
                <a href="https://github.com/Finallf">
                    <img src="https://avatars.githubusercontent.com/u/8967685?v=4" width="80;" alt="Finallf"/>
                    <br />
                    <sub><b>Finallf</b></sub>
                </a>
            </td>
		</tr>
	<tbody>
</table>
<!-- readme: collaborators,contributors -end -->

<br>

---
## 🧙‍♂️ Author:
<div align="center">
	<a href="https://reloaded.com.br">
		<kbd><img alt="Finallf" width="100;" src="https://avatars.githubusercontent.com/u/8967685"></kbd>
	</a>
	<p></p>
	<a href="mailto:finallf@gmail.com"><img alt="Gmail" src="https://img.shields.io/badge/-finallf@gmail.com-c14438?style=plastic&logo=gmail&logoColor=white"></a>
	&nbsp;
	<a href="https://x.com/ReloadeDtec"><img alt="Twitter" src="https://img.shields.io/badge/@ReloadeDtec-blue?style=plastic&logo=X"></a>
	&nbsp;
	<a href="https://forum.reloaded.com.br"><img alt="Static Badge" src="https://img.shields.io/badge/Forum-ReloadeD-blue?style=plastic&logo=phpbb"></a>
	&nbsp;
	<a href="https://discord.gg/HxmqAEkY"><img alt="Static Badge" src="https://img.shields.io/badge/Discord-Finallf-purple?style=plastic&logo=discord"></a>
</div>

<br>

---
## 📝 License:
> [!WARNING]
> This project is licensed under: [GPL-3.0 license](https://github.com/Finallf/terraria?tab=GPL-3.0-1-ov-file).
