include <./build.scad>

square_size = 46;
board_height = 4;
board_border = 4;


module black_square() {
  color("black") {
    cube([square_size, square_size, board_height - 1]);
  }
}

module white_square() {
  color("white") {
    cube([square_size, square_size, board_height - 1.75]);
  }
}

module checkerboard(rows, columns) {
  $rows = rows;
  $columns = columns;

  for(x = [0:1:rows - 1]) {
    for(y = [0:1:columns - 1]) {
      translate([square_size * x, square_size * y, 0]) {
        if ((x + y) % 2 == 0) {
          black_square();
        }
        else {
          white_square();
        }
      }
    }
  }

  children();
}

module top() {
  translate([0, square_size * $columns, 0]) {
    children();
  }
}

module bottom() {
  translate([0, -board_border, 0]) {
    children();
  }
}

module left() {
  translate([-board_border, 0, 0]) {
    children();
  }
}

module right() {
  translate([square_size * $columns, 0, 0]) {
    children();
  }
}

module border_v() {
  color("gray") {
    cube([square_size * $columns + board_border, board_border, board_height]);
  }
}

module border_h() {
  color("gray") {
    cube([board_border, square_size * $columns, board_height]);
  }
}

module top_border() {
  color("gray") {
    translate([0, square_size * $columns, 0]) {
      cube([square_size * $columns, board_border, board_height]);
    }
  }
}

module bottom_border() {
  color("gray") {
    translate([0, -board_border, 0]) {
      cube([square_size * $columns, board_border, board_height]);
    }
  }
}

module left_border() {
  color("gray") {
    translate([-board_border, 0, 0]) {
      cube([board_border, square_size * $columns, board_height]);
    }
  }
}

module right_border() {
  color("gray") {
    translate([square_size * $columns, 0, 0]) {
      cube([board_border, square_size * $columns, board_height]);
    }
  }
}

preview_column(square_size * 4 + 10) {
  preview_row(square_size * 4 + 10) {
    build("bottom-left") checkerboard(4, 4) {
      bottom() left() border_v();
      left() border_h();
    }

    build("bottom-right") checkerboard(4, 4) {
      bottom() border_v();
      right() border_h();
    }
  }
  preview_row(square_size * 4 + 10) {
    build("top-left") checkerboard(4, 4) {
      top() left() border_v();
      left() border_h();
    }

    build("top-right") checkerboard(4, 4) {
      top() border_v();
      right() border_h();
    }
  }
}
