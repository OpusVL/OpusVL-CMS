use strict;
use warnings;

sub {
    my $schema = shift;

    for my $field ($schema->resultset('FormsField')->all) {
        $field->update({ name => $field->generated_name });
    }
};
