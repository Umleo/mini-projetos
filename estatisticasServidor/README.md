# Monitor de Status do Servidor

Um script simples em Shell (`sh`) para monitorar o sistema.

## Funcionalidades

- Exibe uso de CPU e memória em tempo real
- Mostra uso de disco nas partições `/` e `/home`
- Lista os 5 processos que mais consomem CPU e memória

## Instalação e uso

1. Coloque o arquivo `status.sh` no diretório desejado.
2. Dê permissão de execução:

```bash
chmod u+x status.sh
```

3. Execute o monitor:

```bash
./status.sh
```

O script roda em loop exibindo informações no terminal. Para interromper, pressione Ctrl+C.

## Formato do arquivo de log (`registro.txt`)

Cada linha contém um resgistro do dia atual seguido pelo uso de CPU, por exemplo:

```
06 3,68
06 4,12
```

## [roadmap.sh](https://roadmap.sh/projects/server-stats)

Este projeto faz parte do Devops Projects - [roadmap.sh](https://roadmap.sh/projects/server-stats)
