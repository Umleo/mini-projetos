#!/bin/sh

#limpa terminal
clear

#registro para média do uso da cpu
#verifica se arquivo existe
arq_registro="registro.txt"
if [ ! -f $arq_registro ]; then
    touch $arq_registro
else
    #compara data do sistema com data do registro, se o dia for diferente, ele limpa os registros diarios para armazenar do novo dia.
    if [ "$(date '+%d')" != "$(cat $arq_registro | tail -n 1 | cut -d' ' -f1)" ]; then
        echo "Resetando log diário..." 
        sleep 2
        > $arq_registro
    fi
fi

#realiza calculo de média da CPU com os registros do dia - atualizado toda vez que inicia o script
counter=$(cat $arq_registro | wc -l)
cpu_media=0
for i in $(cat $arq_registro | cut -d' ' -f2); do
    cpu_media=$(echo "$cpu_media + $i" | bc)
done
if [ $counter -gt 0 ]; then
    cpu_media=$(echo $cpu_media / $counter | bc)
fi


#usuario e sistema
user=$(whoami)
version_so=$(grep "PRETTY_NAME" /etc/os-release | cut -d'"' -f2)
boot_time=$(systemd-analyze | cut -d"=" -f2 | head -n1)

tput civis # Esconde o cursor para uma aparência mais limpa
trap "tput cnorm; exit" INT  # Garante que o cursor volte
#while true para travar a tela e atualizar dados
while true; do
    #reescreve o conteudo na tela
    tput cup 0 0
    #top: -b para modo batch, -n1 para atualizar apenas uma vez, grep para filtrar a linha de CPU, awk para extrair o valor de idle e calcular o uso da CPU.
    #lc_all=C: Define a localidade para C, garantindo que a saída seja consistente e seja possível realizar os cáculos sem mais problemas no AWK.
    last=$(LC_ALL=C top -bn1 | grep -i "Cpu(s)" | awk -F',' '{print $4}'| awk '{print $1}')
    cpu=$(echo "100 - $last" | bc)
    # Registra dia junto com o uso de CPU
    echo "$(date '+%d') $(echo $cpu | sed 's/\,/./')" >> $arq_registro

    #memoria
    mem_total=$(free -m | awk '/Mem.:/ {print $2}')
    mem_livre=$(free -m | awk '/Mem.:/ {print $4}')
    mem_livre_porcent="$(echo "$mem_livre * 100 / $mem_total" | bc )%"
    mem_uso=$(echo "$mem_total - $mem_livre" | bc)
    mem_usado_porcent="$(echo "($mem_total - $mem_livre) * 100 / $mem_total" | bc )%"

    #armazenamento /
    arm_total_=$(df -h | grep /$ | awk '{print $2}')
    arm_usado_=$(df -h | grep /$ | awk '{print $3}')
    arm_porcent_uso=$(df -h | grep /$ | awk '{print $5}')
    arm_disp_=$(df -h | grep /$ | awk '{print $4}')
    arm_porcent_disp="$(echo "100 - ($arm_usado_ * 100 / $arm_total_)" | bc)%"

    #armazenamento /home
    arm_total_home=$(df -h | grep /home$ | awk '{print $2}')
    arm_usado_home=$(df -h | grep /home$ | awk '{print $3}')
    arm_porcent_uso_home=$(df -h | grep /home$ | awk '{print $5}')
    arm_disp_home=$(df -h | grep /home$ | awk '{print $4}')
    arm_porcent_disp_home="$(echo "100 - ($arm_usado_home * 100 / $arm_total_home)" | bc)%"

    #processos por uso de cpu
    processos_cpu=$(ps aux --sort=-%cpu | head -n 6 | awk '{print $1 " " $2 " " $3 " " $11}')

    #processos por uso de mem
    processos_mem=$(ps aux --sort=-%mem | head -n 6 | awk '{print $1 " " $2 " " $4 " " $11}')

    #uptime
    uptime=$(uptime -p | cut -d" " -f2-)

    # --- Interface ---
    lilas="\e[1;34m"
    titulo="\e[1;40m"
    amarelo="\e[1;33m"
    verde="\e[1;32m"

    echo "\e[$lilas=====================================\e[0m" 
    echo "\e[$titulo   MONITOR DE RECURSOS EM USO \e[0m" "|" $uptime - $user - $version_so - Boot: $boot_time
    echo "\e[$lilas=====================================\e[0m"
    echo "\e[$amarelo CPU em uso: \e[0m [[ $cpu% ]]" "\e[$verde CPU média diária: \e[0m [[ $cpu_media% ]]" 
    echo "\e[$amarelo MEM em uso: \e[0m [[ $mem_uso MB / $mem_total MB ($mem_usado_porcent) ]]" "\e[$verde MEM disponível: \e[0m [[ $mem_livre MB ($mem_livre_porcent) ]]"
    echo "\e[$amarelo Armazenamento raíz em uso: \e[0m [[ $arm_usado_ / $arm_total_ ($arm_porcent_uso) ]]" "\e[$verde Armazenamento raíz disponível: \e[0m [[ $arm_disp_ ($arm_porcent_disp) ]]"
    echo "\e[$amarelo Armazenamento home em uso: \e[0m [[ $arm_usado_home / $arm_total_home ($arm_porcent_uso_home) ]]" "\e[$verde Armazenamento home disponível: \e[0m [[ $arm_disp_home ($arm_porcent_disp_home) ]]"
    echo "\e[$lilas=====================================\e[0m"
    echo "\e[$titulo Processos por uso de CPU: \e[0m"
    echo "$processos_cpu"
    echo "\e[$lilas=====================================\e[0m"
    echo "\e[$titulo Processos por uso de MEM: \e[0m"
    echo "$processos_mem"

    sleep 1
done