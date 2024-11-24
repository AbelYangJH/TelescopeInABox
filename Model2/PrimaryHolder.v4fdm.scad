include <multipart.scad>
include <metricparts.scad>
include <symmetry.scad>

//Usage: get_fwidth(clipbolt, collbolt)
// Frame width
function get_fwidth(
clipbolt, // mirror clip bolt size
collbolt, // Collimation bolt size
) = max(clipbolt*3.25+$pri_wall*3,collbolt*2+3*$pri_wall);

//Usage: get_cwidth(clipbolt)
// Vertical bracket radial width
function get_cwidth(
clipbolt, // mirror clip bolt size
) = ceil(clipbolt+$pri_wall*2+get_thread_depth(clipbolt)*3);

//Usage: get_chambersize(pri_mdia, mspace)
// Mirrorbox internal size
function get_chambersize(
mdia, // Mirror diameter
mspace, // Mirror-box spacing
) = mdia;//+mspace*2;

//Usage: get_boxsize(pri_mdia, mspace)
// Mirrorbox external size
function get_boxsize(
mdia, // Mirror diameter
mspace, // Mirror-box spacing
) = get_chambersize(mdia, mspace);

// Mirror box lower distance below mirror base datum
function get_boxlower( 
lbump, // Mirror pad height
cellfloat, // Mirrorcell to lowerframe spacing
fthick, // Frame z-thickness
bthick, // Frame brace height
) = -(-lbump-cellfloat-bthick*2-fthick*2);

// Minimum xy-spacing between mirror and box
function get_mspace(
mdia, // Mirror diameter
mthick, // Mirror thickness
clipthick, // Mirror clip thickness
lbump, // Mirror pad height
cellfloat, // Mirrorcell to lowerframe spacing
fthick, // Frame z-thickness
bthick, // Frame brace height
) = ceil(sin(atan(cellfloat/(mdia/2)))*(mthick+clipthick+$pri_tol*2+lbump+bthick+fthick))+1;

// Pole mounting pad x-position
function get_pad_x(
boxsize, // Mirrorbox nominal size
poledia, // Mounting pole base size
mspace, // Mirror-side spacing
) = boxsize/2-poledia/2-$pri_wall;

// Pole mounting pad y-position
function get_pad_y(
boxsize, // Mirrorbox nominal size
poledia, // Mounting pole base size
mspace, // Mirror-side spacing
) = boxsize/2+poledia/2+mspace/2-$pri_wall;

// Upper cell z-datum
function get_uppercell_z(
lbump, bthick
) = -lbump-bthick;

// Lower cell z-datum
function get_lowercell_z(
lbump, bthick, fthick, cellfloat
) = get_uppercell_z(lbump,bthick)-cellfloat-bthick-fthick;

// Rocker centre z-datum
function get_arc_z(
arcdia, // rocker arc diameter
boxsize, // mirrorbox external size
lower, // z-datum of mirror box bottom
rail_thick, // Rail thickness
) = sqrt(arcdia*arcdia - boxsize*boxsize)/2 +lower -3*rail_thick;



module pri_stats() {
  echo ("Box Dimensions:", get_boxsize(pri_mdia, mspace, boxthick),"x", get_boxsize(pri_mdia, mspace, boxthick), "x", get_chamberheight(pri_mthick, clipthick, lbump, cellfloat, fthick, bthick));
  echo ("Pole Offset: ", get_pole_y(pri_mdia, mspace, boxthick, pri_poledia));
}


