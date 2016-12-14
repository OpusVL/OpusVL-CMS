package OpusVL::CMS::Schema::RolesFor::Result::AttributeDetail;

use Moose::Role;
use List::UtilsBy qw/sort_by/;
=head1 NAME

OpusVL::CMS::Schema::RolesFor::Result::AttributeDetail - Create AttributeDetail result classes

=head1 DESCRIPTION

The CMS attaches attributes to pages, assets, and attributes. These are defined
in AttributeDetail result classes. They all have - and require - identical
structures, so this Role abstracts those structures out.

Note that you B<must> call C<add_columns>, even with no parameters, and
C<set_primary_key> and C<table> with the usual parameters. Remember to call
C<table> before either of the other two.

=head1 SYNOPSIS

    package MyApp::Schema::ArbitraryAttributeDetail
    use Moose;
    use MooseX::NonMoose;
    extends 'DBIx::Class::Core';
    with 'OpusVL::CMS::Schema::RolesFor::Result::AttributeDetail';

    __PACKAGE__->table('arbitrary_attribute_details');
    __PACKAGE__->add_columns;
    __PACKAGE__->set_primary_key('id');

=head1 COLUMNS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'asset_attribute_details_id_seq'

=head2 code

  data_type: 'text'
  is_nullable: 0
  original: {data_type => "varchar"}

=head2 name

  data_type: 'text'
  is_nullable: 0
  original: {data_type => "varchar"}

=head2 type

  data_type: 'text'
  is_nullable: 0
  original: {data_type => "varchar"}

=head2 active

  data_type: 'boolean'
  default_value: true
  is_nullable: 0

=head2 site_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

around add_columns => sub {
    my $orig = shift;
    my $package = shift;

    $package->$orig(@_,
        id => {
            data_type         => "integer",
            is_auto_increment => 1,
            is_nullable       => 0,
            sequence          => $package->table . "_id_seq",
        },
        code =>
        {
            data_type   => "text",
            is_nullable => 0,
            original    => { data_type => "varchar" },
        },
        name =>
        {
            data_type   => "text",
            is_nullable => 0,
            original    => { data_type => "varchar" },
        },
        type =>
        {
            data_type   => "text",
            is_nullable => 0,
            original    => { data_type => "varchar" },
        },
        active =>
        { 
            data_type => "boolean",
            default_value => \"true",
            is_nullable => 0
        },
        site_id =>
        { 
            data_type => "integer", 
            is_foreign_key => 1,
            is_nullable => 1
        },
    );
};

=head1 RELATIONS

=head2 values

Creates a has_many relationship on the corresponding AttributeData result type,
assuming the current package name is AttributeDetails.  See
L<OpusVL::CMS::Schema::RolesFor::Result::AttributeData>.

This will be all values assigned to this field across all sites, and should
probably be filtered by the site in question.

=head2 field_values

Creates a has_many relationship to the corresponding AttributeValues result
type, being the options for this field when this field is of type C<select>.

Note that the values themselves are also keyed by site, and this returns a
ResultSet of I<all> values for this field. See
L<OpusVL::CMS::Schema::RolesFor::ResultSet::AttributeValue/for_site> to get a
union of the current site's options and the profile's.

=head2 site

Creates a belongs_to relationship between this attribute and a site. Attributes
are now actually exclusively defined on profiles, but historical data may cause
them still to be defined on non-profile sites.

See L<OpusVL::CMS::Schema::Result::Site>.

=cut

after set_primary_key => sub {
    my $package = shift;
    $package->has_many(
        values => $package =~ s/Details$/Data/r,
        "field_id",
        { cascade_copy => 1, cascade_delete => 0 },
    );

    $package->has_many(
        field_values => $package =~ s/Details$/Values/r,
        "field_id",
        { cascade_copy => 0, cascade_delete => 0 },
    );

    $package->belongs_to(
        site => "OpusVL::CMS::Schema::Result::Site",
        "site_id",
    );
);

=head1 METHODS

=head2 form_options

=over

=item $site

Since fields are always defined against profiles, but sites can augment the set
of values, you must pass in the site whose values you want. This will default to
that profile.

=back

Returns an arrayref of arrayrefs for HTML::FormFu usage, for when the field's
type is C<select>

=cut

sub form_options
{
    my $self = shift;
    my $site = shift // $self->site;
    my @all = sort_by { $_->[0] } map { [ $_->value, $_->value ] } $self->field_values->for_site($site);
    return \@all;
}

=head2 valid_option

=over

=item $value

The value to check

=item $site

Since fields are always defined against profiles, but sites can augment the set
of values, you must pass in the site whose values you want. This will default to
that profile.

=back

Returns a true value if the input value exists in the provided site's set of
options for this C<select> field. If it's not a C<select> field, this is false,
because no options are defined.

=cut

sub valid_option
{
    my $self = shift;
    my $value = shift;
    my $site = shift // $self->site;
    return $self->field_values->for_site($site)->find({ value => $value });
}

