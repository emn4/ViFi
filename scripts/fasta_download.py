#!/usr/bin/env python3
import os
from Bio import Entrez
import argparse
import sys

Entrez.email = "eni@ufl.edu"
accession = sys.argv[1]
filename = accession + ".fasta"
if not os.path.isfile(filename):
    net_handle = Entrez.efetch(db="nucleotide", id=accession, rettype="fasta", retmode="text")
    out_handle = open(filename, "w")
    out_handle.write(net_handle.read())
    out_handle.close()
    net_handle.close()
    print("Saved FASTA of " + accession)
else:
    print("Error: FASTA already exists")
