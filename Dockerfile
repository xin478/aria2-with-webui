FROM xujinkai/aria2-with-webui
COPY files/start.sh /conf-copy/start.sh
RUN chmod +x /conf-copy/start.sh
