use LWP::Simple;
use XML::Simple;
use Data::Dumper;
use strict;
use warnings;
use DBI;

#This scripts extracts the length from RCSB

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


#Select RCSB identifier from main table using the imported gene

my $identifier;

my $all_rows = $dbh->selectall_arrayref("SELECT GENE, RCSBIdentifier FROM IdentifierTable");

foreach my $row2 (@$all_rows) { 
	my ($TableGene, $RCSBIdentifier) = @$row2;
	if ($TableGene eq $gene) {
		$identifier = $RCSBIdentifier;
	}
}


#Extract length from RCSB

my $length;

my $url = "http://www.rcsb.org/pdb/rest/describeMol?structureId=$identifier";
my $browser = LWP::UserAgent->new;
my $response = $browser->get($url, 'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 7.0)');

if ($response->is_success) {
		#print $response->content;
		my $xml = new XML::Simple();
		my $data = $xml->XMLin($response->content);
		my $structureId = $data->{structureId}; 
	
		if (defined($structureId)) { 
			while (my ($key, $value) = each(%$structureId)) {
				if($key eq "polymer") {
					if(ref($value) eq 'ARRAY'){					#if polymer node is an array
						foreach my $arrayval (@$value) {
							while (my ($key2, $value2) = each(%$arrayval)) {
								if ($key2 eq "length") {
									$length = $value2;		#length extracted
									$dbh->do("INSERT INTO LengthTable values ('$gene', '$length')");	#add length to database
								}
							}
						}
					}
					
					else {		#if polymer node is a hash reference
						while (my ($key3, $value3) = each(%$value)) {
							if($key3 eq "length") {
								$length = $value3;		#length extracted
								$dbh->do("INSERT INTO LengthTable values ('$gene', '$length')");	#add length to database
							}
						}
					} 
				}
			}
		}
}


#close file handles

close $fh;