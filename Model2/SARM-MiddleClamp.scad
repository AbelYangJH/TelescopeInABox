include <FullAssembly.scad>
poledia=sec_poledia;
height=45;
clampbolt=4;

/* [Hidden] */
isStandalone=false;

  tab_x = get_sec_clamp_tab(clampbolt);
  clamp_x = get_sec_clamp_x(pole_x, poledia, tab_x);
  union() {
    difference() {
      union() {
        translate([0,poledia/8+$sec_wall/2,0]) cube([12,poledia/4,height],center=true);
        translate_xs([pole_x,0,0]) cylinder(d=poledia+$sec_plate*2+$collet_tol*2,h=height,center=true);
        mirror_dup_z() hull() {
          translate([0,poledia/8+$sec_wall/2,-height/2+poledia/8]) cube([pole_x*2,poledia/4,poledia/4],center=true);
          translate([0,$sec_wall/2,-height/2+poledia/2-$sec_wall]) cube([pole_x*2,$sec_wall,poledia/4],center=true);
        }
        mirror_dup_x() {
          translate([-pole_x,0,0]) cylinder(d=poledia+$sec_plate*2,h=height,center=true);
          translate([-pole_x,-$sec_plate-$sec_wall/2,-height/2]) cube([poledia/2+tab_x+$sec_plate,$sec_plate,height]);
          translate([-pole_x+poledia/2+tab_x+$sec_plate,-$sec_plate/2-$sec_wall/2,0]) cylinder(d=$sec_plate,h=height,center=true,$fn=32);
        }
        translate([0,$sec_plate/2+$sec_wall/2,0]) cube([pole_x*2,$sec_plate,height],center=true);
      }
      translate_xs([pole_x,0,0]) cylinder(d=poledia+$collet_tol*2,h=height+2,center=true);
      translate([0,0,0]) cube([pole_x*2,$sec_wall,height+2],center=true);
      translate_xs([clamp_x,poledia/2,0]) rotate([90,0,0]) metric_shaft_cut(clampbolt,sec_poledia);
      translate_xs([clamp_x,$sec_plate,0]) rotate([-90,0,0]) metric_nut_cut(clampbolt, depth=$sec_plate*2);
    mirror_dup_z() translate([0,0,15]) rotate([90,0,0]) cylinder(d=6.5,h=poledia,center=true);
    }
    mirror_dup_x() translate([pole_x,0,0]) rotate(360/24) rsym(12) translate([poledia/2+$collet_tol,0,0]) hull() translate_zs([0,0,height/2-$sec_wall])sphere(d=1,$fn=16);
  }
