package OpusVL::FB11X::CMSView::Roles::CMSStash;

use Moose::Role;
use Scalar::Util qw/looks_like_number/;
use Try::Tiny;
use Template::Stash;
use experimental 'switch';
use 5.014;

sub setup_cms_stash
{
    my $self = shift;
    my $c = shift;
    my $site = shift;
    my $args = shift;

    $args //= {};
    my $host = $args->{host};
    my $preview = $args->{preview};

    $c->stash->{cms} = {
        img   => sub {
            my ($type, $slug, $align, $alt) = @_;
            if ($type and $slug) {
                $align = $align ? $align : 'center';
                my $img;
                for($type) {
                    if (/asset/) {
                        if (my $asset = $site->all_assets->published->find({ slug => $slug })) {
                            if($preview)
                            {
                                $img = $c->uri_for($self->action_for('_asset'), $site->id, $slug, $asset->filename);
                            } else {
                                $img = $c->uri_for($self->action_for('_asset'), $slug, $asset->filename);
                            }
                        }
                    } elsif (/attachment/) {
                        if (my $att = $site->all_attachments->search({ slug => $slug })->first) {
                            if($preview)
                            {
                                $img = $c->uri_for($self->action_for('_attachment'), $site->id, $att->slug, $att->filename);
                            }
                            else
                            {
                                $img = $c->uri_for($self->action_for('_attachment'), $att->slug, $att->filename);
                            }
                        }
                    }
                }
                
                if ($img) {
                    $alt //= "";
                    return qq{<div style="text-align:$align"><img src="$img" alt="${alt}"></div>};
                }
            }
        },

        asset_url => sub {
            my $asset = shift;
            if($preview) {
                return $c->uri_for($self->action_for('_asset'), $site->id, $asset->slug, $asset->filename);
            } else {
                return $c->uri_for($self->action_for('_asset'), $asset->slug, $asset->filename);
            }
        },
        asset => sub {
            my $id = shift;
            if ($id eq 'logo') {
                # FIXME: these really should just be published rather than available,
                # that's re-joining shit again.
                if (my $logo = $site->all_assets->published->search({ description => 'Logo' }, {rows => 1})->first) {
                    if($preview) {
                        return $c->uri_for($self->action_for('_asset'), $site->id, $logo->slug, $logo->filename);
                    } else {
                        return $c->uri_for($self->action_for('_asset'), $logo->slug, $logo->filename);
                    }
                }
            }

            elsif ($id eq 'icon') {
                if (my $icon = $site->all_assets->published->search({ description => 'Icon' }, {rows => 1})->first) {
                    if($preview) {
                        return $c->uri_for($self->action_for('_asset'), $site->id, $icon->id, $icon->filename);
                    } else {
                        return $c->uri_for($self->action_for('_asset'), $icon->id, $icon->filename);
                    }
                }
            }
            else {
                if (my $asset = $site->all_assets->published->search({slug => $id}, {rows => 1})->first) {
                    if($preview) {
                        return $c->uri_for($self->action_for('_asset'), $site->id, $id, $asset->filename);
                    } else {
                        return $c->uri_for($self->action_for('_asset'), $id, $asset->filename);
                    }
                }
            }
        },
        attachment => sub {
            if (my $attachment = $site->all_attachments->search({slug => shift})->first) {
                if($preview) {
                    return $c->uri_for($self->action_for('_attachment'), $site->id, $attachment->slug, $attachment->filename);
                } else {
                    return $c->uri_for($self->action_for('_attachment'), $attachment->slug, $attachment->filename);
                }
            }
        },
        element => sub {
            my ($id, $attrs) = @_;
            if ($attrs) {
                foreach my $attr (%$attrs) {
                    $c->stash->{me}->{$attr} = $attrs->{$attr};
                }
            }
            if (my $element = $site->all_elements->find({slug => $id})) {
                warn $element->name if $ENV{TRACE_ELEMENTS};
                return "\n<!-- " . $element->name . " -->\n" . $element->content . "\n<!-- /" . $element->name . " -->\n";
            }
        },
        site_attr => sub {
            my $code = shift;
            return $site->attribute($code);
        },
        page_by_slug => sub {
            my $pages = $site->pages->published;
            my $me = $pages->current_source_alias;
            return $pages->search({url => shift}, { rows => 1 })->first;
        },
        page => sub {
            my $pages = $site->pages->published;
            my $me = $pages->current_source_alias;
            return $pages->search({"$me.id" => shift}, { rows => 1 })->first;
        },
        pages => sub {
            return $site->pages->published->attribute_search($site, @_);
        },
        attachments => sub {
            return $site->all_attachments->attribute_search($site, @_);
        },
        param => sub {
            return $c->req->param(shift);
        },
        toplevel => sub {
            return $site->pages->published->toplevel;
        },
        thumbnail => sub {
            if($preview) {
                return $c->uri_for($self->action_for('_thumbnail'), $site->id, @_);
            } else {
                return $c->uri_for($self->action_for('_thumbnail'), @_);
            }
        },
        form      => sub {
            my $name = shift;
            if (looks_like_number($name)) {
                return $c->model('CMS::Form')->find($name);
            }

            return $site->form($name);
        },
        site      => sub {
            my $opt = shift;
            given($opt) {
                when ('subdomain') {
                    my ($subdomain, $host, $tld) = split /\./, $host;
                    return $subdomain if $tld;
                }
            }
        },
        hex2rgba => sub {
            my $hex = shift;
            $hex =~ s/#//;

            # Jesus christ... alpha is the only one that's normalised in the
            # rgba CSS function. Therefore, we only accept RGB or RGBA hex, or
            # it gets confusing.
            my @colour = $hex =~ /(..)/g;

            $_ = hex $_ for @colour;

            if (@colour == 4) {
                $colour[3] /= 255;
            }

            return join ',', @colour;
        },
        multiply_units => sub {
            my $scalar = shift;
            my $factor = shift;
            $scalar =~ s/(\d+)/$1 * $factor/re;
        },
    };
}

