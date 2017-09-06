#!/usr/bin/perl

#====================================================================
#
#   FILE: html-table2pandoc.pl
#
#   USAGE: pandoc -r html -R -w markdown in.html \
#          | perl html-table2pandoc >out.md
#
#          I.e. pipe output from Pandoc's HTML-to-markdown
#          conversion through html-table2pandoc.pl.
#
#          Remember to use Pandoc's --parse-raw|-R option!
#
#   DESCRIPTION: Takes utf-8 text input from STDIN, converts
#                contained HTML tables into Pandoc markdown
#                tables and prints to STDOUT.  Empty cells are
#                inserted to compensate for cells with colspan
#                and/or rowspan > 1.
#
#   OPTIONS: --maxwidth|--width|-m|-w <integer>
#
#            Sets the maximum width in characters
#            for output tables.  The default is 80.
#
#            --colsep|-c <integer>
#
#           Sets the number of space characters between columns.
#           The default is 2.  Values < 1 will be ignored with a
#           warning.
#
#            --help
#
#            Prints this text to STDOUT and exits.
#
#   DEPENDENCIES: Perl, obviously, and two CPAN modules
#                 Regexp::Common and Text::FormatTable.
#
#   LIMITATIONS: Does not convert HTML tables with nested tables
#                insside them since Pandoc's table format does
#                not allow for nested tables.  Those are just
#                passed through with a warning.
#
#                Input must be utf-8 encoded and output also always
#                is utf-8 encoded. Not much of a limitation since it
#                applies to Pandoc too!
#
#                Colspan/rowspan layout of the input HTML tables
#                must be 'sane': tables with overlapping cells
#                will be parsed in a way which causes an error
#                in Text::FormatTable!
#
#                Columns in the output markdown tables are all
#                left aligned.
#
#                I would have liked to be able to control that the
#                column offsets in output markdown tables be multiples
#                of some number of characters, corresponding to one's
#                preferred tab width, but this is currently not possible.
#
#   USED WITH: Pandoc, a converter between various
#              text markup formats.  See:
#
#              <http://johnmacfarlane.net/pandoc/>
#
#   AUTHOR: Benct Philip Jonsson <bpj at melroch dot se>
#
#   DISCLAIMER: The author of this script gives no warranties
#               as to its usefulness or usability. I'm only an
#               amateur programmer, so it could probably have
#               been written differently and better.  If you
#               think so then by all means rewrite it!
#
#               I am not the author of Pandoc and the author of
#               Pandoc is not the author of this script, and of
#               course we have no responsibility for each other's
#               creations!
#
#   LICENCE: This script is public domain.  Use it, alter it and
#            redistribute it as you see fit.
#====================================================================

use strict;
use warnings;
use Encode qw/decode encode/;
use Getopt::Long;
use Regexp::Common qw/balanced/;
use Text::FormatTable;

# Option variables
my $help = 0;
my $width = 80;
my $colsep = '  ';

GetOptions(
    "help|h"                => \$help,
    "maxwidth|width|m|w=i"  => \$width,
    "colsep|c=i" => sub { $colsep = $_[1] >= 1 ? ' ' x $_[1] : '  ';
        if($_[1] < 1){
            warn "Invalid value ($_[1]) for --colsep option!\nUsing default value (2).\n"
        }
    }
);

