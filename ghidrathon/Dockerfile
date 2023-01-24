# Compile binaries for arm support:
FROM gradle:jdk17

RUN apt-get update && apt-get install -y curl git bison flex build-essential unzip

ENV VERSION 10.2.2_PUBLIC
ENV GHIDRA_SHA feb8a795696b406ad075e2c554c80c7ee7dd55f0952458f694ea1a918aa20ee3
ENV GHIDRA_URL https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_10.2.2_build/ghidra_10.2.2_PUBLIC_20221115.zip

RUN apt-get update && apt-get install -y fontconfig libxrender1 libxtst6 libxi6 wget unzip python3-requests --no-install-recommends \
    && wget --progress=bar:force -O /tmp/ghidra.zip ${GHIDRA_URL} \
    && echo "$GHIDRA_SHA /tmp/ghidra.zip" | sha256sum -c - \
    && unzip /tmp/ghidra.zip \
    && mv ghidra_${VERSION} /ghidra \
    && chmod +x /ghidra/ghidraRun 

RUN /ghidra/support/buildNatives

# install python and packages
RUN apt-get update \
    && apt-get install -y git python3-pip python-is-python3 \
    && pip3 install pyyaml dill capstone

# install ghidrathon
ENV GHIDRA_INSTALL_DIR /ghidra
RUN git clone https://github.com/mandiant/Ghidrathon.git \
    && cd Ghidrathon \
    && gradle -PGHIDRA_INSTALL_DIR=/ghidra \
    && mv dist /ghidrathon \
    && unzip -d /ghidra/Ghidra/Extensions /ghidrathon/\*.zip \
    && mv /ghidra/Ghidra/Extensions/Ghidrathon/os/linux_x86_64 /ghidra/Ghidra/Extensions/Ghidrathon/os/linux_arm_64

RUN echo "===> Clean up unnecessary files..." \
    && apt-get purge -y --auto-remove wget unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /tmp/* /var/tmp/* /ghidra/docs /ghidra/Extensions/Eclipse /ghidra/licenses

# ##########################################################################################
# FROM eclipse-temurin:17-jdk-jammy

# RUN apt-get update && apt-get install -y fontconfig libxrender1 libxtst6 libxi6 --no-install-recommends \
#     && echo "===> Clean up unnecessary files..." \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /tmp/* /var/tmp/*

COPY entrypoint.sh /entrypoint.sh
# COPY --from=builder /ghidra /ghidra
# COPY --from=builder /ghidrathon /ghidrathon


WORKDIR /ghidra

RUN mkdir /repos
ENTRYPOINT ["/entrypoint.sh"]
# CMD [ "client" ]
