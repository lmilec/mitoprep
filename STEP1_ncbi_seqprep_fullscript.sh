###############################################################
#### This script lists the steps and subscripts to prepare ####
#### a FASTA file of one gene for multiple species needed  ####
#### for multiple alignment for that gene.                 ####
###############################################################
### Leona Milec, 21/10/20 ###



#### Files needed: ############################################
# batchentrez.txt: a list of accession numbers of the species included
# specieslist.txt: a list of the species names, fully spelled (e.g. Carassius auratus)
# genelist.txt: a list of genes for which you want to create the multifasta

#### Make sure to delete:
#previous allspecies.gb file
#previous new$gene.fasta and dedup$gene.fasta files
#to avoid appending to the previous versions and create large files







#### Step 1: downloading the genbank files ####################

#To download all genbank files:
#rm allspecies.gb
cat batchentrez.txt | while read accs; do
        efetch -db nucleotide -format gb -id $accs >> allspecies.gb;
done

###############################################################






#### Step 2: parsing the genbank files #########################
#### into separate gene multifastas ############################

#modify the parser script to fit the genelist and different spellings, 
#then run: 

#rm *fasta
python3 ./GenBank_to_FASTA_Parser_mathieu_LMmod.py

################################################################







#### Step 3: deduplicate the multifasta and #####################
#### check presence of all desired species ######################

#To remove duplicate gene sequences:
cat genelist.txt | while read gene; do
    awk '/^>/{f=!d[$1];d[$1]=1}f' new$gene.fasta > dedup$gene.fasta;
done

#Then check if all species are present:
#For a simple count of fasta sequences in all final files
rm speciescount.txt
grep -c '>' dedup* >> speciescount.txt
cat speciescount.txt

#If it is less than the amount you expect, then you can check for missing species per gene
#This little greppy script takes the list of species and checks which ones are present in the dedup fasta file
#Then pipes the result back into the species list and outputs the species not present in the dedup 
rm specieschecks.txt
cat genelist.txt | while read gene; do
    echo $gene >> specieschecks.txt
    grep -of specieslist.txt dedup${gene}.fasta | grep -vf - specieslist.txt  >> specieschecks.txt;
done
cat specieslist.txt

#Things that commonly go wrong:
#Spaces at the end of species names in specieslist.txt
#Different spellings of genes
#Region not annotated (often the case for D-loop). In this case needs to be added by hand
#Region not part of sequence (for partial sequences). Check for a different accession/voucher
#To add stuff by hand, make an extra .fa file and append to the ones that are missing species e.g.
#cat extraDLOOP.fa >> dedupDLOOP.fasta
./append_extragenes.sh

#################################################################





#### Step 4: rename fasta headers ###############################
#### and check species presence again ###########################

ls dedup* | while read file; do
	perl ./fasta_id_edit_leona.pl $file > renamed_$file;
done

# Do the specieschecks again

rm speciescount_renamed.txt
grep -c '>' dedup* >> speciescount_renamed.txt
cat speciescount_renamed.txt

rm specieschecks_renamed.txt
cat genelist.txt | while read gene; do
    echo $gene >> specieschecks_renamed.txt
    grep -of specieslist.txt dedup${gene}.fasta | grep -vf - specieslist.txt  >> specieschecks_renamed.txt;
done
cat specieschecks_renamed.txt

#################################################################