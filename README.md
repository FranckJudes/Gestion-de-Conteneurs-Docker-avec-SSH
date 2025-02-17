# Gestion de Conteneurs Docker avec SSH

## Description
Ce script Bash permet de gérer des conteneurs Docker exécutant un serveur SSH. Il offre plusieurs fonctionnalités, notamment la création, la suppression et l'affichage des adresses IP des conteneurs.

## Fonctionnalités
- **Création de conteneurs Docker** avec un serveur SSH préinstallé.
- **Suppression de tous les conteneurs créés par le script.**
- **Suppression d'un conteneur spécifique** par son nom.
- **Affichage des adresses IP** des conteneurs en cours d'exécution.

## Prérequis
Avant d'exécuter ce script, assurez-vous que Docker est installé sur votre système. Vous pouvez vérifier l'installation avec la commande :
```bash
command -v docker
```
Si Docker n'est pas installé, consultez la documentation officielle : [https://docs.docker.com/get-docker/](https://docs.docker.com/get-docker/)

## Utilisation
Le script accepte plusieurs options en ligne de commande :
```bash
./script.sh [-c <nombre_de_conteneurs>] [-d] [-r <nom_du_conteneur>] [-i]
```

### Options
| Option  | Description |
|---------|-------------|
| `-c <nombre>` | Crée le nombre spécifié de conteneurs avec SSH (ex: `-c 3` crée 3 conteneurs). |
| `-d` | Supprime tous les conteneurs créés par le script. |
| `-r <nom>` | Supprime un conteneur spécifique en fournissant son nom. |
| `-i` | Affiche les adresses IP des conteneurs créés par le script. |

### Exemples
#### 1. Créer 3 conteneurs Docker avec SSH
```bash
./script.sh -c 3
```
Chaque conteneur aura un accès SSH et sera accessible sur un port spécifique (`2201`, `2202`, `2203`, etc.).

#### 2. Supprimer tous les conteneurs créés
```bash
./script.sh -d
```
Cette commande supprime tous les conteneurs créés par le script ainsi que l'image Docker utilisée.

#### 3. Supprimer un conteneur spécifique
```bash
./script.sh -r conteneur_2
```
Cette commande supprime uniquement le conteneur nommé `conteneur_2`.

#### 4. Afficher les adresses IP des conteneurs actifs
```bash
./script.sh -i
```
Cela listera les noms des conteneurs ainsi que leurs adresses IP internes.

## Structure du Code
- **Création d'un Dockerfile** pour définir une image Docker avec SSH préinstallé.
- **Construction de l'image Docker** sous le nom `ubuntu_ssh_root`.
- **Lancement des conteneurs Docker**, chacun avec un port SSH distinct.
- **Gestion des conteneurs**, incluant suppression et affichage des IP.


## Raison
Développé pour des tests en environnement contrôlé. À utiliser avec précaution. 

