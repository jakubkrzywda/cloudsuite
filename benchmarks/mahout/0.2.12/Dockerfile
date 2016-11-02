FROM cloudsuite/hadoop

ENV MAHOUT_VERSION 0.12.2
ENV MAHOUT_HOME /opt/mahout-${MAHOUT_VERSION}

# Install Mahout
RUN set -x \
    && MIRROR=$(curl -s http://www.apache.org/dyn/closer.lua?as_json=1 | grep preferred | awk '{print $2}' | sed -e 's/"//g') \
    && URL=${MIRROR}mahout/${MAHOUT_VERSION}/apache-mahout-distribution-${MAHOUT_VERSION}.tar.gz \
    && curl ${URL} | tar -xzC /opt \
    && mv /opt/apache-mahout-distribution-${MAHOUT_VERSION} ${MAHOUT_HOME}

COPY files/categories /root/
COPY files/benchmark.sh /root/
RUN chmod +x /root/benchmark.sh && ln -s /root/benchmark.sh /bin/benchmark
