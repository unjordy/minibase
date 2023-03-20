# minibase

This is an [OpenSCAD](https://openscad.org/) library for describing custom
parametric miniature bases in a simple domain-specific language that allows fast
customization. It also comes with a standard set of base definitons for
OnePageRules (which should work for Warhammer and 40k as well) and Battletech,
and a square base suitable for a number of tabletop games and RPGs.

## Requirements

See the [requirements for
scad-build](https://github.com/unjordy/scad-build#requirements). 

## Building STLs

This project uses [scad-build](https://github.com/unjordy/scad-build) to build
all of the defined bases all at once. Typing `make` should produce STLs in `out`
if you're on Linux or a Unix-like system and have all of `scad-build`'s
prerequisites.

If you'd like to render bases to STL individually without `scad-build`, just
open the base definition in OpenSCAD as you normally would and render it from
there.

## Defining new bases

`minibase` defines a domain-specific language just for describing a miniature
base. Each base is defined in a separate scad file in the `minibase` root
directory, though if you're using `scad-build` you can define more than one base
per file. The base declaration in each scad file looks like:
```
include <./minibase.scad>

inclined() diameter(32) base("32mm-opr-infantry");
```
Each base starts with a set of descriptive calls that describe the parameters
for the base you want, followed by a call to `base(id)` that combines your
parameters with `minibase`'s defaults and renders the base. The `id` argument is
used by `scad-build` to name the STL for that base.

Note that each descriptive call is scoped so that it only applies to its
children, so multiple calls to `base()` won't interfere with each other as long
as they're separated by semicolons.

The functions provided by `minibase` are:
| name          | description                                                                       |
|---------------|-----------------------------------------------------------------------------------|
| `tapered(r)`  | A fancy tapered base rim; argument is the ratio of the rim to the top of the base |
| `inclined()`  | A normal slanted base rim                                                         |
| `flat()`      | A flat base rim                                                                   |
| `shape(s)`    | The base has `s` sides; 6 is a hex, 4 is a square, 100 is a circle                |
| `diameter(d)` | The base's diameter is `d` millimeters                                            |
| `height(h)`   | The base is `h` millimeters high                                                  |
| `slant(s)`    | Slant the rim of the base `s`%, if tapered or inclined                            |
| `stretch(s)`  | Stretch one side of the base by `s`% of its diameter                              |
| `base(id)`    | Render a base with build ID `id`                                                  |

