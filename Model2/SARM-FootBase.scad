include <FullAssembly.scad>

Wall = $sec_wall;
FootSize=50;
FootBolt = 4;
Plate = 2.4;
$collet_tol = $sec_tol;
CapLength=20;
PoleDia = 15;
CrushRibs = true;
BaseOuterDia = sec_poledia+Plate*2+$collet_tol*2;
AuxOuterDia = PoleDia+Plate*2+$collet_tol*2;
PivotDia = Plate*2;
$pivot_tol=0.5;

/* [Hidden] */
isStandalone=false;

PivotHeight = floor(AuxOuterDia/sqrt(2));
translate([0,0,Plate/2]) cube([FootSize,FootSize,Plate],center=true);
mirror_dup_y() 
translate([0,AuxOuterDia/2+$pivot_tol,0]) {
  difference() {
    hull() {
      translate([0,0,PivotHeight]) rotate([-90,0,0]) cylinder(d=FootBolt+Plate*2,h=Plate);
      translate([0,Plate/2,Plate/2]) cube([FootSize,Plate,Plate],center=true);
    }
    translate([0,0,PivotHeight]) rotate([-90,0,0])translate([0,0,-1]) metric_shaft_cut(FootBolt,Plate+2);
  }
}

color("lightgreen") translate([FootSize/2+AuxOuterDia/2+5,0,CapLength+Wall+FootBolt/2+Wall]) rotate([0,180,0])
union() {
  difference() {
    hull() {
      rotate([-90,0,0]) cylinder(d=FootBolt+Plate*2,h=AuxOuterDia,center=true);
      translate([-AuxOuterDia/2,-AuxOuterDia/2,FootBolt/2+Wall]) cube([AuxOuterDia,AuxOuterDia,CapLength+Wall]);
    }
    translate([0,-AuxOuterDia/2-1,0]) rotate([-90,0,0]) metric_shaft_cut(FootBolt,AuxOuterDia+2);
    translate([-(PoleDia+$collet_tol)/2,-(PoleDia+$collet_tol)/2,FootBolt/2+Wall]) cube([PoleDia+$collet_tol, PoleDia+$collet_tol, CapLength+Wall+1]);
  }
  if (CrushRibs == true) {
    rsym(4) {
      translate([0,0,FootBolt/2+Wall+CapLength/2]) {
        translate([PoleDia/2+$collet_tol,0,0]) hull() translate_zs([0,0,CapLength/2-Wall]) sphere(d=1+$collet_tol,$fn=16);
        translate_ys([PoleDia/2+$collet_tol,PoleDia/4,0]) hull() translate_zs([0,0,CapLength/2-Wall]) sphere(d=1+$collet_tol,$fn=16);
      }
    }
  }  
}
