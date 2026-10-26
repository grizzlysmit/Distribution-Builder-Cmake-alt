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

0.0.11

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
        "master-lib-version": "0.0.1",
        "lib-versions": {
            "0": "0.0.1",
            "": "0"
        }
    }
    ...
}
```

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

