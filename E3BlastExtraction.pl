use LWP::Simple;
use XML::Simple;
use Data::Dumper;
use strict;
use warnings;
use DBI;
use URI::Escape;

#This scripts extracts the hsp score and identity from Blast

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


#Extract values from Blast

my $url = "http://www.uniprot.org/uniprot/$identifier.xml";
my $browser = LWP::UserAgent->new;
my $response = $browser->get($url, 'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 7.0)');

my $ua = LWP::UserAgent->new;

my @SearchArray = ("blastp", "nr", $identifier);
my $argc = $#SearchArray + 1;
my $program = $SearchArray[0];
my $database = $SearchArray[1];

if ($argc < 3) {
	print "All necessary information not provided in search array\n";
}
		
if ($program eq "megablast") {
	$program = "blastn&MEGABLAST=on";
}

if ($program eq "rpsblast") {
	$program = "blastp&SERVICE=rpsblast";
}


#get sequence from fasta file
my $query = "$identifier.fasta";
my $encoded_query = "";
open(QUERY,$query);
while(<QUERY>) {
	$encoded_query = $encoded_query . uri_escape($_);
}


# build the request
my $args = "CMD=Put&PROGRAM=$program&DATABASE=$database&QUERY=" . $encoded_query;

my $req = new HTTP::Request POST => 'https://www.ncbi.nlm.nih.gov/blast/Blast.cgi';
$req->content_type('application/x-www-form-urlencoded');
$req->content($args);

# get the response
$response = $ua->request($req);

# parse out the request id
$response->content =~ /^    RID = (.*$)/m;
my $rid=$1;

# parse out the estimated time to completion
$response->content =~ /^    RTOE = (.*$)/m;
my $rtoe=$1;

# wait for search to complete
sleep $rtoe;

# poll for results
while (1)	{
	sleep 5;

	$req = new HTTP::Request GET => "https://www.ncbi.nlm.nih.gov/blast/Blast.cgi?CMD=Get&FORMAT_OBJECT=SearchInfo&RID=$rid";
	$response = $ua->request($req);

	if ($response->content =~ /\s+Status=WAITING/m) {
		print STDERR "Searching...\n";
		next;
	}

	if ($response->content =~ /\s+Status=FAILED/m) {
		print STDERR "Search $rid failed; please report to blast-help\@ncbi.nlm.nih.gov.\n";
		exit 4;
	}

	if ($response->content =~ /\s+Status=UNKNOWN/m) {
		print STDERR "Search $rid expired.\n";
		exit 3;
	}

	if ($response->content =~ /\s+Status=READY/m) {
		if ($response->content =~ /\s+ThereAreHits=yes/m) {
			print STDERR "Search complete, retrieving results...\n";
			last;
		}
		else {
			print STDERR "No hits found.\n";
			exit 2;
		}
	}

	exit 5;
} 


#Retrieve and display results
$req = new HTTP::Request GET => "https://www.ncbi.nlm.nih.gov/blast/Blast.cgi?CMD=Get&FORMAT_TYPE=XML&RID=$rid";
$response = $ua->request($req);
		
		
my $counter;
my $hspscore;
my $identity;
		
if ($response->is_success) {
	if ($response->content_type eq "application/xml") {
		#print $response->content;
		my $xml = new XML::Simple();
		my $data = $xml->XMLin($response->content);
		#print Dumper($data);
		my $BlastOutput_Iterations = $data->{BlastOutput_iterations}; # You are looking for BlastOutput, but it's gone
		
		if (defined($BlastOutput_Iterations)) { 
			while (my ($key, $value) = each(%$BlastOutput_Iterations)) {
				
				if ($key eq "Iteration") {
					if (defined($value->{"Iteration_hits"})) {
						my $Iteration_hits = $value->{"Iteration_hits"};
						while (my ($key2, $value2) = each(%$Iteration_hits)){
									
							if ($key2 eq "Hit") {
								$counter = 0;
								foreach my $arrayval (@$value2){ #go through array
									if ($counter < 5) {
										$counter = $counter + 1;
										if (defined($arrayval->{"Hit_hsps"})){
											my $Hit_hsps = $arrayval->{"Hit_hsps"};
											while (my ($key3, $value3) = each(%$Hit_hsps)){
													
												if ($key3 eq "Hsp"){
													if (defined($value3->{"Hsp_score"})) {
														$hspscore = $value3->{"Hsp_score"};	#get evalue
													}
															
													if (defined($value3->{"Hsp_identity"})) {
														$identity = $value3->{"Hsp_identity"};	#get identity
													}
												}
												
												$dbh->do("INSERT INTO BlastValuesTable values ('$gene', '$hspscore', '$identity')");	#add blast values to database
											
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

else {
	print "Error getting $url\n";
}		
		
		
#close file handles

close $fh;