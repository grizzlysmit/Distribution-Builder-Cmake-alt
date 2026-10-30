use v6.d;
use File::Directory::Tree;
unit class Distribution::Builder::Cmake-alt:ver<1.0.3>:auth<Francis Grizzly Smit (grizzly@smit.id.au)>;

=begin pod

=head1 Distribution::Builder::Cmake-alt

=begin head2

Table of Contents

=end head2

=item1 L<NAME|#name>
=item1 L<AUTHOR|#author>
=item1 L<VERSION|#version>
=item1 L<TITLE|#title>
=item1 L<SUBTITLE|#subtitle>
=item1 L<COPYRIGHT|#copyright>
=item1 L<Introduction|#introduction>

=NAME Gzz::Readline 
=AUTHOR Francis Grizzly Smit (grizzly@smit.id.au)
=VERSION 1.0.3
=TITLE Gzz::Readline
=SUBTITLE A Raku module for building CMake projects to make .so files and installing them in into a chosen install directory.

=COPYRIGHT This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0 L<LICENSE|https://github.com/grizzlysmit/Distribution-Builder-Cmake-alt/blob/main/LICENSE>


L<Top of Document|#table-of-contents>

=head2 Introduction

A B«Raku» module for building B«CMake» projects to make B«.so» files and installing them in into a chosen install directory.
Based on L<Distribution::Builder::Cmake|https://raku.land/zef:rawleyfowler/Distribution::Builder::Cmake> by B«Rawley Fowler» I have kept to the same licencing 

=head2 Installation

=begin code :lang<bash>

zef install Distribution::Builder::Cmake

=end code

=head2 Usage

Assuming your Raku project keeps its CMake project in a folder called C«my-cmake-project», and your exported lib is C«my-lib». 
Note, the final C«.so» file will be C«lib{$my-lib}.so».
In your C«META6.json» you'll add the following:

=begin code :lang<json>

{ 
    ...
    "depends": [
        "Distribution::Builder::Cmake-alt"
    ], 
    "builder": "Distribution::Builder::Cmake-alt",
    "build": {
        "lib": "my-lib",
        "src-dir": "my-cmake-project",
        "install": "/usr/local/lib",
        "install-local": "$*HOME/lib",
        "master-lib-version": "0.0.1",
        "lib-versions": {
            "0": "0.0.1",
            "": "0"
        },
            "source":   "src",
            "log":      "path",
            "debug":    false
    }
    ...
}


=end code

Where 
=item1 C«lib» is the name of your lib and is mandatory.
=item1 C«src-dir» is the location of your library and is mandatory it should be relative to the working directory or it can be an empty string or a "."
=item1 C«install» is optional and specifies the location to install the libraries (lib{$lib}.so files) it should be an absolute path otherwise the install would achieve nothing (defaults to C«/usr/local/lib»). B«NB» this field supports expandable patterns C«~/»,  C«$*HOME/», C«$HOME/», C«{$*HOME}/» and C«{$HOME}/» all expand to the user home directory followed by a C«/» and C«~username» will expand to usernames dome dir.
=item1 C«install-local» is optional and specifies the location to install the libraries if installing locally (lib{$lib}.so files) it should be a path inside the users users directory tree, otherwise the install would achieve nothing (defaults to C«$HOME/lib»). B«NB» this field supports expandable patterns C«~/»,  C«$*HOME/», C«$HOME/», C«{$*HOME}/» and C«{$HOME}/» all expand to the user home directory followed by a C«/» and C«~username» will expand to usernames dome dir.
=item1 C«master-lib-version» specifies the version number to put on the .so file (i.e. lib{$lib}.so.{$master-lib-version}) but you can leave it as an empty sting.
=item1 C«lib-versions» a collection of mappings to specify a list of symbolic links to the library. The example above would produce 
=begin item2
=begin code :lang<bash>
$ exa -F -laahigHb --color-scale --time-style=full-iso --icons=always /usr/local/lib/
   inode Permissions Links Size User Group Date Modified                       Name
15614859 drwxr-xr-x      3    - root root  2026-10-28 17:39:53.989170059 +1100  ./
15466504 drwxr-xr-x     11    - root root  2026-04-23 12:15:04.000000000 +1100  ../
15604140 lrwxrwxrwx      1    - root root  2026-10-28 17:39:53.989170059 +1100  libmy-lib.so -> libmy-lib.so.0*
15604139 lrwxrwxrwx      1    - root root  2026-10-28 17:39:53.989170059 +1100  libmy-lib.so.0 -> libmy-lib.so.0.0.1*
15604115 .rwxr-xr-x      1 22Ki root root  2026-10-28 17:39:53.924168331 +1100  libmy-lib.so.0.0.1*

