FROM rodolpheche/wiremock:2.27.2

COPY . /home/wiremock
COPY entrypoint.sh /

HEALTHCHECK --start-period=30s CMD curl -f http://localhost:8080/health || exit 1

ENTRYPOINT [ "/entrypoint.sh" ]