# Scripts-Consulta-de-Certificado

Scripts de Consulta e Renovação de Certificados
📌 Visão Geral

Este repositório contém dois scripts em Bash desenvolvidos para facilitar a gestão e aumentar a segurança no controle de expiração de certificados digitais.

A proposta é automatizar:

A verificação de validade de certificados
A renovação automática quando estiverem próximos da expiração

Esses scripts são úteis em ambientes que utilizam certificados locais (ex: laboratórios, ambientes internos, aplicações com CA própria).


Este script percorre um diretório contendo certificados (.crt) e exibe:

Nome do certificado;

Quantidade de dias restantes até a expiração;

Alerta caso esteja próximo de expirar.

💡 Funcionamento

Lê a data de expiração usando openssl;

Converte para timestamp;

Calcula a diferença em dias;

Exibe alerta se estiver abaixo do limite.

--- 

🔄 Script 2: Renovação Automática
📄 Recriação de Certificado.sh

Este script automatiza:

Verificação da validade de um certificado específico;

Geração de um novo certificado caso esteja próximo da expiração;

Backup do certificado antigo;

Reload do serviço (ex: Nginx).


💡 Funcionamento

Verifica quantos dias faltam para expiração

Se estiver acima do limite → não faz nada

Se estiver abaixo:

Gera CSR automaticamente

Assina com CA local

Valida novo certificado

Faz backup do antigo

Substitui pelo novo

Reinicia o serviço

---

⏰ Automação com Crontab

Para execução automática diária (ex: 02:00 da manhã):

crontab -e

Adicionar:

0 2 * * * /caminho/para/Recriação\ de\ Certificado.sh

🔐 Boas Práticas de Segurança:

Proteger a chave privada (.key) com permissões restritas;

Evitar expor arquivos da CA (rootCA.key);

Validar certificados antes de substituir;

Manter backups (.bak);

Monitorar logs de execução.

---

👨‍💻 Autor

Victor Djalma

---

📄 Licença

Este projeto pode ser utilizado para fins educacionais e laboratoriais.
