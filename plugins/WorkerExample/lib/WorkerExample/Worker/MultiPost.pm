package WorkerExample::Worker::MultiPost;

use strict;
use base qw( TheSchwartz::Worker );

use TheSchwartz::Job;

sub keep_exit_status_for { 1 }
sub grab_for { 60 }
sub max_retries { 10 }
sub retry_delay { 60 }

sub work {
    my $class = shift;
    my TheSchwartz::Job $job = shift;
    my @jobs;
    push @jobs, $job;
    if ( my $key = $job->coalesce ) {
        while (
            my $job
            = MT::TheSchwartz->instance->find_job_with_coalescing_value(
                $class, $key
            )
            )
        {
            push @jobs, $job;
        }
    }
    foreach $job ( @jobs ) {
        if ( my $entry = MT->model( 'entry' )->load( $job->uniqkey ) ) {
            # do something(Post entry to foo)
        }
    }
    return $job->completed();
}

1;