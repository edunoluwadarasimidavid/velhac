#!/data/data/com.termux/files/usr/bin/bash

# Colors
R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
W="$(printf '\033[1;37m')"
C="$(printf '\033[1;36m')"
N="$(printf '\033[1;92m')"

VELHAC_VERSION="3.0"
VELHAC_RAW="https://raw.githubusercontent.com/edunoluwadarasimidavid/velhac/main/velhac.sh"

# ─────────────────────────────────────────
#  BANNER
# ─────────────────────────────────────────
banner(){
clear
printf ${N}"
 ██╗   ██╗███████╗██╗     ██╗  ██╗ █████╗  ██████╗
 ██║   ██║██╔════╝██║     ██║  ██║██╔══██╗██╔════╝
 ██║   ██║█████╗  ██║     ███████║███████║██║
 ╚██╗ ██╔╝██╔══╝  ██║     ██╔══██║██╔══██║██║
  ╚████╔╝ ███████╗███████╗██║  ██║██║  ██║╚██████╗
   ╚═══╝  ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝
"${W}
printf ${Y}"       Mobile Dev & Security Toolkit v${VELHAC_VERSION}\n"
printf      "          By Smart Tech Programming\n"
printf      "       youtube.com/@smarttechprogramming\n\n"${W}
}

# ─────────────────────────────────────────
#  ARCHITECTURE CHECK
# ─────────────────────────────────────────
get_arch() {
    printf ${G}"[*] Checking device architecture..."${W}
    echo
    case $(getprop ro.product.cpu.abi) in
        arm64-v8a)           SYS_ARCH=arm64 ;;
        armeabi|armeabi-v7a) SYS_ARCH=armhf ;;
        *)
            echo ${R}"[!] Unsupported architecture."${W}
            SYS_ARCH=unknown
            ;;
    esac
}

# ─────────────────────────────────────────
#  HACKING TOOLS
# ─────────────────────────────────────────

install_beef(){
    pkg update -y
    pkg install curl git libyaml libxslt ruby python nodejs nano binutils -y
    cd $PREFIX/opt
    [ -d beef ] || git clone https://github.com/beefproject/beef
    cd $PREFIX/opt/beef
    grep -q "net-smtp" Gemfile || echo " gem 'net-smtp', require: false" >> Gemfile
    grep -n "sudo" install 2>/dev/null | head -1 | cut -d: -f1 | xargs -I{} sed -i '{}d' install
    sed -i 's/sudo//' install
    bash install
    echo "cd $PREFIX/opt/beef && ruby beef" > $PREFIX/bin/beef
    chmod +x $PREFIX/bin/beef
    echo ${N}"[*] BeEF installed. Run with: beef"
    echo "[*] Change credentials in: $PREFIX/opt/beef/config.yaml"${W}; echo
}

install_metasploit(){
    pkg update -y && pkg install wget -y
    echo ${Y}"[*] Downloading Metasploit installer..."${W}
    if wget -q --spider https://github.com/gushmazuko/metasploit_in_termux/raw/master/metasploit.sh 2>/dev/null; then
        wget https://github.com/gushmazuko/metasploit_in_termux/raw/master/metasploit.sh
        bash metasploit.sh && rm metasploit.sh
    else
        echo ${R}"[!] Metasploit installer unavailable. Visit:"
        echo "    https://github.com/gushmazuko/metasploit_in_termux"${W}
    fi; echo
}

install_mitmproxy(){
    get_arch
    if [[ $SYS_ARCH == "arm64" ]]; then
        pkg update -y
        pkg install python rust python-cryptography -y
        export CARGO_BUILD_TARGET=aarch64-linux-android
        pip install cryptography --no-binary cryptography
        pip3 install mitmproxy
        echo ${N}"[*] mitmproxy installed. Run with: mitmproxy"${W}; echo
    else
        echo ${R}"[!] Architecture not supported."${W}
    fi
}

install_routersploit(){
    get_arch
    if [[ $SYS_ARCH == "arm64" ]]; then
        pkg update -y
        pkg install git python rust libsodium python-cryptography -y
        cd $PREFIX/opt
        [ -d routersploit ] || git clone https://github.com/threat9/routersploit
        cd $PREFIX/opt/routersploit
        export CARGO_BUILD_TARGET=aarch64-linux-android
        pip install cryptography --no-binary cryptography
        SODIUM_INSTALL=system pip install pynacl
        pip3 install -r requirements.txt
        echo "python3 $PREFIX/opt/routersploit/rsf.py" > $PREFIX/bin/rsf
        chmod +x $PREFIX/bin/rsf
        echo ${N}"[*] Routersploit installed. Run with: rsf"${W}; echo
    else
        echo ${R}"[!] Architecture not supported."${W}
    fi
}

install_nmap(){
    pkg update -y && pkg install nmap -y
    echo ${N}"[*] Nmap installed. Run with: nmap"${W}; echo
}

