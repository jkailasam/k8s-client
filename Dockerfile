FROM ubuntu:bionic
MAINTAINER Jeeva Kailasam

# set environment variables
ENV HOME="/root" \
	TERM="xterm" \
	DEBIAN_FRONTEND=noninteractive

ARG IAM_AUTHENTICATOR_URL="https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator"
ARG REQD_PKGS="apt-transport-https \
    apt-utils \
    curl \
    git \
    tzdata \
    libcurl4-openssl-dev \
    ca-certificates \
    python3 \
    python3-distutils \
    python-setuptools \
    gnupg2 \
    vim \
    sudo \
    jq \
    dnsutils \
    netcat \
    wget"


RUN apt-get update -y --fix-missing && \
    apt-get upgrade -y --no-install-recommends --fix-missing && \
    apt-get install -y --no-install-recommends --fix-missing $REQD_PKGS && \
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update -y --fix-missing && \
    apt-get install -y kubectl && \
    curl -o /usr/local/bin/aws-iam-authenticator ${IAM_AUTHENTICATOR_URL} && \
    chmod +x /usr/local/bin/aws-iam-authenticator && \
    curl -s https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash -x && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

RUN update-alternatives --install /usr/bin/python python /usr/bin/python2 1 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 2 && \
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python get-pip.py && \
    pip install awscli boto3 jinja2 yq


