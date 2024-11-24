use <metricparts.scad>
use <symmetry.scad>
$fn=48;
$tol=0.25;

outer=20;
inner=outer-2;
size=4;
wall=2;
shaft=10;
lobes=6;
FullHeight=ceil(max(wall,get_hex_thick(size)+1)+wall);
ldia=outer/2.5;
KnobHeight=ceil(get_hex_thick(size)+1);


module CollKnob() {
  difference() {
    union() {
      sphere(d=shaft);
      hull() {
        cylinder(d=shaft,h=1);
        translate([0,0,FullHeight-KnobHeight/2]) hull() {
          cylinder(d=inner,h=KnobHeight-2,center=true);
          cylinder(d=inner-2,h=KnobHeight,center=true);
        }
      }
      translate([0,0,FullHeight-KnobHeight/2]){
        rsym(lobes) translate([outer/2-ldia/2,0,0]) hull() {
          cylinder(d=ldia,h=KnobHeight-2,center=true);
          cylinder(d=ldia-2,h=KnobHeight,center=true);
        }
      }
    }
    translate([0,0,-shaft-1]) metric_shaft_cut(size,FullHeight+shaft+2);
    translate([0,0,wall+0.6]) metric_nut_cut(size,depth=FullHeight,allowance=$tol);
    translate([0,0,wall+0.6])rotate([180,0,0]) shaftsupport_nut(size,layer=0.3,allowance=$tol);
  }
}

rotate([180,0,0]) CollKnob();
