# json-schema-for-humans のビルドステージ
FROM python:3.9-slim-buster AS builder

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY ./schema .
RUN mkdir output
RUN python -m json_schema_for_humans.cli example-schema.json output/example-schema.html

# Nginx のステージ
FROM nginx:alpine

COPY --from=builder /app/output /usr/share/nginx/html

COPY index.html /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
