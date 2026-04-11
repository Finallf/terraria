<p align="center">
	<a href="https://terraria.org/"><img alt="Terraria Logo" src="https://raw.githubusercontent.com/finallf/terraria/master/assets/terraria-logo.webp"></a>
</p>

<br>

<p align="center">
	<a href="#-features">Features</a>&nbsp;&nbsp;•&nbsp;
	<a href="#%EF%B8%8F-minimum-requirements">Requirements</a>&nbsp;&nbsp;•&nbsp;
	<a href="#-quick-setup">Quick Setup</a>&nbsp;&nbsp;•&nbsp;
	<a href="#%EF%B8%8F-environment-variables">Environment Variables</a>&nbsp;&nbsp;•&nbsp;
	<a href="#-dynamic-inventory--startinginventory-">Dynamic Inventory</a>&nbsp;&nbsp;•&nbsp;
	<a href="#-persistence-structure-volumes">Volumes</a>&nbsp;&nbsp;•&nbsp;
	<a href="#-security-and-permissions-rootless-architecture">Security</a>
</p>

---
## 🖥️ About the project
### This is a high-performance <a href="https://www.docker.com"><img alt="Docker Logo" width="85" src="https://raw.githubusercontent.com/finallf/terraria/master/assets/docker-logo.webp"></a> image for Terraria <a href="https://github.com/Pryaxis/TShock"><img alt="TShock Logo" width="60" src="https://raw.githubusercontent.com/finallf/terraria/master/assets/tshock-logo.webp"></a> servers. Designed with a focus on automation, data security, detailed monitoring, and is completely rootless.

<br>

<p align="center">
  <a href="https://hub.docker.com/r/finallf/terraria"><img alt="Static Badge" src="https://img.shields.io/badge/Docker Hub-finallf/terraria-blue?style=plastic&logo=docker"></a>
  &nbsp;
  <a href="https://hub.docker.com/r/finallf/terraria"><img alt="Docker Image Version" src="https://img.shields.io/docker/v/finallf/terraria?style=plastic"></a>
  &nbsp;
  <a href="https://hub.docker.com/r/finallf/terraria"><img alt="Docker Image Size (tag)" src="https://img.shields.io/docker/image-size/finallf/terraria/v3.1?style=plastic"></a>
  &nbsp;
  <a href="https://hub.docker.com/r/finallf/terraria"><img alt="Docker Pulls" src="https://img.shields.io/docker/pulls/finallf/terraria?style=plastic"></a>
  <br>
  <br>
  <a href="https://github.com/finallf/terraria"><img alt="Static Badge" src="https://img.shields.io/badge/GitHub-finallf/terraria-blue?style=plastic&logo=github"></a>
  &nbsp;
  <a href="https://github.com/finallf/terraria"><img alt="GitHub License" src="https://img.shields.io/github/license/finallf/terraria?style=plastic"></a>
  &nbsp;
  <a href="https://github.com/finallf/terraria"><img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/finallf/terraria?style=plastic"></a>
  &nbsp;
  <a href="https://github.com/finallf/terraria"><img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/finallf/terraria"></a>
</p>

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
> ✔️ Basic knowledge of Docker.

<br>

---
## 🧰 Quick Setup
If you want to test the container, use the shell command:

```bash
docker run --rm -di --terraria finallf/terraria:latest
```

<br>

The recommended way to run your server is using **Docker Compose**.  

