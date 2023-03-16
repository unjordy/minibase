# scad-build

This is a multi-STL [OpenSCAD](https://openscad.org/) build system based around
GNU `make`. It supports dynamic build targets, intelligent previews with
user-defined part layouts, and autoplating to efficiently send the maximum
number of objects that will fit your 3D printer build plate to your slicer,
reducing the amount of work that goes into printing complex projects.

## Requirements

- OpenSCAD 2021.01 or newer
- GNU `make`
- Python 3.9.x or newer and the command line version of `prusa-slicer` (only for autoplating)

## Using scad-build

This repository is intended to be a template to base new projects off of;
existing projects without a build system can be adapted to use `scad-build`
too. The files in this repository expect to be copied into the root of your
OpenSCAD project.

### Importing

Once you have installed `scad-build` into the root of your project, import it
into any SCAD file you want to export multiple STLs from with
`import <./build.scad>`. Modify the path if `build.scad` is not in the same
directory as your SCAD file.

### Using `build(id)`

`build()` is a module that designates its children as a separate build unit;
this will cause `make` to output an STL at `out/scad_file/build_id.stl`
containing only the children in scope for the `build(build_id)` module in the 
file `scad_file.scad`. `build` modules exist at runtime, so they can be nested
under other modules if desired, or generated dynamically. Note that for
`scad-build` to work properly, everything that renders during a build should be
scoped under a `build()` module. See the section on previewing below for
information on how to render multiple items while designing.

While `scad-build` is running under `make`, the function `building()` will
return `true`, and `building(build_id)` will return true if the current build
unit for the `openscad` process has been called to handle `build(build_id)`.

Children of `build()` can access the current build ID via the `$build_id`
variable. If there is no `build()` parent, `$build_id` is the empty string.

`scad-build` only pays attention to the first `build()` module in a render tree;
any instances of `build()` inside of `build()` will not be picked up by the
build system.

### Previewing

`scad-build` has three distinctive modes for the OpenSCAD runtime. The first
is `build()` module discovery, which is an implementation detail. The second is
build mode, where `make` calls `openscad` with a single `build_id` selected. The
third mode is preview mode, the default mode when `scad-build` projects are
accessed outside of `make` -- most relevantly, in OpenSCAD's UI for preview.

While previewing, the function `previewing()` returns `true`. This can be used
to define modules that will render all of your STLs in the same view while you
are designing them without interfering with building. See the `preview_row()`
and `preview_column()` modules in `build.scad` for ready-to-go preview layout
utilites that demonstrate how to use `previewing()` to generate your own layout.

Note that preview modules disable layouts and call `children()` when not
previewing, because they expect to only render children wrapped in `build()`,
and only the child matching the `build_id` will be rendered when not previewing.

### Building (rendering)

Type `make` to start a build. Your STLs will end up in the `out` directory, in
subdirectories named after the SCAD file used to build the STL. Each STL is
named after the argument to its parent `build()` module.

### Multi-process rendering

`scad-build` supports the standard `make` mechanism for multi-process/multi-core
builds: specify `-j#` as an argument to `make`, where `#` is the number of
processes (build units) you want to render simultaneously.

## Autoplating

Ideal for complex 3D printing projects with many discrete parts, autoplating
tries to pack the maximum number of STL files into your build volume. It
requires Python 3.9.x and the command line version of `prusa-slicer` to be
accessible.

### Configuring

Autoplating requires you to create a `.plateconfig` file in your project root;
this file should be added to your `.gitignore`, since it is specific to your
3D printer. Its contents should look like:

```
[plate]
size_x = <the x size (width) of your build volume in mm>
size_y = <the y size (height) of your build volume in mm>
spacing = <optional: the amount of space to leave between objects (default: 8mm)>
```

### Running the autoplater

Type `make autoplate`. If you have written a `.plateconfig` and have all of the
necessary dependencies, this should build your STL files if necessary, then
populate `out/autoplate` with subdirectories representing each prepared build
plate. Each subdirectory contains the STLs on that plate (more specifically, 
symbolic links to already built STLs to save space).

To slice a whole plate based off of the autoplater's suggestion, call your
slicer like: `prusa-slicer out/autoplater/plate0/*.stl`, changing this
command as needed if slicing other plate numbers or using Cura or another
slicer.
