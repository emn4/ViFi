import os
from Bio import Entrez
import re

accession_path = raw_input(
    "Input the path to accession list as a .txt file, making sure that each accession is separated by a comma.")

accession_file = open(accession_path, "r")
regex = r'(\s)*,+(\s)*'
accession_string = accession_file.read()  # type: str
accession_list = [s.strip() for s in re.split(",", accession_string)]

for i in accession_list:
    filename = ("/virus/%s.fasta" %i)
    if not os.path.isfile(filename):
        net_handle = Entrez.efetch(db="nucleotide", id=i, rettype="fasta", retmode="text")
        out_handle = open(filename, "w")
        out_handle.write(net_handle.read())
        out_handle.close()
        net_handle.close()
        print("Saved FASTA of %s" %i)
    else:
        print("Error: FASTA already exists")









