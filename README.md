# 🖥️ MiniMon – Supervision Linux légère et efficace en ligne de commande

> L’outil de monitoring Linux minimaliste, 100% en ligne de commande, sans dépendances lourdes, prêt en 2 minutes.

---

## 🚀 Qu'est-ce que MiniMon ?

**MiniMon** est un outil **CLI de supervision système pour Linux**, ultra-léger, rapide à installer, idéal pour les :
- administrateurs système,
- hébergeurs de serveurs VPS,
- passionnés de self-hosting,
- et développeurs DevOps.

Il vous permet de **surveiller en temps réel** vos ressources système, vos services critiques, et d’envoyer des **alertes par mail ou Telegram** en cas de problème.

---

## ⚙️ Fonctionnalités principales

✅ Surveillance CPU, RAM, disque  
✅ Vérification des services actifs (ex: `nginx`, `sshd`, `mysql`, etc.)  
✅ Alertes automatiques par **email** ou **Telegram**  
✅ Génération d’un rapport complet (HTML ou texte)  
✅ Installation simple en une commande  
✅ 100% **Bash**, sans bloatware, idéal pour **serveurs headless / VPS**

---

## 📸 Aperçu

```bash
$ ./minimon.sh

 MiniMon v0.1 – État du système
-------------------------------
CPU usage     : 23%
RAM available : 1.2 GB
Disk usage    : 67% (/)
Services      : nginx ✅  sshd ✅  mysql ❌
Alerts        : 1 seuil dépassé ⚠️
