#!/bin/bash

dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
###########- COLOR CODE -##############
colornow=$(cat /etc/toji/theme/color.conf)
export NC="\e[0m"
export YELLOW='\033[0;33m';
export RED="\033[0;31m"
export COLOR1="$(cat /etc/toji/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
export COLBG1="$(cat /etc/toji/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')"
WH='\033[1;37m'
###########- END COLOR CODE -##########
tram=$( free -h | awk 'NR==2 {print $2}' )
uram=$( free -h | awk 'NR==2 {print $3}' )
ipn=$(curl -s https://pastebin.com/raw/MPzxzcus)
ISP=$(curl -s ipinfo.io/org?token=$ipn | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city?token=$ipn )
vnstat_profile=$(vnstat | sed -n '3p' | awk '{print $1}' | grep -o '[^:]*')
vnstat -i ${vnstat_profile} >/root/t1
bulan=$(date +%b)
today=$(vnstat -i ${vnstat_profile} | grep today | awk '{print $8}')
todayd=$(vnstat -i ${vnstat_profile} | grep today | awk '{print $8}')
today_v=$(vnstat -i ${vnstat_profile} | grep today | awk '{print $9}')
today_rx=$(vnstat -i ${vnstat_profile} | grep today | awk '{print $2}')
today_rxv=$(vnstat -i ${vnstat_profile} | grep today | awk '{print $3}')
today_tx=$(vnstat -i ${vnstat_profile} | grep today | awk '{print $5}')
today_txv=$(vnstat -i ${vnstat_profile} | grep today | awk '{print $6}')
if [ "$(grep -wc ${bulan} /root/t1)" != '0' ]; then
    bulan=$(date +%b)
    month=$(vnstat -i ${vnstat_profile} | grep "$bulan " | awk '{print $9}')
    month_v=$(vnstat -i ${vnstat_profile} | grep "$bulan " | awk '{print $10}')
    month_rx=$(vnstat -i ${vnstat_profile} | grep "$bulan " | awk '{print $3}')
    month_rxv=$(vnstat -i ${vnstat_profile} | grep "$bulan " | awk '{print $4}')
    month_tx=$(vnstat -i ${vnstat_profile} | grep "$bulan " | awk '{print $6}')
    month_txv=$(vnstat -i ${vnstat_profile} | grep "$bulan " | awk '{print $7}')
else
    bulan=$(date +%Y-%m)
    month=$(vnstat -i ${vnstat_profile} | grep "$bulan " | awk '{print $8}')
    month_v=$(vnstat -i ${vnstat_profile} | grep "$bulan " | awk '{print $9}')
    month_rx=$(vnstat -i ${vnstat_profile} | grep "$bulan " | awk '{print $2}')
    month_rxv=$(vnstat -i ${vnstat_profile} | grep "$bulan " | awk '{print $3}')
    month_tx=$(vnstat -i ${vnstat_profile} | grep "$bulan " | awk '{print $5}')
    month_txv=$(vnstat -i ${vnstat_profile} | grep "$bulan " | awk '{print $6}')
fi
if [ "$(grep -wc yesterday /root/t1)" != '0' ]; then
    yesterday=$(vnstat -i ${vnstat_profile} | grep yesterday | awk '{print $8}')
    yesterday_v=$(vnstat -i ${vnstat_profile} | grep yesterday | awk '{print $9}')
    yesterday_rx=$(vnstat -i ${vnstat_profile} | grep yesterday | awk '{print $2}')
    yesterday_rxv=$(vnstat -i ${vnstat_profile} | grep yesterday | awk '{print $3}')
    yesterday_tx=$(vnstat -i ${vnstat_profile} | grep yesterday | awk '{print $5}')
    yesterday_txv=$(vnstat -i ${vnstat_profile} | grep yesterday | awk '{print $6}')
else
    yesterday=NULL
    yesterday_v=NULL
    yesterday_rx=NULL
    yesterday_rxv=NULL
    yesterday_tx=NULL
    yesterday_txv=NULL
fi

# // SSH Websocket Proxy
ssh_ws=$( systemctl status ws-stunnel | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $ssh_ws == "running" ]]; then
    status_ws="${COLOR1}ON${NC}"
else
    status_ws="${RED}OFF${NC}"
fi

# // nginx
nginx=$( systemctl status nginx | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $nginx == "running" ]]; then
    status_nginx="${COLOR1}ON${NC}"
