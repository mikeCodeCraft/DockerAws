FROM python:3.10-slim-buster

WORKDIR /app

RUN apt-get update && apt-get install -y \
    wget \
    build-essential \
    gcc \
    make \
    libsqlite3-dev \
    libssl-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://www.sqlite.org/2023/sqlite-autoconf-3410200.tar.gz && \
    tar xzf sqlite-autoconf-3410200.tar.gz && \
    cd sqlite-autoconf-3410200 && \
    ./configure && make && make install && \
    cd .. && rm -rf sqlite-autoconf-3410200*

ENV LD_LIBRARY_PATH="/usr/local/lib"

COPY requirements.txt requirements.txt


RUN pip install --upgrade pip && pip install -r requirements.txt

COPY . .

RUN python manage.py collectstatic --noinput || true

CMD ["gunicorn", "Gallery.wsgi:application", "--bind", "0.0.0.0:8000"]