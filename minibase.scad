// Based off of titancraft's Customizable Miniature Base (CC0 1.0)
// https://www.thingiverse.com/thing:1112237

include <./build.scad>

$base_rim = 1; //	[1: tapered, 2: inclined, 3: flat]
// Number of sides:
$base_shape = 100; //	[30:Low-res Circle, 100: Hi-res Circle, 5:Pentagon, 6:Hexagon, 8:Octagon, 4:Square, 3:Triangle]

$base_diameter = 32;
$base_height = 4;
$base_slant = 95;

// Percentage:
$base_stretch = 100;

//(tapered base only)
$base_inner_circle_ratio = 40;

module tapered(r=40) {
  $base_rim = 1;
  $base_inner_circle_ratio = r;

  children();
}

module inclined() {
  $base_rim = 2;

  children();
}

module flat() {
  $base_rim = 3;

  children();
}

module shape(s) {
  $base_shape = s;

  children();
}

module diameter(d) {
  $base_diameter = d;

  children();
}

module height(h) {
  $base_height = h;

  children();
}

module slant(s) {
  $base_slant = s;

  children();
}

module stretch(s) {
  $base_stretch = s;

  children();
}

module base(id) {
  build(id) union() {
    radius = $base_diameter/2;
    scale([$base_stretch/100, 1, 1]){
      if ($base_rim == 1){
        // tapered base
        cyl1_height = $base_height * (1-$base_inner_circle_ratio/100);
        cylinder(cyl1_height, radius, radius * $base_slant/100, $fn=$base_shape);

        cyl2_radius = radius  * $base_slant/100 * .95;
        cyl2_height = $base_height - cyl1_height;

        translate([0, 0, cyl1_height]){
          cylinder(cyl2_height, cyl2_radius, cyl2_radius * $base_slant/100, $fn=$base_shape);
          cylinder(cyl2_height*.5, radius * $base_slant/100, cyl2_radius, $fn=$base_shape);
        }
      } else if ($base_rim == 2){
        // inclined base
        cylinder($base_height, radius, radius * $base_slant/100, $fn=$base_shape);
      } else if ($base_rim == 3){
        // flat base

        cylinder($base_height, radius, radius, $fn=$base_shape);
      }
    }
  }
}