module sideclip(
lower, // z-datum offset
cbump, // z-mirror Pad height
clipbolt, // Mirror clip bolt size
collbolt, // Collimation bolt size
zbracepos, // z-mirror pad position
mthick, // Mirror thickness
) {
  fwidth=get_fwidth(clipbolt, collbolt);
  cwidth=get_cwidth(clipbolt);
  difference() {
    union() {
      translate([cbump,-fwidth/2,-lower]) cube(size=[cwidth,fwidth,mthick+lower+$pri_tol]);
      translate([cbump,0,zbracepos*mthick]) rotate([0,-90,0]) hull() {
        translate([0,0,cbump-2]) sphere(r=2);
        translate([0,0,-1]) cylinder(d=fwidth-2*$pri_wall,h=1);
      }
    }
    translate_ys([cbump+cwidth/2, (fwidth/2-clipbolt/2-$pri_wall*1.5),mthick-clipbolt*2.25]) metric_shaft_cut(clipbolt,clipbolt*2.5+$pri_tol*2,shaft="threaded");
  }
}

module topclip(
cbump, // side mirror pad thickness
clipbolt, // Mirror clip bolt size
collbolt, // Collimation bolt size
clipthick, // Top Clip thickness
clipext, // Top Clip overhang
mdia, // Mirror diameter
) {
  fwidth=get_fwidth(clipbolt, collbolt);
  cwidth=get_cwidth(clipbolt);
  difference() {
    translate([0,0,$pri_tol]) linear_extrude(clipthick) 
    intersection() {
      translate([-clipext*2,-fwidth/2]) square([clipext*2+cbump+cwidth,fwidth]);
      translate([4*clipbolt-clipext-(mdia/2 - sqrt(mdia*mdia-4*4*clipbolt*clipbolt)/2),0]) circle(r=4*clipbolt);
    }
    translate_ys([cbump+cwidth/2, (fwidth/2-clipbolt/2-$pri_wall*1.5),-1]) metric_shaft_cut(clipbolt,clipthick+2);
  }
}

module cellbase(
fwidth, // Frame xy width
fthick, // Frame z thickness
bthick, // Frame brace thickness
mdia, // Mirror diameter
rbracepos, // Mirror pad position (radial)
extra, // Extra length beyond mirror
) {
  module base_inner() {
    union() {
      translate_ys([0,rbracepos*(mdia/2)*sin(60),0]) square([rbracepos*mdia*sin(60),fwidth],center=true);
      translate([rbracepos*(mdia/2),0,0]) square([fwidth,rbracepos*mdia],center=true);
      rotate(45) square([mdia+extra*2,fwidth],center=true);
      rotate(-45) square([mdia+extra*2,fwidth],center=true);
    }
  }
  difference(convexity=10) {
    translate([0,0,-fthick]) linear_extrude(fthick+bthick,convexity=20) base_inner();
    if (bthick > 0) {
      minkowski() {
        linear_extrude(1,convexity=20) offset(delta=-$pri_wall-1) base_inner();
        cylinder(r1=0,r2=1,h=bthick+0.01,$fn=4);
      }
    }
  }  
}


// Upper Cell
// Datum: 0,0,-lbump-lthick
module mirrorcell(
mdia, // Mirror diameter
mthick, // Mirror thickness
fthick, // Frame z thickness
bthick, // Brace height
clipbolt, // Clip Bolt size
collbolt, // Collimation Bolt size
lbump, // base mirror pad thickness
cbump, // side mirror pad thickness
rbracepos, // Lower mirror pad position
zbracepos, // Side mirror pad position
cpointpos, // Collimation bolt position
cbolttype="hex", // Collimation bolt type (hex, shc or csk)
) {
  fwidth=get_fwidth(clipbolt, collbolt);
  cwidth=get_cwidth(clipbolt);
  multipart("mirrorcell","red") union() {
    rsym(3) translate([rbracepos*mdia/2,0,0]) hull() {
      translate([0,0,bthick+lbump-2]) sphere(r=2);
      translate([0,0,-1]) cylinder(d=fwidth-2*$pri_wall,h=1);
    }
    rsym(4) rotate(45) translate([mdia/2,0,bthick+lbump]) sideclip(lbump+bthick,cbump,clipbolt,collbolt,zbracepos,mthick);
    difference() {
      cellbase(fwidth,fthick,bthick, mdia, rbracepos, cbump+cwidth);
      rsym(4) rotate(45) translate([cpointpos*mdia/2,0,0]) {
        if (cbolttype == "hex") {
          translate([0,0,-fthick-1]) metric_shaft_cut(collbolt,fthick,shaft="free", sfactor=1.1);
          translate([0,0,-fthick+$pri_plate]) metric_nut_cut(collbolt,depth=fthick,allowance=0.25);
        }
        else if (cbolttype == "shc") {
          translate([0,0,-fthick-1]) metric_shaft_cut(collbolt,fthick,shaft="threaded");
          translate([0,0,-fthick+$pri_plate]) cylinder(r=collbolt,h=fthick);
        }
        else if (cbolttype=="csk") {
          metric_countersunk_cut(collbolt,fthick,shaft="threaded");
        }
        cylinder(d=collbolt*2*1.1,h=bthick);
      }
      translate([0,0,-fthick-0.01]) cylinder($fn=3,r2=0,r1=collbolt*1.5,h=$pri_wall);
    }
  }
}