if($help){ print <<'HELPTEXT'; exit; }
   FILE: html-table2pandoc.pl

   USAGE: pandoc -r html -R -w markdown in.html \
          | perl html-table2pandoc >out.md

          I.e. pipe output from Pandoc's HTML-to-markdown
          conversion through html-table2pandoc.pl.

          Remember to use Pandoc's --parse-raw|-R option!

   DESCRIPTION: Takes utf-8 text input from STDIN, converts
                contained HTML tables into Pandoc markdown
                tables and prints to STDOUT.  Empty cells are
                inserted to compensate for cells with colspan
                and/or rowspan > 1.

   OPTIONS: --maxwidth|--width|-m|-w <integer>

            Sets the maximum width in characters
            for output tables.  The default is 80.

            --colsep|-c <integer>

            Sets the number of space characters between columns.
            The default is 2.  Values < 1 will be ignored with a
            warning.

            --help

            Prints this text to STDOUT and exits.

   DEPENDENCIES: Perl, obviously, and two CPAN modules:
                 Regexp::Common and Text::FormatTable

   LIMITATIONS: Does not convert HTML tables with nested tables
                insside them since Pandoc's table format does
                not allow for nested tables.  Those are just
                passed through with a warning.

                Input must be utf-8 encoded and output also always
                is utf-8 encoded. Not much of a limitation since it
                applies to Pandoc too!

                Colspan/rowspan layout of the input HTML tables
                must be 'sane': tables with overlapping cells
                will be parsed in a way which causes an error
                in Text::FormatTable!

                Columns in the output markdown tables are all
                left aligned.

                I would have liked to be able to control that the
                column offsets in output markdown tables be multiples
                of some number of characters, corresponding to one's
                preferred tab width, but this is currently not possible.

   USED WITH: Pandoc, a converter between various
              text markup formats.  See:

              <http://johnmacfarlane.net/pandoc/>

   AUTHOR: Benct Philip Jonsson <bpj at melroch dot se>

   DISCLAIMER: The author of this script gives no warranties
               as to its usefulness or usability. I'm only an
               amateur programmer, so it could probably have
               been written differently and better.  If you
               think so then by all means rewrite it!

               I am not the author of Pandoc and the author of
               Pandoc is not the author of this script, and of
               course we have no responsibility for each other's
               creations!

   LICENCE: This script is public domain.  Use it, alter it and
            redistribute it as you see fit.
HELPTEXT

###############################################################################

# Pattern to find HTML tables
my $tablepat = qr#$RE{balanced}{-begin => "<table>|<table |<table   "}{-end => "</table>"}{-keep}#i;

# Slurp in the input
my $text;
{
    local $/ = undef;
    $text = <>;
}

# Decode input
$text = decode('utf8', $text);

$text =~ s/$tablepat/table2markdown($1)/eg;

print encode('utf8', $text);

if(not $text){
    die "No input.  For usage run with --help option.\n"
}

sub table2markdown {
    my $html = shift;

    # Return unmodified if it contains a nested table
    if($html =~ s/(<table\b)/$1/g > 1){
        warn "Found nested table. Returning containing table unmodified.\n";
        return $html;
    }

    # Convert HTML table to a perl array of arrays
    my ($caption,$colcount,@table) = html2AoA($html);

    # Create a format for Text::FormatTable
    my $format = "l$colsep" x $colcount;
    # Remove trailing space(s)
    $format =~ s/\s+$//;

    # Create a 'format' for the head rule.

    # Text::FormatTable has no notion of anything
    # like Pandoc's broken row of dashes to
    # indicate the columns, so we have to use some
    # tricks to create it: We don't know
    # beforehand the widths of the columns in the
    # table Text::FormatTable creates, so we
    # make Text::FormatTable begin the table with
    # a row where each cell containts only a lone
    # dash followed by spaces padding to the
    # column width.  After rendering the table we
    # use a regex to convert the extra spaces to
    # hyphens.

    # We create our placeholder headrule as the
    # first line of the rendered table and then
    # move it into its right place after the first
    # row, since then we avoid messing up the
    # table content, which may contain a line
    # consisting of only hyphens and spaces!  We
    # also always create multiline tables, since
    # we hardly know beforehand if the data of
    # each row will fit in our output table width.

    my @headrule = ('-') x $colcount;

    # Create a Text::FormatTable object using our format
    my $tabobj = Text::FormatTable->new($format);

    # Build up the table in the Text::FormatTable object.

    # Add the headrule
    $tabobj->row(@headrule);

    # Add the top row of dashes
    $tabobj->rule('-');

    # Step through the table data array of arrays
    # adding each row in turn
    for my $row (@table){

        # Add the row content
        $tabobj->row(@$row);

        # Add an empty Text::FormatTable 'rule'
        # corresponding to the inter-row empty line
        # of the Pandoc multiline table.
        $tabobj->rule('');
    }
    # Add the footer row of dashes
    $tabobj->rule('-');

    # Render the table with Text::FormatTable
    my $tabstring = $tabobj->render($width);

    # Get our placeholder headrule
    $tabstring =~ s{^([\-\ ]+)\n}{};
    my $headrule = $1;
    # Convert our placeholder headrule to one Pandoc
    # will understand.
    # Find each instance of a hyphen followed by
    # one or more spaces up to a space followed
    # by a hyphen and replace the found spaces
    # with hyphens, i.e. convert
    #    ^-      -      -      -     $
    # into
    #    ^------ ------ ------ ------$
    $headrule =~ s[(- +?)(?=$colsep-|$)][ '-' x length($1) ]eg;
    # Insert the expanded headrule after the first row.
    $tabstring =~ s/\n\n/\n$headrule\n/;
    # Add the caption if any
    if($caption){ return "\n$tabstring\nTable: $caption\n" }
    else { return "\n$tabstring\n" }
}

