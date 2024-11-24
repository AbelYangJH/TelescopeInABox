use <metricparts.scad>
use <symmetry.scad>
$fa=2;
$fs=1;
PoleDia = 20;
wall = 2.4;
width = 15;
length = 30;
angle = 30;
cut = 1.25;
flex = 0.5;

CurveDia = PoleDia-flex;

union() {
  rotate(90-angle) rotate_extrude(angle=180+angle*2) {
    translate([CurveDia/2,0,0]) square([wall,length]);
  }

  mirror_dup_y() translate([(5+wall+CurveDia/2)*sin(angle),(5+wall+CurveDia/2)*cos(angle),0]) {
    rotate(-(90+angle)) rotate_extrude(angle=90) translate([5,0,0]) square([wall,length]);
    rotate(-angle) translate([5+wall/2,0,0]) cylinder(d=wall,h=length,$fn=16);
  }

  difference() {
    translate([-PoleDia/2-cut*4,-width/2,0]) cube([PoleDia/2+cut*4, width,length]);
    translate([0,0,-1]) cylinder(d=PoleDia+wall,h=length+2);
    translate_ys([-PoleDia/2-cut*2,width/2,-1]) cylinder(d=2*cut*sqrt(2),h=length+2,$fn=4);
  }
}
