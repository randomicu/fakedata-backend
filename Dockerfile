FROM python:3.9.0-slim-buster

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PYTHONPATH /usr/src/randomicu-fakedata
ENV POETRY_VERSION 1.1.2
ENV POETRY_HOME /opt/poetry

WORKDIR /usr/src/randomicu-fakedata

COPY . /usr/src/randomicu-fakedata
COPY ./deploy /usr/src/randomicu-fakedata

RUN set -eux && \
    apt-get update && \
    apt-get install --yes --no-install-recommends gcc python-dev curl && \
    curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python && \
    cd /usr/local/bin && \
    ln -s /opt/poetry/bin/poetry && \
    poetry config virtualenvs.create false && \
    cd /usr/src/randomicu-fakedata && \
    poetry install --no-root && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    apt-get remove --purge --yes python-dev gcc curl && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
    rm -rf /var/lib/apt/lists/*

CMD ["/usr/src/randomicu-fakedata/start.sh"]