&emsp;1 - Create a `compose.yml` file and adapt the volume paths to your environment, similar to this:  
```yml
services:
  terraria:
    image: finallf/terraria:latest
    container_name: terraria
    stdin_open: true
    tty: false
    environment:
      - SERVER_PASSWORD=yourpassword123
      - WORLD_NAME=My World Terraria
    volumes:
      # Map these folders to persist your data on the host.
      - ./terraria/config:/tshock/config
      - ./terraria/logs:/tshock/logs
      - ./terraria/crashes:/tshock/crashes
      - ./terraria/plugins:/tshock/plugins
      - ./terraria/worlds:/tshock/worlds
    ports:
      - "7777:7777" # Game Port
      - "7878:7878" # REST API Port (Optional)
    restart: unless-stopped
```
&emsp;These are the minimum required settings.  
&emsp;For more refined settings, see the [Environment Variables](#%EF%B8%8F-environment-variables) section for more information.

<br>

&emsp;2 - Make sure that the folders on the host have the correct permissions for the **UID**, the container runs by default with **UID** `1000`.  

<br>

&emsp;3 - To begin, run the following command in the terminal, in the directory containing the compose.yml file:
```bash
docker compose up -d
```
Once your Docker container is running, open your Terraria client and connect using the host's IP address and the default port 7777. 

If this is the first time running the container, it may take a while due to world creation. 

<br>

&emsp;4 - You can also monitor the startup:  
```bash
tail -f ./tshock/logs/container_init.log
```

<br>

> [!NOTE]
> &emsp;5 - "First Steps" Instructions (Admin Setup)  
> When starting the container for the first time, check the logs (docker logs terraria) to copy the Setup Code generated by TShock.  
> You will need it in-game to use the /setup command.

<br>

---
## ⚙️ Environment Variables

You can configure the server behavior using the variables below in your compose.yml file or via the -e flag in docker run:

|  ***Variable*** | ***Description*** | ***Default*** |
|:---------|:-----------:|:-------:|
| LOG_INIT | If `true`, enable container logging, saving everything to the `container_init.log` file. | `false` |
| SERVER_PASSWORD | The server password required to join the server. | `false` |
| MAX_SLOTS | Maximum number of clients connected at once. | `8` |
| REST_API_ENABLED | If `true`, activate the REST API. | `false` |
| LOG_REST | If `true`, enables logging of REST API connections. | `false` |
| DISABLE_UUID_LOGIN | If `true`, prevents users from logging in with the client's UUID. | `false` |
| SSC_ENABLED | If `true`, enables server-side character, causing client data to be saved on the server instead of the client. | `false` |
| SSC_SAVE | How often SSC should save, in minutes. | `5` |
| PLAYER_APPEARANCE | If `true`, it allows players to retain the local appearance of their characters in SSC. | `false` |
| STARTINGINVENTORY | If `true`, adds some items to the Inventory for new players when SSC is enabled.<br>[***Click here 👆 for more information.***](#-dynamic-inventory--startinginventory-) | `false` |
| WORLD_NAME | Give your World a friendly name. | (Empty) |
| WORLD_FILE | Specifies a name for the world file. | `terraria_world.wld` |
| AUTO_CREATE | Creates the world file with the specified size (`1`: Small, `2`: Medium, `3`: Large). | `1` |
| DIFFICULTY | Sets the world's difficulty (`0`: normal, `1`: expert, `2`: master, `3`: journey). This only affects new worlds. | `0` |
| WORLD_EVIL | Sets the world's evil state (`random`, `corrupt`, `crimson`). | `random` |
| SEED | Specifies the world seed when using -autocreate. | `random` |
| FORCE_UPDATE | If `true`, prevents the server from entering hibernation mode when there are no players. | `false` |
| MOTD | Sets the Message of the Day. | (Empty) |
| SECURE | If `true`, activates the base game's "antispam" feature. | `false` |
| LANG | Sets the server language (`en-US`, `de-DE`, `it-IT`, `fr-FR`, `es-ES`, `ru-RU`, `zh-Hans`, `pt-BR`, `pl-PL`). | `en-US` |
| TZ | Set your local time zone. - See https://en.wikipedia.org/wiki/List_of_tz_database_time_zones | `UTC` |

> [!TIP]
> <details>
>	<summary>Click here 👆 for a complete example of the compose.yml and .env files:</summary><br>
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
>       - LOG_INIT=true
>       - SERVER_PASSWORD=123456
>       - MAX_SLOTS=16
>       - REST_API_ENABLED=true
>       - LOG_REST=true
>       - DISABLE_UUID_LOGIN=true
>       - SSC_ENABLED=true
>       - SSC_SAVE=1
>       - PLAYER_APPEARANCE=true
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
>	    # TShock paths for settings, SQLite database, logs, crashes, plugins, and world files.
>       - ${SSD}/config:/tshock/config
>       - ${SSD}/logs:/tshock/logs
>       - ${SSD}/crashes:/tshock/crashes
>       - ${SSD}/plugins:/tshock/plugins
>       - ${SSD}/worlds:/tshock/worlds
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
> SSD=/path/on/host/terraria
> ```
> </details>

> [!CAUTION]
> Don't forget to adjust the options to suit your specific situation.

<br>

---
## 🎒 Dynamic Inventory ( STARTINGINVENTORY )
The Dynamic Inventory system allows you to define which items new players will receive when they first join the server, without needing to edit files manually.
The script processes this information atomically on boot using `jq`.

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
&emsp;&emsp;&ensp;For players to start with a Platinum Axe (ID: 3482), 10 Torches (ID: 8), and 5 Lesser Healing Potion (ID: 28):  
```yml
environment:
  - STARTINGINVENTORY=3482,0,1:8,0,10:28,0,5
```
> [!TIP]
> You can find the complete list of Terraria item netIDs on the <a href="https://terraria.wiki.gg/wiki/Item_IDs">Official Wiki</a>.

<br>

---
## 💾 Persistence Structure (Volumes)  
To ensure your server maintains its progress after reboots or image updates, it's necessary to map the 5 main volumes. Below, we detail the content and purpose of each:  

<br>

- 📁 `/tshock/config`  
	- **Contents:** JSON configuration files and SQLite database (`config.json`, `sscconfig.json`, `tshock.sqlite`).  
	- **Purpose:** This is the "brain" of the server rules. This volume is where our boot script performs dynamic changes. Note: The `sscconfig.json` file resides here and is where the initial inventory is managed.  

<br>

- 📁 `/tshock/logs` ( optional )  
	- **Contents:** The `container_init.log` file and native TShock logs.  
	- **Purpose:** Auditing and diagnostics. This volume allows you to monitor what happened during boot ( such as the injection of items by `jq` ) and view server errors without needing to access the Docker console.

<br>

- 📁 `/tshock/crashes` ( optional - legacy )  
	- **Contents:** Memory dump files (crash dumps) from an unexpected crash.  
	- **Purpose:** This is only necessary if you are a TShock plugin developer or are debugging deep crashes (segfaults/memory crashes) and need to organize the `.dmp` files into a specific network folder or volume.

<br>

- 📁 `/tshock/plugins` ( optional )  
	- **Contents:** Additional plugins and extensions for TShock.  
	- **Purpose:** Customization. By mapping this volume, you can add new features to the server (such as saving systems or area protection) simply by copying the files to the folder on your host, without needing to rebuild the Docker image.  

<br>

- 📁 `/tshock/worlds`  
	- **Contents:** Map files ( `.wld` ) and automatic backup folders.  
	- **Purpose:** Stores the "body" of your server. This is where all construction, mining, and terrain modifications are saved. Without this volume, the world will be reset on every reboot.  

<br>

> [!TIP]
> Host Organization
> 
> When configuring your server, we recommend creating a folder structure that mirrors the volumes to facilitate backups:
>
> ```Plaintext
> /path/on/host/terraria/
> ├── config/
> ├── logs/
> ├── crashes/
> ├── plugins/
> └── worlds/
> ```

<br>

---
## 🔐 Security and Permissions (Rootless Architecture)
To ensure the highest level of security, this image was built following the **Rootless** standard. This means that the TShock server and all internal scripts **do not run as administrator (root)** within the container.  

This prevents game vulnerabilities from compromising your physical server (host), but requires correct configuration of the permissions for the mapped folders in your `compose.yml` file.  

<br>

🔹 **How does a static UID/GID work**  
By default, the container's internal process runs with a static User ID (e.g., UID `1000`) and belongs to the Root Group (GID `0`).  
- **Why Group 0?** Using GID `0` is a recommended practice (adopted by platforms like Red Hat OpenShift) that allows for flexibility. The container does not require that the user who owns the folder on the host be exactly `1000`, as long as the folder's group allows read and write access.

🔹 **How to prepare your folders on the Host**  
Before starting the container for the first time, you need to ensure that the directory where the volumes will be saved allows writing.  

<br>

- **Method 1: Adjust the owner in the container (Recommended)**  
If you want to be strict, change the **UID** in your `compose.yml` file to match the **UID** of your **host** (replace `1000` with your **UID**):  
```yml
services:
  terraria:
    user: 1000:0
```

<br>

- **Method 2: Adjust the owner on the host (no flexibility)**  
Alternatively, you can change the folder **owner** on your **host** to match the container **UID**:  
```bash
sudo chown -R 1000:1000 ./terraria
```

<br>

- **Method 3: Group 0 (More flexible)**  
If you don't want to change the user who owns your folder, simply grant write permission to Group `0`:  
```bash
sudo chgrp -R 0 ./terraria
sudo chmod -R g+rwX ./terraria
```
Whichever method you choose, the container will be able to write logs, worlds, and `sscconfig.json` without permission conflicts, keeping Rootless security intact.  

<br>

---
## 🛡️ Monitoring and Logs
This image was designed following the philosophy of **total observability**. Every step of the initialization and every command sent to the server is recorded with chronological precision.  

<br>

📁 ***Log Locations***  
To persist logs outside the container, map a volume in your `compose.yml file`:
```yml
volumes:
  - /path/to/host/logs:/tshock/logs
```

The main file will be container_init.log, where you will find the complete trace of:

- Injection of items and boot scripts.
- Creation and status of the Named Pipe communication system.
- Real-time output from the TShock console (STDOUT/STDERR).

<br>

🕒 ***Precision Timestamps***  
Unlike standard logs, our system prefixes each line with a customizable timestamp:  

`[2026-04-05 14:30:05] [INFO] Items successfully added to starting inventory.`  

This allows you to cross-reference error information with events from your file system or network on the host.

<br>

📟 ***Console-based interactivity (Named Pipe)***  
Since the server runs in the background to allow monitoring, you don't use `docker attach`.  
To send commands (such as `kick`, `ban`, or `save`), use the built-in **Named Pipe**:  

Example of a command via the terminal:
```bash
docker exec -i [container_name] sh -c 'echo "say Hello Terrarians!" > /tmp/terraria_input'
```

<br>

🛑 ***Graceful Shutdown***  
When you send a `docker stop` command, the container captures the interrupt signal and automatically executes a save script.  
This ensures that the world's progress is written to disk before the process is terminated, preventing the dreaded "roll-back" of items.

<br>

---
## ☕ Support the Project / Apoie o Projeto  
If this project has helped you in any way, consider buying me a coffee! Your donation helps keep the updates and documentation current.  

🇧🇷 Se este projeto te ajudou de alguma forma, considere me pagar um café! Sua doação ajuda a manter as atualizações e a documentação.


| 🌎 GitHub Sponsors | <img src="https://upload.wikimedia.org/wikipedia/commons/5/50/Pix_%28Brazil%29_logo.svg" width="50px" alt="PIX Logo"> | <img src="https://avatars.githubusercontent.com/u/476675?s=48&v=4" width="15px" alt="PayPal Logo"> PayPal |
|:---:|:---:|:---:|
| You can support me through<br>GitHub Sponsors.<br><p></p><a href="https://github.com/sponsors/finallf"><img src="https://img.shields.io/badge/Sponsor-GitHub-ea4aaa?style=for-the-badge&logo=github-sponsors"></a> | 🇧🇷 Escaneie o QR Code:<br><a href="https://pag.ae/81FaYZrhJ"><img src="https://raw.githubusercontent.com/finallf/terraria/master/assets//qrcode-pix.webp" width="200px" alt="Pix QR Code"></a> | Click or scan the QR code:<br><a href="https://www.paypal.com/donate/?hosted_button_id=9MS3GZX5KGLP2"><img src="https://raw.githubusercontent.com/finallf/terraria/master/assets/qrcode-paypal.webp" width="200px" alt="PayPal QR Code"></a> |

🇧🇷 Ou utilize a Chave Pix (Copia e Cola):

```
25d1d528-df10-4005-bb28-2acf89706243
```

<br>

---
## 💪 How to contribute to the project

> [!NOTE]
> If you have any questions, check out this guide on how to contribute on GitHub: <a href="https://github.com/Finallf/terraria?tab=contributing-ov-file">📖</a>
> 
> 1. Fork the project.  
> 2. Create a new branch with your changes:  
> `git checkout -b my-feature`
> 4. Save the changes and create a commit message describing what you did:  
> `git commit -m "feature: My new feature"`
> 6. Send your changes:  
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
💜 Thank you to everyone who contributed to the improvement of this project 😊

<p align="center">
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
            <td align="center">
                <a href="https://github.com/semantic-release-bot">
                    <img src="https://avatars.githubusercontent.com/u/32174276?v=4" width="80;" alt="semantic-release-bot"/>
                    <br />
                    <sub><b>semantic-release-bot</b></sub>
                </a>
            </td>
		</tr>
	<tbody>
</table>
<!-- readme: collaborators,contributors -end -->
</p>

<br>

---
## 🧙‍♂️ Author:
<p align="center">
      <a href="https://reloaded.com.br"><img alt="Finallf" width="100" src="https://avatars.githubusercontent.com/u/8967685"></a>
      <br>
      <br>
      <a href="mailto:finallf@gmail.com"><img alt="Gmail" src="https://img.shields.io/badge/-finallf@gmail.com-c14438?style=plastic&logo=gmail&logoColor=white"></a>
      &nbsp;
      <a href="https://x.com/ReloadeDtec"><img alt="Twitter" src="https://img.shields.io/badge/@ReloadeDtec-blue?style=plastic&logo=X"></a>
      &nbsp;
      <a href="https://forum.reloaded.com.br"><img alt="Static Badge" src="https://img.shields.io/badge/Forum-ReloadeD-blue?style=plastic&logo=phpbb"></a>
      &nbsp;
      <a href="https://discord.gg/HxmqAEkY"><img alt="Static Badge" src="https://img.shields.io/badge/Discord-Finallf-purple?style=plastic&logo=discord"></a>
</p>

<br>

---
## 📝 License:
> [!WARNING]
> This project is licensed under: <a href="https://github.com/finallf/terraria?tab=GPL-3.0-1-ov-file">GPL-3.0 license</a>.