install_netcat(){
    pkg update -y && pkg install netcat-openbsd -y
    echo ${N}"[*] Netcat installed. Run with: nc"${W}; echo
}

install_ghost(){
    get_arch
    if [[ $SYS_ARCH == "arm64" ]]; then
        pkg update -y
        pkg install git python rust python-cryptography -y
        export CARGO_BUILD_TARGET=aarch64-linux-android
        pip install cryptography --no-binary cryptography
        pip3 install git+https://github.com/EntySec/Ghost
        echo ${N}"[*] Ghost Framework installed. Run with: ghost"${W}; echo
    else
        echo ${R}"[!] Architecture not supported."${W}
    fi
}

install_pyphisher(){
    pkg update -y
    pkg install git python curl wget php proot -y
    cd $PREFIX/opt
    [ -d PyPhisher ] || git clone https://github.com/KasRoudra/PyPhisher
    echo "cd $PREFIX/opt/PyPhisher && python3 pyphisher.py" > $PREFIX/bin/pyphisher
    chmod +x $PREFIX/bin/pyphisher
    echo ${N}"[*] PyPhisher installed. Run with: pyphisher"${W}; echo
}

install_phonesploit(){
    pkg update -y
    pkg install git python android-tools -y
    pip3 install colorama
    cd $PREFIX/opt
    [ -d PhoneSploit ] || git clone https://github.com/aerosol-can/PhoneSploit
    echo "python3 $PREFIX/opt/PhoneSploit/phonesploit.py" > $PREFIX/bin/phonesploit
    chmod +x $PREFIX/bin/phonesploit
    echo ${N}"[*] PhoneSploit installed. Run with: phonesploit"${W}; echo
}

install_sherlock(){
    pkg update -y && pkg install git python -y
    [ -d $HOME/sherlock ] || git clone https://github.com/sherlock-project/sherlock $HOME/sherlock
    cd $HOME/sherlock && pip3 install -r requirements.txt
    echo "python3 $HOME/sherlock/sherlock/sherlock.py \"\$@\"" > $PREFIX/bin/sherlock
    chmod +x $PREFIX/bin/sherlock
    echo ${N}"[*] Sherlock installed. Run with: sherlock <username>"${W}; echo
}

install_johntheripper(){
    pkg update -y && pkg install git make perl clang binutils -y
    [ -d $HOME/john ] || git clone https://github.com/openwall/john $HOME/john
    cd $HOME/john/src && ./configure && make -s clean && make -sj4
    echo "$HOME/john/run/john \"\$@\"" > $PREFIX/bin/john
    chmod +x $PREFIX/bin/john
    echo ${N}"[*] John The Ripper installed. Run with: john"${W}; echo
}

install_cupp(){
    pkg update -y && pkg install git python -y
    [ -d $HOME/cupp ] || git clone https://github.com/Mebus/cupp $HOME/cupp
    echo "python3 $HOME/cupp/cupp.py \"\$@\"" > $PREFIX/bin/cupp
    chmod +x $PREFIX/bin/cupp
    echo ${N}"[*] CUPP installed. Run with: cupp"${W}; echo
}

install_hydra(){
    pkg update -y
    pkg install wget clang binutils make libidn libpcre2 libssh libgcrypt -y
    cd $PREFIX/opt
    wget -q https://github.com/vanhauser-thc/thc-hydra/archive/refs/tags/v9.4.tar.gz
    mkdir -p thc-hydra
    tar -xzvf v9.4.tar.gz -C thc-hydra --strip-components=1
    rm v9.4.tar.gz
    cd thc-hydra && ./configure --prefix=$PREFIX && make && make install
    echo ${N}"[*] Hydra installed. Run with: hydra"${W}; echo
}

# ─────────────────────────────────────────
#  MOBILE DEV TOOLS
# ─────────────────────────────────────────

install_nodejs(){
    pkg update -y && pkg install nodejs -y
    echo ${N}"[*] Node.js $(node -v) installed."${W}; echo
}

install_python(){
    pkg update -y && pkg install python -y
    echo ${N}"[*] $(python --version) installed."${W}; echo
}

install_git(){
    pkg update -y && pkg install git -y
    read -p ${Y}"GitHub username: "${W} git_user
    read -p ${Y}"GitHub email: "${W} git_email
    git config --global user.name "$git_user"
    git config --global user.email "$git_email"
    echo ${N}"[*] Git configured for $git_user"${W}; echo
}

install_code_server(){
    pkg update -y && pkg install nodejs -y
    npm install -g code-server
    echo ${N}"[*] Code Server installed. Run with: code-server"
    echo "[*] Then open: http://localhost:8080"${W}; echo
}

install_eas_cli(){
    pkg update -y && pkg install nodejs -y
    npm install -g eas-cli
    echo ${N}"[*] EAS CLI installed."
    echo "[*] Create app: npx create-expo-app myapp"
    echo "[*] Build: eas build"${W}; echo
}

