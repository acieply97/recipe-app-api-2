FROM python:3.13-alpine3.22
LABEL maintainer="acieply97@gmail.com"

ENV PYTHONUNBUFFERED=1

# Zainstaluj pakiety potrzebne do kompilacji pakietów Pythona
RUN apk add --no-cache build-base libffi-dev musl-dev

# Skopiuj pliki z wymaganiami
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# Skopiuj kod aplikacji
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# Zmienna argumentu build
ARG DEV=false

# Utwórz wirtualne środowisko i zainstaluj zależności
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then /py/bin/pip install -r /tmp/requirements.dev.txt; fi && \
    rm -rf /tmp && \
    adduser --disabled-password --no-create-home django-user && \
    chown -R django-user:django-user /app

# Ustaw PATH do wirtualnego środowiska
ENV PATH="/py/bin:$PATH"

# Zmien użytkownika
USER django-user
