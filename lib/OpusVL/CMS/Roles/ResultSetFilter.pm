package OpusVL::CMS::Roles::ResultSetFilter;

use MooseX::Role::Parameterized;

our $VERSION = '62';

parameter field => (
    isa => 'Str',
    required => 1,
);

role {
    my $p = shift;
    my $field = $p->field;

    method "filter_by_$field" => sub
    {
        my $self = shift;
        # filter out duplicate codes.
        my %filtered;
        for my $a ($self->all)
        {
            unless($filtered{$a->$field})
            {
                $filtered{$a->$field} = $a;
            }
        }
        return sort { $a->$field cmp $b->$field } values %filtered;
    }
};

1;
