FROM debian:bullseye-slim

# 1. Variables d'environnement pour éviter les questions lors de l'install
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:0
ENV RESOLUTION=1280x720

# 2. Installation des paquets nécessaires (XFCE, VNC, noVNC, Python)
RUN apt-get update && apt-get install -y --no-install-recommends \
    xfce4 \
    xfce4-goodies \
    tigervnc-standalone-server \
    novnc \
    python3-websockify \
    python3-numpy \
    supervisor \
    procps \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# 3. Lien symbolique pour que noVNC trouve son fichier index
RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# 4. Configuration du dossier VNC
RUN mkdir -p /root/.vnc \
    && echo "#!/bin/bash\nstartxfce4 &" > /root/.vnc/xstartup \
    && chmod +x /root/.vnc/xstartup

# 5. Script de démarrage (C'est ici que la magie du port dynamique opère)
# Railway impose un port via la variable $PORT. Fly utilise 8080 par défaut ici.
RUN echo "#!/bin/bash\n\
vncserver :0 -geometry \$RESOLUTION -SecurityTypes None --I-KNOW-THIS-IS-INSECURE\n\
websockify --web /usr/share/novnc/ \${PORT:-8080} localhost:5900\n\
" > /entrypoint.sh && chmod +x /entrypoint.sh

# 6. Lancement
CMD ["/entrypoint.sh"]

