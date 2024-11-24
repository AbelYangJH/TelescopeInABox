include <threads.scad>

module nut_cut(fwidth, height, allowance=0) {
  cylinder($fn=6,r=(allowance+fwidth/2)/sin(60),h=height);
}

function get_hex_side(p) = lookup(p, [
 		[   1, 2.5 ],
 		[ 1.2, 3.0 ],
 		[ 1.4, 3.0 ],
 		[ 1.6, 3.2 ],
 		[   2, 4.0 ],
 		[ 2.5, 5.0 ],
 		[   3, 5.5 ],
 		[ 3.5, 6 ],
 		[   4, 7 ],
 		[   5, 8 ],
 		[   6, 10 ],
 		[   7, 11 ],
 		[   8, 13 ],
 		[  10, 17 ],
 	]);

function get_hex_major(p) = get_hex_side(p)/sin(60);

function get_hex_thick(p) = lookup(p, [
 		[   1, 0.8 ],
 		[ 1.2, 1 ],
 		[ 1.4, 1.2 ],
 		[ 1.6, 1.3 ],
 		[   2, 1.6 ],
 		[ 2.5, 2 ],
 		[   3, 2.4 ],
 		[ 3.5, 2.8 ],
 		[   4, 3.2 ],
 		[   5, 4 ],
 		[   6, 5 ],
 		[   7, 5.5 ],
 		[   8, 6.5 ],
 		[  10, 8 ],
 	]);

function get_pitch(p) = lookup(p, [
 		[   1, 0.25 ],
 		[ 1.2, 0.25 ],
 		[ 1.4, 0.3 ],
 		[ 1.6, 0.35 ],
 		[   2, 0.45 ],
 		[ 2.5, 0.45 ],
 		[   3, 0.6 ],
 		[ 3.5, 0.6 ],
 		[   4, 0.75 ],
 		[   5, 1 ],
 		[   6, 1 ],
 		[   7, 1 ],
 		[   8, 1.25 ],
 		[  10, 1.5 ],
 	]);

function get_washer_side(p) = lookup(p, [
 		[ 1.6, 4 ],
 		[   2, 5 ],
 		[ 2.5, 6 ],
 		[   3, 7 ],
 		[ 3.5, 8 ],
 		[   4, 9 ],
 		[   5, 10 ],
 		[   6, 12 ],
 		[   7, 14 ],
 		[   8, 16 ],
 		[  10, 20 ],
 	]);

function get_washer_hole(p) = lookup(p, [
 		[ 1.6, 1.7 ],
 		[   2, 2.2 ],
 		[ 2.5, 2.7 ],
 		[   3, 3.2 ],
 		[ 3.5, 3.7 ],
 		[   4, 4.3 ],
 		[   5, 5.3 ],
 		[   6, 6.4 ],
 		[   7, 7.4 ],
 		[   8, 8.4 ],
 		[  10, 10.5 ],
 	]);

function get_washer_thick(p) = lookup(p, [
 		[ 1.6, 0.3 ],
 		[   2, 0.3 ],
 		[ 2.5, 0.5 ],
 		[   3, 0.5 ],
 		[ 3.5, 0.5 ],
 		[   4, 0.8 ],
 		[   5, 1 ],
 		[   6, 1.6 ],
 		[   7, 1.6 ],
 		[   8, 1.6 ],
 		[  10, 2 ],
 	]);

function get_thread_depth(p) = get_pitch(p)*0.866;

module metric_washer(size) {
  difference() {
    cylinder(d=get_washer_side(size),h=get_washer_thick(size));
    translate([0,0,-0.1]) cylinder(d=get_washer_hole(size),h=get_washer_thick(size)+0.2);
  }
}

module shaftsupport_nut(
size, // nut size
allowance=0, // side allowance
sfactor=1.05, // shaft size factor
layer=0.2, // layer thickness
) {
  id = size*sfactor;
  od = (allowance+get_hex_side(size)/2)/sin(60);
  dd1=max(id/sin(30),od);
  translate([0,0,-0.01]) cylinder(d=dd1,h=layer+0.01,$fn=3);
  translate([0,0,layer-0.01]) intersection() {
    cylinder(d=dd1,h=layer+0.01,$fn=3);
    rotate(60) cylinder(d=id/sin(30),h=layer+0.01,$fn=3);
  }
}

module metric_nut_cut(
size, // nut size
depth=0, // override auto depth
add_depth=0, // additional depth over auto depth
allowance=0, // side allowance
) {
  nut_cut(get_hex_side(size),add_depth+((depth==0)?get_hex_thick(size):depth),allowance=allowance);
}

module metric_shaft_cut(
size, // bolt size
length, // cut depth
sfactor=1.05, // shaft oversize factor
shaft="free", // "free", "threaded", "undersized" or "undersized_hex"
allowance=0, // allowance for thread
test=$preview, // test mode
) {
  if (shaft == "threaded") {
    metric_thread(diameter=size+allowance,pitch=get_pitch(size),length=length,internal=true,test=test);
  }
  else if (shaft == "undersized") {
    cylinder(d=size-1.5*get_thread_depth(size), h=length);
  }
  else if (shaft == "undersized_hex") {
    cylinder(d=size, h=length, $fn=6);
  }
  else { //(shaft == "free") {
    cylinder(d=size*sfactor, h=length);
  }
}

module metric_countersunk_cut(
size, // bolt size
length, // cut depth
factor=1.1, // cone oversize factor
sfactor=1.05, // shaft oversize factor
shaft="free", // "free", "threaded", "undersized" or "undersized_hex"
allowance=0, // allowance for thread
test=$preview, // test mode
) {
  translate([0,0,-size*1.05]) union() {
    cylinder(d1=0,d2=size*2*(factor+0.05),h=size*(factor+0.05));
    translate([0,0,-length-size/2])
      metric_shaft_cut(size=size, length=length+size, sfactor=sfactor, shaft=shaft, allowance=allowance, test=test);
  }
}
