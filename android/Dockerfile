FROM gitpod/workspace-full-vnc

USER root

RUN apt update -qq \
 && apt install zip unzip \
 && cd /opt \
 && wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip \
 && unzip -q *.zip -d /opt/android-sdk-linux \
 && rm *.zip \
 && chmod -R 777 /opt/android-sdk-linux \
 && apt clean -qq

USER gitpod

ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${PATH}

RUN ["/bin/bash", "-c", "source ~/.sdkman/bin/sdkman-init.sh"]