module lowerbase(
fthick, // Frame thickness
bthick, // Brace thickness
boxsize, // Mirror outer box size
fwidth, // frame width
pole_extra, // Extra width for pole
) {
  module base_inner() {
    union() {
      intersection() {
        union() {
          rotate(45) square([boxsize*sqrt(2),fwidth],center=true);
          rotate(-45) square([boxsize*sqrt(2),fwidth],center=true);
        }
        square([boxsize-fwidth,boxsize+pole_extra*2-fwidth],center=true);
      }
      translate_xs([ boxsize/2-fwidth/2,0,0]) square([fwidth,boxsize+pole_extra*2],center=true);
      translate_ys([ 0,boxsize/2+pole_extra-fwidth/2,0]) square([boxsize,fwidth],center=true);
    }
  }
  difference(convexity=10) {
    translate([0,0,-fthick]) linear_extrude(fthick+bthick,convexity=20) base_inner();
    if (bthick > 0) {
      minkowski() {
        linear_extrude(1,convexity=20) offset(delta=-$pri_wall-1) base_inner();
        cylinder(r1=0,r2=1,h=bthick+0.01,$fn=4);
      }
    }
  }
}

module shaftsupport(od,id,layer=0.3) {
  dd1=max(id/sin(30),od);
  translate([0,0,-0.01]) cylinder(d=dd1,h=layer+0.01,$fn=3);
  translate([0,0,layer-0.01]) intersection() {
    cylinder(d=dd1,h=layer+0.01,$fn=3);
    rotate(60) cylinder(d=id/sin(30),h=layer+0.01,$fn=3);
  }
}

