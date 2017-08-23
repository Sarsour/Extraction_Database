use LWP::Simple;
use XML::Simple;
use Data::Dumper;
use warnings;
use DBI;

#This scripts extracts the gene function from Uniprot

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


#Select uniprot identifier from main table using the imported gene

my $identifier;

my $all_rows = $dbh->selectall_arrayref("SELECT GENE, UniProtIdentifier FROM IdentifierTable");

foreach my $row2 (@$all_rows) { 
	my ($TableGene, $UniProtIdentifier) = @$row2;
	if ($TableGene eq $gene) {
		$identifier = $UniProtIdentifier; 	#identifer isolated
	}
}

#Create Fasta File for Blast Extraction Script

my $filename2 = "$identifier.fasta";
open (my $fh2, '>', $filename2) or die "Could not open file '$filename2' $!";


#Extracting Function Data from UniProt

my $url = "http://www.uniprot.org/uniprot/$identifier.xml";
my $browser = LWP::UserAgent->new;
my $response = $browser->get($url, 'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 7.0)');
my $ProteinFunction;
my $GeneralProteinName;
my $RecommendedProteinName;
my $Sequence;

if ($response->is_success) {
	if ($response->content_type eq "application/xml") {
		#print $response->content;
		my $xml = new XML::Simple();
		my $data = $xml->XMLin($response->content, forcearray=>[qw(dbReference)], keyattr=>[]);
		my $entry_node = $data->{entry};
		my $comment = $entry_node->{comment};
		
		#extract protein variables and add to table
		
		if (defined($comment)) {
			foreach my $commentarrayval (@$comment) {
				if ($commentarrayval->{type} && ($commentarrayval->{type} eq "function") && ($commentarrayval->{text})) {
					
					#protein function
					if (defined($commentarrayval->{"text"})) {
						my $function = $commentarrayval->{"text"};
						if (defined($function)) {
							if (ref $function eq ref {})	{	#if function node is a hash
								$ProteinFunction = $function->{"content"}; 	
								$ProteinFunction =~ s/'//gi;
							}
							
							else {	#if function node is not a hash
								$ProteinFunction = $function; 				#protein function isolated
								$ProteinFunction =~ s/'//gi;
							}
						}
					}
					
					#protein (general name)
					if (defined($entry_node)) {
						while (my ($key, $value) = each(%$entry_node)) {
							if ($key eq "name") {
								$GeneralProteinName = $value;
								print $fh2 ">$GeneralProteinName - ";				#General protein name isolated
							}
						}
					}
				
					#protein (full name)
					my $acc_node = $entry_node->{protein};
					if (defined($acc_node)) {
						while (my ($key, $value) = each (%$acc_node)){		
						    if ($key eq "recommendedName") {
								if (defined($value->{fullName})) {
									$RecommendedProteinName = $value->{fullName};
										if (ref $RecommendedProteinName eq ref {}) {	#if protein name node is a hash
											while (my ($key2, $value2) = each (%$RecommendedProteinName)){	
												if ($key2 eq "content") {
													$RecommendedProteinName = $value2;
													print $fh2 "$RecommendedProteinName" . "\n";	#Recommended protein name isolated
												}
											}
										}
										
										else { #if protein name node is not a hash
											print $fh2 "$RecommendedProteinName" . "\n";	#Recommended protein name isolated
										}
								}		
							} 
						}
					}	
				
					#sequence
					$acc_node = $entry_node->{sequence};
					if (defined($acc_node)) {
						while (my ($key, $value) = each (%$acc_node)){	
							if ($key eq "content") {
								if (defined($value=~ /^[a-zA-Z]{10}/)) {
									$Sequence = $value;
									print $fh2 "$Sequence";							#Protein sequence isolated
								}
							}
						}
					}
				}
			}
		
			$dbh->do("INSERT INTO ProteinTable values ('$gene', '$GeneralProteinName', '$RecommendedProteinName', '$Sequence', '$ProteinFunction')");	#add protein information to database
		}
	}
	
	else {
		print "URL not working\n";
		print "\n";
	}
}


#close file handles

close $fh;
close $fh2;