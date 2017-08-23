use LWP::Simple;
use XML::Simple;
use Data::Dumper;
use warnings;
use URI::Escape;
use LWP::UserAgent;
use HTTP::Request::Common qw(POST);
use DBI;
use JSON;

#This scripts extracts the disease from Encode

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


#Select Encode identifier from main table using the imported gene

my $identifier;

my $all_rows = $dbh->selectall_arrayref("SELECT GENE, EncodeIdentifier FROM IdentifierTable");

foreach my $row2 (@$all_rows) { 
	my ($TableGene, $EncodeIdentifier) = @$row2;
	if ($TableGene eq $gene) {
		$identifier = $EncodeIdentifier;
	}
}


#Extract disease from Encode

my $url = "https://www.encodeproject.org/biosamples/$identifier/ ";
my $ua = LWP::UserAgent->new;
$ua->agent('Mozilla/4.0 (compatible; MSIE 7.0)');
my $req = HTTP::Request->new(GET => $url);
$req->header('Accept' => 'application/json');
my $response = $ua->request($req);
  
if ($response->is_success) {
  #print $response->content;
  my $data = decode_json($response->content);
  #print Dumper($data);
  my $entry = $data->{health_status};
  
  if (defined($entry)){
	my $disease = $entry;		#disease extracted
	$dbh->do("INSERT INTO DiseaseTable values ('$gene', '$disease')");	#add disease to database
  }
} 

else {
  print "Response not a success\n";
}


#close file handles

close $fh;