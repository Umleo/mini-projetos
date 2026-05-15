#/bin/bash

#-z verifica se varivel está vazia
if [ -z "$1" ];then
    echo "Falta argumentos."
    echo "Use --help para ajuda"
    #finaliza o script
    exit 1
fi


#caso variavel especial ($1) for --help:
case "$1" in
  --help|-h)
    echo "Uso: logArchive DIRETÓRIO DESTINO(opcional)"
    echo "  Um diretório logArchive será criado em /var/log se DESTINO não for espcificado."
    echo "  o diretório especificado irá ser compactado em gzip."
    exit 1
    ;;
esac


if [ ! -d "$1" ]; then
    echo "Error: Diretório não encontrado."
    exit 1
fi


data=$(date +"%Y%m%d"-"%H%M%S")
dir_origem=$1

#-n verifica se varivel 2 existe
if [ -n "$2" ];then
    caminho_destino=$2
elif [ ! -e "/var/log/logArchive" ];then
    caminho_destino="/var/log/logArchive"
    #-e verifica se o caminho existe
    echo "Diretório de logs não existe."
    sleep 1
    echo "Criando diretório de logs $caminho_destino"
    mkdir -p "$caminho_destino"
fi


#para passar argumentos, podemos usar as variaveis especiais $@, $1, $2... Ou getops.
tar -cvzf "$caminho_destino/logArchive.$data.tar.gz" "$dir_origem"




