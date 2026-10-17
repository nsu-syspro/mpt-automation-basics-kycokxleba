FROM ubuntu:22.04
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    jq \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY . .
RUN make check
ENTRYPOINT ["./build/wordcount"]