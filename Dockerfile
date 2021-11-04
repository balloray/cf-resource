FROM maven:3.8.3-eclipse-temurin-11

ENV CF_VERSION=6.53.0
ENV CF7_VERSION=7.2.0
ENV YAML_VERSION=3.4.1

# ADD resource/ /opt/resource/
# ADD itest/ /opt/itest/

# install useful tools
RUN apt-get update && apt-get install -y python3-pip zip wget vim telnet git curl bash jq util-linux && apt-get clean all

# Install uuidgen
# RUN apk add --no-cache ca-certificates curl bash jq util-linux

# # Install Cloud Foundry cli v6
ADD https://packages.cloudfoundry.org/stable?release=linux64-binary&version=${CF_VERSION} /tmp/cf-cli.tgz
RUN mkdir -p /usr/local/bin && \
  tar -xf /tmp/cf-cli.tgz -C /usr/local/bin && \
  cf --version && \
  rm -f /tmp/cf-cli.tgz

# Install Cloud Foundry cli v7
ADD https://packages.cloudfoundry.org/stable?release=linux64-binary&version=${CF7_VERSION} /tmp/cf7-cli.tgz
RUN mkdir -p /usr/local/bin /tmp/cf7-cli && \
  tar -xf /tmp/cf7-cli.tgz -C /tmp/cf7-cli && \
  install /tmp/cf7-cli/cf7 /usr/local/bin/cf7 && \
  cf7 --version && \
  rm -f /tmp/cf7-cli.tgz && \
  rm -rf /tmp/cf7-cli

# Install yaml cli
ADD https://github.com/mikefarah/yq/releases/download/${YAML_VERSION}/yq_linux_amd64 /tmp/yq_linux_amd64
RUN install /tmp/yq_linux_amd64 /usr/local/bin/yq && \
  yq --version && \
  rm -f /tmp/yq_linux_amd64

# # install gcloud package
ADD https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz  /tmp/google-cloud-sdk.tar.gz
RUN mkdir -p /usr/local/gcloud \
  && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
  && /usr/local/gcloud/google-cloud-sdk/install.sh \
  && rm /tmp/google-cloud-sdk.tar.gz
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin
