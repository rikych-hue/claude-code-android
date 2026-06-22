# 📱 Claude Code en Android — Servidor IA ARM64 por $0 al mes

> **"Convertí mi viejo Samsung en un servidor de Claude Code que le gana a un VPS de $10"**

Corre Claude Code en tu celular Android como agente IA autónomo 24/7. Sin VPS, sin costo de hosting.

> 💡 **Aclaración de costos:**  
> - **El servidor: gratis** — sin VPS, sin hosting, solo tu celular  
> - **Claude Code / API de Anthropic: de pago** — requiere [suscripción a Claude](https://claude.ai) o [API key de Anthropic](https://console.anthropic.com)  
> - Este proyecto elimina el costo de *infraestructura*, no el costo de la IA

> **Probado en:** Samsung Galaxy Note 10+ · Snapdragon 855 · 8 núcleos ARM64 · 12GB RAM · Android 12  
> **Funciona en:** Cualquier Android 10+ con al menos 4GB de RAM y Termux (F-Droid)

> 🙋 **Esta es mi primera contribución open source.** No soy desarrollador profesional —  
> solo alguien que descubrió cómo correr Claude Code en un celular Android y pensó  
> que podría serle útil a otros. ¡Feedback, issues y PRs son muy bienvenidos!

---

## 🏗️ Arquitectura del servidor

```
Samsung Galaxy Note 10+
├── CPU: Snapdragon 855 — 8 núcleos ARM64
│   ├── 1× 2.84 GHz (Prime)
│   ├── 3× 2.42 GHz (Performance)
│   └── 4× 1.80 GHz (Efficiency)
├── RAM: 12 GB (~5-6 GB disponibles para Ubuntu)
├── Storage: 228 GB · UFS 3.0 · ~450 MB/s
└── Android 12
    └── Termux (F-Droid)          :8022 SSH
        └── Ubuntu 26.04 LTS ARM64 :8023 SSH
            ├── Node.js 22.16.0
            └── Claude Code 2.1+   ← aquí corres
```

---

## ⚠️ CRÍTICO: Descarga Termux desde F-Droid — NO desde Play Store

> La versión de Play Store de Termux está **desactualizada y rota**. Muchos paquetes fallarán.

**Descarga Termux desde F-Droid:**  
👉 https://f-droid.org/en/packages/com.termux/

---

## 🚀 Instalación rápida

Ver [README.md](README.md) para instrucciones completas en inglés.

### Resumen de pasos

1. Instalar Termux **desde F-Droid**
2. Configurar SSH en Termux (puerto 8022)
3. Evitar que Android mate Termux (via ADB — paso crítico)
4. Instalar Ubuntu via `proot-distro`
5. Instalar Node.js con **binario ARM64** (NO usar apt)
6. Instalar Claude Code con npm
7. Configurar arranque automático

### El truco más importante — Instalar Node.js

`apt install nodejs` **NO funciona** en proot. Usar el binario oficial:

```bash
proot-distro login ubuntu -- bash << 'EOF'
curl -fsSL https://nodejs.org/dist/v22.16.0/node-v22.16.0-linux-arm64.tar.gz \
  -o /tmp/node.tar.gz
tar -xzf /tmp/node.tar.gz --strip-components=1 -C /usr/local
rm /tmp/node.tar.gz
node --version
EOF
```

---

## 💰 Comparativa con VPS

| | Tu celular | VPS 4 núcleos 8GB |
|--|-----------|-------------------|
| CPU | 8 núcleos ARM64 | 4 vCPU x86 |
| RAM | 12 GB | 8 GB |
| Disco | ~450 MB/s (UFS 3.0) | ~200–500 MB/s SSD |
| **Costo mensual** | **$0** | **$5–15 USD** |

---

## ⚠️ Aviso — Uso Personal, No Producción

Este setup es **funcional para uso personal** pero nunca puede sustituir un entorno de producción.

| ✅ Ideal para | ❌ No apto para |
|--------------|----------------|
| Agente IA personal en tu red local | Servicios web públicos |
| Automatizar tareas personales | Alta disponibilidad |
| Aprender Linux y Claude Code | Datos sensibles críticos |
| Darle vida a un celular viejo | Entornos multi-usuario |

Trátalo como una **herramienta personal poderosa**, no como un servidor empresarial.

---

## 💡 Qué puedes hacer con esto

```bash
# Limpiar archivos duplicados del cel
claude -p "Encuentra archivos duplicados en /root/downloads y lista los más pesados"

# Organizar almacenamiento
claude -p "Analiza /sdcard y dime qué está ocupando más espacio y qué es seguro borrar"

# Monitorear tus servidores
claude -p "Revisa si nginx está corriendo en mi servidor y reporta el uso de disco"

# Análisis de archivos
claude -p "Lista todos los PDFs en /root/documentos y resume sus nombres"

# Tareas programadas (con cron)
echo "0 8 * * * claude -p 'Dame el reporte de estado del sistema'" | crontab -
```

---

## 🔒 Seguridad Básica

```bash
# 1. Usar SSH keys en lugar de contraseñas
ssh-keygen -t ed25519 -C "mi-servidor-android"
ssh-copy-id -p 8023 ubuntu@IP_DEL_CEL

# 2. Deshabilitar login por contraseña
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

# 3. Acceso remoto seguro sin exponer puertos (recomendado)
# Instala Tailscale en Ubuntu para VPN gratuita
curl -fsSL https://tailscale.com/install.sh | sh
```

> **Nunca hagas port forwarding** del SSH a internet — usa una VPN como Tailscale.

---

## 🎁 Bonus: Usar API de DeepSeek (Más Barato + Tier Gratuito)

¿No quieres pagar Anthropic? Puedes usar **DeepSeek** como backend de IA — es mucho más barato y tiene créditos gratuitos al registrarte.

| | Anthropic Claude | DeepSeek |
|--|-----------------|----------|
| **Tier gratuito** | No | ✅ Sí (~$5 USD al registrarte) |
| **Precio entrada** | ~$3/M tokens | ~$0.27/M tokens |
| **Precio salida** | ~$15/M tokens | ~$1.10/M tokens |
| **Código abierto** | No | ✅ Sí |

### Cómo funciona

Instalamos **LiteLLM** — un proxy que traduce la API de DeepSeek al formato de Anthropic que espera Claude Code:

```
Claude Code → LiteLLM (localhost:4000) → API de DeepSeek
```

### Instalación rápida

```bash
# 1. Obtén tu API key gratuita en: https://platform.deepseek.com

# 2. Instala LiteLLM en Ubuntu
pip3 install litellm[proxy]

# 3. Crea la configuración
cat > ~/litellm-config.yaml << 'EOF'
model_list:
  - model_name: claude-3-5-sonnet-20241022
    litellm_params:
      model: deepseek/deepseek-chat
      api_key: TU_DEEPSEEK_API_KEY
EOF

# 4. Inicia el proxy y apunta Claude Code a él
litellm --config ~/litellm-config.yaml --port 4000 &
export ANTHROPIC_BASE_URL="http://localhost:4000"
export ANTHROPIC_API_KEY="no-necesaria"

# 5. Prueba
claude -p "hola, estás funcionando?"
```

> ⚠️ **Nota:** Los servidores de DeepSeek están en China — no usar con datos personales sensibles.

---

## 📄 Licencia

MIT
