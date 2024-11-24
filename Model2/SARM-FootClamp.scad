include <FullAssembly.scad>
Wall = $sec_wall;
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

union() {
  translate([AuxOuterDia/2+BaseOuterDia/2+Plate,0,0]) {
    difference() {
      union() {
        difference() {
          union() {
            cylinder(d=BaseOuterDia, h=CapLength);
            scale([1,(AuxOuterDia+$pivot_tol*2+Plate*2)/BaseOuterDia,1]) cylinder(d=BaseOuterDia, h=PivotDia+Plate*2);
            translate([0,-Wall/2-Plate,0]) cube([BaseOuterDia/2+12,Plate*2+Wall,CapLength]);
          }
          translate([0,0,-1]) cylinder(d=sec_poledia+$collet_tol*2, h=CapLength+2);
        }
        rsym(12) translate([sec_poledia/2+$collet_tol*2,0,CapLength/2]) hull() translate_zs([0,0,CapLength/2-Wall]) sphere(d=1+$collet_tol,$fn=16);
      }
      translate([0,-Wall/2,-1]) cube([BaseOuterDia/2+14,Wall,CapLength+2]);
      translate([BaseOuterDia/2+6,0,CapLength/2]) rotate([90,0,0])  cylinder(d=4*1.1,h=Plate*3,center=true);
      translate([BaseOuterDia/2+6,Plate,CapLength/2]) rotate([-90,0,0])  metric_nut_cut(4,depth=Plate);
    }
  }

  mirror_dup_y() translate([0,AuxOuterDia/2+$pivot_tol,Plate+PivotDia/2]) {
    difference() {
      union() {
        rotate([-90,0,0]) cylinder(d=(PivotDia+Plate*2)/cos(30),h=Plate,$fn=6);
        translate([0,0,-(Plate+PivotDia/2)]) cube([AuxOuterDia/2+BaseOuterDia/2+Plate,Plate,PivotDia+Plate*2]);
      }
      rotate([-90,0,0]) translate([0,0,-1]) cylinder(d=PivotDia+$pivot_tol*2,h=Plate+2);
    }
  }
}

union() {
  mirror_dup_y() translate([0,AuxOuterDia/2+$pivot_tol*2+Plate,Plate+PivotDia/2]) rotate([-90,0,0]) cylinder(d=(PivotDia+Plate*2)/cos(30),h=$sec_wall,$fn=6);
  
  rotate([0,180,0])  union() {
    difference() {
      union() {
        translate([0,0,-PivotDia/2-Plate]) rotate([90,0,0]) cylinder(d=PivotDia,h=AuxOuterDia+Plate*2+$pivot_tol*2+$sec_wall*2,center=true);
        translate([-AuxOuterDia/2,-AuxOuterDia/2,-CapLength-Wall]) cube([AuxOuterDia,AuxOuterDia,CapLength+Wall]);
      }
      translate([-PoleDia/2-$collet_tol/2,-PoleDia/2-$collet_tol/2,-CapLength-Wall-1]) cube([PoleDia+$collet_tol, PoleDia+$collet_tol, CapLength+1]);
    }
    if (CrushRibs == true) {
      rsym(4) {
        translate([0,0,-Wall-CapLength/2]) {
          translate([PoleDia/2+$collet_tol,0,0]) hull() translate_zs([0,0,CapLength/2-Wall]) sphere(d=1+$collet_tol,$fn=16);
          translate_ys([PoleDia/2+$collet_tol,PoleDia/4,0]) hull() translate_zs([0,0,CapLength/2-Wall]) sphere(d=1+$collet_tol,$fn=16);
        }
      }
    }
  }
}