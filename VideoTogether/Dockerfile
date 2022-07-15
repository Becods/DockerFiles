FROM python:alpine3.16 As git

RUN apk add git \
 && git clone https://github.com/VideoTogether/VideoTogether /app

FROM python:alpine3.16

COPY --from=git /app /app
RUN pip install -r /app/requirements.txt

ENTRYPOINT ["python3"]
CMD ["/app/source/server/main.py","debug"]
