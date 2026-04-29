#!/bin/bash

CERT_DIR="/home/kali/criptolab"
CERT_NAME="server"
DAYS_THRESHOLD=30

CRT="$CERT_DIR/$CERT_NAME.crt"
KEY="$CERT_DIR/$CERT_NAME.key"
CSR="$CERT_DIR/$CERT_NAME.csr"
NEW_CRT="$CERT_DIR/$CERT_NAME.new.crt"

echo "🔍 Verificando validade do certificado..."

# Pega data de expiração
end_date=$(openssl x509 -enddate -noout -in "$CRT" | cut -d= -f2)
end_date_epoch=$(date -d "$end_date" +%s)
current_epoch=$(date +%s)

diff_days=$(( (end_date_epoch - current_epoch) / 86400 ))

echo "📅 Dias restantes: $diff_days"

# Só renova se estiver perto de expirar
if [ "$diff_days" -gt "$DAYS_THRESHOLD" ]; then
    echo "✅ Certificado ainda válido. Nenhuma ação necessária."
    exit 0
fi

echo "⚠️ Renovando certificado..."

# Gerar CSR sem interação
openssl req -new -key "$KEY" -out "$CSR" \
-subj "/C=BR/ST=SP/L=PresidenteVenceslau/O=Lab/CN=meusite.local"

# Assinar com CA
openssl x509 -req -in "$CSR" \
-CA "$CERT_DIR/rootCA.crt" \
-CAkey "$CERT_DIR/rootCA.key" \
-CAcreateserial \
-out "$NEW_CRT" \
-days 365 -sha256

# Validar novo certificado antes de substituir
if ! openssl x509 -in "$NEW_CRT" -noout &>/dev/null; then
    echo "❌ Erro ao gerar novo certificado. Abortando."
    exit 1
fi

# Backup do antigo
cp "$CRT" "$CRT.bak"

# Substitui
mv "$NEW_CRT" "$CRT"

echo "🔄 Certificado substituído com sucesso"

# Reiniciar serviço (simulado ou real)
echo "♻️ Reiniciando serviço..."

systemctl reload nginx 2>/dev/null || echo "(Simulação: nginx não instalado)"

echo "✅ Renovação concluída"
