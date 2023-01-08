FROM alpine/git AS git

RUN git clone --depth=1 https://github.com/Ice-Cirno/HoshinoBot.git /tmp/HoshinoBot \
 && git clone --depth=1 https://github.com/CYDXDianXian/AI_image_gen /tmp/AI_image_gen

FROM python:slim

ENV PYTHONIOENCODING=utf-8

COPY --from=git /tmp/HoshinoBot /tmp/HoshinoBot
COPY --from=git /tmp/AI_image_gen /AI_image_gen
COPY res /tmp/HoshinoBot/res
COPY msyh.ttc /usr/shared/fonts/chinese/

RUN cd /tmp/HoshinoBot \
 && apt-get update \
 && apt-get install -y --no-install-recommends gcc cc1plus libc6-dev \
 && pip3 install -r requirements.txt --no-cache-dir \
 && pip3 install msgpack ujson python-Levenshtein --no-cache-dir \
 && cd /tmp/AI_image_gen \
 && pip install -r requirements.txt --no-cache-dir \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["python3", "run.py"]
