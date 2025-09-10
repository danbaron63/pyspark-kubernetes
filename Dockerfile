FROM apache/spark:4.0.0-python3

WORKDIR /app

COPY main.py .
COPY dist/*.whl .
