package JBD::Core::PerlWalk;
# ABSTRACT: wrapper for File::DirWalk
our $VERSION = '0.01'; # VERSION

#/ Wrapper for File::DirWalk.
#/ @author Joel Dalley
#/ @version 2013/Oct/27

use JBD::Core::stern;
use JBD::Core::Exporter;
use File::DirWalk;

our @EXPORT_OK = qw(on_file);

#/ @param coderef $callback    called on each perl file
#/ @param array    zero or more file paths
sub on_file(&@) {
    my $callback = shift;

    #/ callback is wrapped so it always skips non-perl
    #/ files, and always returns File::DirWalk::SUCCESS 
    my $wrapper = sub {
        my $file = shift;
        $callback->($file) if $file =~ /\.(pl|pm6?|p6)$/o;
        File::DirWalk::SUCCESS;
    };

    my $walker = File::DirWalk->new;
    $walker->onFile($wrapper);
    $walker->walk($_) for @_;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

JBD::Core::PerlWalk - wrapper for File::DirWalk

=head1 VERSION

version 0.01

=head1 AUTHOR

Joel Dalley <joeldalley@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Joel Dalley.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
