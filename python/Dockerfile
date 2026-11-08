## voir pour passer sur uv https://hub.docker.com/r/astral/uv plus simple à gérer pour les app python, si j'ai le temps

FROM astral/uv:python3.11-alpine AS builder

WORKDIR /build/

COPY ./vote/ /build/

RUN uv build --wheel -o /target


FROM python:3.11.18-alpine3.24

RUN apk update

##je récup le wheel du builder dans target et on le copie dans /tmp/  on récup vote.whl
COPY --from=builder /target/*.whl /tmp/


##on n'a plus qu'à installer le wheel, plus besoin de requiremnts -> l'installation se fait directement avec l'installation de python du conteneur avec le pyproject.toml, pas d'environnement virtuel
#je n'utilise donc pas de python -m venv .venv
#et je n'installe pas le wheel dans un environnement virtuel car le conteneur "simule" déjà un environnement isolé
RUN pip install /tmp/*.whl

EXPOSE 5000

ENTRYPOINT [ "python" ]

##on lance directement le module python avec -m
CMD ["-m", "vote.app"]
 