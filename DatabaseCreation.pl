use LWP::Simple;
use XML::Simple;
use Data::Dumper;
use strict;
use warnings;
use DBI;

#Create database
my $dbfile = "Gene_Database.db";
my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile");

#Create identifier table
$dbh->do("create table if not exists IdentifierTable (Gene, UniProtIdentifier, EnsembleIdentifier, BlastIdentifier, RCSBIdentifier, EncodeIdentifier, GenBankIdentifier)") or die $DBI::errstr;

						#Add genes
#BRCA1
$dbh->do("INSERT INTO IdentifierTable values ('BRCA1', 'P38398', 'ENSG00000012048', 'P38398', '4Y18', 'ENCBS637AAA', '262359905')");
#AARS
$dbh->do("INSERT INTO IdentifierTable values ('AARS', 'P49588', 'ENSG00000090861', 'P49588', '4XEM', 'ENCBS453TYZ', '299829180')"); 
#FOXA1
$dbh->do("INSERT INTO IdentifierTable values ('FOXA1', 'P55317', 'ENSG00000129514', 'P55317', '5DUI', 'ENCBS547AXB', '429836885')");	#should come up as empty for additional resources...there are none
#MYC
$dbh->do("INSERT INTO IdentifierTable values ('MYC', 'P01106', 'ENSG00000136997', 'P01106', '5G1X', 'ENCBS252AAA', '162329557')"); 
#TGIF2
$dbh->do("INSERT INTO IdentifierTable values ('TGIF2', 'Q9GZN2', 'ENSG00000118707', 'Q9GZN2', '2DMN', 'ENCBS246HTK', '237858687')"); 





#Create tables in database
$dbh->do("create table if not exists ProteinTable (Gene, GeneralProteinName, RecommendedProteinName, ProteinSequence, Function)") or die $DBI::errstr; 

$dbh->do("create table if not exists SpeciesTable (Gene, Species)") or die $DBI::errstr;

$dbh->do("create table if not exists BlastValuesTable (Gene, HSPScore, HSPIdentity)") or die $DBI::errstr;

$dbh->do("create table if not exists LengthTable (Gene, Length)") or die $DBI::errstr;

$dbh->do("create table if not exists DiseaseTable (Gene, Disease)") or die $DBI::errstr;

$dbh->do("create table if not exists PublicationTable (Gene, Titles)") or die $DBI::errstr;

$dbh->do("create table if not exists ExpertTable (Gene, Expert)") or die $DBI::errstr;