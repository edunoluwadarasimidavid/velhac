#!/data/data/com.termux/files/usr/bin/bash

# Colors
R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
W="$(printf '\033[1;37m')"
C="$(printf '\033[1;36m')"
N="$(printf '\033[1;92m')"  # Neon green

# Banner
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
printf ${Y}"         Mobile Dev & Security Toolkit\n"
printf      "           By Smart Tech Programming\n"
printf      "        youtube.com/@smarttechprogramming\n\n"${W}
}

# FIX 14: return instead of exit so script doesn't die
get_arch() {
    printf ${G}"[*] Checking device architecture..."${W}
    echo
    case $(getprop ro.product.cpu.abi) in
        arm64-v8a)  SYS_ARCH=arm64 ;;
        armeabi|armeabi-v7a) SYS_ARCH=armhf ;;
        *)
            echo ${R}"[!] Unsupported architecture."${W}
            SYS_ARCH=unknown
            ;;
    esac
}

# ─────────────────────────────────────────
#         SECURITY TOOLS
# ─────────────────────────────────────────

install_beef(){
    # FIX 1+2: removed espeak and bison (not in Termux repos)
    pkg update -y
    pkg install curl git libyaml libxslt ruby python nodejs nano binutils -y
    cd $PREFIX/opt
    # Skip if already cloned
    [ -d beef ] || git clone https://github.com/beefproject/beef
    cd $PREFIX/opt/beef
    echo " gem 'net-smtp', require: false" >> Gemfile
    # FIX 3: use grep to find and delete the sudo check line safely
    grep -n "sudo" install | head -1 | cut -d: -f1 | xargs -I{} sed -i '{}d' install
    sed -i 's/sudo//' install
    bash install
    echo "cd $PREFIX/opt/beef && ruby beef" > $PREFIX/bin/beef
    chmod +x $PREFIX/bin/beef
    echo ${N}"[*] BeEF installed. Run with: beef"
    echo "[*] Change credentials in: $PREFIX/opt/beef/config.yaml"${W}
    echo
}

install_metasploit(){
    # FIX 4: added fallback message if script is unavailable
    pkg update -y
    pkg install wget -y
    echo ${Y}"[*] Downloading Metasploit installer..."${W}
    if wget -q --spider https://github.com/gushmazuko/metasploit_in_termux/raw/master/metasploit.sh; then
        wget https://github.com/gushmazuko/metasploit_in_termux/raw/master/metasploit.sh
        bash metasploit.sh
        rm metasploit.sh
    else
        echo ${R}"[!] Metasploit installer unavailable. Try manually:"
        echo "    https://github.com/gushmazuko/metasploit_in_termux"${W}
    fi
    echo
}

install_mitmproxy(){
    get_arch
    if [[ $SYS_ARCH == "arm64" ]]; then
        pkg update -y
        pkg install python rust python-cryptography -y
        export CARGO_BUILD_TARGET=aarch64-linux-android
        pip install cryptography --no-binary cryptography
        pip3 install mitmproxy
        echo ${N}"[*] mitmproxy installed. Run with: mitmproxy"${W}
        echo
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
        echo ${N}"[*] Routersploit installed. Run with: rsf"${W}
        echo
    else
        echo ${R}"[!] Architecture not supported."${W}
    fi
}

install_nmap(){
    pkg update -y
    pkg install nmap -y
    echo ${N}"[*] Nmap installed. Run with: nmap"${W}
    echo
}

install_netcat(){
    pkg update -y
    pkg install netcat-openbsd -y
    echo ${N}"[*] Netcat installed. Run with: nc"${W}
    echo
}

install_ghost(){
    get_arch
    if [[ $SYS_ARCH == "arm64" ]]; then
        pkg update -y
        pkg install git python rust python-cryptography -y
        export CARGO_BUILD_TARGET=aarch64-linux-android
        pip install cryptography --no-binary cryptography
        pip3 install git+https://github.com/EntySec/Ghost
        echo ${N}"[*] Ghost Framework installed."${W}
        echo
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
    echo ${N}"[*] PyPhisher installed. Run with: pyphisher"${W}
    echo
}

install_phonesploit(){
    pkg update -y
    pkg install git python android-tools -y
    pip3 install colorama
    cd $PREFIX/opt
    [ -d PhoneSploit ] || git clone https://github.com/aerosol-can/PhoneSploit
    echo "python3 $PREFIX/opt/PhoneSploit/phonesploit.py" > $PREFIX/bin/phonesploit
    chmod +x $PREFIX/bin/phonesploit
    echo ${N}"[*] PhoneSploit installed. Run with: phonesploit"${W}
    echo
}

install_sherlock(){
    pkg update -y
    pkg install git python -y
    # FIX 11: use absolute path, skip if exists
    [ -d $HOME/sherlock ] || git clone https://github.com/sherlock-project/sherlock $HOME/sherlock
    cd $HOME/sherlock
    pip3 install -r requirements.txt
    # FIX 11: create launcher
    echo "python3 $HOME/sherlock/sherlock/sherlock.py \"\$@\"" > $PREFIX/bin/sherlock
    chmod +x $PREFIX/bin/sherlock
    echo ${N}"[*] Sherlock installed. Run with: sherlock <username>"${W}
    echo
}

install_johntheripper(){
    pkg update -y
    pkg install git make perl clang binutils -y
    [ -d $HOME/john ] || git clone https://github.com/openwall/john $HOME/john
    cd $HOME/john/src
    ./configure
    make -s clean && make -sj4
    # FIX 9: create launcher
    echo "$HOME/john/run/john \"\$@\"" > $PREFIX/bin/john
    chmod +x $PREFIX/bin/john
    echo ${N}"[*] John The Ripper installed. Run with: john"${W}
    echo
}

