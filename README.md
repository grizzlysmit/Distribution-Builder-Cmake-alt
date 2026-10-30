Distribution::Builder::Cmake-alt
================================

Table of Contents
-----------------

  * [NAME](#name)

  * [AUTHOR](#author)

  * [VERSION](#version)

  * [TITLE](#title)

  * [SUBTITLE](#subtitle)

  * [COPYRIGHT](#copyright)

  * [Introduction](#introduction)

NAME
====

Gzz::Readline 

AUTHOR
======

Francis Grizzly Smit (grizzly@smit.id.au)

VERSION
=======

1.0.4

TITLE
=====

Gzz::Readline

SUBTITLE
========

A Raku module for building CMake projects to make .so files and installing them in into a chosen install directory.

COPYRIGHT
=========

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0 [LICENSE](https://github.com/grizzlysmit/Distribution-Builder-Cmake-alt/blob/main/LICENSE)

[Top of Document](#table-of-contents)

Introduction
------------

A **Raku** module for building **CMake** projects to make **.so** files and installing them in into a chosen install directory. Based on [Distribution::Builder::Cmake](https://raku.land/zef:rawleyfowler/Distribution::Builder::Cmake) by **Rawley Fowler** I have kept to the same licencing 

Installation
------------

```bash
zef install Distribution::Builder::Cmake
```

Usage
-----

Assuming your Raku project keeps its CMake project in a folder called `my-cmake-project`, and your exported lib is `my-lib`. Note, the final `.so` file will be `lib{$my-lib}.so`. In your `META6.json` you'll add the following:

```json
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
```

Where 

  * `lib` is the name of your lib and is mandatory.

  * `src-dir` is the location of your library and is mandatory it should be relative to the working directory or it can be an empty string or a "."

  * `install` is optional and specifies the location to install the libraries (lib{$lib}.so files) it should be an absolute path otherwise the install would achieve nothing (defaults to `/usr/local/lib`). **NB** this field supports expandable patterns `~/`, `$*HOME/`, `$HOME/`, `{$*HOME}/` and `{$HOME}/` all expand to the user home directory followed by a `/` and `~username` will expand to usernames dome dir.

  * `install-local` is optional and specifies the location to install the libraries if installing locally (lib{$lib}.so files) it should be a path inside the users users directory tree, otherwise the install would achieve nothing (defaults to `$HOME/lib`). **NB** this field supports expandable patterns `~/`, `$*HOME/`, `$HOME/`, `{$*HOME}/` and `{$HOME}/` all expand to the user home directory followed by a `/` and `~username` will expand to usernames dome dir.

  * `master-lib-version` specifies the version number to put on the .so file (i.e. lib{$lib}.so.{$master-lib-version}) but you can leave it as an empty sting.

  * `lib-versions` a collection of mappings to specify a list of symbolic links to the library. The example above would produce 

    * ```bash
    $ exa -F -laahigHb --color-scale --time-style=full-iso --icons=always /usr/local/lib/
       inode Permissions Links Size User Group Date Modified                       Name
    15614859 drwxr-xr-x      3    - root root  2026-10-28 17:39:53.989170059 +1100  ./
    15466504 drwxr-xr-x     11    - root root  2026-04-23 12:15:04.000000000 +1100  ../
    15604140 lrwxrwxrwx      1    - root root  2026-10-28 17:39:53.989170059 +1100  libmy-lib.so -> libmy-lib.so.0*
    15604139 lrwxrwxrwx      1    - root root  2026-10-28 17:39:53.989170059 +1100  libmy-lib.so.0 -> libmy-lib.so.0.0.1*
    15604115 .rwxr-xr-x      1 22Ki root root  2026-10-28 17:39:53.924168331 +1100  libmy-lib.so.0.0.1*
    ```

  * `source` specifies the name of the source dir relative to the `src-dir` can be `""` to specify that the source is in `src-dir` itself.

  * `log` the place to spit logging info to defaults to `/dev/null` optional use `/dev/tty` to send debug data into the terminal that called `zef` or a file name, like Install and install-local this supports `~/`, `$*HOME/`, `$HOME/`, `{$*HOME}/` and `{$HOME}/` resolution.

  * `debug` if `true` then spit as much details into the log `$log` can be `/dev/null` to throw away the results or `/dev/tty` to write to the terminal, or a file.

**Note:** You may also provide a `install` field to specify the directory to install the library. This defaults to: `resources/libraries/lib<your-lib>.so`

The typical CMake project will look like (assuming your lib is `my-lib`):

```cmake
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
```

You can see an example of this in action in [this repo](https://github.com/grizzlysmit/gzzReadline.git)

(Obviously, you'll need Make and CMake installed)

