#!/bin/env perl 
# Dump MySQL database 
# main -> create_filename 
# You can modify 'database name'

# Show the usage of script 

use warnings;

my $ARGVS = $#ARGV + 1; 
if ($ARGVS != 1) {
	print "Usage: $0 {NORMAL|MINI}\n";
}

# Choose backup mode 
my $DUMP_MODE = $ARGV[0];


sub create_filename {
my $DBNAME = $_[0];
my $HOSTNAME = $_[1];
my $DATE = $_[2];

$OUTPUT_DIR = '/home';

for  ($NUM = 0; $NUM <= 100; $NUM++) {
	$DUMP_FILE = sprintf ("%s_%s_%s_%02d.sql.gz", $DBNAME, $HOSTNAME, $DATE, $NUM);
	if (! -f "$OUTPUT_DIR/$DUMP_FILE") {
	last; 
	exit 1; 
	}	  
  } 	

	if ($NUM >= 100) {
	print "Backup over $NUM , clean overtime backup_files\n";
	exit 2; 
        }	
        return $DUMP_FILE;
}


sub main {
	my $HOSTNAME = `hostname`;
	chomp ($HOSTNAME);
	my $DATE = `date '+%F'`;
	chomp ($DATE);

	if ($DUMP_MODE eq 'NORMAL') {
	my $DBNAME = 'test';
	$DUMP_FILE = &create_filename( $DBNAME, $HOSTNAME, $DATE );
	my $BAK_CMD = "mysqldump --opt --skip-extended-insert --default-character-set=binary --compatible=mysql323 -uroot $DBNAME |gzip -c > $OUTPUT_DIR/$DUMP_FILE 2> ${OUTPUT_DIR}/${DUMP_FILE}.err ";	
	print "$BAK_CMD\n";
	`$BAK_CMD`;	
	
	my $DBNAME = 'mysql';
	$DUMP_FILE = &create_filename( $DBNAME, $HOSTNAME, $DATE );
	my $BAK_CMD = "mysqldump --opt --skip-extended-insert --default-character-set=binary --compatible=mysql323 -uroot $DBNAME |gzip -c > $OUTPUT_DIR/$DUMP_FILE 2> ${OUTPUT_DIR}/${DUMP_FILE}.err ";	
	print "$BAK_CMD\n";
	`$BAK_CMD`;	
	}
	
	elsif ($DUMP_MODE eq 'MINI') {
	my $DBNAME = 'test';
	$DUMP_FILE = &create_filename( $DBNAME, $HOSTNAME, $DATE );
	my $BAK_CMD = "mysqldump --opt --skip-extended-insert --default-character-set=binary --compatible=mysql323 -uroot $DBNAME |gzip -c > $OUTPUT_DIR/$DUMP_FILE 2> ${OUTPUT_DIR}/${DUMP_FILE}.err ";	
	print "$BAK_CMD\n";
	`$BAK_CMD`;	
        }
}	

&main();
__END__
