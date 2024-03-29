#!/bin/bash

install_dependencies() {
if ! command -v jq &> /dev/null; then
print_Message "1;31" "Error:JQ Is Not Installed." "1"
print_Message "1;31" "Waiting For Install..." "1"
sudo apt-get update
sudo apt-get install -y jq
fi

if ! command -v curl &> /dev/null; then
print_Message "1;31" "Error:Curl Is Not Installed." "1"
print_Message "1;31" "Waiting For Install..." "1"
sudo apt-get update
sudo apt-get install -y curl
fi
}

print_Message() {
Color=$1
Message=$2
Format=$3
printf "\n\033[${Format};${Color}m%s\033[0m\n" "$Message"
}

display_banner() {

printf "\033[1;33m Project:Gamee Hack\n"
printf "\033[1;33m Developer:\033[1mARMIN-SOFT | WWW.ARMIN-SOFT.IR\n"
printf "\e[36m"
printf "
   __    ____  __  __  ____  _  _      ___  _____  ____  ____ 
  /__\  (  _ \(  \/  )(_  _)( \( )___ / __)(  _  )( ___)(_  _)
 /(__)\  )   / )    (  _)(_  )  ((___)\__ \ )(_)(  )__)   )(  
(__)(__)(_)\_)(_/\/\_)(____)(_)\_)    (___/(_____)(__)   (__) 
  ___    __    __  __  ____  ____    _   _    __    ___  _  _ 
 / __)  /__\  (  \/  )( ___)( ___)  ( )_( )  /__\  / __)( )/ )
( (_-. /(__)\  )    (  )__)  )__)    ) _ (  /(__)\( (__  )  ( 
 \___/(__)(__)(_/\/\_)(____)(____)  (_) (_)(__)(__)\___)(_)\_)                 
"
}

display_progress() {
Percentage=$1
Bar_Length=60
Fill_Length=$((Percentage * Bar_Length / 100))
Fill=$(printf "%${Fill_Length}s" | tr ' ' '=')
Empty=$(printf "%$((Bar_Length - Fill_Length))s" | tr ' ' '-')

if ((Percentage < 30)); then
Color="31"
elif ((Percentage < 70)); then
Color="33"
else
Color="36"
fi

printf "\r\e[1;${Color}m[%-${Bar_Length}s] %3d%%\e[0m" "$Fill$Empty" "$Percentage"
}

main() {
install_dependencies
display_banner

while true; do
printf "\n\e[1;95mEnter License: \e[0m" && read -p "" License
if [[ ! "$License" =~ ^[A-Za-z0-9]{32}$ ]]; then
print_Message "1;31" "Error:Enter A Valid 32-Character License" "1"
else
break
fi
done

while true; do
printf "\e[1;95mEnter Score: \e[0m" && read -p "" Score

if [[ ! "$Score" =~ ^[0-9]+$ ]]; then
print_Message "1;31" "Error:Enter A Valid Numeric Score" "1"
else
break
fi
done

while true; do
printf "\e[1;95mEnter Url: \e[0m" && read -p "" Url

if [[ ! "$Url" =~ ^https://prizes\.gamee\.com/game-bot/.*$ ]]; then
print_Message "1;31" "Error:Enter A Valid Url" "1"
else
break
fi
done

API_Url="https://api.armin-soft.ir/Gamee-Hack/"
Response=$(curl -s "$API_Url?License=$License&Score=$Score&Url=$Url")

Pogress_Counter=0
while [ "$Pogress_Counter" -le 100 ]; do
display_progress "$Pogress_Counter"
sleep 0.05
((Pogress_Counter++))
done
printf "\n"

Ok=$(echo "$Response" | jq -r '.Ok')

Title=$(echo "$Response" | jq -r '.Result.Game_Information.Title')
First_Name=$(echo "$Response" | jq -r '.Result.User_Information.First_Name')
Nick_Name=$(echo "$Response" | jq -r '.Result.User_Information.Nick_Name')
User_ID=$(echo "$Response" | jq -r '.Result.User_Information.User_ID')

if [ "$Ok" == "true" ]; then
printf "\033[1;32m
   ___  _  __
  / _ \| |/ /
 | | | | ' / 
 | |_| | . \ 
  \___/|_|\_\
             
             
The Game Score Increased.\033[0m\n\n"
printf "\033[1;32mGame Information:\033[0m\n\n"
printf "\033[1;32mTitle:$Title\033[0m\n"
printf "\033[1;32m=================================\033[0m\n"
printf "\033[1;32mUser Information:\033[0m\n\n"
printf "\033[1;32mFirst Name:$First_Name\033[0m\n"
printf "\033[1;32mNick Name:$Nick_Name\033[0m\n"
printf "\033[1;32mUser ID:$User_ID\033[0m\n"

else 
Error=$(echo "$Response" | jq -r '.Result.Message')
case "$Error" in
"خطا:لایسنس معتبر نمی باشد")
printf "\033[1;31m
 _   _  ___  
| \ | |/ _ \ 
|  \| | | | |
| |\  | |_| |
|_| \_|\___/ 

Error:The License Is Not Valid\033[0m\n";;

"خطا:کاربر توسط @Gamee مسدود شده است")
printf "\033[1;31m
 _   _  ___  
| \ | |/ _ \ 
|  \| | | | |
| |\  | |_| |
|_| \_|\___/ 

Error:User Has Been Banned By @Gamee\033[0m\n";;

"خطا:لینک بازی صحیح نمی باشد")
printf "\033[1;31m
 _   _  ___  
| \ | |/ _ \ 
|  \| | | | |
| |\  | |_| |
|_| \_|\___/ 

Error:The Game Link Is Not Correct\033[0m\n";;

"خطا:سرویس در دسترس نمی باشد")
printf "\033[1;31m
 _   _  ___  
| \ | |/ _ \ 
|  \| | | | |
| |\  | |_| |
|_| \_|\___/ 

Error:The Service Is Not Available\033[0m\n";;
*)
;;
esac
fi
}

main
