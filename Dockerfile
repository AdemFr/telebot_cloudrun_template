FROM python:3.10-slim-bullseye as base

ENV PYTHONFAULTHANDLER=1 \
    PYTHONHASHSEED=random \
    # Immediately send stdout and stderr to terminal to catch more info on crash
    PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y gcc libffi-dev g++
WORKDIR /app

FROM base as builder

ENV PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    POETRY_VERSION=1.4.0

RUN pip install "poetry==$POETRY_VERSION"
RUN python -m venv /venv

COPY pyproject.toml poetry.lock ./
RUN . /venv/bin/activate && poetry install --no-dev --no-root

COPY . .
RUN . /venv/bin/activate && poetry build

FROM base as final

COPY --from=builder /venv /venv
COPY --from=builder /app/dist .
COPY run.dev.sh .
RUN chmod +x run.dev.sh

# Activate the virtual environment without root access
ENV VIRTUAL_ENV=/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN pip install *.whl
