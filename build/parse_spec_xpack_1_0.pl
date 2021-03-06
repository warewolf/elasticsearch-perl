#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';
use v5.12;
use Path::Class;
use FindBin;

do "$FindBin::RealBin/parse_spec_base.pl" || die $@;

my @files
    = map { file($_) }
    glob
    '../x-plugins/watcher/rest-api-spec/api/watcher*';

process_files( 'lib/Search/Elasticsearch/Plugin/XPack/1_0/Role/API.pm', @files );
