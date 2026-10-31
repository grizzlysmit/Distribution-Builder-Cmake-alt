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

1.0.6

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

Assuming your Raku project keeps its CMake project in a folder called `my-cmake-project`, and your exported lib is `gzz_readline`. Note, the final `.so` file will be `lib{$my-lib}.so`. In your `META6.json` you'll add the following:

```json
{ 
    ....
    "provides": {
        "Gzz::Readline":            "lib/Gzz/Readline.rakumod"
    },
    "resources": [
        "CMakeLists.txt",
        "contrib/postinst.in",
        "debian/final_deb_stuff.sh.in",
        "images/grizzly.png",
        "source/gzz_readline.c",
        "source/gzz_readline.h",
        "source/gzz_readline.pc.in",
        "source/gzz_rlprivate.c",
        "source/gzz_rlprivate.h",
        "docs/Gzz/Readline.3",
        "docs/Gzz/Readline.html",
        "docs/Gzz/Readline.rakudoc",
        "docs/Gzz/README.md",
        "docs/Gzz/Readline.1",
        "docs/Gzz/Readline.html",
        "docs/README.md",
        "docs/Gzz/Readline.1",
        "docs/Gzz/Readline.html"
    ], 
    "bin": {
        "Gzz::Readline.rakudoc": "doc/Gzz/Readline.rakudoc"
    },
    "depends": [
        "Distribution::Builder::Cmake-alt",
        "P5readlink",
        "Pod::To::HTML", 
        "Pod::To::Man",
        "Pod::Load", 
        "Test::Output", 
        "Template::Mustache"
    ],
    .....
    ......
    "builder": "Distribution::Builder::Cmake-alt",
    "build": {
        "lib"    : "gzz_readline",
        "install": "/usr/local/lib",
        "install-local": "$*HOME/lib",
        "src-dir": "resources",
        "master-lib-version": "1.0.0",
        "lib-versions": {
            "1": "1.0.0",
            "": "1"
        },
        "man-number" : "3",
        "man"    : "resources/docs/Gzz/Readline.$man-number",
        "man-install" : "/usr/local/man/man$man-number/Gzz::Readline.$man-number",
        "man-install-local" : "$*HOME/man/man$man-number/Gzz::Readline.$man-number",
        "html" : "resources/docs/Gzz/Readline.html",
        "html-install" : "/usr/local/share/html/Gzz::Readline.html",
        "html-install-local" : "$HOME/html/Gzz::Readline.html",
        "markdown-path" : "resources/docs/README.md",
        "markdown-path-install" : "/usr/local/share/Gzz::Readline/README.md",
        "markdown-path-install-local" : "$HOME/docs/Gzz::Readline/README.md",
        "source": "source",
        "log":    "/dev/tty",
        "debug":  true
    }
}
```

