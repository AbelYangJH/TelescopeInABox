include <FullAssembly.scad>
brim=false;

/* [Hidden] */
isStandalone=false;

union() {
  translate([0,0,pole_caplength+$sec_wall])
        ColletJoint(sec_poledia, $sec_wall, pole_colletpitch, pole_colletlength, 5+pole_caplength-pole_colletlength, sec_poledia+$sec_plate*2, pole_caplength, extra_tol=0.2);
  if (brim) difference() {
    cylinder(d=sec_poledia+($sec_wall+5)*2,h=0.3);
    cylinder(d=sec_poledia+$sec_wall,h=1,center=true);
  }
}