install_php(){
    pkg update -y && pkg install php -y
    echo ${N}"[*] $(php -v | head -1) installed."${W}; echo
}

install_acode(){
    echo ${N}"[*] Acode is an Android app — install from:"
    echo "    https://acode.app or F-Droid"${W}; echo
}

# ─────────────────────────────────────────
#  WEB DEV TOOLS
# ─────────────────────────────────────────

install_apache(){
    pkg update -y && pkg install apache2 -y
    echo ${N}"[*] Apache installed."
    echo "[*] Start: apachectl start"
    echo "[*] Root:  $PREFIX/share/apache2/default-site/htdocs"${W}; echo
}

install_nginx(){
    pkg update -y && pkg install nginx -y
    echo ${N}"[*] Nginx installed."
    echo "[*] Start: nginx"
    echo "[*] Root:  $PREFIX/share/nginx/html"${W}; echo
}

install_ngrok(){
    pkg update -y && pkg install wget unzip -y
    cd $HOME
    wget -q https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm64.tgz
    tar -xzf ngrok-v3-stable-linux-arm64.tgz
    mv ngrok $PREFIX/bin/ngrok
    chmod +x $PREFIX/bin/ngrok
    rm -f ngrok-v3-stable-linux-arm64.tgz
    echo ${N}"[*] ngrok installed. Run with: ngrok http 8080"
    echo "[*] Sign up at https://ngrok.com for a free auth token"${W}; echo
}

install_wordpress(){
    pkg update -y
    pkg install apache2 php php-apache mariadb wget -y
    cd $PREFIX/share/apache2/default-site/htdocs
    wget -q https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz && rm latest.tar.gz
    echo ${N}"[*] WordPress downloaded to htdocs/wordpress"
    echo "[*] Start Apache: apachectl start"
    echo "[*] Visit: http://localhost:8080/wordpress"${W}; echo
}

install_yarn(){
    pkg update -y && pkg install nodejs -y
    npm install -g yarn
    echo ${N}"[*] Yarn $(yarn -v) installed."${W}; echo
}

install_vite(){
    pkg update -y && pkg install nodejs -y
    npm install -g vite
    echo ${N}"[*] Vite installed."
    echo "[*] Create project: npm create vite@latest"${W}; echo
}

# ─────────────────────────────────────────
#  PROGRAMMING LANGUAGES
# ─────────────────────────────────────────

install_java(){
    pkg update -y && pkg install openjdk-17 -y
    echo ${N}"[*] Java $(java -version 2>&1 | head -1) installed."${W}; echo
}

install_ruby(){
    pkg update -y && pkg install ruby -y
    echo ${N}"[*] Ruby $(ruby -v) installed."${W}; echo
}

install_golang(){
    pkg update -y && pkg install golang -y
    echo ${N}"[*] Go $(go version) installed."${W}; echo
}

install_rust(){
    pkg update -y && pkg install rust -y
    echo ${N}"[*] Rust $(rustc --version) installed."${W}; echo
}

install_lua(){
    pkg update -y && pkg install lua54 -y
    echo ${N}"[*] Lua installed. Run with: lua5.4"${W}; echo
}

install_kotlin(){
    pkg update -y && pkg install openjdk-17 -y
    cd $HOME
    if [ ! -f $PREFIX/bin/kotlinc ]; then
        wget -q https://github.com/JetBrains/kotlin/releases/download/v1.9.22/kotlin-compiler-1.9.22.zip
        unzip -q kotlin-compiler-1.9.22.zip -d $PREFIX/opt/
        rm kotlin-compiler-1.9.22.zip
        ln -sf $PREFIX/opt/kotlinc/bin/kotlinc $PREFIX/bin/kotlinc
        ln -sf $PREFIX/opt/kotlinc/bin/kotlin $PREFIX/bin/kotlin
    fi
    echo ${N}"[*] Kotlin installed. Run with: kotlinc"${W}; echo
}

# ─────────────────────────────────────────
#  DATABASE TOOLS
# ─────────────────────────────────────────

install_mysql(){
    pkg update -y && pkg install mariadb -y
    mysql_install_db 2>/dev/null
    echo ${N}"[*] MariaDB (MySQL) installed."
    echo "[*] Start: mysqld_safe &"
    echo "[*] Login: mysql -u root"${W}; echo
}

install_sqlite(){
    pkg update -y && pkg install sqlite -y
    echo ${N}"[*] SQLite $(sqlite3 --version) installed. Run with: sqlite3"${W}; echo
}

install_redis(){
    pkg update -y && pkg install redis -y
    echo ${N}"[*] Redis installed."
    echo "[*] Start server: redis-server"
    echo "[*] CLI: redis-cli"${W}; echo
}

install_mongodb(){
    pkg update -y && pkg install mongodb -y
    echo ${N}"[*] MongoDB installed."
    echo "[*] Start: mongod --dbpath \$HOME/mongodb"
    echo "[*] CLI: mongosh"${W}; echo
}