=end code
=end item2
=item1 C«source» specifies the name of the source dir relative to the C«src-dir» can be C«""» to specify that the source is in C«src-dir» itself.
=item1 C«log» the place to spit logging info to defaults to C«/dev/null» optional use  C«/dev/tty» to send debug data into the terminal that called C«zef» or a file name, like Install and install-local this supports C«~/»,  C«$*HOME/», C«$HOME/», C«{$*HOME}/» and C«{$HOME}/» resolution.
=item1 C«debug» if C«true» then spit as much details into the log C«$log» can be C«/dev/null» to throw away the results or C«/dev/tty» to write to the terminal, or a file.

B«Note:» You may also provide a C«install» field to specify the directory to install the library. This defaults to: C«resources/libraries/lib<your-lib>.so»

The typical CMake project will look like (assuming your lib is `my-lib`):

=begin code :lang<cmake>

cmake_minimum_required(VERSION 3.11)
project(my-lib VERSION 0.0.1 DESCRIPTION "My lib!")
add_library(my-lib SHARED my-lib.cc)
set_target_properties(my-lib PROPERTIES VERSION ${PROJECT_VERSION})
set_target_properties(my-lib PROPERTIES SOVERSION 0)
set_target_properties(my-lib PROPERTIES PUBLIC_HEADER my-lib.hh)
target_include_directories(${PROJECT_NAME} PRIVATE source)
target_include_directories(my-lib PRIVATE .)
install(TARGETS my-lib
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
	PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

=end code

You can see an example of this in action in [this repo](https://github.com/grizzlysmit/gzzReadline.git)

(Obviously, you'll need Make and CMake installed)

=end pod

my $home = $*HOME;


has %.meta;


method die-handle(IO::Handle:D $handle is copy, Str:D $msg --> Bool) {
    with %!meta«build»«log» {
        if %!meta«build»«log» ~~ rx/ ^^ '/dev/null' $$ / {
            $handle = "/dev/tty".IO.open: :append, :mode<rw>, :out-buffer(False);
        }
    }
    $handle.say: $msg;
    X::AdHoc.from-slurpy(10, False, $msg).throw;
}

method subst-man-number(Str:D $man-param, $man-number --> Str:D ) {
    my Str:D $result = $man-param;
    $result ~~ s:g/ '{' \h*'$man-number' \h* '}' /$man-number/;
    $result ~~ s:g/ '$man-number' <?wb> /$man-number/;
    return $result;
}

multi method resolve-dir(Any $dir, IO::Handle $handle, Bool $relitive-to-home = True --> False){
    self.die-handle($handle, "bad value");
}

multi method resolve-dir(Str:D $dir, IO::Handle $handle, Bool $relitive-to-home = True --> Str) is export {
    self.die-handle($handle, "bad value") without $dir;
    my Str $Dir = ~$dir;
    #$Dir.say;
    $Dir = $home if $Dir eq '~';
    $Dir = $home if $Dir eq '$*HOME';
    $Dir = $home if $Dir eq '{$*HOME}';
    $Dir = $home if $Dir eq '$HOME';
    $Dir = $home if $Dir eq '{$HOME}';
    $Dir ~~ s! ^^ '~' \/ !$home\/!;
    $Dir ~~ s! ^^ '$HOME' \/ !$home\/!;
    $Dir ~~ s! ^^ '{$HOME}' \/ !$home\/!;
    $Dir ~~ s! ^^ '$*HOME' \/ !$home\/!;
    $Dir ~~ s! ^^ '{$*HOME}' \/ !$home\/!;
    if $Dir ~~ rx! ^^ $<start> = [ '~' <-[ \/ ]> +  ] \/ ! {
        my Str $start = ~$<start>;
        given $start {
            when '~root' { $Dir ~~ s! ^^ '~' !\/!; }
            default {
                my Str @candidates = dir('/home', test => { "/home/$_".IO.d && $_ ne '.' && $_ ne '..' }).map: { $_.Str };
                my Str $start_d = $start.substr(1);
                my Str $candidate = @candidates.grep: { rx/ \/ $start_d $$ / };
                if $candidate {
                    $Dir ~~ s! ^^ $start \/ !$candidate\/!;
                } else {
                    "cannot resolve $start".say;
                    return $dir;
                }
            }
        }
    }
    $Dir = "$home/$Dir" if $relitive-to-home && $Dir !~~ rx! ^^ \/ !;
    #$Dir.say;
    return $Dir;
} # multi method resolve-dir(Str:D $dir, Bool $relitive-to-home = True --> Str) is export #


method build(IO() $work-dir = $*CWD) {
    my Bool:D $debug = False;
    with %!meta«build»«debug» {
        $debug = %!meta«build»«debug».Bool;
    }
    my IO::Path:D $log = "/dev/null".IO;
    with %!meta«build»«log» {
        my Str:D $tmp = %!meta«build»«log»;
        if $tmp eq '/dev/tty' {
            $log = $tmp.IO;
        } else {
            my IO::Handle:D $handle-tmp = "/dev/tty".IO.open: :append, :mode<rw>, :out-buffer(False);
            $log = self.resolve-dir($tmp, $handle-tmp).IO;
        }
    }
    $log.dirname.IO.mkdir if $debug && $log.path !~~ rx@ ^^ '/dev/' .* $$ @;
    #my $log = "/dev/tty".IO;
    #my IO::Handle:D $handle = $log.open: :append, :create, :mode<rw>;
    my Bool:D $create = $log !~~ rx@ ^^ '/dev/' .* $$ @;
    my IO::Handle:D $handle = $log.open: :append, :$create, :mode<rw>, :out-buffer(False);
    $*OUT = $handle;
    $*ERR = $handle;
    $handle.say: '%!meta = ', %!meta.raku if $debug;
    my %meta = %!meta<build>;
    $handle.say: '%meta = ', %meta.raku if $debug;
    self.die-handle($handle, 'You need CMake to install this package!') unless shell 'which cmake';
    self.die-handle($handle, 'You need Make to install this package!') unless shell 'which make';

    my Proc $r;
    $r = run 'exa', '-F', '-laahigHb', '--color-scale', '--time-style=full-iso', '--icons=always', '.', :out($handle), :err($handle) if $debug;
    $r = run 'pwd', :out($handle), :err($handle) if $debug;

    # Prepare to build
    my $src-dir;
    my $cmake-src-dir;
    with %meta«src-dir» {
        $src-dir = %meta«src-dir»;
        if $src-dir eq '.' || $src-dir eq '' {
            $cmake-src-dir = '';
        } else {
            $cmake-src-dir = "$src-dir";
        }
    } else {
        $src-dir       = '';
        $cmake-src-dir = "";
    }
    $handle.say: '$cmake-src-dir = ', $cmake-src-dir.raku if $debug;
    if $cmake-src-dir eq '.' || $cmake-src-dir eq '' {
        $r = run 'exa', '-F', '-laahigHb', '--color-scale', '--time-style=full-iso', '--icons=always', '.', :out($handle), :err($handle) if $debug;
    } else {
        $r = run 'exa', '-F', '-laahigHb', '--color-scale', '--time-style=full-iso', '--icons=always', $cmake-src-dir, :out($handle), :err($handle) if $debug;
    }
    #self.die-handle($handle, "$cmake-src-dir is not a directory.") unless $cmake-src-dir eq '' || $cmake-src-dir eq '.' || ($cmake-src-dir.IO.e && $cmake-src-dir.IO.d);

    # Build
    my $build-dir;
    if $cmake-src-dir eq '' || $cmake-src-dir eq '.' {
        $build-dir = 'build';
    }else {
        $build-dir = "$cmake-src-dir/build";
        chdir($cmake-src-dir.IO);
    }
    my Str:D $source = '';
    with %meta«source» {
        $source = %meta«source» // '';
    }
    # start with a clean empty build directory #
    if "build".IO ~~ :d {
        rmtree("build".IO);
    } else {
        "build".IO.unlink();
    }
    "build".IO.mkdir;
    $r = run 'pwd', :out($handle), :err($handle) if $debug;
    $handle.say: '$build-dir = ', $build-dir.raku if $debug;
    chdir("build".IO);
    $r = run 'pwd', :out($handle), :err($handle) if $debug;
    $r = run 'exa', '-F', '-laahigHb', '--color-scale', '--time-style=full-iso', '--icons=always', '..', :out($handle), :err($handle) if $debug;
    $r = run 'exa', '-F', '-laahigHb', '--color-scale', '--time-style=full-iso', '--icons=always', "../$source", :out($handle), :err($handle) if $debug;
    $handle.say: "cmake .." if $debug;
    $r = run 'cmake', '..', :out($handle), :err($handle);
    $r = run 'exa', '-F', '-laahigHb', '--color-scale', '--time-style=full-iso', '--icons=always', '.', :out($handle), :err($handle) if $debug;
    $handle.say: "make" if $debug;
    $r = run 'make', :out($handle), :err($handle);
    $r = run 'exa', '-F', '-laahigHb', '--color-scale', '--time-style=full-iso', '--icons=always', '.', :out($handle), :err($handle) if $debug;
    $r = run 'pwd', :out($handle), :err($handle) if $debug;
    if $build-dir eq 'build' || $build-dir eq './build' {
        chdir('..');
        $r = run 'pwd', :out($handle), :err($handle) if $debug;
    } else {
        my $tmp = $build-dir;
        while !($tmp eq '' || $tmp eq '/' || $tmp eq '.') {
            $handle.say: '$tmp = ', $tmp.raku if $debug;
            chdir('..');
            $r = run 'pwd', :out($handle), :err($handle) if $debug;
            $tmp = $tmp.IO.dirname;
        }
        $handle.say: '$tmp = ', $tmp.raku if $debug;
    }
    $r = run 'pwd', :out($handle), :err($handle) if $debug;

    # Prepare library target
    my $library = "lib{ %meta<lib> }.so"; # If your cmake is setup properly, then it should start with 'lib'
    $handle.say: '$library = ', $library.raku if $debug;
    my %libraries;
    my %lib-versions;
    with %meta«lib-versions» {
        %lib-versions = %meta«lib-versions»;
        $handle.say: '%lib-versions = ', %lib-versions.raku if $debug;
        for %lib-versions.kv -> $ver, $to {
            if $ver eq '' {
                %libraries{$library.Str} = "{$library}.$to";
            } else {
                %libraries{"{$library}.$ver"} = "{$library}.$to";
            }
        } # for %lib-versions.kv -> $ver, $to #
        $handle.say: '%libraries = ', %libraries.raku if $debug;
    } # with %meta«lib-versions» #
    # Prepare install location
    my Str:D $install = "/use/local/lib";
    with %meta«install» {
        $install = %meta«install»;
    }
    my Str:D $install-local = "$home/lib";
    with %meta«install-local» {
        $install-local = %meta«install-local»;
    }
    #$install ~= '/';
    my Str $install-location;
    $handle.say: "$?FILE\[$?LINE\] \$install == {$install.raku}" if $debug;
    my $tmp = self.resolve-dir($install, $handle);
    $handle.say: "$?FILE\[$?LINE\] \$install == {$install.raku}" if $debug;
    if $*USER == 0 || ($tmp.Bool && $tmp.IO ~~ :rwx) {
        $install-location = $tmp;
    } else {
        $handle.say: "$?FILE\[$?LINE\] \$install == {$install.raku}" if $debug;
        my $temp = self.resolve-dir($install-local, $handle);
        $handle.say: "$?FILE\[$?LINE\] \$install == {$install.raku}" if $debug;
        self.die-handle($handle, "bad value for install-local") unless $temp.Bool;
        $install-location = $temp;
    }
    $handle.say: "$?FILE\[$?LINE\] \$install-local == {$install-local.raku}" if $debug;
    $handle.say: "$?FILE\[$?LINE\] \$install-location == {$install-location.raku}" if $debug;
    mkdir $install-location;
    # remove all old libs #
    my $old-lib-pattern = "$install-location/$library";
    $handle.say: '$old-lib-pattern = ', $old-lib-pattern.raku if $debug;
    my @old-libs = $old-lib-pattern.IO.dirname.IO.dir( text => rx/ ^^ $old-lib-pattern [ \. \d+ [ \. \d+ [ \. \d+ ]? ]? ]? $$ /).map: { .Str };
    $handle.say: '@old-libs = ', @old-libs.raku if $debug;
    $handle.say: "$?FILE\[$?LINE\]" if $debug;
    $r = run 'pwd', :out($handle), :err($handle) if $debug;
    #«««
    for @old-libs -> $lib {
        #$handle.say: '$lib = ', $lib.raku if $debug;
        if $lib.IO ~~ :e && $lib.IO ~~ :d {
            $handle.say: "$?FILE\[$?LINE\] \$lib == {$lib}" if $debug;
            rmtree($lib.IO) if $lib.IO ~~ :e;
        } elsif $lib.IO ~~ :e  || $lib.IO ~~ :l {
            $handle.say: "$?FILE\[$?LINE\] \$lib == {$lib}" if $debug;
            $lib.IO.unlink();
        } else {
            $handle.say: "$?FILE\[$?LINE\] \$lib == {$lib}" if $debug;
        }
        CATCH {
            when X::IO::Unlink {
                $handle.say: "$?FILE\[$?LINE\] \$lib == {$lib}" if $debug;
                $handle.say: "$?FILE\[$?LINE\] { .^name}: {.Str}" if $debug;
                exit -9;
            }
            default {
                $handle.say: "$?FILE\[$?LINE\] \$lib == {$lib}" if $debug;
                $handle.say: "$?FILE\[$?LINE\] { .^name}: {.Str}" if $debug;
                exit -10;
            }
        }
    }
    #»»»
    $r = run 'pwd', :out($handle), :err($handle) if $debug;
    $handle.say: "$?FILE\[$?LINE\]" if $debug;
    with %meta«master-lib-version» {
        my $ver   = %meta«master-lib-version»;
        $library ~= ".$ver";
    }
    $r = run 'pwd', :out($handle), :err($handle) if $debug;
    $handle.say: "$?FILE\[$?LINE\] \$library == {$library}" if $debug;
    $r = run 'exa', '-F', '-laahigHb', '--color-scale', '--time-style=full-iso', '--icons=always', '.', :out($handle), :err($handle) if $debug;


    # Install
    my $from = "$build-dir/$library";
    my $to   = "$install-location/$library";
    $r = run 'pwd', :out($handle), :err($handle) if $debug;
    $handle.say: "$?FILE\[$?LINE\]" if $debug;
    $handle.say: '$from = ', $from.raku if $debug;
    $handle.say: '$to = ', $to.raku if $debug;
    $handle.say: "$?FILE\[$?LINE\]" if $debug;
    $r = run 'exa', '-F', '-laahigHb', '--color-scale', '--time-style=full-iso', '--icons=always', $from, :out($handle), :err($handle) if $debug;
    $r = run 'exa', '-F', '-laahigHb', '--color-scale', '--time-style=full-iso', '--icons=always', $to.IO.dirname, :out($handle), :err($handle) if $debug;
    #$to.IO.unlink() if $to.IO ~~ :e;
    $handle.say: "$?FILE\[$?LINE\]" if $debug;
    $install-location.IO.mkdir;
    $handle.say: '$from = ', $from.raku if $debug;
    $handle.say: '$to = ', $to.raku if $debug;
    $handle.say: "$?FILE\[$?LINE\]" if $debug;
    self.die-handle($handle, "Failed to install lib: $library") unless $from.IO.copy($to.IO);
    $handle.say: "$?FILE\[$?LINE\]" if $debug;
    my Str:D $man-number = '1';
    with %meta«man-number» {
        $man-number = %meta«man-number»;
    }
    my $man;
    with %meta«man» {
        $man = self.subst-man-number(%meta«man», $man-number);
    }
    my Str:D $man-name = '';
    with $man {
        $man-name = $man.IO.basename;
    }
    my Str:D $man-install = "/usr/local/man/man1{$man-name}";
    with %meta«man-install» {
        $man-install = self.subst-man-number(%meta«man-install», $man-number);
    }
    my $man-install-local = "$home/man/man$man-number/{$man-name}";
    with %meta«man-install-local» {
        $man-install-local = self.subst-man-number(%meta«man-install-local», $man-number);
    }
    my Str $man-install-location;
    $handle.say: "$?FILE\[$?LINE\] \$man-install == {$man-install}" if $debug;
    if $*USER == 0 || self.resolve-dir($man-install, $handle).IO ~~ :rwx {
        $man-install-location = self.resolve-dir($man-install, $handle);
    } else {
        $man-install-location = self.resolve-dir($man-install-local, $handle);
    }
    $man-install-location.IO.dirname.IO.mkdir;
    $handle.say: "$?FILE\[$?LINE\] \$man-install-location == {$man-install-location}" if $debug;
    $handle.say: "$?FILE\[$?LINE\] \$man-install-location.IO.dirname == {$man-install-location.IO.dirname}" if $debug;
    with $man {
        $handle.say: '$man = ', $man.raku if $debug;
        $handle.say: '$man-install-location = ', $man-install-location.raku if $debug;
        if $man.IO ~~ :e {
            $r = run 'exa', '-F', '-laahigHb', '--color-scale', '--time-style=full-iso', '--icons=always', $man.IO.dirname, :out($handle), :err($handle) if $debug;
            $handle.say: "$?FILE\[$?LINE\] \$man-install-location == {$man-install-location}" if $debug;
            $handle.say: "$?FILE\[$?LINE\] \$man-install-location.IO.dirname == {$man-install-location.IO.dirname}" if $debug;
            $man-install-location.IO.dirname.IO.mkdir;
            self.die-handle($handle, "Failed to install man page {$man-name}") unless "$man".IO.copy($man-install-location.IO);
        }
        $r = run 'exa', '-F', '-laahigHb', '--color-scale', '--time-style=full-iso', '--icons=always', $man-install-location.IO.dirname, :out($handle), :err($handle) if $debug;
    }
    my Str $html;
    with %meta«html» {
        $html = %meta«html»;
    }
    my Str:D $html-name = '';
    with $html {
        $html-name = $html.IO.basename;
    }
    my Str:D $html-install = "/usr/local/html/$html-name";
    with %meta«html-install» {
        $html-install = %meta«html-install»;
    }
    my Str:D $html-install-local = "$home/html/{$html-name}";
    with %meta«html-install-local» {
        $html-install-local = %meta«html-install-local»;
    }
    my Str $html-install-location;
    if $*USER == 0 || self.resolve-dir($html-install, $handle).IO ~~ :rwx {
        $html-install-location = self.resolve-dir($html-install, $handle);
    } else {
        $html-install-location = self.resolve-dir($html-install-local, $handle);
    }
    $html-install-location.IO.dirname.IO.mkdir;
    with $html {
        $handle.say: '$html = ', $html.raku if $debug;
        $handle.say: '$html-install-location = ', $html-install-location.raku if $debug;
        if $html.IO ~~ :e {
            $r = run 'exa', '-F', '-laahigHb', '--color-scale', '--time-style=full-iso', '--icons=always', $html.IO.dirname, :out($handle), :err($handle) if $debug;
            $handle.say: "$?FILE\[$?LINE\] \$html-install-location == {$html-install-location}" if $debug;
            $handle.say: "$?FILE\[$?LINE\] \$html-install-location.IO.dirname == {$html-install-location.IO.dirname}" if $debug;
            $html-install-location.IO.dirname.IO.mkdir;
            self.die-handle($handle, "Failed to install html page {$html-name}") unless $html.IO.copy($html-install-location.IO);
        }
        $r = run 'exa', '-F', '-laahigHb', '--color-scale', '--time-style=full-iso', '--icons=always', $html-install-location.IO.dirname, :out($handle), :err($handle) if $debug;
    }
    $r = run 'exa', '-F', '-laahigHb', '--color-scale', '--time-style=full-iso', '--icons=always', $to, :out($handle), :err($handle) if $debug;
    $handle.say: '$install-location = ', $install-location.raku if $debug;
    $r = run 'pwd', :out($handle), :err($handle) if $debug;

    chdir("$install-location".IO);
    $r = run 'pwd', :out($handle), :err($handle) if $debug;
    $r = run 'exa', '-F', '-laahigHb', '--color-scale', '--time-style=full-iso', '--icons=always', $to, :out($handle), :err($handle) if $debug;
    if %libraries {
        my @libs = %libraries.pairs.sort( { $^a.value leg $^b.value } ).reverse;
        $handle.say: '@libs = ', @libs.raku if $debug;
        for @libs -> $pair {
            my $link   = $pair.key;
            my $target = $pair.value;
            "$link".IO.unlink if "$link".IO ~~ :e;
            "$target".IO.symlink("$link".IO, :!absolute);
        }
    }
    $r = run 'pwd', :out($handle), :err($handle) if $debug;
    $r = run 'exa', '-F', '-laahigHb', '--color-scale', '--time-style=full-iso', '--icons=always', :out($handle), :err($handle) if $debug;
    True;
}
