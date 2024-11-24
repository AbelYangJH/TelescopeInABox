include <FullAssembly.scad>
Wall = $pri_wall;
Plate = $pri_plate;
CWThick = 20;
CWshaft = 15;
fwidth=get_fwidth(clipbolt, collbolt);
hubdia = fwidth+16;

ShaftODia = CWshaft;
ShaftOThread = CWshaft-$pri_wall*2;
ShaftIThread = CWshaft-$pri_wall*2-0.5;

/* [Hidden] */
isStandalone=false;

difference() {
  union() {
    union() {
      cube([fwidth, hubdia, Plate],center=true);
      cube([hubdia, fwidth, Plate],center=true);
    }
    rsym(4) translate([hubdia/2-Wall/2,0,Plate/2]) cube([Wall, fwidth, Wall],center=true);
    cylinder(d=CWshaft, h=CWThick);
  }
  translate([0,0,-Plate]) metric_shaft_cut(8,CWThick+Plate*2, shaft="threaded");
  translate([0,0,CWThick-1.25]) cylinder(d1=8-get_thread_depth(8)*2,d2=8,h=1.26);
}
