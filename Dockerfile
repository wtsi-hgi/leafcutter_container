# leafcutter install instructions at http://davidaknowles.github.io/leafcutter/articles/Installation.html
FROM continuumio/miniconda3
# ARG conda_env variable must match conda env name in environment.yml:
ARG conda_env=conda_leafcutter

LABEL authors="Guillaume Noell" \
  maintainer="Guillaume Noell <gn5@sanger.ak>" \
  description="Docker image for leafcutter"

# nuke cache dirs before installing pkgs; tip from Dirk E fixes broken img
RUN rm -f /var/lib/dpkg/available && rm -rf  /var/cache/apt/*
RUN apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y --no-install-recommends \
  build-essential \
  curl \
  procps \ 
  gfortran \
  libreadline-dev \
  libpcre3-dev \
  libcurl4-openssl-dev \
  build-essential \
  zlib1g-dev \
  libbz2-dev \
  liblzma-dev \
  wget \
  libssl-dev \
  libxml2-dev \
  libnss-sss \
  git \
  build-essential \
  cmake \
  && rm -rf /var/lib/apt/lists/*

# install Conda env:
ADD environment.yml /tmp/environment.yml
RUN conda env create -f /tmp/environment.yml

# Set installed Conda env as default:
ENV CONDA_DEFAULT_ENV $conda_env
ENV PATH /opt/conda/envs/$conda_env/bin:$PATH
RUN echo $PATH

# Add additional software using Conda env:
RUN /bin/bash -c "source activate $conda_env \
    && conda env list"
    ## && pip install cellSNP \
    ## && pip install vireoSNP \
    
############################ Setup: non-conda tools ############################
RUN python --version
RUN samtools --help

RUN cd /home && git clone https://github.com/griffithlab/regtools && \
    cd regtools/ && \ 
    mkdir build && \
    cd build/ && \
    cmake .. && \
    make
ENV PATH /home/regtools/build:/home/regtools/scripts:$PATH
RUN ls -ltra /home/regtools/scripts
RUN ls -ltra /home/regtools/build
RUN regtools --help

RUN cd /home && git clone https://github.com/davidaknowles/leafcutter
ENV PATH /home/leafcutter/scripts:/home/leafcutter/clustering:$PATH

RUN echo $PATH
RUN leafcutter_cluster.py --help
# no --help option: RUN bam2junc.sh --help
RUN cd /home/leafcutter && git describe --tags


CMD /bin/sh
