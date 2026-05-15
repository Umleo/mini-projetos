# Olá Docker!

Este projeto acadêmico demonstra a criação de uma imagem Docker personalizada baseada em Nginx (Alpine). O objetivo é servir uma página estática simples que exibe uma mensagem de boas-vindas personalizada, utilizando variáveis de ambiente para injetar dados no container durante a execução.

---

## Como Executar

### 1. Baixe o projeto

Faça o download dos arquivos do projeto.

### 2. Construa a imagem Docker

```bash
docker build -t oladocker .
```

### 3. Execute o container

```bash
docker run -d -e var=Leonardo -p 8087:80 oladocker:latest
```

---

## Detalhes Técnicos

- Baseado na imagem `nginx:alpine`
- Container expõe a porta `80`
- Declara uma variável `var` que deve ser definida pelo usuário durante a execução
