#!/usr/bin/env python3
import os
import sys
from Bio import Entrez
import re
from io import StringIO
import numpy as np
import pandas as pd

accession_path = sys.argv[1]

accession_data = pd.read_excel(io=accession_path)

search_term = input(
    "Input the host you are searching for: ")

filtered_list = accession_data[accession_data['Host'].str.contains(search_term,case=False, na=False)]
accession_list = filtered_list['Representative']

my_list = accession_list.str.cat(sep=",")

file1 = open("virus_list.txt","w")
file1.write(my_list)
file1.close()

print("Completed and saved to virus_list.txt")