module lowercell(
mdia, // Mirror diameter
mspace, // Mirror-Box spacing
fthick, // Frame z thickness
bthick, // Brace height
clipbolt, // Clip Bolt size
collbolt, // Collimation Bolt size
basebolt, // Lower cell bolt size
cellfloat, // Lowercell-uppercell nominal spacing
cpointpos, // Collimation bolt position
poledia, // Upper Pole Diameter
) {
  fwidth=get_fwidth(clipbolt, collbolt);
  boxsize=get_boxsize(mdia, mspace);
  cprad=cpointpos*mdia/2;
  pad_x = get_pad_x(boxsize, poledia, mspace);
  pad_y = get_pad_y(boxsize, poledia, mspace);
  
  pole_extra=pad_y-pad_x; // Extra width for pole
  pad_dia=poledia+$pri_wall; // Pole pad diameter
  multipart("lowercell","green") 
  union() {
    difference() {
      union() {
        lowerbase(fthick,bthick,boxsize,fwidth,pole_extra);
        mirror_dup_y() mirror_dup_x() translate([pad_x,pad_y,-fthick]) union() {
          cylinder(d=pad_dia,h=fthick+bthick);
          cube([pad_dia/2,pad_dia/2,fthick+bthick]);
        }
        mirror_dup_y() rotate(135) translate([cprad,0,bthick/2])cube([13+$pri_wall*2,fwidth-$pri_wall,bthick],center=true);
        mirror_dup_y() rotate(45) translate([cprad,0,bthick/2]) cube([collbolt*3+4+$pri_wall*2,fwidth-$pri_wall,bthick],center=true);
      }
      mirror_dup_y() rotate(135) translate([cprad,0,-fthick-0.01]) {
        metric_shaft_cut(collbolt,(fthick+bthick)+2,sfactor=1.3);
        cylinder(d=12.5,h=fthick/2);
        translate([0,0,fthick/2]) shaftsupport(12.5,collbolt*1.3,layer=0.3);
      }
      mirror_dup_y() rotate(45) translate([cprad,0,-fthick]) {
        hull() {
          translate_xs([1,0,-1]) metric_shaft_cut(collbolt,(fthick+bthick)+2,sfactor=1.2);
        }
        rotate([0,0,90]) rotate([90,0,0]) translate([0,0,-(collbolt*3+4)/2]) linear_extrude(collbolt*3+4) { polygon([[-(fwidth/2-$pri_wall),-0.01],[(fwidth/2-$pri_wall),-0.01],[0,(fthick+bthick-1)]]); }
      }
      mirror_dup_y() mirror_dup_x() translate([pad_x,pad_y,-fthick-1]) metric_shaft_cut(basebolt,bthick+fthick+2,shaft="free");
    }
    hull() {
      translate([0,0,bthick+cellfloat-collbolt*1.25/2]) sphere(d=collbolt*1.25,$fn=48);
      cylinder(d1=fwidth-2*$pri_wall,d2=collbolt*1.25,h=bthick+cellfloat-collbolt*1.25/2,$fn=48);
    }
  }
}

module rocker(
altmin, // minimum altitude
rail_dia, // track diameter
rail_tab, // probably at least the radius of a 608
rail_width, // overall width
rail_thick, // track thickness
basebolt, // Mounting bolt size
bolt_x, // Mounting Bolt x-datum
boxsize, // Mirrorbox outer size
rail_height, // Rail height
boxbase, // Mirrorbox base datum
) {
  arc_z = get_arc_z(rail_dia,boxsize,boxbase,rail_thick);
  basearc = 2*asin(boxsize/rail_dia);
  fullarc = basearc+(90-altmin);
  pad_width=ceil(get_hex_major(basebolt)+$pri_wall*3);
  module rotate_arc() {
    translate([0,0,arc_z]) rotate([90,0,0]) children();
  }
  multipart("rocker","orange") {
    difference() {
      rotate_arc() linear_extrude(rail_width,center=true,convexity=20) difference() {
        union() {
          difference() {
            circle(d=rail_dia);
            difference() {
              pxd = rail_dia/2-bolt_x;
              circle(d=rail_dia-rail_thick*2);
              translate([bolt_x,boxbase-arc_z-pxd/2]) square([pad_width,pxd],center=true);
              translate([-bolt_x-pxd/2,boxbase-arc_z-pxd/2]) square([pxd+pad_width,pxd],center=true);
            }
          }
          difference() {
            union() {
              translate([-boxsize/2-rail_thick,boxbase-arc_z]) square([rail_thick,rail_height*2]);
              circle(d=rail_dia-rail_height*2+rail_thick*2);
            }
            circle(d=rail_dia-rail_height*2);
          }
          for (a=[0:30:359]) rotate(a) translate([rail_dia/2-rail_height/2,0]) square([rail_height-rail_thick,rail_thick],center=true);
          rotate(90+altmin+basearc/2) 
            translate([rail_dia/2-rail_height+rail_thick/2,0]) square([rail_height-rail_thick+rail_tab,rail_thick]);
          rotate(-90+basearc/2)
            translate([rail_dia/2-rail_height+rail_thick/2,0]) square([rail_height-rail_thick+rail_tab,rail_thick]);
        }
        rotate((altmin+basearc/2)) square( [rail_dia,rail_dia]);
        rotate((-90+basearc/2)) translate([0,rail_thick]) square( [rail_dia,rail_dia]);
        translate([-boxsize/2,boxbase-arc_z]) square([rail_dia, rail_dia]);
      }
      translate_xs([bolt_x,0,boxbase]) union() {
        translate([0,0,-rail_thick*2-get_hex_thick(basebolt)]) metric_shaft_cut(basebolt,rail_thick*2+get_hex_thick(basebolt)+2);
        translate([0,0,-rail_thick-get_hex_thick(basebolt)-1])
          hull() {
          rotate(90) metric_nut_cut(basebolt,add_depth=1,allowance=0.5);
          translate([0,2*rail_width,0]) rotate(90) metric_nut_cut(basebolt,add_depth=1,allowance=0.5);
        }
      }
    }
  }
}

