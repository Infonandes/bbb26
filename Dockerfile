# Usar imagem Python oficial
FROM python:3.11-slim

# Instalar dependências do sistema (ffmpeg e yt-dlp precisam)
RUN apt-get update && apt-get install -y \
    ffmpeg \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Definir diretório de trabalho
WORKDIR /app

# Copiar arquivo de dependências
COPY requirements.txt .

# Instalar dependências Python
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copiar todo o código
COPY . .

RUN mkdir -p /tmp/downloads

# Expor porta (Railway usa variável $PORT)
EXPOSE 8080

# Comando para iniciar
CMD gunicorn app:app --bind 0.0.0.0:$PORT --workers 2 --timeout 600 --log-level info