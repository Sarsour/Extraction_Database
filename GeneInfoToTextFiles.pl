use LWP::Simple;
use XML::Simple;
use Data::Dumper;
use warnings;
use DBI;
use strict;

#Find the requested gene from temp.txt

my $gene;
my $filename = 'temp.txt';

open(my $fh, '<:encoding(UTF-8)', $filename)
	or die "Could not open file '$filename' $!";
 
while (my $row = <$fh>) {
	chomp $row;
	$gene = $row;
}


#Connect to database

my $db_name = "Gene_Database.db";
my $dbh = DBI->connect("dbi:SQLite:dbname=$db_name");


#Open file handlers

my $genProteinFile = 'genProteinFile.txt';
open(my $genProteinfh, '>:encoding(UTF-8)', $genProteinFile)
	or die "Could not open file '$genProteinFile' $!";
	
my $recProteinFile = 'recProteinFile.txt';
open(my $recProteinfh, '>:encoding(UTF-8)', $recProteinFile)
	or die "Could not open file '$recProteinFile' $!";
	
my $sequenceFile = 'sequenceFile.txt';
open(my $sequencefh, '>:encoding(UTF-8)', $sequenceFile)
	or die "Could not open file '$sequenceFile' $!";

my $functionFile = 'functionFile.txt';
open(my $functionfh, '>:encoding(UTF-8)', $functionFile)
	or die "Could not open file '$functionFile' $!";
	
my $speciesFile = 'speciesFile.txt';
open(my $speciesfh, '>:encoding(UTF-8)', $speciesFile)
	or die "Could not open file '$speciesFile' $!";

my $hspscoreFile = 'hspscoreFile.txt';
open(my $hspscorefh, '>:encoding(UTF-8)', $hspscoreFile)
	or die "Could not open file '$hspscoreFile' $!";
	
my $hspidentityFile = 'hspidentityFile.txt';
open(my $hspidentityfh, '>:encoding(UTF-8)', $hspidentityFile)
	or die "Could not open file '$hspidentityFile' $!";
	
my $lengthFile = 'lengthFile.txt';
open(my $lengthfh, '>:encoding(UTF-8)', $lengthFile)
	or die "Could not open file '$lengthFile' $!";
	
my $diseaseFile = 'diseaseFile.txt';
open(my $diseasefh, '>:encoding(UTF-8)', $diseaseFile)
	or die "Could not open file '$diseaseFile' $!";
	
my $titleFile = 'titleFile.txt';
open(my $titlefh, '>:encoding(UTF-8)', $titleFile)
	or die "Could not open file '$titleFile' $!";
	
my $expertFile = 'expertFile.txt';
open(my $expertfh, '>:encoding(UTF-8)', $expertFile)
	or die "Could not open file '$expertFile' $!";
	
	
#Get info from database and create text files for the Java user interface

#ProteinTable

my $all_rowsProtein = $dbh->selectall_arrayref("SELECT Gene, GeneralProteinName, RecommendedProteinName, ProteinSequence, Function FROM ProteinTable");

foreach my $row (@$all_rowsProtein) { 
	my ($TableGene, $genProteinName, $recProteinName, $proteinSequence, $proteinFunction) = @$row;
	if ($TableGene eq $gene) {
		print $genProteinfh "$genProteinName\n";
		print $recProteinfh "$recProteinName\n";
		print $sequencefh "$proteinSequence\n";
		print $functionfh "$proteinFunction\n";
	}
}


#SpeciesTable

my $all_rowsSpecies = $dbh->selectall_arrayref("SELECT Gene, Species FROM SpeciesTable");

foreach my $row (@$all_rowsSpecies) { 
	my ($TableGene, $genProteinName) = @$row;
	if ($TableGene eq $gene) {
		print $speciesfh "$genProteinName\n";
	}
}


#BlastValuesTable

my $all_rowsBlast = $dbh->selectall_arrayref("SELECT Gene, HSPScore, HSPIdentity FROM BlastValuesTable");

foreach my $row (@$all_rowsBlast) { 
	my ($TableGene, $hspScore, $hspIdentity) = @$row;
	if ($TableGene eq $gene) {
		print $hspscorefh "$hspScore\n";
		print $hspidentityfh "$hspIdentity\n";
	}
}


#LengthTable

my $all_rowsLength = $dbh->selectall_arrayref("SELECT Gene, Length FROM LengthTable");

foreach my $row (@$all_rowsLength) { 
	my ($TableGene, $proteinLength) = @$row;
	if ($TableGene eq $gene) {
		print $lengthfh "$proteinLength\n";
	}
}


#DiseaseTable

my $all_rowsDisease = $dbh->selectall_arrayref("SELECT Gene, Disease FROM DiseaseTable");

foreach my $row (@$all_rowsDisease) { 
	my ($TableGene, $disease) = @$row;
	if ($TableGene eq $gene) {
		print $diseasefh "$disease\n";
	}
}


#PublicationTable

my $all_rowsTitle = $dbh->selectall_arrayref("SELECT Gene, Titles FROM PublicationTable");

foreach my $row (@$all_rowsTitle) { 
	my ($TableGene, $title) = @$row;
	if ($TableGene eq $gene) {
		print $titlefh "$title\n";
	}
}


#ExpertTable

my $all_rowsExpert = $dbh->selectall_arrayref("SELECT Gene, Expert FROM ExpertTable");

foreach my $row (@$all_rowsExpert) { 
	my ($TableGene, $expert) = @$row;
	if ($TableGene eq $gene) {
		print $expertfh "$expert\n";
	}
}


#close file handlers

close $fh;
close $genProteinfh;
close $recProteinfh;
close $sequencefh;
close $functionfh;
close $speciesfh;
close $hspscorefh;
close $hspidentityfh;
close $lengthfh;
close $diseasefh;
close $titlefh;
close $expertfh;