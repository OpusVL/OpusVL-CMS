package OpusVL::FB11X::CMSView::View::CMS;
use URL::Encode;

use Moose;

extends 'Catalyst::View::TT::Alloy';

__PACKAGE__->config({
  ENCODING => 'utf-8',
  AUTO_FILTER => 'html',
  FILTERS => {
    uri_utf8 => \&URL::Encode::url_encode_utf8,
  }
});

1;
