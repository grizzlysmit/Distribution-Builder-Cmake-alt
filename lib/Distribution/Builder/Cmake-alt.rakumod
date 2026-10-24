use v6.d;
unit class Distribution::Builder::Cmake-alt:ver<0.0.1>:auth<Francis Grizzly Smit (grizzly@smit.id.au)>;

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
=VERSION 0.0.1
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
        "master-lib-version": "0.0.1",
        "lib-versions": {
            "0": "0.0.1",
            "": "0"
        }
    }
    ...
}


=end code

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


has %.meta;

method build(IO() $work-dir = $*CWD) {
    my %meta = %!meta<build>;
    die 'You need CMake to install this package!' unless shell 'which cmake';
    die 'You need Make to install this package!' unless shell 'which make';

    # Prepare to build
    my $src-dir;
    my $cmake-src-dir;
    with %meta«src-dir» {
        $src-dir = %meta«src-dir»;
        if $src-dir ne '.' {
            $cmake-src-dir = "$work-dir/$src-dir";
        } else {
            $cmake-src-dir = $work-dir;
        }
    } else {
        $src-dir       = '.';
        $cmake-src-dir = "$work-dir/cc";
    }
    die "$cmake-src-dir is not a directory." unless $cmake-src-dir.IO.e && $cmake-src-dir.IO.d;

    # Build
    my $build-dir = "$cmake-src-dir/build";
    mkdir $build-dir;
    die 'Failed to run cmake, or compile this package.' unless shell "cd $build-dir && cmake .. && make";

    # Prepare library target
    my $library = "lib{ %meta<lib> }.so"; # If your cmake is setup properly, then it should start with 'lib'
    my %libraries;
    my %lib-versions;
    with %meta«lib-versions» {
        %lib-versions = %{%meta«lib-versions»};
        for %lib-versions.kv -> $ver, $to {
            next if $ver ne '';
            if $ver eq '' {
                %libraries{$library.Str} = "{$library}.$to";
            } else {
                %libraries{"{$library}.$ver"} = "{$library}.$to";
            }
        } # for %lib-versions.kv -> $ver, $to #
    } # with %meta«lib-versions» #
    with %meta«master-lib-version» {
        my $ver   = %meta«master-lib-version»;
        $library ~= ".$ver";
    }
    #unlink "$work-dir/$library" if "$work-dir/$library".IO.e;

    # Prepare install location
    my $install = %meta«install» // "$work-dir/resources/libraries";
    #$install ~= '/';
    my $install-location = $install;
    mkdir $install-location;

    # Install
    die "Failed to install lib: $library" unless copy "$build-dir/$library", "$install-location/$library";

    if %libraries {
        my $cwd = $*CWD;
        chdir("$install-location".IO);
        for %libraries.kv -> $lib, $to {
            "$to".IO.unlink if "$to".IO ~~ :e;
            "$to".IO.symlink("$lib".IO, :!absolute);
        }
        chdir($cwd);
    }

    True;
}