else
    status_nginx="${RED}OFF${NC}"
fi

Tojiba () {
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}               ${WH}• MENU PANEL VPS •              ${NC} $COLOR1 $NC"
echo -e "$COLOR1 ${NC} ${COLBG1}                  ${WH}• PREMIUM •                  ${NC} $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
uphours=`uptime -p | awk '{print $2,$3}' | cut -d , -f1`
upminutes=`uptime -p | awk '{print $4,$5}' | cut -d , -f1`
uptimecek=`uptime -p | awk '{print $6,$7}' | cut -d , -f1`
cekup=`uptime -p | grep -ow "day"`
IPVPS=$(curl -s ipinfo.io/ip )

if [ "$Isadmin" = "ON" ]; then
uis="${COLOR1}Premium User$NC"
else
uis="${COLOR1}Premium Version$NC"
fi
echo -e "$COLOR1 $NC ${WH}User Roles        ${COLOR1}: ${WH}$uis"
if [ "$cekup" = "day" ]; then
echo -e "$COLOR1 $NC ${WH}System Uptime     ${COLOR1}: ${WH}$uphours $upminutes $uptimecek"
else
echo -e "$COLOR1 $NC ${WH}System Uptime     ${COLOR1}: ${WH}$uphours $upminutes"
fi
echo -e "$COLOR1 $NC ${WH}Memory Usage      ${COLOR1}: ${WH}$uram / $tram"
echo -e "$COLOR1 $NC ${WH}ISP & City        ${COLOR1}: ${WH}$ISP & $CITY"
echo -e "$COLOR1 $NC ${WH}IP-VPS            ${COLOR1}: ${WH}$IPVPS${NC}"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 $NC ${WH}[ SSH WS : ${status_ws} ${WH}]  ${WH}[ TOJIRENZ ${WH}]   ${WH}[ NGINX : ${status_nginx} ${WH}] $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${COLOR1}Traffic${NC}      ${COLOR1}Today       Yesterday       Month   ${NC}"
echo -e "$COLOR1 ${WH}Download${NC}   ${WH}$today_tx $today_txv     $yesterday_tx $yesterday_txv     $month_tx $month_txv   ${NC}"
echo -e "$COLOR1 ${WH}Upload${NC}     ${WH}$today_rx $today_rxv    $yesterday_rx $yesterday_rxv     $month_rx $month_rxv   ${NC}"
echo -e "$COLOR1 ${COLOR1}Total${NC}    ${COLOR1}  $todayd $today_v    $yesterday $yesterday_v     $month $month_v  ${NC} "
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
}


Option1() {
Tojiba
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "  ${WH}[${y}01${WH}]${NC} ${y}• ${WH}Create SSH & OpenVPN Account   ${WH}[${y}${status_ssh_ovpn}${WH}]"
echo -e "  ${WH}[${y}02${WH}]${NC} ${y}• ${WH}Generate SSH & OpenVPN Trial Account   ${WH}[${y}${status_trial}${WH}]"
echo -e "  ${WH}[${y}03${WH}]${NC} ${y}• ${WH}Extend SSH & OpenVPN Account Active Life   ${WH}[${y}${status_extend}${WH}]"
echo -e "  ${WH}[${y}04${WH}]${NC} ${y}• ${WH}Check User Login SSH & OpenVPN"
echo -e "  ${WH}[${y}05${WH}]${NC} ${y}• ${WH}List Members SSH & OpenVPN"
echo -e "  ${WH}[${y}06${WH}]${NC} ${y}• ${WH}Delete SSH & OpenVPN Account"
echo -e "  ${WH}[${y}07${WH}]${NC} ${y}• ${WH}Delete Expired SSH & OpenVPN Users"
echo -e "  ${WH}[${y}08${WH}]${NC} ${y}• ${WH}Set up Autokill SSH"
echo -e "  ${WH}[${y}09${WH}]${NC} ${y}• ${WH}Display Users with Multiple SSH Logins"
echo -e "  ${WH}[${y}10${WH}]${NC} ${y}• ${WH}Restart All Services"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}${WH}     • I dont regret sharing this script •${NC}  $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
}

Option2 () {
Tojiba
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e ""
echo -e "  ${WH}11${y}. Create Account L2TP"
echo -e "  ${WH}12${y}. Delete Account L2TP"
echo -e "  ${WH}13${y}. Extend Account L2TP Active Life"
echo -e ""
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}${WH}     • I dont regret sharing this script •${NC}  $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
}

