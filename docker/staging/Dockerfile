FROM debian:buster-slim
RUN apt update && apt upgrade -y --no-install-recommends --fix-missing
RUN apt install -y --no-install-recommends \
    vim \
    libpq-dev gcc \
    python3 python3-pip python3-setuptools python3-wheel python3-venv python3-dev uwsgi-plugin-python3

WORKDIR /srv

RUN apt install -y --no-install-recommends git

# copy everything
RUN git clone --depth 1 --branch development https://github.com/JonasCir/open-survey-tool.git repo

WORKDIR repo

RUN python3 -m venv python/venv && \
    pip3 install -r src/requirements.txt

COPY setup_and_run.sh /srv/repo/src/config/setup_and_run.sh

CMD [ "/srv/repo/src/config/setup_and_run.sh" ]
