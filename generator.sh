#!/bin/bash

# Affiche l'usage du script
usage() {
    echo "Usage: $0 [-c <nombre_de_conteneurs>] [-d] [-r <nom_du_conteneur>] [-i]"
    echo "  -c <nombre_de_conteneurs> : Crée le nombre spécifié de conteneurs avec SSH"
    echo "  -d                        : Supprime tous les conteneurs créés par ce script"
    echo "  -r <nom_du_conteneur>     : Supprime le conteneur spécifié par son nom"
    echo "  -i                        : Affiche les IP des conteneurs créés par ce script"
    exit 1
}

# Vérifie si Docker est installé
if ! command -v docker &> /dev/null; then
    echo "Docker n'est pas installé. Veuillez l'installer pour utiliser ce script."
    exit 1
fi

# Variables pour stocker les paramètres
nb_conteneurs=0
delete_containers=false
remove_container_name=""
show_ips=false

# Parse les arguments
while getopts "c:dr:i" opt; do
    case ${opt} in
        c)
            nb_conteneurs=$OPTARG
            ;;
        d)
            delete_containers=true
            ;;
        r)
            remove_container_name=$OPTARG
            ;;
        i)
            show_ips=true
            ;;
        *)
            usage
            ;;
    esac
done

# Créer un Dockerfile pour une image avec SSH
create_dockerfile() {
    cat <<EOF > Dockerfile
# Utilise une image de base (par exemple Ubuntu)
FROM ubuntu:latest

# Installer OpenSSH Server
RUN apt-get update && \
    apt-get install -y openssh-server && \
    mkdir /var/run/sshd

# Définir un mot de passe pour root
RUN echo "root:root" | chpasswd

# Permettre à root de se connecter via SSH
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

# Exposer le port 22 pour SSH
EXPOSE 22

# Lancer le service SSH
CMD ["/usr/sbin/sshd", "-D"]
EOF
}

# Construire l'image Docker avec SSH
build_image() {
    docker build -t ubuntu_ssh_root .
}

# Crée les conteneurs
create_containers() {
    for ((i=1; i<=nb_conteneurs; i++)); do
        # Tenter de créer le conteneur, mais ignorer les erreurs si le conteneur existe déjà
        docker run -d --name "conteneur_$i" -p 22$((i)):22 ubuntu_ssh_root || true
        echo "Conteneur 'conteneur_$i' créé avec SSH direct pour root sur le port 22$((i))."
    done
}



# Supprime tous les conteneurs créés par ce script
delete_all_containers() {
    for conteneur in $(docker ps -a --filter "name=conteneur_" --format "{{.Names}}"); do
        docker rm -f "$conteneur"
        echo "Conteneur '$conteneur' supprimé."
    done
    # Supprimer l'image Docker si elle existe encore
    if docker images -q ubuntu_ssh_root &> /dev/null; then
        docker rmi ubuntu_ssh_root
        echo "Image 'ubuntu_ssh_root' supprimée."
    fi
}

# Supprime un conteneur spécifique
delete_single_container() {
    if docker ps -a --format "{{.Names}}" | grep -q "^$remove_container_name\$"; then
        docker rm -f "$remove_container_name"
        echo "Conteneur '$remove_container_name' supprimé."
    else
        echo "Conteneur '$remove_container_name' non trouvé."
    fi
}

# Affiche les IP des conteneurs créés par ce script
show_container_ips() {
    echo "Adresses IP des conteneurs :"
    for conteneur in $(docker ps --filter "name=conteneur_" --format "{{.Names}}"); do
        ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$conteneur")
        echo "Conteneur '$conteneur' : IP $ip"
    done
}

# Exécution en fonction des options fournies
if [ "$nb_conteneurs" -gt 0 ]; then
    # Crée le Dockerfile et construit l'image
    create_dockerfile
    build_image
    create_containers
elif [ "$delete_containers" = true ]; then
    delete_all_containers
elif [ -n "$remove_container_name" ]; then
    delete_single_container
elif [ "$show_ips" = true ]; then
    show_container_ips
else
    usage
fi
