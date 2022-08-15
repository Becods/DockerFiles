FROM alpine:3.15
RUN set -x \
  && apk update \
  && apk add --no-cache php7 php7-json php7-openssl \
  openssl coreutils bind-tools curl jq

RUN curl https://get.acme.sh | sh && rm -rf /install_acme.sh/ \
 && ln -s  /root/.acme.sh/acme.sh  /usr/local/bin/acme.sh \
 && crontab -l | grep acme.sh | sed 's#> /dev/null##' | crontab - \
 && for verb in help \
  version \
  install \
  uninstall \
  upgrade \
  issue \
  signcsr \
  deploy \
  install-cert \
  renew \
  renew-all \
  revoke \
  remove \
  list \
  info \
  showcsr \
  install-cronjob \
  uninstall-cronjob \
  cron \
  toPkcs \
  toPkcs8 \
  update-account \
  register-account \
  create-account-key \
  create-domain-key \
  createCSR \
  deactivate \
  deactivate-account \
  set-notify \
  set-default-ca \
  set-default-chain \
  ; do \
    printf -- "%b" "#!/usr/bin/env sh\n/root/.acme.sh/acme.sh --${verb} --config-home /acme.sh \"\$@\"" >/usr/local/bin/--${verb} && chmod +x /usr/local/bin/--${verb} \
  ; done

VOLUME /acme.sh

ENV PORT=7000
ENV PASSWORD=Please-Change-Me

COPY entrypoint.sh /entrypoint.sh
COPY index.php /index.php
COPY client.sh /bin/get

EXPOSE ${PORT}

ENTRYPOINT ["/entrypoint.sh"]
CMD ["--help"]