module AzimuthBlock(
rail_dia, // outer diameter
rail_width, // xy-width
rail_thick, // Height of lower rail
rail_x, // x-displacement of block centre
rail_y, // y-displacement of block centre
block_x, // x-size of block
fthick, // frame thickness
fwidth, // frame width
) {
  multipart("azimuth","blue") {
    base_width = ceil(max(rail_width+$pri_wall*3, fwidth));
    block_z = rail_dia+rail_thick/2-sqrt(rail_dia*rail_dia-rail_x*rail_x*4);
    base_z = -rail_dia/2-fthick;
    bpthick=5+$pri_wall;
    echo ("base_lower", base_z-bpthick);
    difference() {
      union() {
        mirror_dup_y() mirror_dup_x() difference() {
          union() {
            translate([rail_x-block_x/2, rail_y-base_width/2, -rail_dia/2-fthick]) cube([block_x, base_width, block_z]);
          }
          translate([0,rail_y,0]) rotate([90,0,0]) cylinder(d=rail_dia, h=rail_width+$pri_tol*2, center=true);
          translate([0,rail_y,0]) rotate([90,0,0]) cylinder(d=rail_dia-rail_thick*1.5, h=base_width+2, center=true);
        }
        translate([0,0,base_z-bpthick]) linear_extrude(bpthick) difference() {
          union() {
            circle(d=51+fthick*3);
            mirror_dup_x() translate([rail_x+block_x/2-fthick*0.75,0]) square([fthick*1.5,rail_y*2],center=true);
            dx=rail_x+block_x/2-fthick*1.5; dy=rail_y-base_width/2;
            mirror_dup_x() rotate(atan(dx/dy)) square([fthick*1.5,sqrt(dx*dx+dy*dy)*2+1],center=true);
            mirror_dup_y() translate([0, rail_y]) square([rail_x*2+block_x,base_width],center=true);
          }
          circle(d=51);
        }
      }
    }
  }
}


//// Vitamin parts
module primarymirror(mdia, mthick) {
//  multipart("mirror","lightblue",0.5) 
  %cylinder(d=mdia,h=mthick);
}


module DummyPole(poledia1, poledia2=undef) {
  if (is_undef(poledia2)) 
    %cylinder(d=poledia1,h=100);
  else {
    %cylinder(d=poledia1,h=50);
    %cylinder(d=poledia2,h=100);
  }
}



