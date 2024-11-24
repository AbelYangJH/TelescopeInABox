
// duplicate and mirror
module mirror_dup(v) {
  children();
  mirror(v) children();
}

// duplicate and mirror in x
module mirror_dup_x () { mirror_dup([1,0,0]) children(); }
// duplicate and mirror in y
module mirror_dup_y () { mirror_dup([0,1,0]) children(); }
// duplicate and mirror in z
module mirror_dup_z () { mirror_dup([0,0,1]) children(); }

// translate in v and duplicate in +-d
module translate_s(v=[0,0,0],d=[0,0,0]) {
  translate(v) {
    translate(d) children();
    translate(-1*d) children();
  }
}

// translate and duplicate in +-x
module translate_xs(v=[0,0,0], dx=undef) {
  v = len(v)==2?[v.x,v.y,0]:v;
  if (is_undef(dx)) {
    translate(v) children();
    translate(v*[[-1,0,0],[0,1,0],[0,0,1]]) children();
  }
  else {
    translate(v) {
      translate([ dx,0,0]) children();
      translate([-dx,0,0]) children();
    }
  }
}

// translate and duplicate in +-y
module translate_ys(v=[0,0,0], dy=undef) {
  v = len(v)==2?[v.x,v.y,0]:v;
  if (is_undef(dy)) {
    translate(v) children();
    translate(v*[[1,0,0],[0,-1,0],[0,0,1]]) children();
  }
  else {
    translate(v) {
      translate([0, dy,0]) children();
      translate([0,-dy,0]) children();
    }
  }
}

// translate and duplicate in +-z
module translate_zs(v=[0,0,0], dz=undef) {
  if (is_undef(dz)) {
    translate(v) children();
    translate(v*[[1,0,0],[0,1,0],[0,0,-1]]) children();
  }
  else {
    translate(v) {
      translate([0,0, dz]) children();
      translate([0,0,-dz]) children();
    }
  }
}

// rotate +-a about v
module rotate_s(a,v=undef,orig=false) {
  if (orig == true) { children(); }
  if (is_list(a) || is_undef(v)) {
    rotate(a) children();
    rotate(-a) children();
  }
  else {
    rotate(a,v) children();
    rotate(-a,v) children();
  }
}

// rotate about vector starting at vs with direction v
module rotate_v(a, v=[0,0,1], vs=[0,0,0]) {
  translate(vs) rotate(a=a, v=v) translate(-1*vs) children();
}

// duplicate with rotational symmetry
module rsym(n) {
  for (a=[0:360/n:359]) rotate(a) children();
}

// rotate extrusion symmetric about x=0 plane
module rotate_extrude_s(angle=360,convexity=10) {
  rotate(-angle/2) rotate_extrude(angle=angle,convexity=convexity) children();
}
