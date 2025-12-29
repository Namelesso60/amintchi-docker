# Utilisation d'une image légère avec noVNC intégré
FROM alpine:edge

# Installation des dépendances basiques et du bureau
RUN apk add --no-cache \
    xvfb x11vnc novnc \
    supervisor xfce4 \
    faenza-icon-theme \
    bash

# Configuration des variables d'environnement
ENV DISPLAY=:0 \
    RESOLUTION=1280x720 \
    VNC_PASSWORD=monmotdepasse

# Exposer le port pour le web (souvent 8080 ou 80)
EXPOSE 8080

# Commande de lancement (lance le serveur X et le web socket)
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

