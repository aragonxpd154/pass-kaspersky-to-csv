#!/bin/bash

# Verifica se um arquivo de entrada foi fornecido como argumento
if [ $# -ne 1 ]; then
  echo "Uso: $0 arquivo_de_entrada.txt"
  exit 1
fi

# Nome do arquivo de entrada
arquivo_entrada="$1"

# Nome do arquivo CSV de saída
arquivo_csv="senhas.csv"

# Inicializa as variáveis de dados
website_name=""
website_url=""
login_name=""
login=""
password=""
comment=""

# Cria o cabeçalho do CSV
echo "Website Name,Website URL,Login Name,Login,Password,Comment" > "$arquivo_csv"

# Lê o arquivo linha por linha
while IFS= read -r linha; do
  # Remove espaços em branco à esquerda e à direita da linha
  linha_limpa="$(echo -e "$linha" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

  case "$linha_limpa" in
    "Website name:"*) website_name="${linha_limpa#"Website name:"}" ;;
    "Website URL:"*) website_url="${linha_limpa#"Website URL:"}" ;;
    "Login name:"*) login_name="${linha_limpa#"Login name:"}" ;;
    "Login:"*) login="${linha_limpa#"Login:"}" ;;
    "Password:"*) password="${linha_limpa#"Password:"}" ;;
    "Comment:"*) comment="${linha_limpa#"Comment:"}" ;;
    "---") # Quando encontrar "---", escreve os dados no arquivo CSV
      echo "\"$website_name\",\"$website_url\",\"$login_name\",\"$login\",\"$password\",\"$comment\"" >> "$arquivo_csv"
      # Reinicializa as variáveis de dados
      website_name=""
      website_url=""
      login_name=""
      login=""
      password=""
      comment=""
      ;;
  esac
done < "$arquivo_entrada"

echo "Processamento concluído. Os dados foram exportados para $arquivo_csv."

