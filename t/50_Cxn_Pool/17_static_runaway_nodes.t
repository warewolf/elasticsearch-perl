use Test::More;
use Test::Exception;
use Elasticsearch;
use lib 't/lib';
use Elasticsearch::MockCxn qw(mock_static_client);

## Runaway nodes (ie wrong HTTP response codes signal node failure, instead of
## request failure)

my $t = mock_static_client(
    { nodes => 'one' },

    { node => 1, ping => 1 },
    { node => 1, code => 200, content => 1 },
    { node => 1, code => 503, error => 'Unavailable' },
    { node => 1, ping => 1 },
    { node => 1, code => 503, error => 'Unavailable' },

    # throw Internal: too many retries

    { node => 1, ping => 1 },
    { node => 1, code => 503, error => 'Unavailable' },
    { node => 1, ping => 1 },
    { node => 1, code => 503, error => 'Unavailable' },

    # throw Internal: too many retries

);

ok $t->perform_request
    && !eval { $t->perform_request }
    && $@ =~ /Retried request/
    && !eval { $t->perform_request }
    && $@ =~ /Retried request/,
    "Runaway nodes";

done_testing;
