<div align="center">

<table>
<tr>
<td><img src="readme-media/logo_moveto.png" alt="MoveTo" width="140" /></td>
<td align="left">
<h1 style="margin:0">MoveTo</h1>
<p style="margin:0.25em 0 0"><strong>Envoyer vers… · Navigateur de fichiers · KOReader</strong><br/>Plugin · déplacement · sidecars / historique</p>
</td>
</tr>
</table>

<a href="https://atelier.atechnologie.fr/" title="l'Atelier – Association de fabrication de livres et d'outils de recherche"><img src="https://raw.githubusercontent.com/Atelier-Recherche/.github/main/profile/logo.jpg" alt="l'Atelier" width="200" /></a>  
<sub>Développé par <a href="https://atelier.atechnologie.fr/">l'Atelier</a> — fabrication de livres et outils de recherche (EHESS)</sub>

<p>
🇫🇷 <a href="README.md"><b>Français</b></a> ·
🇬🇧 <a href="README.en.md">English</a> ·
🇩🇪 <a href="README.de.md">Deutsch</a> ·
🇪🇸 <a href="README.es.md">Español</a>
</p>

<p>
<a href="https://atelier.atechnologie.fr/"><img src="https://img.shields.io/badge/🌐_l'Atelier-atelier.atechnologie.fr-2d5016?style=for-the-badge" alt="Site l'Atelier" /></a>
<a href="https://github.com/Morglaf/ATmoveto.koplugin"><img src="https://img.shields.io/badge/📦_Dépôt-GitHub-181717?style=for-the-badge&logo=github" alt="Dépôt GitHub" /></a>
</p>

</div>

---

## 📸 Aperçu

| Menu | Déplacement |
| :---: | :---: |
| <img src="readme-media/screen1.jpg" alt="MoveTo — Menu" width="400" /> | <img src="readme-media/screen2.jpg" alt="MoveTo — Déplacement" width="400" /> |

## 📖 À propos

Plugin KOReader qui ajoute **Envoyer vers…** au menu d’appui long du navigateur de fichiers, pour déplacer un fichier ou un dossier vers un répertoire cible configuré.

## 📋 Prérequis

- KOReader **2025.04** ou plus récent (`FileManager:addFileDialogButtons`)

## ⬇️ Installation

1. Copier ce dossier en `koreader/plugins/moveto.koplugin/`  
   (le nom du dossier doit être `moveto.koplugin`, pas `ATmoveto.koplugin`)
2. Redémarrer KOReader
3. Vérifier que le plugin est activé : *Outils → Plugin management*

## ⚙️ Configuration

1. Ouvrir le menu → **Outils → Move to**
2. **Choisir le dossier…** et sélectionner le répertoire cible

Le chemin est enregistré dans les réglages KOReader (`moveto_target_dir`).

## ✏️ Utilisation

1. Appui long sur un fichier ou un dossier
2. Toucher **Envoyer vers « … »**
3. Confirmer le déplacement

Le déplacement met à jour les sidecars (`.sdr`), l’historique et les collections, comme Couper / Coller.

## 📦 Fichiers

| Fichier | Rôle |
|---------|------|
| `_meta.lua` | Métadonnées du plugin |
| `main.lua` | Menu, paramètres, déplacement |

## 🔗 Ressources

| | |
| --- | --- |
| 🌐 **l'Atelier** | [atelier.atechnologie.fr](https://atelier.atechnologie.fr/) |
| 📦 **Dépôt** | [github.com/Morglaf/ATmoveto.koplugin](https://github.com/Morglaf/ATmoveto.koplugin) |
| 📖 **KOReader** | [github.com/koreader/koreader](https://github.com/koreader/koreader) |

---

<div align="center">

<sub>🇫🇷 <a href="README.md">Français</a> · <a href="README.en.md">🇬🇧 English</a> · <a href="README.de.md">🇩🇪 Deutsch</a> · <a href="README.es.md">🇪🇸 Español</a> · MoveTo — <a href="https://atelier.atechnologie.fr/">l'Atelier</a></sub>

</div>
