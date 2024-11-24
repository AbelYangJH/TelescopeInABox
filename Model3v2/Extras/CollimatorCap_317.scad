tol=0.2;
barrel=31.7;
flange=35;
wall=1.6;
base=2;
bwall=1.4;
fheight=12;
theight=5;
flare=10;
ap=2;
fp=2*(theight)*tan(flare/2);

tube=true;

fillet=2;

$fa=1;$fs=0.5;
ri=(barrel-tol)/2-wall;

rotate_extrude()
union() {
  
  translate([ri,0]) square([wall,fheight+(base-bwall)]);
  difference() {
    translate([ri-fillet,0]) square(fillet);
    translate([ri-fillet,fillet]) circle(r=fillet,$fn=36);
  }
  if (tube) {
    translate([ap/2+wall,-bwall]) square([flange/2-ap/2-wall,bwall]);
    polygon([[ap/2,-bwall],[ap/2+fp/2,theight-bwall],[ap/2+fp/2+wall,theight-bwall],[ap/2+fp/2+wall,-bwall]]);
    difference() {
      translate([ap/2+fp/2+wall,0]) square(fillet);
      translate([ap/2+fp/2+wall+fillet,fillet]) circle(r=fillet,$fn=36);
    }
  }
  else {
    translate([ap/2,-bwall]) square([flange/2-ap/2,bwall]);
  }
  translate([ri,-bwall]) square([flange/2-ri,base]);
}
