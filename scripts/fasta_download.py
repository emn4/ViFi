#!/usr/bin/env python3
import os
from Bio import Entrez
import argparse

parser = argparse.ArgumentParser(description='Enter the accession number of the verome')

args = parser.parse_args()

filename = args[0] + ".fasta"
if not os.path.isfile(filename):
    net_handle = Entrez.efetch(db="nucleotide", id=args[0], rettype="fasta", retmode="text")
    out_handle = open(filename, "w")
    out_handle.write(net_handle.read())
    out_handle.close()
    net_handle.close()
    print("Saved FASTA of " + args[0])
else:
    print("Error: FASTA already exists")