module PrimaryHolder() {
/* [Options] */
// Show mirror
showmirror=true;
// Test Mode
$test=false;
current_part="ALL";

/* [Hidden] */
$fa=2.5;
$fs=0.5;
isStandalone=true;

/* [General Parameters] */
// Wall Thickness (mm)
$pri_wall=1.8;
// Plate Thickness (mm)
$pri_plate=3;
// General Tolerance (mm)
$pri_tol=0.5;

/* [Primary Mirror] */
// Mirror Diameter
pri_mdia=112.5; // [60:0.1:300]
// Mirror Thickness
pri_mthick=16; // [1:0.1:100]
// Mirror Side Brace Position (fraction of mirror thickness)
zbracepos=0.475; // [0:0.001:1] 
// Should be at z-centre of mass of mirror
// Mirror Bottom Brace Position (fraction of mirror radius)
rbracepos=0.6; // [0:0.001:1] 
// Ideally should follow PLOP output, but not much difference for small mirrors
// Collimation Screw Position (fraction of mirror radius)
cpointpos=0.8; // [0:0.001:1] 
// collimation screw position
// Sideclip Bump Height
cbump=2; // [0:0.1:10]
// Underbump Height
lbump=3; // [0:0.1:10]

/* [Primary Mounting Frame] */
// Cell to lower box spacing
cellfloat=5; // [0:0.1:50]
// Mirror Clip Thickness
clipthick=3; // [0:0.1:10]
// Mirror Clip Overhang
clipext=4; // [0:0.1:10]
// Sideclip Bolt size
clipbolt=3; // [2,3,4,5,6,8,10,12]
// Collimation Bolt Size
collbolt=4; // [2,3,4,5,6,8,10,12]
// Base Mounting Bolt Size
basebolt=6; // [2,3,4,5,6,8,10,12]

// Base Frame Thickness
fthick=6.0; // [0:0.1:20]
// Brace Height
bthick=3.0; // [0:0.1:20]

// Pole diameter
pri_poledia=26; // [5:0.1:50]
// Diameter measured at base

/* [Altitude Bearing] */
// Rocker minimum altitude
altmin=30; // [0:1:90]

// Rocker Outer rail diameter
rail_dia=180; // [100:0.1:500]

// Rocker Rail individual z-thickness
rail_thick=5; // [1:0.1:20]
// Rocker Rail Full z-thickness
rail_height=20; // [5:0.1:100]
// Rocker Rail retention tab protrusion
rail_tab=10; // [0:0.1:20]

// Rocker Rail y-width
rail_width=round(get_fwidth(clipbolt, collbolt));

  mspace = get_mspace(pri_mdia, pri_mthick, clipthick, lbump, cellfloat, fthick, bthick);
  uppercell_z = get_uppercell_z(lbump,bthick);
  lowercell_z = get_lowercell_z(lbump,bthick,fthick,cellfloat);
  boxsize = get_boxsize(pri_mdia, mspace);
  pole_x = get_pad_x(boxsize, pri_poledia, mspace);
  pole_y = get_pad_y(boxsize, pri_poledia, mspace);
  
  multipart("clip","pink") rsym(4) rotate(45) translate([pri_mdia/2,0,pri_mthick]) {
    topclip(cbump,clipbolt,collbolt,clipthick,clipext,pri_mdia);
  }
  translate([0,0,uppercell_z])
    mirrorcell(pri_mdia, pri_mthick,fthick,bthick,clipbolt,collbolt,lbump,cbump,rbracepos,zbracepos,cpointpos);
  translate([0,0,lowercell_z])
    lowercell(pri_mdia,mspace,fthick,bthick,clipbolt,collbolt,basebolt,cellfloat,cpointpos, pri_poledia);
  if (showmirror == true) {
    primarymirror(pri_mdia, pri_mthick);
    mirror_dup_x() mirror_dup_y() translate([pole_x, pole_y,lowercell_z]) DummyPole(pri_poledia);
  }
  
  
  mirror_dup_y() translate([0,pole_y,0])
    rocker(altmin, rail_dia, rail_tab, rail_width, rail_thick, basebolt, pole_x, boxsize, rail_height, lowercell_z-fthick);
  translate([0,0,get_arc_z(rail_dia,boxsize,lowercell_z-fthick,rail_thick)])
    AzimuthBlock(rail_dia, rail_width, rail_thick, pole_x, pole_y, pri_poledia, fthick, get_fwidth(clipbolt, collbolt));
  }


PrimaryHolder();
