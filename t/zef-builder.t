use v6;
use Zef::Builder;
plan 2;
use Test;


# Basic tests on default builder method
subtest { {
    my $builder = Zef::Builder.new;
    my @results = $builder.pre-compile($*CWD);
    
    ok all(@results.map(-> %h { %h<precomp>:exists })), 'Zef::Builder default pre-compile works';

    LEAVE { 
        Zef::Utils::FileSystem.rm( "{$*CWD}/blib".IO.path, :d, :f, :r );
    }
} }, 'Zef::Builder';


# Basic tests on Plugin::PreComp
subtest { {
    lives_ok { use Zef::Plugin::PreComp; }, 'Zef::Plugin::PreComp `use`-able to test with';
    my $builder = Zef::Builder.new( :plugins(["Zef::Plugin::PreComp"]) );
    my @precompiled = $builder.pre-compile($*CWD);
    @precompiled.join("\n").say;
    # TODO: actually check for all files being precompiled
    is any(@precompiled), "$*CWD/blib/lib/Zef.pm6.{$*VM.precomp-ext}", 'Zef::Builder default pre-compile works';

    LEAVE { 
        Zef::Utils::FileSystem.rm( "{$*CWD}/blib".IO.path, :d, :f, :r );
    }
} }, 'Plugin::Precomp';


done();
