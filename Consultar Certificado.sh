#!/bin/bash

CERT_DIR="/home/kali/criptolab"
ALERT_DAYS=30

for cert in "$CERT_DIR"/*.crt; do
    # Verifica se existe arquivo (evita erro se não houver .crt)
    [ -e "$cert" ] || continue

    echo "🔍 Verificando: $cert"

    # Pega data de expiração
    end_date=$(openssl x509 -enddate -noout -in "$cert" | cut -d= -f2)

    # Converte para timestamp
    end_date_epoch=$(date -d "$end_date" +%s)
    current_epoch=$(date +%s)

    # Calcula dias restantes
    diff_seconds=$((end_date_epoch - current_epoch))
    diff_days=$((diff_seconds / 86400))

    echo "📅 Expira em: $diff_days dias"

    # Alerta
    if [ "$diff_days" -lt "$ALERT_DAYS" ]; then
        echo "⚠️ ALERTA: Certificado próximo da expiração!"
    fi

    echo "-----------------------------------"
done
