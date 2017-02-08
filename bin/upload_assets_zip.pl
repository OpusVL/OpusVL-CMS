#!/usr/bin/perl
# PODNAME: upload_assets_zip.pl

use 5.010;
use lib 'lib';
use OpusVL::CMS::Schema;
use Archive::Zip qw/ :ERROR_CODES /;
use MIME::Types;

if (scalar(@ARGV) < 5) {
    printf(STDERR "Usage: %s <database> <username> <password> <zipfile> <site>\n", $0);
    exit(1);
}

my ($database, $username, $password, $zip_file, $site) = @ARGV;
my $schema = OpusVL::CMS::Schema->connect("dbi:Pg:dbname=${database}", $username, $password);

my $site = $schema->resultset('Site')->find({ name => $site });
my $guard = $site->result_source->storage->txn_scope_guard;
die 'Unable to find site' unless $site;

my $zip = Archive::Zip->new();
my $mt = MIME::Types->new();

if($zip->read($zip_file) == AZ_OK)
{
    for my $member ($zip->members())
    {
        my $filename = $member->fileName;
        unless($member->isDirectory || $filename =~ /\.DS_Store/ || $filename =~ /__MACOSX/)
        {
            print "$filename\n";
            $filename =~ s|^release|/unwrap|; # this is very specific to the giftwrap zip we are processing.
            print $filename, "\n";
            my $contents = $member->contents;
            my ($name) = $filename =~ m|/([^/]+)$|;
            my $mime_type = $mt->mimeTypeOf($name)->type;
            #print "$name - $mime_type\n";

            $site->create_related('assets', {
                    filename => $name,
                    mime_type => $mime_type,
                    slug => $name,
                    global => 0,
                    arbitrary_url => $filename,
                    asset_datas => [
                        {
                            data => $contents,
                        }
                    ],
                });
        }
    }
}
$guard->commit;
