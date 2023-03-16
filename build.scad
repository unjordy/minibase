$build_id = "";

function building(filename) = is_undef(filename) ?
  !is_undef(build)
  : !is_undef(build) && build == filename;

function previewing() = !building();

module build(filename) {
  $build_id = filename;

  if(!is_undef(scad_build_scan) && scad_build_scan == true) {
    echo(str("scad_build_scan: ", filename));
  }
  else if(previewing() || build == filename) {
    children();
  }
}

module preview_row(spacing) {
  if(previewing()) {
    for(x = [0:1:$children - 1]) {
      translate([x * spacing, 0, 0]) {
        children(x);
      }
    }
  }
  else {
    children();
  }
}

module preview_column(spacing) {
  if(previewing()) {
    for(y = [0:1:$children - 1]) {
      translate([0, y * spacing, 0]) {
        children(y);
      }
    }
  }
  else {
    children();
  }
}