install_postgresql(){
    pkg update -y && pkg install postgresql -y
    initdb $PREFIX/var/lib/postgresql 2>/dev/null
    echo ${N}"[*] PostgreSQL installed."
    echo "[*] Start: pg_ctl -D \$PREFIX/var/lib/postgresql start"
    echo "[*] Login: psql -U \$(whoami)"${W}; echo
}

# ─────────────────────────────────────────
#  DEVOPS TOOLS
# ─────────────────────────────────────────

install_docker(){
    pkg update -y && pkg install proot-distro -y
    proot-distro install ubuntu
    echo ${N}"[*] proot-distro + Ubuntu installed (Docker alternative for Termux)"
    echo "[*] Enter Ubuntu: proot-distro login ubuntu"
    echo "[*] Inside Ubuntu you can install Docker normally"${W}; echo
}

install_github_cli(){
    pkg update -y && pkg install gh -y
    echo ${N}"[*] GitHub CLI installed."
    echo "[*] Login: gh auth login"
    echo "[*] Create repo: gh repo create"${W}; echo
}

install_cloudflare_tunnel(){
    pkg update -y && pkg install wget -y
    cd $HOME
    wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64
    mv cloudflared-linux-arm64 $PREFIX/bin/cloudflared
    chmod +x $PREFIX/bin/cloudflared
    echo ${N}"[*] Cloudflare Tunnel installed."
    echo "[*] Expose port: cloudflared tunnel --url http://localhost:8080"${W}; echo
}

install_ssh_server(){
    pkg update -y && pkg install openssh -y
    echo ${N}"[*] OpenSSH installed."
    echo "[*] Start server: sshd"
    echo "[*] Your SSH port: 8022"
    echo "[*] Connect from PC: ssh -p 8022 \$(whoami)@<your-ip>"${W}; echo
}

install_ansible(){
    pkg update -y && pkg install python -y
    pip3 install ansible
    echo ${N}"[*] Ansible installed. Run with: ansible"${W}; echo
}

install_vercel_cli(){
    pkg update -y && pkg install nodejs -y
    npm install -g vercel
    echo ${N}"[*] Vercel CLI installed."
    echo "[*] Deploy: vercel"
    echo "[*] Login: vercel login"${W}; echo
}

# ─────────────────────────────────────────
#  UPDATE VELHAC
# ─────────────────────────────────────────

update_velhac(){
    echo ${Y}"[*] Checking for updates..."${W}
    if wget -q --spider "$VELHAC_RAW" 2>/dev/null; then
        wget -q -O $PREFIX/bin/velhac "$VELHAC_RAW"
        chmod +x $PREFIX/bin/velhac
        echo ${N}"[*] Velhac updated successfully!"
        echo "[*] Restart velhac to use the new version."${W}
    else
        echo ${R}"[!] Could not reach update server. Check your internet."${W}
    fi
    echo
}

# ─────────────────────────────────────────
#  CHECK INSTALLED TOOLS
# ─────────────────────────────────────────

check_installed(){
    banner
    echo ${N}"  ╔══════════════════════════════════════╗"
    echo   "  ║       INSTALLED TOOLS CHECK          ║"
    echo   "  ╠══════════════════════════════════════╣"${W}
    echo

    check_tool(){ 
        if command -v "$1" &>/dev/null || [ -f "$PREFIX/bin/$1" ]; then
            printf "  ${N}[✔] %-20s installed${W}\n" "$1"
        else
            printf "  ${R}[✘] %-20s not installed${W}\n" "$1"
        fi
    }

    echo ${Y}"  — Hacking Tools —"${W}
    check_tool beef
    check_tool msfconsole
    check_tool mitmproxy
    check_tool rsf
    check_tool nmap
    check_tool nc
    check_tool pyphisher
    check_tool phonesploit
    check_tool sherlock
    check_tool john
    check_tool cupp
    check_tool hydra
    echo

    echo ${Y}"  — Mobile Dev —"${W}
    check_tool node
    check_tool python
    check_tool git
    check_tool code-server
    check_tool eas
    check_tool php
    echo

    echo ${Y}"  — Web Dev —"${W}
    check_tool apachectl
    check_tool nginx
    check_tool ngrok
    check_tool yarn
    check_tool vite
    echo

    echo ${Y}"  — Languages —"${W}
    check_tool java
    check_tool ruby
    check_tool go
    check_tool rustc
    check_tool lua5.4
    check_tool kotlinc
    echo

    echo ${Y}"  — Databases —"${W}
    check_tool mysql
    check_tool sqlite3
    check_tool redis-cli
    check_tool mongod
    check_tool psql
    echo

    echo ${Y}"  — DevOps —"${W}
    check_tool proot-distro
    check_tool gh
    check_tool cloudflared
    check_tool sshd
    check_tool ansible
    check_tool vercel
    echo
}

