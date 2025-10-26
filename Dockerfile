FROM python:3.11-slim

WORKDIR /app

COPY script.py .

CMD ["python", "script.py"]

