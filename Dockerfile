# Utilise une image de base (par exemple Ubuntu)
FROM ubuntu:latest

# Installer OpenSSH Server
RUN apt-get update &&     apt-get install -y openssh-server &&     mkdir /var/run/sshd

# Définir un mot de passe pour root
RUN echo "root:root" | chpasswd

# Permettre à root de se connecter via SSH
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

# Exposer le port 22 pour SSH
EXPOSE 22

# Lancer le service SSH
CMD ["/usr/sbin/sshd", "-D"]
