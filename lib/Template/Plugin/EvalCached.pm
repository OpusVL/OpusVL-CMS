package Template::Plugin::EvalCached;

use base qw( Template::Plugin );
use Template::Plugin;
use Template::Alloy;

sub load 
{
	my ($class, $context) = @_;
	return $class;       # returns 'MyPlugin'
}

sub new 
{
	my ($class, $context, @params) = @_;

	my $self = bless {
		_CONTEXT => $context,
	}, $class;           # returns blessed MyPlugin object
	$context->define_vmethod( $_ => eval_cached => sub { $self->eval_cached(@_) } ) for qw(hash list scalar);
	return $self;
}

sub eval_cached
{
	my ($self, $template, $site) = @_;

    if ($ENV{TT_EVAL_CACHE_DISABLE}) {
        return $self->{_CONTEXT}->_template->item_method_eval($template);
    } else {
        my $cached = $site->cached_entity($template);
        return $cached if defined $cached;

        my $out = $self->{_CONTEXT}->_template->item_method_eval($template);
        $site->cache_entity($template, $out);
        return $out;
    }
}

1;


# ABSTRACT: a cached eval filter.

=head1 DESCRIPTION

This allows you to run a cached eval on templates. The environment variable TT_EVAL_CACHE_DISABLE disables caching which is useful for development or for the admin previews.

    [% USE EvalCached %]

    [% cms.element('section.header-menu') | eval_cached(me.site) %]

=head1 METHODS

=head2 load

=head2 new

=head2 eval_cached

=cut
