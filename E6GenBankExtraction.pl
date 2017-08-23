use LWP::Simple;
use XML::Simple;
use Data::Dumper;
use warnings;
use URI::Escape;
use LWP::UserAgent;
use HTTP::Request::Common qw(POST);
use DBI;
use JSON;

#This scripts extracts the additional resources from GenBank

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


#Select GenBank identifier from main table using the imported gene

my $identifier;

my $all_rows = $dbh->selectall_arrayref("SELECT GENE, GenBankIdentifier FROM IdentifierTable");

foreach my $row2 (@$all_rows) { 
	my ($TableGene, $GenBankIdentifier) = @$row2;
	if ($TableGene eq $gene) {
		$identifier = $GenBankIdentifier;
	}
}


#Extract additional resources from GenBank

my $url = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=$identifier&retmode=xml&rettype=gb ";
my $ua = LWP::UserAgent->new;
$ua->agent('Mozilla/4.0 (compatible; MSIE 7.0)');
my $req = HTTP::Request->new(GET => $url);
$req->header('Accept' => 'text/xml');
my $response = $ua->request($req);

my $authors;
my $title;
  
if ($response->is_success) {
  #print $response->content;
	if ($response->content_type eq "text/xml") {
		my $xml = new XML::Simple();
		my $data = $xml->XMLin($response->content); 
		#print Dumper($data);
		my $GBSeq = $data->{GBSeq}; # You are looking for BlastOutput, but it's gone
	
		if (defined($GBSeq)) { 
			while (my ($key, $value) = each(%$GBSeq)) {
				if ($key eq "GBSeq_references") {
					if (defined($value->{"GBReference"})) {
						my $GBReference = $value->{"GBReference"};
						if(ref($GBReference) eq 'ARRAY'){			#if GBReference node is an array
							foreach my $arrayval (@$GBReference){
								if (defined($arrayval->{"GBReference_title"})){
									$title = $arrayval->{"GBReference_title"};	#title isolated
									$title =~ s/'//gi;
									$title = "\"$title\"";
									$dbh->do("INSERT INTO PublicationTable values ('$gene', '$title')");	#add paper to database
								}
								if (defined($arrayval->{"GBReference_authors"})){
									my $authors = $arrayval->{"GBReference_authors"};
									while (my ($key3, $value3) = each(%$authors)){
										if(ref($value3) eq 'ARRAY'){	#if authors node is an array, there are multiple authors
											foreach my $arrayval (@$value3){	
												$authors = $arrayval;		#authors isolated
											}
										}

										else {	#if authors node is not an array, there's only 1 author
											$authors = $value3;
										}
										
										$dbh->do("INSERT INTO ExpertTable values ('$gene', '$authors')");	#add experts to database
									}
								}	
							}
						}
						
						else {
							if (defined($GBReference->{"GBReference_title"})){
								$title = $GBReference->{"GBReference_title"};	#title isolated
								$title =~ s/'//gi;
								$title = "\"$title\"";
								$dbh->do("INSERT INTO PublicationTable values ('$gene', '$title')");	#add paper to database
							}
							if (defined($GBReference->{"GBReference_authors"})){
								my $authors = $GBReference->{"GBReference_authors"};
								while (my ($key3, $value3) = each(%$authors)){
									if(ref($value3) eq 'ARRAY'){	#if authors node is an array, there are multiple authors
										foreach my $GBReference (@$value3){	
											$authors = $GBReference;		#authors isolated
										}
									}

									else {	#if authors node is not an array, there's only 1 author
										$authors = $value3;
									}
									
									$dbh->do("INSERT INTO ExpertTable values ('$gene', '$authors')");	#add experts to database
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
  print "Response not a success\n";
}


#close file handles

close $fh;