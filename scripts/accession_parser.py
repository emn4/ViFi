#!/usr/bin/env python3
import os
from Bio import Entrez
import re
from io import StringIO
import numpy as np

accession_path = input(
    "Input the path to accession list as a .txt file, making sure that each accession is separated by a comma.")

accession_data = np.asarray(np.genfromtxt(accession_path, skiprows = 2))

search_term = input(
    "Input the host you are searching for")

pattern = re.compile(search_term)

accession_data = accession_data[pattern.search(accession_data[:,2]) != None]

accession_data = accession_data[:,1]

my_list = ','.join(map(accession_data, my_list))

print("Completed")
