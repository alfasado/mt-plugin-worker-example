package WorkerExample::Callbacks;

use strict;
use MT::TheSchwartz;
use TheSchwartz::Job;

sub _post_save_entry {
    my ( $cb, $app, $obj, $original ) = @_;
    return 1 unless $obj->status == MT::Entry::RELEASE();
    my $job = TheSchwartz::Job->new();
    $job->funcname( 'WorkerExample::Worker::MultiPost' );
    my $uniqkey = $obj->id;
    $job->uniqkey( $uniqkey );
    my $priority = 5;
    $job->priority( $priority );
    $job->coalesce( ( $obj->blog_id || 0 ) . ':' 
            . $$ . ':'
            . $priority . ':'
            . ( time - ( time % 10 ) ) );
    MT::TheSchwartz->insert( $job );
    return 1;
}

1;