FROM python:3.13
WORKDIR /usr/local/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY batchexecutioner.py ./batchexecutioner.py
COPY wait-for-clickhouse.sh ./wait-for-clickhouse.sh

RUN chmod +x wait-for-clickhouse.sh \
    && useradd -m app \
    && chown -R app:app /usr/local/app

USER app

CMD ["./wait-for-clickhouse.sh", "python", "batchexecutioner.py"]