# ─────────────────────────────────────────
#  UNINSTALL TOOL
# ─────────────────────────────────────────

uninstall_tool(){
    banner
    echo ${N}"  ╔══════════════════════════════════════╗"
    echo   "  ║          UNINSTALL A TOOL            ║"
    echo   "  ╠══════════════════════════════════════╣"${W}
    echo ${C}"  [1]  BeEF Framework"
    echo   "  [2]  Metasploit"
    echo   "  [3]  Routersploit"
    echo   "  [4]  PyPhisher"
    echo   "  [5]  PhoneSploit"
    echo   "  [6]  Sherlock"
    echo   "  [7]  John The Ripper"
    echo   "  [8]  CUPP"
    echo   "  [9]  Hydra"
    echo   "  [10] Code Server"
    echo   "  [11] ngrok"
    echo   "  [12] Cloudflare Tunnel"
    echo   "  [13] Kotlin"
    echo   "  [14] WordPress"${W}
    echo
    read -p ${Y}"  Select tool to uninstall: "${W} t
    echo

    confirm_uninstall(){
        read -p ${R}"  [!] Are you sure you want to uninstall $1? (y/n): "${W} confirm
        [[ "$confirm" == "y" || "$confirm" == "Y" ]]
    }

    case $t in
        1)
            confirm_uninstall "BeEF" && {
                rm -rf $PREFIX/opt/beef
                rm -f $PREFIX/bin/beef
                echo ${N}"[*] BeEF removed."${W}
            } ;;
        2)
            confirm_uninstall "Metasploit" && {
                rm -rf $PREFIX/opt/metasploit-framework
                rm -f $PREFIX/bin/msfconsole $PREFIX/bin/msfvenom $PREFIX/bin/msfdb
                echo ${N}"[*] Metasploit removed."${W}
            } ;;
        3)
            confirm_uninstall "Routersploit" && {
                rm -rf $PREFIX/opt/routersploit
                rm -f $PREFIX/bin/rsf
                echo ${N}"[*] Routersploit removed."${W}
            } ;;
        4)
            confirm_uninstall "PyPhisher" && {
                rm -rf $PREFIX/opt/PyPhisher
                rm -f $PREFIX/bin/pyphisher
                echo ${N}"[*] PyPhisher removed."${W}
            } ;;
        5)
            confirm_uninstall "PhoneSploit" && {
                rm -rf $PREFIX/opt/PhoneSploit
                rm -f $PREFIX/bin/phonesploit
                echo ${N}"[*] PhoneSploit removed."${W}
            } ;;
        6)
            confirm_uninstall "Sherlock" && {
                rm -rf $HOME/sherlock
                rm -f $PREFIX/bin/sherlock
                echo ${N}"[*] Sherlock removed."${W}
            } ;;
        7)
            confirm_uninstall "John The Ripper" && {
                rm -rf $HOME/john
                rm -f $PREFIX/bin/john
                echo ${N}"[*] John The Ripper removed."${W}
            } ;;
        8)
            confirm_uninstall "CUPP" && {
                rm -rf $HOME/cupp
                rm -f $PREFIX/bin/cupp
                echo ${N}"[*] CUPP removed."${W}
            } ;;
        9)
            confirm_uninstall "Hydra" && {
                rm -rf $PREFIX/opt/thc-hydra
                pkg remove hydra -y 2>/dev/null
                echo ${N}"[*] Hydra removed."${W}
            } ;;
        10)
            confirm_uninstall "Code Server" && {
                npm uninstall -g code-server
                echo ${N}"[*] Code Server removed."${W}
            } ;;
        11)
            confirm_uninstall "ngrok" && {
                rm -f $PREFIX/bin/ngrok
                echo ${N}"[*] ngrok removed."${W}
            } ;;
        12)
            confirm_uninstall "Cloudflare Tunnel" && {
                rm -f $PREFIX/bin/cloudflared
                echo ${N}"[*] Cloudflare Tunnel removed."${W}
            } ;;
        13)
            confirm_uninstall "Kotlin" && {
                rm -rf $PREFIX/opt/kotlinc
                rm -f $PREFIX/bin/kotlinc $PREFIX/bin/kotlin
                echo ${N}"[*] Kotlin removed."${W}
            } ;;
        14)
            confirm_uninstall "WordPress" && {
                rm -rf $PREFIX/share/apache2/default-site/htdocs/wordpress
                echo ${N}"[*] WordPress removed."${W}
            } ;;
        *)
            echo ${R}"[!] Invalid option."${W} ;;
    esac
    echo
}

# ─────────────────────────────────────────
#  UPDATE + CLEAN (FREE SPACE)
# ─────────────────────────────────────────