# Convert an HTML table into a perl array of arrays
sub html2AoA {
    my $html = shift;
    # Create an array to hold the table
    my @table;

    # Get the caption if any
    my $caption = $html =~ m{<caption\b[^>]*>(.*?)</caption>} ? $1 : '';

    # Get each table row and push it into a row in the array
    $html =~ s{(<tr\b[^>]*>.*?</tr>)}{ push @table, $1 }egs;

    # Step through the array and convert each HTML
    # table row into an array where each item is a
    # hash with keys for the content, colspan and
    # rowspan of each HTML table header/data span.

    for my $row (@table){
        # Get the row contents into a temporary scalar
        my $tmp = $row;
        # Convert the row/array item into an empty array ref
        $row = [];
        # Find each HTML td/th span and extract its data
        $tmp =~ s{<t[hd]\b([^>]*)>(.*?)</t[hd]>}{
            my($attr,$content) = ($1,$2);
            # Get colspan and rowspan
            my($colspan,$rowspan) = (1,1);
            if($attr and $attr =~ /colspan=(['"])(\d+)\1/i){ $colspan = $2 }
            if($attr and $attr =~ /rowspan=(['"])(\d+)\1/i){ $rowspan = $2 }
            push @$row, { colspan => $colspan, rowspan => $rowspan, content => $content };
        }egs;
    }

    # Expand colspans by adding empty cells to the right
    # of wide cells.
    for my $row (@table){
        # A temporary array for the expanded row
        my @tmp;
        for my $cell (@$row){
            # Add the cell to the expanded row
            push @tmp, $cell;
            if($cell->{colspan} > 1){
                # If the cell has a colspan > 1 add the
                # appropriate number of empty cells to its right.
                my @fill = ({ rowspan => $cell->{rowspan}, colspan => 0, content => '' }) x ($cell->{colspan} - 1);
                push @tmp, @fill;
            }
        }
        # Replace the original row with the expanded row
        @$row = @tmp;
    }

    # Keep check if the rows are of uneven length.
    # This variable will hold the length of the longest
    # row we have seen so far.
    my $collength = 0;

    # Expand rowspans by adding empty cells below cells with
    # a rowspan greater than 1
    for(my $row = 0; $row <= $#table; $row++){
        for(my $cell = 0; $cell <= $#{$table[$row]}; $cell++){
            my $rowspan = $table[$row]->[$cell]->{rowspan};
            while($rowspan > 1){
                $rowspan--;
                splice @{$table[$row+$rowspan]}, $cell,0,{content => '', rowspan => 0};
            }
            # Now we can turn the cell value into a scalar
            # containing the content, since the span values
            # aren't needed anymore.
            $table[$row]->[$cell] = $table[$row]->[$cell]->{content};
        }
        # If the current row is longer than the longest
        # row seen so far increase $collongth accordingly
        if($collength < $#{$table[$row]}){ $collength = $#{$table[$row]} }
    }

    # Pad to rowlength, if necessary
    for my $row (@table){
        if($#$row < $collength){
            $$row[$collength] = '';
        }
    }

    return ($caption,$collength+1,@table);
}

