FROM python:3.11.6-alpine

WORKDIR /usr/src/app

# dependances (cache)
COPY requirements.txt ./
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -r requirements.txt

# user non root
RUN adduser -D app

USER app

COPY --chown=app:app . .

EXPOSE 8080

CMD ["python", "app.py"]
