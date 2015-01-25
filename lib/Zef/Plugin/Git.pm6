use Zef::Phase::Getting;

role Zef::Plugin::Git does Zef::Phase::Getting {
    has %.options;
    has @.flags = <--quiet>;


    multi method get(:$save-to = $*TMPDIR, *@urls) {
        my @fetched;
        my @failed;

        for @urls -> $url {
            KEEP @fetched.push($url);
            UNDO @failed.push($url);

            my $cmd = "git clone " ~ @.flags.join(' ') ~ " $url {$save-to.IO.path}";
            my $git_result = shell($cmd).exit;
            given $git_result {
                when 128 {
                    # directory already exists and is not empty
                    say "Folder exists: updating via pull";
                    $git_result = shell("(cd {$save-to.IO.path} && git pull {@.flags.join(' ')})").exit;
                }
            }

            $git_result == 0 ?? True !! False;
        }

        return %(@fetched.map({ $_ => True }), @failed.map({ $_ => False }));
    }
}

