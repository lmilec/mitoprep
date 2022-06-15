# -*- coding: utf-8 -*-
"""
Spyder Editor

"""

# This script was adapted from Alexander Thomas Baker and Sanjay Kumar Srikakulam (researchgate)
# Link to the original script: https://www.researchgate.net/post/How_can_I_parse_a_GenBank_file_to_retrieve_specific_gene_sequences_with_IDs
# It was modified on 28/09/20 by Mathieu Tachon and Leona Milec

from Bio import SeqIO
import os

input_file = "allspecies.gb" #Your GenBank file locataion. e.g C:\\Sequences\\my_genbank.gb
output_file_template = "new{}.fasta" #The name out your fasta output
genes_dict = {"COI": ["COX1", "CO1", "COI","cytochrome c oxidase subunit I"],
              "COII": ["COX2", "CO2", "COII","cytochrome c oxidase subunit II"],
              "COIII": ["COX3", "CO3", "COIII","cytochrome c oxidase subunit III"],
              "ND1": ["ND1", "NADH dehydrogenase subunit 1"],
              "ND2": ["ND2", "NADH dehydrogenase subunit 2"],
              "ND3": ["ND3", "NADH dehydrogenase subunit 3"],
              "ND4": ["ND4", "NADH dehydrogenase subunit 4"],
              "ND4L": ["ND4L", "NADH dehydrogenase subunit 4L"],
              "ND5": ["ND5", "NADH dehydrogenase subunit 5"],
              "ND6": ["ND6", "NADH dehydrogenase subunit 6"],
              "ATP6": ["ATP6", "ATPase 6", "ATPase subunit 6", "ATP synthase F0 subunit 6","ATPase6"],
              "ATP8": ["ATP8", "ATPase 8", "ATPase subunit 8", "ATP synthase F0 subunit 8","ATPase8"],
              "12S": ["12S","12S rRNA", "12S ribosomal RNA","s-rRNA","srRNA"],
              "16S": ["16S","16S rRNA", "16S ribosomal RNA","l-rRNA","lrRNA"],
              "DLOOP": ["D-loop","D loop","Dloop","control region","putative control region","complete","control region (completely determined)", "control region incomplete","control region, incomplete"],
              "CYTB": ["CYTB","cytochrome b"]          
              }

for rec in SeqIO.parse(input_file, "gb"): #calls the record for the genbank file and SeqIO (BioPython module) to parse it
    acc = rec.annotations['accessions'][0] #Defines your accession numbers
    organism = rec.annotations['organism'] #defines your organism ID
    tax_line = ("| ").join(rec.annotations['taxonomy']) #defines your taxonomy and seperates entries with a |, remove this line, the 'tax_line', and the {2} in your save for a simpler output
    for feature in rec.features: #looks for features in the genbank
        for key, val in feature.qualifiers.items(): #looks for val in the feature qualifiers
            for g, l in genes_dict.items():
                if any(el in val for el in l):
                    try:
                        with open(output_file_template.format(g), "a") as ofile: #opens the output file and "a" designates it for appending
                            ofile.write(">{0}| {1}| {2}| \n{3}\n\n".format(acc, organism, val[0], feature.extract(rec.seq))) #Writes my FASTA format sequences to the output file                    
                    except Exception:
                        print("Error for feature : {}, with qualifiers: {}\n".format(feature, feature.qualifiers))
