#!/bin/sh
perl ../OpusVL-FB11/bin/fb11-dbh -f -c 'dbi:SQLite:test.db' OpusVL::CMS::Schema prepare