update_and_clean(){
    banner
    echo ${N}"  ╔══════════════════════════════════════╗"
    echo   "  ║       UPDATE + CLEAN STORAGE         ║"
    echo   "  ╠══════════════════════════════════════╣"${W}
    echo

    # Step 1: Update Velhac itself
    echo ${Y}"[1/5] Updating Velhac..."${W}
    if wget -q --spider "$VELHAC_RAW" 2>/dev/null; then
        wget -q -O $PREFIX/bin/velhac "$VELHAC_RAW"
        chmod +x $PREFIX/bin/velhac
        echo ${N}"    ✔ Velhac updated to latest version."${W}
    else
        echo ${R}"    ✘ Could not reach update server. Skipping."${W}
    fi
    echo

    # Step 2: Update all pkg packages
    echo ${Y}"[2/5] Updating all Termux packages..."${W}
    pkg update -y && pkg upgrade -y
    echo ${N}"    ✔ Packages updated."${W}
    echo

    # Step 3: Remove unused pkg packages
    echo ${Y}"[3/5] Removing unused packages..."${W}
    pkg autoremove -y 2>/dev/null
    echo ${N}"    ✔ Unused packages removed."${W}
    echo

    # Step 4: Clean pkg cache (downloaded .deb files)
    echo ${Y}"[4/5] Cleaning package cache..."${W}
    pkg clean 2>/dev/null
    rm -rf $PREFIX/var/cache/apt/archives/*.deb 2>/dev/null
    echo ${N}"    ✔ Package cache cleared."${W}
    echo

    # Step 5: Clean temp/junk files
    echo ${Y}"[5/5] Cleaning temp files..."${W}
    rm -rf $TMPDIR/* 2>/dev/null
    rm -rf $HOME/.cache/* 2>/dev/null
    rm -rf $PREFIX/tmp/* 2>/dev/null
    echo ${N}"    ✔ Temp files cleared."${W}
    echo

    # Show freed space
    echo ${N}"[*] Storage cleanup complete!"
    echo "[*] Available storage: $(df -h $HOME | tail -1 | awk '{print $4}') free"${W}
    echo
}

# ─────────────────────────────────────────
#  REMOVE PKG ADDED BY VELHAC
# ─────────────────────────────────────────

remove_velhac_packages(){
    banner
    echo ${N}"  ╔══════════════════════════════════════╗"
    echo   "  ║     REMOVE VELHAC-ADDED PACKAGES     ║"
    echo   "  ╠══════════════════════════════════════╣"${W}
    echo ${R}"  [!] WARNING: This removes pkg packages."
    echo   "  [!] Only use if you want a clean Termux."${W}
    echo
    echo ${C}"  [1]  Hacking packages (nmap, ruby, rust...)"
    echo   "  [2]  Dev packages (nodejs, python, php...)"
    echo   "  [3]  Web packages (apache2, nginx...)"
    echo   "  [4]  Language packages (openjdk-17, golang...)"
    echo   "  [5]  Database packages (mariadb, redis...)"
    echo   "  [6]  DevOps packages (openssh, gh, ansible...)"
    echo   "  [7]  Remove ALL Velhac packages"${W}
    echo
    read -p ${Y}"  Select: "${W} t
    echo

    HACKING_PKGS="nmap netcat-openbsd ruby python nodejs binutils clang make libidn libpcre2 libssh libgcrypt git curl wget libyaml libxslt nano python-cryptography rust libsodium php proot android-tools"
    DEV_PKGS="nodejs python git php"
    WEB_PKGS="apache2 nginx php php-apache mariadb"
    LANG_PKGS="openjdk-17 ruby golang rust lua54"
    DB_PKGS="mariadb sqlite redis mongodb postgresql"
    DEVOPS_PKGS="proot-distro openssh gh"

    do_remove(){
        read -p ${R}"  [!] Confirm remove: $1 packages? (y/n): "${W} confirm
        if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
            pkg remove $1 -y 2>/dev/null
            echo ${N}"[*] Done."${W}
        else
            echo ${Y}"[*] Cancelled."${W}
        fi
        echo
    }

    case $t in
        1) do_remove "$HACKING_PKGS" ;;
        2) do_remove "$DEV_PKGS" ;;
        3) do_remove "$WEB_PKGS" ;;
        4) do_remove "$LANG_PKGS" ;;
        5) do_remove "$DB_PKGS" ;;
        6) do_remove "$DEVOPS_PKGS" ;;
        7)
            read -p ${R}"  [!!] Remove ALL Velhac packages? This is irreversible. (y/n): "${W} confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                ALL="$HACKING_PKGS $DEV_PKGS $WEB_PKGS $LANG_PKGS $DB_PKGS $DEVOPS_PKGS"
                # deduplicate
                ALL=$(echo $ALL | tr ' ' '\n' | sort -u | tr '\n' ' ')
                pkg remove $ALL -y 2>/dev/null
                pkg autoremove -y 2>/dev/null
                echo ${N}"[*] All Velhac packages removed."${W}
            else
                echo ${Y}"[*] Cancelled."${W}
            fi
            echo ;;
        *) echo ${R}"[!] Invalid option."${W} ;;
    esac
}

# ─────────────────────────────────────────
#  MAIN MENU
# ─────────────────────────────────────────

main_menu(){
    banner
    echo ${N}"  ╔══════════════════════════════════════╗"
    echo   "  ║          SELECT CATEGORY             ║"
    echo   "  ╠══════════════════════════════════════╣"${W}
    echo ${C}"  [1]  Hacking Tools"
    echo   "  [2]  Mobile Dev"
    echo   "  [3]  Web Dev"
    echo   "  [4]  Languages"
    echo   "  [5]  Database"
    echo   "  [6]  DevOps"
    echo   "  [7]  Update Velhac"
    echo   "  [8]  Check Installed Tools"
    echo   "  [9]  Uninstall a Tool"
    echo   "  [10] Update + Clean Storage"
    echo   "  [11] Remove Velhac Packages"
    echo   "  [0]  Exit"${W}
    echo
    read -p ${Y}"  Select category: "${W} category
    echo

    case $category in

        1)
            banner
            echo ${N}"  ╔══════════════════════════════════════╗"
            echo   "  ║          HACKING TOOLS               ║"
            echo   "  ╠══════════════════════════════════════╣"${W}
            echo ${C}"  [1]  BeEF Framework"
            echo   "  [2]  Metasploit"
            echo   "  [3]  mitmproxy"
            echo   "  [4]  Routersploit"
            echo   "  [5]  Nmap"
            echo   "  [6]  Netcat"
            echo   "  [7]  Ghost Framework"
            echo   "  [8]  PyPhisher"
            echo   "  [9]  PhoneSploit"
            echo   "  [10] Sherlock"
            echo   "  [11] John The Ripper"
            echo   "  [12] CUPP"
            echo   "  [13] Hydra"${W}
            echo
            read -p ${Y}"  Select tool: "${W} t; echo
            case $t in
                1)  echo ${N}"[*] Installing BeEF..."${W}; install_beef ;;
                2)  echo ${N}"[*] Installing Metasploit..."${W}; install_metasploit ;;
                3)  echo ${N}"[*] Installing mitmproxy..."${W}; install_mitmproxy ;;
                4)  echo ${N}"[*] Installing Routersploit..."${W}; install_routersploit ;;
                5)  echo ${N}"[*] Installing Nmap..."${W}; install_nmap ;;
                6)  echo ${N}"[*] Installing Netcat..."${W}; install_netcat ;;
                7)  echo ${N}"[*] Installing Ghost Framework..."${W}; install_ghost ;;
                8)  echo ${N}"[*] Installing PyPhisher..."${W}; install_pyphisher ;;
                9)  echo ${N}"[*] Installing PhoneSploit..."${W}; install_phonesploit ;;
                10) echo ${N}"[*] Installing Sherlock..."${W}; install_sherlock ;;
                11) echo ${N}"[*] Installing John The Ripper..."${W}; install_johntheripper ;;
                12) echo ${N}"[*] Installing CUPP..."${W}; install_cupp ;;
                13) echo ${N}"[*] Installing Hydra..."${W}; install_hydra ;;
                *)  echo ${R}"[!] Invalid option."${W} ;;
            esac ;;

        2)
            banner
            echo ${N}"  ╔══════════════════════════════════════╗"
            echo   "  ║          MOBILE DEV TOOLS            ║"
            echo   "  ╠══════════════════════════════════════╣"${W}
            echo ${C}"  [1]  Node.js"
            echo   "  [2]  Python"
            echo   "  [3]  Git + GitHub Config"
            echo   "  [4]  Code Server (VS Code)"
            echo   "  [5]  EAS CLI (React Native)"
            echo   "  [6]  PHP"
            echo   "  [7]  Acode Editor (info)"${W}
            echo
            read -p ${Y}"  Select tool: "${W} t; echo
            case $t in
                1) echo ${N}"[*] Installing Node.js..."${W}; install_nodejs ;;
                2) echo ${N}"[*] Installing Python..."${W}; install_python ;;
                3) echo ${N}"[*] Setting up Git..."${W}; install_git ;;
                4) echo ${N}"[*] Installing Code Server..."${W}; install_code_server ;;
                5) echo ${N}"[*] Installing EAS CLI..."${W}; install_eas_cli ;;
                6) echo ${N}"[*] Installing PHP..."${W}; install_php ;;
                7) install_acode ;;
                *) echo ${R}"[!] Invalid option."${W} ;;
            esac ;;

        3)
            banner
            echo ${N}"  ╔══════════════════════════════════════╗"
            echo   "  ║          WEB DEV TOOLS               ║"
            echo   "  ╠══════════════════════════════════════╣"${W}
            echo ${C}"  [1]  Apache (Web Server)"
            echo   "  [2]  Nginx (Web Server)"
            echo   "  [3]  ngrok (Expose localhost)"
            echo   "  [4]  WordPress"
            echo   "  [5]  Yarn"
            echo   "  [6]  Vite"${W}
            echo
            read -p ${Y}"  Select tool: "${W} t; echo
            case $t in
                1) echo ${N}"[*] Installing Apache..."${W}; install_apache ;;
                2) echo ${N}"[*] Installing Nginx..."${W}; install_nginx ;;
                3) echo ${N}"[*] Installing ngrok..."${W}; install_ngrok ;;
                4) echo ${N}"[*] Installing WordPress..."${W}; install_wordpress ;;
                5) echo ${N}"[*] Installing Yarn..."${W}; install_yarn ;;
                6) echo ${N}"[*] Installing Vite..."${W}; install_vite ;;
                *) echo ${R}"[!] Invalid option."${W} ;;
            esac ;;

        4)
            banner
            echo ${N}"  ╔══════════════════════════════════════╗"
            echo   "  ║          LANGUAGES                   ║"
            echo   "  ╠══════════════════════════════════════╣"${W}
            echo ${C}"  [1]  Java (OpenJDK 17)"
            echo   "  [2]  Ruby"
            echo   "  [3]  Go (Golang)"
            echo   "  [4]  Rust"
            echo   "  [5]  Lua"
            echo   "  [6]  Kotlin"${W}
            echo
            read -p ${Y}"  Select language: "${W} t; echo
            case $t in
                1) echo ${N}"[*] Installing Java..."${W}; install_java ;;
                2) echo ${N}"[*] Installing Ruby..."${W}; install_ruby ;;
                3) echo ${N}"[*] Installing Go..."${W}; install_golang ;;
                4) echo ${N}"[*] Installing Rust..."${W}; install_rust ;;
                5) echo ${N}"[*] Installing Lua..."${W}; install_lua ;;
                6) echo ${N}"[*] Installing Kotlin..."${W}; install_kotlin ;;
                *) echo ${R}"[!] Invalid option."${W} ;;
            esac ;;

        5)
            banner
            echo ${N}"  ╔══════════════════════════════════════╗"
            echo   "  ║          DATABASE TOOLS              ║"
            echo   "  ╠══════════════════════════════════════╣"${W}
            echo ${C}"  [1]  MariaDB (MySQL)"
            echo   "  [2]  SQLite"
            echo   "  [3]  Redis"
            echo   "  [4]  MongoDB"
            echo   "  [5]  PostgreSQL"${W}
            echo
            read -p ${Y}"  Select database: "${W} t; echo
            case $t in
                1) echo ${N}"[*] Installing MariaDB..."${W}; install_mysql ;;
                2) echo ${N}"[*] Installing SQLite..."${W}; install_sqlite ;;
                3) echo ${N}"[*] Installing Redis..."${W}; install_redis ;;
                4) echo ${N}"[*] Installing MongoDB..."${W}; install_mongodb ;;
                5) echo ${N}"[*] Installing PostgreSQL..."${W}; install_postgresql ;;
                *) echo ${R}"[!] Invalid option."${W} ;;
            esac ;;

        6)
            banner
            echo ${N}"  ╔══════════════════════════════════════╗"
            echo   "  ║          DEVOPS TOOLS                ║"
            echo   "  ╠══════════════════════════════════════╣"${W}
            echo ${C}"  [1]  proot-distro + Ubuntu (Docker alt)"
            echo   "  [2]  GitHub CLI"
            echo   "  [3]  Cloudflare Tunnel"
            echo   "  [4]  SSH Server"
            echo   "  [5]  Ansible"
            echo   "  [6]  Vercel CLI"${W}
            echo
            read -p ${Y}"  Select tool: "${W} t; echo
            case $t in
                1) echo ${N}"[*] Installing proot-distro..."${W}; install_docker ;;
                2) echo ${N}"[*] Installing GitHub CLI..."${W}; install_github_cli ;;
                3) echo ${N}"[*] Installing Cloudflare Tunnel..."${W}; install_cloudflare_tunnel ;;
                4) echo ${N}"[*] Installing SSH Server..."${W}; install_ssh_server ;;
                5) echo ${N}"[*] Installing Ansible..."${W}; install_ansible ;;
                6) echo ${N}"[*] Installing Vercel CLI..."${W}; install_vercel_cli ;;
                *) echo ${R}"[!] Invalid option."${W} ;;
            esac ;;

        7)
            banner
            echo ${N}"  ╔══════════════════════════════════════╗"
            echo   "  ║          UPDATE VELHAC               ║"
            echo   "  ╠══════════════════════════════════════╣"${W}
            echo
            update_velhac ;;

        8)
            check_installed ;;

        9)
            uninstall_tool ;;

        10)
            update_and_clean ;;

        11)
            remove_velhac_packages ;;

        0)
            echo ${N}"[*] Goodbye! — Smart Tech Programming"${W}
            echo
            exit 0 ;;

        *)
            echo ${R}"[!] Invalid category. Select 0-11."${W}; echo ;;
    esac
}

# Run
main_menu
