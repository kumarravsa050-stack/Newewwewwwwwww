FROM python:3.11-slim

# 1. Install FFmpeg, curl, unzip (required for Deno 2.x installation and video merging)
RUN apt-get update && \
    apt-get install -y ffmpeg curl unzip ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# 2. Install Deno 2.x directly into /usr/local/bin (Enabled by default in yt-dlp EJS Wiki!)
RUN curl -fsSL https://deno.land/install.sh | DENO_INSTALL=/usr/local sh && \
    deno --version

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -U pip && \
    pip install --no-cache-dir -U -r requirements.txt && \
    pip install --no-cache-dir -U --pre "yt-dlp[default,curl-cffi]" yt-dlp-ejs ytdlp-jsc

COPY . .

CMD ["python", "bot.py"]
