use <metricparts.scad>
use <symmetry.scad>
$fn=48;
$tol=0.25;

outer=20;
inner=outer-2;
size=4;
wall=1.8;
shaft=12.5+wall*2;
lobes=6;
FullHeight=ceil(max(wall,get_hex_thick(size)+1)+wall);
ldia=outer/2.5;
KnobHeight=ceil(get_hex_thick(size)+1);


module CollLock() {
  difference() {
    union() {
      hull() {
        cylinder(d=shaft,h=1);
        translate([0,0,FullHeight-KnobHeight/2]) hull() {
          cylinder(d=outer,h=KnobHeight-2,center=true);
          cylinder(d=outer-2,h=KnobHeight,center=true);
        }
      }
    }
    translate([0,0,-shaft-1]) metric_shaft_cut(size,FullHeight+shaft+2);
    translate([0,0,wall+0.6]) metric_nut_cut(size,depth=FullHeight,allowance=$tol);
    translate([0,0,wall+0.6])rotate([180,0,0]) shaftsupport_nut(size,layer=0.3,allowance=$tol);
  }
  translate([0,0,-wall*1.5]) difference() {
    cylinder(d=shaft,h=wall*1.5);
    translate([0,0,-1]) cylinder(d=12.5,h=FullHeight);
  }
}

rotate([180,0,0]) CollLock();
