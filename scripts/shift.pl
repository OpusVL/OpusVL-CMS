use strict;
use warnings;
package ID::Shift;

use OpusVL::CMS::Schema;
use Getopt::Long;
use Try::Tiny::Retry;
use Safe::Isa;

my ($connection, $user, $password);
GetOptions(
    "dbic=s" => \$connection,
    "user=s" => \$user,
    "pass=s" => \$password) or die "I don't like your command line arguments";

die 'Must specify connection string' unless $connection;

my $conn = OpusVL::CMS::Schema->connect($connection, $user, $password);
my $storage = $conn->storage;
for my $name ($conn->sources)
{
    my $rs = $conn->resultset($name);
    # skip some of the resultsets.
    my $source = $rs->result_source;
    if(grep { $_ eq 'id' } $source->columns)
    {
        print "pg_dump --column-inserts -t " . $source->name . " >> db_dump.sql\n";
        $storage->dbh_do(sub {
            my ($storage, $dbh, $name) = @_;
            # FIXME: figure out the sequence name for the id field.
            # FIXME: should find current max (in other db?) to rebase there.
            my $sequence = sprintf("%s_id_seq", $name);
            my $retried = 0;
            retry
            {
                $dbh->do(sprintf("alter sequence %s restart with 10000", $sequence));
                my $update = sprintf("nextval('%s')", $sequence);
                $rs->update({ id => \$update });
                # perhaps save this for later.
                printf("alter sequence %s restart with select max(id) from %s;\n", $sequence, $source->name);
            }
            on_retry
            {
                $DB::single = 1;
                # FIXME: try to fix the cascade.
                if($_->$_isa('DBIx::Class::Exception'))
                {
                    my ($foreign_table, $constraint, $table) = /update or delete on table "([^"]+)" violates foreign key constraint "([^"]+)" on table "([^"]+)"/i;
                    my $foreign_field = 'FIXME';
                    my $field = 'FIXME';
                    my $sql = sprintf("alter table %s drop constraint %s, add constraint %s foreign key (%s) references %s(%s) on update cascade deferrable", $table, $constraint, $constraint, $field, $foreign_table, $foreign_field);
                    print $sql, "\n";
                    # FIXME: need field, foreign_field, foreign_table
                    # now we need the full index info
                    # then we can recreate it with cascade.
                }
                $retried = 1; # only retry this once.
            }
            retry_if
            {
                return 0 if $retried;
                return 1 if $_->$_isa('DBIx::Class::Exception') && $_ =~ /violates foreign key constraint/i;
            };
            # FIXME: rebase the sequence above the new max id.
        }, $source->name);
        # lets try to shift the ids
    }
}
# rip through the resultsets
# grab the id field
# shift it
# spot errors
# and update the foreign keys to cascade.

1;