install_cupp(){
    pkg update -y
    pkg install git python -y
    [ -d $HOME/cupp ] || git clone https://github.com/Mebus/cupp $HOME/cupp
    # FIX 10: create launcher
    echo "python3 $HOME/cupp/cupp.py \"\$@\"" > $PREFIX/bin/cupp
    chmod +x $PREFIX/bin/cupp
    echo ${N}"[*] CUPP installed. Run with: cupp"${W}
    echo
}

install_hydra(){
    # FIX 5+6+7+8: removed git-svn, memcached, fixed libpcreposix -> libpcre2, removed libgpg-error
    pkg update -y
    pkg install wget clang binutils make libidn libpcre2 libssh libgcrypt -y
    cd $PREFIX/opt
    wget -q https://github.com/vanhauser-thc/thc-hydra/archive/refs/tags/v9.4.tar.gz
    mkdir -p thc-hydra
    tar -xzvf v9.4.tar.gz -C thc-hydra --strip-components=1
    rm v9.4.tar.gz
    cd thc-hydra
    ./configure --prefix=$PREFIX
    make
    make install
    echo ${N}"[*] Hydra installed. Run with: hydra"${W}
    echo
}

# ─────────────────────────────────────────
#         DEV TOOLS
# ─────────────────────────────────────────

install_nodejs(){
    pkg update -y
    pkg install nodejs -y
    echo ${N}"[*] Node.js installed. Version: $(node -v)"${W}
    echo
}

install_python(){
    pkg update -y
    pkg install python -y
    echo ${N}"[*] Python installed. Version: $(python --version)"${W}
    echo
}

install_git(){
    pkg update -y
    pkg install git -y
    echo ${N}"[*] Git installed."${W}
    echo
    read -p ${Y}"Enter your GitHub username: "${W} git_user
    read -p ${Y}"Enter your GitHub email: "${W} git_email
    git config --global user.name "$git_user"
    git config --global user.email "$git_email"
    echo ${N}"[*] Git configured for $git_user"${W}
    echo
}

install_code_server(){
    # FIX 12: code-server not in Termux repo, install via npm
    pkg update -y
    pkg install nodejs -y
    npm install -g code-server
    echo ${N}"[*] Code Server installed. Run with: code-server"
    echo "[*] Open browser at: http://localhost:8080"${W}
    echo
}

install_react_native(){
    # FIX 13: expo-cli deprecated, use create-expo-app
    pkg update -y
    pkg install nodejs -y
    npm install -g eas-cli
    echo ${N}"[*] EAS CLI installed."
    echo "[*] Create a project with: npx create-expo-app myapp"
    echo "[*] Build with: eas build"${W}
    echo
}

install_php(){
    pkg update -y
    pkg install php -y
    echo ${N}"[*] PHP installed. Version: $(php -v | head -1)"${W}
    echo
}

# ─────────────────────────────────────────
#         MAIN MENU
# ─────────────────────────────────────────

banner

echo ${N}"  ╔══════════════════════════════════════╗"
echo   "  ║          SELECT CATEGORY             ║"
echo   "  ╠══════════════════════════════════════╣"${W}
echo ${C}"  [1]  Hacking Tools"
echo   "  [2]  Mobile Dev Tools"${W}
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
        read -p ${Y}"  Select tool: "${W} user_input
        echo
        case $user_input in
            1)  echo ${N}"[*] Installing BeEF..."${W}; echo; install_beef ;;
            2)  echo ${N}"[*] Installing Metasploit..."${W}; echo; install_metasploit ;;
            3)  echo ${N}"[*] Installing mitmproxy..."${W}; echo; install_mitmproxy ;;
            4)  echo ${N}"[*] Installing Routersploit..."${W}; echo; install_routersploit ;;
            5)  echo ${N}"[*] Installing Nmap..."${W}; echo; install_nmap ;;
            6)  echo ${N}"[*] Installing Netcat..."${W}; echo; install_netcat ;;
            7)  echo ${N}"[*] Installing Ghost Framework..."${W}; echo; install_ghost ;;
            8)  echo ${N}"[*] Installing PyPhisher..."${W}; echo; install_pyphisher ;;
            9)  echo ${N}"[*] Installing PhoneSploit..."${W}; echo; install_phonesploit ;;
            10) echo ${N}"[*] Installing Sherlock..."${W}; echo; install_sherlock ;;
            11) echo ${N}"[*] Installing John The Ripper..."${W}; echo; install_johntheripper ;;
            12) echo ${N}"[*] Installing CUPP..."${W}; echo; install_cupp ;;
            13) echo ${N}"[*] Installing Hydra..."${W}; echo; install_hydra ;;
            *)  echo ${R}"[!] Invalid option."${W}; echo ;;
        esac
        ;;

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
        echo   "  [6]  PHP"${W}
        echo
        read -p ${Y}"  Select tool: "${W} user_input
        echo
        case $user_input in
            1) echo ${N}"[*] Installing Node.js..."${W}; echo; install_nodejs ;;
            2) echo ${N}"[*] Installing Python..."${W}; echo; install_python ;;
            3) echo ${N}"[*] Setting up Git..."${W}; echo; install_git ;;
            4) echo ${N}"[*] Installing Code Server..."${W}; echo; install_code_server ;;
            5) echo ${N}"[*] Installing EAS CLI..."${W}; echo; install_react_native ;;
            6) echo ${N}"[*] Installing PHP..."${W}; echo; install_php ;;
            *) echo ${R}"[!] Invalid option."${W}; echo ;;
        esac
        ;;

    *)
        echo ${R}"[!] Invalid category. Please select 1 or 2."${W}
        echo
        ;;

esac
