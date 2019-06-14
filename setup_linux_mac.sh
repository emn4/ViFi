#!/usr/bin/env bash
#Get ViFi
git clone https://github.com/emn4/ViFi.git
cd ViFi
VIFI_DIR=`pwd`

#Get data repos
echo "Downloading the data_repo"
wget https://raw.githubusercontent.com/circulosmeos/gdown.pl/master/gdown.pl
perl gdown.pl "https://drive.google.com/open?id=0ByYcg0axX7udUDRxcTdZZkg0X1k" data_repo.tar.gz
tar zxf data_repo.tar.gz
rm data_repo.tar.gz
echo "Downloading the HMM models"
perl gdown.pl "https://drive.google.com/open?id=0Bzp6XgpBhhghSTNMd3RWS2VsVXM" data.zip
unzip data.zip
rm data.zip

#Get hg38p12 Fasta from NCBI
curl -o hg19full.fna.gz ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/405/GCF_000001405.38_GRCh38.p12/GCF_000001405.38_GRCh38.p12_genomic.fna.gz
gunzip hg19full.fna.gz

#Set up environmental variables
echo "Set environmental variables"
echo export VIFI_DIR=$VIFI_DIR >> ~/.bashrc
echo export AA_DATA_REPO=$PWD/data_repo >> ~/.bashrc
echo export REFERENCE_REPO=$PWD/data >> ~/.bashrc

VIFI_DIR=$VIFI_DIR
AA_DATA_REPO=$PWD/data_repo
REFERENCE_REPO=$PWD/data

#Replacing old hg19 with hg38p12
rm $AA_DATA_REPO//hg19/hg19full.fa
mv $VIFI_DIR/hg19full.fna $AA_DATA_REPO//hg19/hg19full.fa

source ~/.bashrc

#Pull the Docker file
echo "Getting the dockerized version of ViFi"
singularity pull docker://emn4/vifi

#Set up reference for alignment
echo "Building the hg19+HPV reference"
cat $AA_DATA_REPO//hg19/hg19full.fa $REFERENCE_REPO/hpv/hpv.unaligned.fas > $REFERENCE_REPO/hpv/hg19_hpv.fas
singularity run --bind $REFERENCE_REPO/hpv/:/home/hpv/ docker://emn4/vifi bwa index /home/hpv/hg19_hpv.fas

#Build reduced list of HMMs for testing
echo "Running test for ViFi"
ls $VIFI_DIR/data/hpv/hmms/hmmbuild.[0-9].hmm > $VIFI_DIR/data/hpv/hmms/hmms.txt
source ~/.bashrc

#Run ViFi under docker mode on test dataset on reduced HMM list set
python $VIFI_DIR/scripts/run_vifi.py --cpus 2 --hmm_list $VIFI_DIR/data/hpv/hmms/hmms.txt -f $VIFI_DIR/test/data/test_R1.fq.gz -r $VIFI_DIR/test/data/test_R2.fq.gz -o $VIFI_DIR/tmp/docker/ --docker
