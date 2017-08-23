use LWP::Simple;
use XML::Simple;
use Data::Dumper;
use strict;
use warnings;
use DBI;
use HTTP::Tiny;

#This scripts extracts the species from Ensemble

#Find the requested gene from temp.txt

my $gene;
my $filename = 'temp.txt';

open(my $fh, '<:encoding(UTF-8)', $filename)
	or die "Could not open file '$filename' $!";
 
while (my $row = <$fh>) {
	chomp $row;
	$gene = $row;
}
	
	
#Connect to Gene_Database

my $db_name = "Gene_Database.db";
my $dbh = DBI->connect("dbi:SQLite:dbname=$db_name");


#Select ensemble identifier from main table using the imported gene

my $identifier;

my $all_rows = $dbh->selectall_arrayref("SELECT GENE, EnsembleIdentifier FROM IdentifierTable");

foreach my $row2 (@$all_rows) { 
	my ($TableGene, $EnsembleIdentifier) = @$row2;
	if ($TableGene eq $gene) {
		$identifier = $EnsembleIdentifier;
	}
}


#Extract species from Ensemble
 
my $url = "http://rest.ensembl.org/homology/id/$identifier?content-type=text/xml";
my $browser = LWP::UserAgent->new;
my $response = $browser->get($url,
  'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 7.0)');

my $species;
my $counter = 0;	#used to only take the first species since all are identical...no need for replicates of the same species

if ($response->is_success) {
  if ($response->content_type eq "text/xml") {
    my $xml = new XML::Simple();
    # print $response->content;
	my $data = $xml->XMLin($response->content);
	# print Dumper($data);
	my $entry_node = $data->{data};
	
	if (defined($data)){
		while (my ($key, $value) = each(%$data)){
			if ($key eq "data"){
				if (defined($value->{"data"})){
					my $data2 = $value->{"data"};
					while (my ($key2,$value2) = each(%$data2)){
						
						if ($key2 eq "homologies") {
							foreach my $arrayval (@$value2){
								while (my ($key3,$value3) = each(%$arrayval)){
									
									if ($key3 eq "source") {
										if (defined($value3->{"species"})){
											$species = $value3->{"species"};	#species extracted
											while ($counter < 1) {				#only get first instance of species
												$counter = $counter + 1;
												$dbh->do("INSERT INTO SpeciesTable values ('$gene', '$species')");	#add speciies to database
											}	
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}	
  } 
}  


#close file handles

close $fh;