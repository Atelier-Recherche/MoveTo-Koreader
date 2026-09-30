# Move to (KOReader)

Plugin KOReader qui ajoute **Envoyer vers…** au menu d’appui long du navigateur de fichiers, pour déplacer un fichier ou un dossier vers un répertoire cible configuré.

## Prérequis

- KOReader **2025.04** ou plus récent (`FileManager:addFileDialogButtons`)

## Installation

1. Copier ce dossier en `koreader/plugins/moveto.koplugin/`  
   (le nom du dossier doit être `moveto.koplugin`, pas `ATmoveto.koplugin`)
2. Redémarrer KOReader
3. Vérifier que le plugin est activé : *Outils → Plugin management*

## Configuration

1. Ouvrir le menu → **Outils → Move to**
2. **Choisir le dossier…** et sélectionner le répertoire cible

Le chemin est enregistré dans les réglages KOReader (`moveto_target_dir`).

## Utilisation

1. Appui long sur un fichier ou un dossier
2. Toucher **Envoyer vers « … »**
3. Confirmer le déplacement

Le déplacement met à jour les sidecars (`.sdr`), l’historique et les collections, comme Couper / Coller.

## Fichiers

| Fichier     | Rôle                          |
|-------------|-------------------------------|
| `_meta.lua` | Métadonnées du plugin         |
| `main.lua`  | Menu, paramètres, déplacement |