sub __asset
{
    my ($self, $c, $site, $asset_id, $filename) = @_;
    if ($filename) {
        my $assets = $site->all_assets->published;
        my $me = $assets->current_source_alias;
        if ($asset_id eq 'use') {
            if (my $asset = $assets->search({ "$me.slug" => $filename }, { rows => 1 })->first) {
                $asset_id = $asset->id;
            }
            else {
                $c->res->status(404);
                $c->res->body("Not found");
                $c->detach;
            }
        }

        if (my $asset = $assets->search({ "$me.slug" => $asset_id }, { rows => 1 })->first) {
            $c->encoding(undef);
            $c->response->content_type($asset->mime_type);
            $c->response->body($asset->content);
            $c->detach;
        }
        elsif (looks_like_number($asset_id) && ($asset = $assets->search({"$me.id" => $asset_id})->first)) {
            $c->encoding(undef);
            $c->response->content_type($asset->mime_type);
            $c->response->body($asset->content);
            $c->detach;
        } else {
            $c->response->status(404);
            $c->response->body("Not found");
        }
    }
}

sub __attachment
{
    my ($self, $c, $site, $attachment_id, $filename) = @_;
    my $attachments = $site->all_attachments;
    my $me = $attachments->current_source_alias;

    if (my $attachment = $attachments->search({ "$me.slug" => $attachment_id }, { rows => 1 })->first) {
        $c->encoding(undef);
        $c->res->content_type($attachment->mime_type);
        $c->res->body($attachment->content);
        $c->detach;
    } 
    elsif ($attachment_id =~ /^\d+$/ && ($attachment = $attachments->search({"$me.id" => $attachment_id})->first)) {
        $c->encoding(undef);
        $c->response->content_type($attachment->mime_type);
        $c->response->body($attachment->content);
        $c->detach;
    } else {
        $c->response->status(404);
        $c->response->body("Not found");
    }
}

sub __thumbnail
{
    my ($self, $c, $site, $type, $id) = @_;
    given ($type) {
        when ('asset') {
            my $assets = $site->all_assets->published;
            my $me = $assets->current_source_alias;
            if (my $asset = $assets->find({"$me.id" => $id})) {
                $c->stash->{image} = $asset->content;
            }
        }
        when ('attachment') {
            my $attachments = $site->all_attachments;
            my $me = $attachments->current_source_alias;
            if (my $attachment = $attachments->find({"$me.id" => $id})) {
                $c->stash->{image} = $attachment->content;
            }
        }
    }
    
    if ($c->stash->{image}) {
        $c->stash->{x}       = $c->req->param('x') || undef;
        $c->stash->{y}       = $c->req->param('y') || undef;
        $c->stash->{zoom}    = $c->req->param('zoom') || 100;
        $c->stash->{scaling} = $c->req->param('scaling') || 'fill';
        
        unless ($c->stash->{x} || $c->stash->{y}) {
            $c->stash->{y} = 50;
        }
        
        $c->forward($c->view('CMS::Thumbnail'));
    } else {
        $c->response->status(404);
        $c->response->body("Not found");
    }
}

1;

=head1 NAME

OpusVL::FB11X::CMSView::Roles::CMSStash

=head1 DESCRIPTION

=head1 METHODS

=head2 setup_cms_stash

=head1 ATTRIBUTES


=cut
