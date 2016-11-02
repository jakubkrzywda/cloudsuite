#!/bin/bash

DATASET_SIZE=${1:-small}
DATASET=wiki-${DATASET_SIZE}
URL=

case $DATASET_SIZE in
  small)
    URL=https://dumps.wikimedia.org/enwiki/latest/enwiki-latest-pages-articles1.xml-p000000010p000030302.bz2
    ;;
  medium)
    URL=https://dumps.wikimedia.org/enwiki/latest/enwiki-latest-pages-articles10.xml-p002336425p003046511.bz2
    ;;
  full)
    URL=https://dumps.wikimedia.org/enwiki/latest/enwiki-latest-pages-articles.xml.bz2
    ;;
esac

if [ ! -f /root/$DATASET ]; then
  curl -o /root/${DATASET}.bz2 $URL
  bunzip2 /root/${DATASET}.bz2
  ${HADOOP_PREFIX}/bin/hdfs dfs -mkdir -p /user/root
  ${HADOOP_PREFIX}/bin/hdfs dfs -put /root/$DATASET /user/root/
fi

START=$(($(date +"%s%N")/1000000))

# Create sequence files from wiki
echo "mahout seqwiki"
${MAHOUT_HOME}/bin/mahout seqwiki -c /root/categories -i /user/root/$DATASET -o /user/root/wiki-seq
# Convert sequence files to vectors using bigrams
echo "mahout seq2sparse"
${MAHOUT_HOME}/bin/mahout seq2sparse -i /user/root/wiki-seq -o /user/root/wiki-vectors -lnorm -nv -wt tfidf -ow -ng 2
# Create training and holdout sets with a random 80-20 split of the generated vector dataset
echo "mahout split"
${MAHOUT_HOME}/bin/mahout split -i /user/root/${WORK_DIR}/wiki-vectors/tfidf-vectors --trainingOutput /user/root/training \
                                --testOutput  /user/root/testing -rp 20 -ow -seq -xm sequential
# Train Bayes model
echo "mahout trainnb"
${MAHOUT_HOME}/bin/mahout trainnb -i /user/root/training -o /user/root/model -li /user/root/labelindex -ow -c
# Test on holdout set
echo "mahout testnb"
${MAHOUT_HOME}/bin/mahout testnb -i /user/root/testing -m /user/root/model -l /user/root/labelindex -ow -o /user/root/output -seq

END=$(($(date +"%s%N")/1000000))
TIME=$(($END - $START))
echo -e "\nBenchmark time: ${TIME}ms"

