FROM cloudsuite/hadoop

ENV MAHOUT_VERSION 0.12.2
ENV MAHOUT_HOME /opt/mahout-${MAHOUT_VERSION}

# Install Mahout
RUN set -x \
    && MIRROR=$(curl -s http://www.apache.org/dyn/closer.lua?as_json=1 | grep preferred | awk '{print $2}' | sed -e 's/"//g') \
    && URL=${MIRROR}mahout/${MAHOUT_VERSION}/apache-mahout-distribution-${MAHOUT_VERSION}.tar.gz \
    && curl ${URL} | tar -xzC /opt \
    && mv /opt/apache-mahout-distribution-${MAHOUT_VERSION} ${MAHOUT_HOME}

# TODO: remove
RUN curl -o /root/wiki-small.bz2 https://dumps.wikimedia.org/enwiki/latest/enwiki-latest-pages-articles1.xml-p000000010p000030302.bz2 \
    && bunzip2 /root/wiki-small.bz2

COPY files/categories /root/
COPY files/benchmark.sh /root/
RUN chmod +x /root/benchmark.sh && ln -s /root/benchmark.sh /bin/benchmark

# TODO: ???
COPY files/mapred-site.xml ${HADOOP_CONF_DIR}
COPY files/yarn-site.xml ${HADOOP_CONF_DIR}
COPY files/hdfs-site.xml ${HADOOP_CONF_DIR}
COPY files/core-site.xml ${HADOOP_CONF_DIR}