Where 

  * `lib` is the name of your lib and is mandatory.

  * `src-dir` is the location of your library and is mandatory it should be relative to the working directory or it can be an empty string or a "."

  * `install` is optional and specifies the location to install the libraries (lib{$lib}.so files) it should be an absolute path otherwise the install would achieve nothing (defaults to `/usr/local/lib`). **NB** this field supports expandable patterns `~/`, `$*HOME/`, `$HOME/`, `{$*HOME}/` and `{$HOME}/` all expand to the user home directory followed by a `/` and `~username` will expand to usernames dome dir.

  * `install-local` is optional and specifies the location to install the libraries if installing locally (lib{$lib}.so files) it should be a path inside the users users directory tree, otherwise the install would achieve nothing (defaults to `$HOME/lib`). **NB** this field supports expandable patterns `~/`, `$*HOME/`, `$HOME/`, `{$*HOME}/` and `{$HOME}/` all expand to the user home directory followed by a `/` and `~username` will expand to usernames dome dir.

    * The `install` versions of things mean if `$*USER == 0` or if the path (up until the file for `install` the file isn't there so just the path) is readable writable and executable, to the current user, `path.IO ~~ :rwx`. Whereas `install-local` will be used otherwise. In the cases bellow `man-install` `man-install-local` etc the file name is in the path so `path.IO.dirname.IO ~~ :rwx`, is the required condition.

  * `master-lib-version` specifies the version number to put on the .so file (i.e. lib{$lib}.so.{$master-lib-version}) but you can leave it as an empty sting.

  * `lib-versions` a collection of mappings to specify a list of symbolic links to the library. The example above would produce 

    * ```bash
    $ exa -F -laahigHb --color-scale --time-style=full-iso --icons=always /usr/local/lib/
      inode Permissions Links Size User Group Date Modified                       Name
    1448471 drwxr-xr-x      2    - root root  2026-10-31 06:44:22.781481214 +1100  ./
    1310728 drwxr-xr-x     10    - root root  2026-10-31 06:41:40.271428243 +1100  ../
    1454469 lrwxrwxrwx      1    - root root  2026-10-31 06:44:22.781481214 +1100  libgzz_readline.so -> libgzz_readline.so.1*
    1448470 lrwxrwxrwx      1    - root root  2026-10-31 06:44:22.781481214 +1100  libgzz_readline.so.1 -> libgzz_readline.so.1.0.0*
    1446352 .rwxr-xr-x      1 22Ki root root  2026-10-31 06:44:22.588264210 +1100  libgzz_readline.so.1.0.0*
    ```

  * `man-number` is the manual section to install the man file ([see **Linux/Unix** man pages](https://en.wikipedia.org/wiki/Man_page)) if you are looking to install a executable then man-number should be `1` if you are installing a library then `3`.

  * `man` is the path to the manual page inside the install package. 

  * `man-install` is the path to install the man page to if the user is the root user or otherwise able to read write and execute the path `path.IO.dirname.IO ~~ :rwx`.

  * `man-install-local` is the path to install to inside the users directory tree. (i.e. `$*HOME/man/man$man-number/manpage.$man-number`. e.g. **~/man/man3/manpage.3**)

  * `html` is the path to the html page to be installed.

  * `html-install` is the path to use for a global install.

  * `html-install-local` is the path to use for a local install.

  * `markdown-path` is the path to the markdown file to be installed.

  * `markdown-path-install` is the path to use for a global install.

  * `markdown-path-install-local` is the path to use for a local install.

  * `source` specifies the name of the source dir relative to the `src-dir` can be `""` to specify that the source is in `src-dir` itself.

  * `log` the place to spit logging info to defaults to `/dev/null` optional use `/dev/tty` to send debug data into the terminal that called `zef` or a file name, like Install and install-local this supports `~/`, `$*HOME/`, `$HOME/`, `{$*HOME}/` and `{$HOME}/` resolution.

  * `debug` if `true` then spit as much details into the log `$log` can be `/dev/null` to throw away the results or `/dev/tty` to write to the terminal, or a file.

**Note:** You may also provide a `install` field to specify the directory to install the library. This defaults to: `resources/libraries/libgzz_readline.so`

The typical CMake project will look like (assuming your lib is `gzz_readline`):

```cmake
# Specify the minimum version.
cmake_minimum_required(VERSION 3.11)

# Specify the project info.
project(gzz_readline
        VERSION 1.0.0
        DESCRIPTION "Extension to Gnu Readline to get a prompt with a default value"
        LANGUAGES "C")


# Declare the library target.
add_library(${PROJECT_NAME} SHARED
    source/gzz_rlprivate.c
    source/gzz_readline.c
)

#add_dependencies(gzz_readline libreadline.so.0)

target_link_libraries(gzz_readline libreadline.so.1)

# Configure the directories to search for header files.
target_include_directories(${PROJECT_NAME} PRIVATE source)

# Set the version property.
set_target_properties(${PROJECT_NAME} PROPERTIES VERSION ${PROJECT_VERSION})

# Set the shared object version property to the project's major version.
set_target_properties(${PROJECT_NAME} PROPERTIES SOVERSION ${PROJECT_VERSION_MAJOR})

# Set the public header property to the one with the actual API.
set_target_properties(${PROJECT_NAME} PROPERTIES PUBLIC_HEADER source/gzz_readline.h)

# Set the private header property to the one with the actual API.
#set_target_properties(${PROJECT_NAME} PROPERTIES PRIVATE_HEADER source/gzz_rlprivate.h)

# For access to standard installation directory variables (CMAKE_INSTALL_xDIR).
include(GNUInstallDirs)

# Set library shared object and API header file to install.
install(TARGETS ${PROJECT_NAME}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

# Create the pkg-config file from the template.
configure_file(source/${PROJECT_NAME}.pc.in ${PROJECT_NAME}.pc @ONLY)

# Set pkg-config file to install.
install(FILES ${CMAKE_BINARY_DIR}/${PROJECT_NAME}.pc
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig
)

# generate postinst file in ${CMAKE_BINARY_DIR} from template                        #
CONFIGURE_FILE("${CMAKE_SOURCE_DIR}/contrib/postinst.in" "postinst" @ONLY IMMEDIATE)


    # generate a DEB when cpack is run
    SET(CPACK_GENERATOR "DEB")
    SET(CPACK_PACKAGE_NAME ${CMAKE_PROJECT_NAME})
    SET(CPACK_PACKAGE_ICON "${CMake_SOURCE_DIR}/images/grizzly.png")
    SET(CPACK_SET_DESTDIR TRUE)
    SET(CPACK_DEBIAN_PACKAGE_MAINTAINER "grizzlysmit@smit.id.au")
    SET(CPACK_PACKAGE_VERSION_MAJOR "1")
    SET(CPACK_PACKAGE_VERSION_MINOR "0")
    SET(CPACK_PACKAGE_VERSION_PATCH "0")
    #include(GNUInstallDirs)
    add_custom_command(OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/changelog.gz"

        COMMAND gzip -cn9 "${CMAKE_CURRENT_SOURCE_DIR}/changelog" ">" "${CMAKE_CURRENT_BINARY_DIR}/changelog.gz"
        WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
        DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/changelog"
        COMMENT "Compressing changelog"
    )

    add_custom_target(changelog ALL DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/changelog.gz")

    install(FILES "${CMAKE_CURRENT_BINARY_DIR}/changelog.gz"
        DESTINATION "${CMAKE_INSTALL_DOCDIR}"
    )
    set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA "${CMAKE_CURRENT_BINARY_DIR}/changelog.gz")

    SET(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_SOURCE_DIR}/docs/CPack.Description.txt")
    SET(CPACK_RESOURCE_FILE_README "${CMAKE_SOURCE_DIR}/docs/Gzz/README.md")
    SET(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/docs/LICENCE")
    SET(CPACK_DEBIAN_PACKAGE_DEPENDS "libreadline8, libreadline-dev")
    SET(CPACK_PACKAGE_VENDOR "Grizzly")
    # make postinst run after install                                                #
    SET(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA "${CMAKE_BINARY_DIR}/postinst;")


    include(CPack)
```

You can see an example of this in action in [this repo](https://github.com/grizzlysmit/gzzReadline.git)

(Obviously, you'll need Make and CMake installed and what ever compiler your project uses in this case `g++`)

  * **Note:** all files needed by either your `cmake` command or manual pages etc must be put inside your `"resources"` list for a full working [example see Gzz::Readline](https://github.com/grizzlysmit/gzzReadline.git)

    * ```json
    { ...
      .....
        "resources": [
            "CMakeLists.txt",
            "contrib/postinst.in",
            "debian/final_deb_stuff.sh.in",
            "images/grizzly.png",
            "source/gzz_readline.c",
            "source/gzz_readline.h",
            "source/gzz_readline.pc.in",
            "source/gzz_rlprivate.c",
            "source/gzz_rlprivate.h",
            "docs/Gzz/Readline.3",
            "docs/Gzz/Readline.rakudoc",
            "docs/Gzz/README.md",
            "docs/README.md",
            "docs/Gzz/Readline.html"
        ], 
       ....
       ...
    }
    ```

