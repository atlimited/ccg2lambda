FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y language-pack-ja-base language-pack-ja
ENV LANG=ja_JP.UTF-8
RUN apt-get -y install vim

RUN DEBIAN_FRONTEND=noninteractive
RUN apt-get -y install default-jre-headless
RUN apt-get clean

RUN apt-get -y install python3-dev python3-pip
RUN echo '#!/bin/bash\npython3 "$@"' > /usr/bin/python && chmod +x /usr/bin/python
RUN echo '#!/bin/bash\npip3 "$@"' > /usr/bin/pip && chmod +x /usr/bin/pip

RUN apt-get -y install libxml2-dev libxslt1-dev git

WORKDIR /opt
RUN git clone https://github.com/mynlp/ccg2lambda.git
WORKDIR ccg2lambda
RUN pip install lxml simplejson pyyaml -I nltk==3.0.5
RUN python -c "import nltk; nltk.download('wordnet')"
RUN python scripts/run_tests.py

RUN apt-get -y install coq
RUN coqc coqlib.v

WORKDIR /opt/ccg2lambda
RUN apt-get install wget
RUN ./ja/download_dependencies.sh

WORKDIR /opt
RUN git clone https://github.com/masashi-y/depccg.git
RUN pip install cython chainer==1.23

WORKDIR depccg/src
RUN python setup.py build_ext --inplace

RUN mkdir ../models
WORKDIR ../models
RUN wget http://cl.naist.jp/~masashi-y/resources/depccg/en_hf_tri.tar.gz
RUN wget http://cl.naist.jp/~masashi-y/resources/depccg/ja_hf_ccgbank.tar.gz
RUN tar xzvf en_hf_tri.tar.gz
RUN tar xzvf ja_hf_ccgbank.tar.gz
RUN rm en_hf_tri.tar.gz
RUN rm ja_hf_ccgbank.tar.gz

RUN apt-get -y install bc

RUN echo 'depccg:/opt/depccg' > /opt/ccg2lambda/en/parser_location.txt
RUN echo 'jigg:/opt/ccg2lambda/ja/jigg-v-0.4' > /opt/ccg2lambda/ja/parser_location_ja.txt
RUN echo 'depccg:/opt/depccg' >> /opt/ccg2lambda/ja/parser_location_ja.txt

WORKDIR /opt/ccg2lambda

RUN cp ja/coqlib_ja.v coqlib.v
RUN coqc coqlib.v
RUN cp ja/tactics_coq_ja.txt tactics_coq.txt
RUN ./ja/rte_ja_mp.sh ja/sample_ja.txt ja/semantic_templates_ja_emnlp2016.yaml