Option3 () {
Tojiba
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e ""
echo -e "  ${WH}17${y}. Create Account SSTP"
echo -e "  ${WH}18${y}. Delete Account SSTP"
echo -e "  ${WH}19${y}. Extend Account SSTP Active Life"
echo -e "  ${WH}20${y}. Check User Login SSTP"
echo -e ""
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}${WH}     • I dont regret sharing this script •${NC}  $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
}

Option4 () {
Tojiba
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e ""
echo -e "  ${WH}1${y}. Create Account Wireguard"
echo -e "  ${WH}2${y}. Delete Account Wireguard"
echo -e "  ${WH}3${y}. Extend Account Wireguard Active Life"
echo -e ""
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}${WH}     • I dont regret sharing this script •${NC}  $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
}


Option4 () {
Tojiba
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e ""
echo -e "  ${WH}1${y}. Change Port Of Some Service"
echo -e "  ${WH}2${y}. Autobackup Data VPS"
echo -e "  ${WH}3${y}. Backup Data VPS"
echo -e "  ${WH}4${y}. Restore Data VPS"
echo -e "  ${WH}5${y}. Limit Bandwidth Speed Server"
echo -e "  ${WH}6${y}. Check Usage of VPS RAM"
echo -e "  ${WH}7${y}. Reboot VPS"
echo -e "  ${WH}8${y}. Speedtest VPS"
echo -e "  ${WH}9${y}. Display System Information"
echo -e "  ${WH}10${y}. Info Script Auto Install"
echo -e ""
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}${WH}     • I dont regret sharing this script •${NC}  $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
}

main_menu() {
clear
Tojiba
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e ""
echo -e "  ${WH}1${y}. SSH WS [menu]"
echo -e "  ${WH}2${y}. L2TP [menu]"
echo -e "  ${WH}3${y}. SSTP [menu]"
echo -e "  ${WH}4${y}. Wireguard [menu]"
echo -e "  ${WH}5${y}. SYSTEM [menu]"
echo -e ""
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}${WH}     • I dont regret sharing this script •${NC}  $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
    read -p "Select From Options [1 - 5]: " MENU1

    case $MENU1 in
        1)
            Option1
            echo ""
            read -p "Select [1 - 10]: " SUB_MENU
            case $SUB_MENU in
                1) addssh ;;
                2) trialssh ;;
                3) renewssh ;;
                4) cekssh ;;
                5) member ;;
                6) delssh ;;
                7) delexp ;;
                8) autokill ;;
                9) ceklim ;;
                10) restart ;;
                *)  echo ""
                    echo "Invalid option. Please select a valid option." 
                    sleep 3 ;;
            esac
            ;;
        2)
            Option2
            echo ""
            read -p "Select [1 - 3]: " SUB_MENU
            case $SUB_MENU in
               11) addl2tp ;;
               12) dell2tp ;;
               13) renewl2tp ;;
                *)  echo ""
                    echo "Invalid option. Please select a valid option." 
                    sleep 3 ;;
            esac
            ;;
        3)
            Option3
            echo ""
            read -p "Select [1 - 4]: " SUB_MENU
            case $SUB_MENU in
                1) addsstp ;;
                2) delsstp ;;
                3) renewsstp ;;
                4) ceksstp ;;
                *)  echo ""
                    echo "Invalid option. Please select a valid option." 
                    sleep 3 ;;
            esac
            ;;
        4)
            Option4
            echo ""
            read -p "Select [1 - 2]: " SUB_MENU
            case $SUB_MENU in
                1) addwg ;;
                2) delwg ;;
                3) renewwg ;;
                *)  echo ""
                    echo "Invalid option. Please select a valid option." 
                    sleep 3 ;;
            esac
            ;;
        5)
            Option5
            echo ""
            read -p "Select [1 - 11]: " SUB_MENU
            case $SUB_MENU in
               1) changeport ;;
               2) autobackup ;;
               3) backup ;;
               4) restore ;;
               5) limitspeed ;;
               6) ram ;;
               7) reboot ;;
               8) speedtest ;;
               9) info ;;
              10) about ;;
              11) theme
                 *)  echo ""
                     echo "Invalid option. Please select a valid option." 
                     sleep 3 ;;
            esac
            ;;
        *)  echo ""
            echo "Invalid option. Please select a valid option." 
            sleep 3 ;;
    esac
}

# Main script execution starts here
while true; do
    main_menu
done
