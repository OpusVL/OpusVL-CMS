#!/bin/sh

if [ $# -lt 1 ] 
then
	echo Usage $0 dsn [user] [password]
    echo
    echo For SQLite use something like dbi:SQLite:cms.db
    echo For Postgres use dbi:Pg:dbname=cms
    echo
    echo Remember to quote your dsn if you have semicolons in it,
    echo
    echo '   scripts/deploy.sh "dbi:Pg:dbname=cms;hostname=10.0.3.48;port=5433" user password'
	exit 1
fi
EXTRA=
if [ $# -gt 1 ]
then
    USER=$2
    PASSWORD=$3
    EXTRA=", '$USER', '$PASSWORD'"
fi
perl -I lib -MOpusVL::CMS::Schema -e "OpusVL::CMS::Schema->connect('$1'$EXTRA)->deploy_with_data"
