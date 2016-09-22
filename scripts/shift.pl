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

sub get_foreign_key
{
    my $dbh = shift;
    my $table = shift;
    my $constraint = shift;
    my $fk_select = $dbh->prepare(
        q/
SELECT r.conname,
       c.relname,
       d.relname AS frelname,
       r.conkey,
       ARRAY(SELECT column_name::varchar
               FROM information_schema.columns
              WHERE ordinal_position = ANY  (r.conkey)
                AND table_schema = n.nspname
                AND table_name   =   c.relname ) AS fields,
       r.confkey,
       ARRAY(SELECT column_name::varchar
               FROM information_schema.columns
              WHERE ordinal_position = ANY  (r.confkey)
                AND table_schema =   n.nspname
                AND table_name   =   d.relname ) AS reference_fields,
       r.confupdtype,
       r.confdeltype,
       r.confmatchtype

FROM pg_catalog.pg_constraint r

JOIN pg_catalog.pg_class c
  ON c.oid = r.conrelid
 AND r.contype = 'f'

JOIN pg_catalog.pg_class d
  ON d.oid = r.confrelid

JOIN pg_catalog.pg_namespace n
  ON n.oid = c.relnamespace

WHERE pg_catalog.pg_table_is_visible(c.oid)
  AND n.nspname = ?
  AND c.relname = ?
  AND r.conname = ?
ORDER BY 1;
        /) or die "Can't prepare: $@";
	$fk_select->execute('public', $table, $constraint);

    my $fkeys = $fk_select->fetchall_arrayref({});
    my ($row) = @$fkeys;
    return $row;
}

sub rebase_table
{
    my ($storage, $dbh, $name, $rs, $source) = @_;
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
        if($_->$_isa('DBIx::Class::Exception'))
        {
            my ($foreign_table, $constraint, $table) = /update or delete on table "([^"]+)" violates foreign key constraint "([^"]+)" on table "([^"]+)"/i;
            my $constraint_info = get_foreign_key($dbh, $table, $constraint);
            my $field = $constraint_info->{fields};
            my $foreign_field = $constraint_info->{reference_fields};
            my $sql = sprintf("alter table %s drop constraint %s, add constraint %s foreign key (%s) references %s(%s) on update cascade deferrable", $table, $constraint, $constraint, join(', ', @$field), $foreign_table, join(', ', @$foreign_field));
            #print $sql, "\n";
            $dbh->do($sql);
        }
        $retried = 1; # only retry this once.
    }
    retry_if
    {
        return 0 if $retried;
        return 1 if $_->$_isa('DBIx::Class::Exception') && $_ =~ /violates foreign key constraint/i;
    };
}

my $conn = OpusVL::CMS::Schema->connect($connection, $user, $password);
my $storage = $conn->storage;
my @dump_commands;
for my $name ($conn->sources)
{
    my $rs = $conn->resultset($name);
    # skip some of the resultsets.
    my $source = $rs->result_source;
    if(grep { $_ eq 'id' } $source->columns)
    {
        push @dump_commands, "pg_dump --column-inserts -t " . $source->name . " >> db_dump.sql";
        $storage->dbh_do(sub {
            rebase_table(@_);
        }, $source->name, $rs, $source);
    }
}
print "\n", join("\n", @dump_commands), "\n";
# rip through the resultsets
# grab the id field
# shift it
# spot errors
# and update the foreign keys to cascade.

1;
