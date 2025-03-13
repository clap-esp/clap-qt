
# 🎬 CLAP
CLAP est un projet permettant le dérush intelligent de vidéos, basé sur Qt et un moteur d’analyse en Python.

# 📁 Prérequis
Avant d'exécuter ce projet, assure-toi que le répertoire clap_ai_core est placé dans le même dossier que clap-qt.

## 🐍 Configuration de l’environnement Python

Se placer dans le dossier clap-qt

1. Créer un environnement virtuel :


    ```python -m venv venv```

2. Activer l’environnement virtuel :

    Sur Ubuntu

    ```source venv/bin/activate```

    Sur Windows

    ```venv\Scripts\activate\```

3. Installer les dépendances :


    ```pip install -r requirements.txt```





## 🔨 Compilation et exécution du projet

1. Ouvrir le projet dans Qt Creator.
2. Compiler le projet avec le kit Qt approprié.
3. Exécuter l'application depuis Qt Creator.



# 📁 Stockage des fichiers dans CLAP

Ci-dessous la structure du dossier d'un projet clap :

```
📦 Nom du projet
├─ metadata
│  ├─ config.json
│  ├─ app_output_stt.srt
│  ├─ app_output_stt.json
│  ├─ app_subtitles_{lang}.srt
│  ├─ app_subtitles_{lang}.json
│  ├─ app_derush.json
│  └─ app_current_src_lang.txt
└─ thumbs
   └─ *.png
```

## 📍 Emplacement du dossier  selon l'OS


| Système | Chemin d'accès                                                                    |
|---------|-----------------------------------------------------------------------------------|
| windows | C:\Users\NomUtilisateur\AppData\Roaming\appclap_v1\NomDuProjet\                     |
| macos   | /Users/NomUtilisateur/Library/Application Support/appclap_v1/NomDuProjet/         |
| linux   | /home/NomUtilisateur/.local/share/NomDeLApp/appclap_v1/                           |




## 📂 Contenu du dossier metadata

Ce dossier contient :

✅ Les fichiers de transcription et de traduction générés par les scripts Python exécutés dans l’application. (*.srt, *.json)

✅ Le fichier de configuration du projet, créé lors de l'initialisation d'un nouveau projet dans CLAP. (config.json)


## 📂 Contenu du dossier thumbs

Ce dossier contient :

✅ Les miniatures générées et utilisées dans la frise (timeline) et dans la liste des projets (dans l'UI)


## 📝 Fichier config.json

Le fichier ````config.json```` contient les informations essentielles du projet. Il est généré automatiquement à la création d’un projet.



## Explications

Il existe pour l'instant les fichiers 'Main.qml' et 'TextButton.qml' qui sont les fichiers importants pour l'edition du logiciel.
Voici leurs fonctionnalités :

- **Main.qml** : Il sera la fenêtre mère, il va accueillir tous les widgets qu'on va mettre en place, que ce soit les boutons ou des barres de chargement etc.
- **TestButton.qml** (Je vais le renommer plus tard) : Il est un widget _button_ que j'ai crée au préalable car il n'y a pas de preset de bouton. Cela nous permettra d'être vraiment très versatile au niveau de design de chaque _Components_.

## Missions

Voici la liste de ce qui nous reste à faire :

- Des **Widgets** réutilisables dans les différentes fenêtres.
- La **Fenêtre Mère** que l'on doit terminer mais [@JayEpic](https://github.com/JayEpic) est dessus. On peut travailler à plusieurs sur cette fenêtre.
- La **Fenêtre des Paramètres** qui doit être juste faite juste pour le design, ses fonctionnalités sont prévues pour la suite du projet.

## Contribution

- [@JayEpic](https://github.com/JayEpic)
- [@Hamza Ikiou](https://github.com/Hamza-Ikiou)
- [@mehditkd](https://github.com/mehditkd)
- [@lyke](https://github.com/lyke)
