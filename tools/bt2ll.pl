while (<>) {
	if (/^#\d+\s+(.*) at (.*)/) {
		print $2, ":0:", $1, "\n";
	}	
}
