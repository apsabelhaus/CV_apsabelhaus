#!/local/bin/perl -w
#
#

$DEFS = "html-btxbst.doc";

sub cpp ($@);

&cpp('a',  'ALPHA');
&cpp('aa', 'ALPHA', 'ABSTRACT');
&cpp('n',  'NAMED');
&cpp('na', 'NAMED', 'ABSTRACT');
&cpp('u',  'UNSRT');
&cpp('ua', 'UNSRT', 'ABSTRACT');
&cpp('nr',   'NAMED',             'REVERSEDATE');
&cpp('ar',   'ALPHA',             'REVERSEDATE');
&cpp('ara',  'ALPHA', 'ABSTRACT', 'REVERSEDATE');
&cpp('nra',  'NAMED', 'ABSTRACT', 'REVERSEDATE');
&cpp('acr',  'ALPHA',             'REVERSEDATE', 'SORTBYYEAR');
&cpp('acra', 'ALPHA', 'ABSTRACT', 'REVERSEDATE', 'SORTBYYEAR');
&cpp('ncr',  'NAMED',             'REVERSEDATE', 'SORTBYYEAR');
&cpp('ncra', 'NAMED', 'ABSTRACT', 'REVERSEDATE', 'SORTBYYEAR');
&cpp('ac',   'ALPHA',             'SORTBYYEAR');
&cpp('aca',  'ALPHA', 'ABSTRACT', 'SORTBYYEAR');
&cpp('nc',   'NAMED',             'SORTBYYEAR');
&cpp('nca',  'NAMED', 'ABSTRACT', 'SORTBYYEAR');

# ----------------------------------------------------------------------------
# cpp function does just enough cpp parsing to process the $DEFS file.
sub cpp ($@) {
    my $suffix = shift;
    my @defs = @_;

    my $word;
    my $value;
    my %defs;
    my $skipping = 0;
    my $blank = 0;
    my $outfile = "html-${suffix}.bst";

    print STDERR "creating $outfile...\n";

    $defs{'HTML'} = 1;
    foreach $word (@defs) {
#print "define $word 1\n";
	$defs{$word} = 1;
    }

    open(FILE, "<$DEFS") || die "error opening $DEFS for read: $!\n";
    open(OUTFILE, ">$outfile") || die "error opening $outfile for write: $!\n";

line:
    while (<FILE>) {
	next line if (m/^%/);

	if (m/^#/) {
	    if (m/^#\s*ifdef\s+(\w+)/) {
		$word = $1;
#print "ifdef $word: " . (exists($defs{$word}) ? "1" : "0") . "\n";
		if ($skipping) {
		    $skipping++;
		    next line;
		}
		if (!exists($defs{$word})) {
		    $skipping++;
		}
		next line;
	    }
	    if (m/^#\s*ifndef\s+(\w+)/) {
		$word = $1;
		if ($skipping) {
		    $skipping++;
		    next line;
		}
		if (exists($defs{$word})) {
		    $skipping++;
		}
#print "ifndef $word: " . (exists($defs{$word}) ? "0" : "1") . "\n";
		next line;
	    }
	    if (m/^#\s*if\s+(\!?)\s*(\w+)/) {
		$negate = ($1 ne '');
		$word = $2;
		if ($skipping) {
		    $skipping++;
		    next line;
		}
		if (($negate && $defs{$word}) || (!$negate && !$defs{$word})) {
		    $skipping++;
		}
#print "if $word: (". $defs{$word} . ") " . ($defs{$word} != 0 ? "1" : "0") . "\n";
		next line;
	    }
	    if (m/^#\s*else\b/) {
		if ($skipping == 1) {
		    $skipping--;
		} elsif ($skipping == 0) {
		    $skipping++;
		}
#print "else\n";
		next line;
	    }
	    if (m/^#\s*endif\b/) {
#print "endif\n";
		if ($skipping > 0) {
		    $skipping--;
		}
		next line;
	    }
	    if (m/^#\s*define\s+(\w+)\s+(\S+)?/) {
		next line if $skipping;
		$word = $1;
		$value = $2;
#print "define $word = $value\n";
		$defs{$word} = (defined($value) ? $value : 1);
		next line;
	    }
	}

	if (m/^$/) {
	    next line if ($blank);
	    $blank = 1;
	} else {
	    $blank = 0;
	}

	print OUTFILE if (!$skipping);
    }

    die "#ifdef/#endif mismatch!\n" if ($skipping != 0);

    close(FILE);
    close(OUTFILE);
}
