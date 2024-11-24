use <RotatingHelical.v2.scad>
//use <KelvinClamp.v3.scad>
use <MaxwellClamp.v3.scad>
use <PrimaryHolder.v4fdm.scad>
use <Collet.scad>

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

//// PRIMARY ////

/* [General Parameters] */
// Loaded Plate Thickness (mm)
$pri_plate=3; // [0.1:0.1:5]
// Wall Thickness (mm)
$pri_wall=1.8; // [0.1:0.1:5]
// General Tolerance (mm)
$pri_tol=0.5; // [0:0.01:2]

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
clipbolt=3; // [2:M2,3:M3,4:M4,5:M5,6:M6,8:M8,10:M10]
// Collimation Bolt Size
collbolt=4; // [2:M2,3:M3,4:M4,5:M5,6:M6,8:M8,10:M10]
// Base Mounting Bolt Size
basebolt=6; // [2:M2,3:M3,4:M4,5:M5,6:M6,8:M8,10:M10,12:M12]

// Base Frame Thickness
fthick=8.0; // [0:0.1:20]
// Brace Height
bthick=0.0; // [0:0.1:20]

// Pole diameter
pri_poledia=26; // [5:0.1:50]
// Diameter measured at base

/* [Altitude Bearing] */
// Rocker minimum altitude
altmin=20; // [0:1:90]

// Rocker Outer rail diameter
rail_dia=200; // [100:0.1:500]

// Rocker Rail individual z-thickness
rail_thick=5; // [1:0.1:20]
// Rocker Rail Full z-thickness
rail_height=20; // [5:0.1:100]
// Rocker Rail retention tab protrusion
rail_tab=10; // [0:0.1:20]

// Rocker Rail y-width
rail_width=round(get_fwidth(clipbolt, collbolt));


//// SECONDARY ////

/* [General Parameters] */
// Loaded Plate Thickness
$sec_plate = 3; // [0.1:0.1:10]
// General Wall Thickness
$sec_wall = 1.8; // [0.1:0.1:10]
// Tolerance Allowance
$sec_tol = 0.25; // [0.0:0.01:10]
// General Fillet
$sec_fil = 1.2; // [0.0:0.1:10]
// Collet Joint Tolerance
$collet_tol = 0.25; // [0.0:0.01:10]

/* [Secondary Mirror] */
// Mirror Minor Axis
sec_mdia = 28; // [10:0.1:120]
// Mirror Thickness
sec_mthick = 4; // [1:0.1:50]
// Mirror-pad spacing
sec_mpad_space = 2; // [0:0.1:10]
// Primary mirror f-ratio
pri_fratio = 8; // [1:0.01:20]

/* [Secondary Mounting Frame] */

// Mirror Attachment type
secondaryattachment="pad"; // [cap, pad]

// Tilt Adjustment Bolt auto offset
toffsetauto = true;
// Tilt Adjustment Bolt offset
tadjustoffset=11; // [5:0.1:60]
// Tilt Plate Spacing
tspacing = 2.5; // [1:0.1:30]

// Mirror pad is combined with endplate?
unibodypad=true;

// Tilt plate is combined with topplate?
unibodytop=true;

// Secondary holder auto diameter
secdiaauto=true;
// Secondary holder diameter
sec_dia=28; // [10:0.1:120]

// Adjustment ball diameter
ball=5; // [1:0.05:30]
// Adjustment notch depth
cut=0.5; // [0.1:0.05:10]

// Adjustment Bolt size
adjustbolt=3; // [2:M2,3:M3,4:M4,5:M5,6:M6,8:M8,10:M10]
// Central Bolt size
centralbolt=4; // [2:M2,3:M3,4:M4,5:M5,6:M6,8:M8,10:M10]
// Clamp Bolt size
clampbolt=3; // [2:M2,3:M3,4:M4,5:M5,6:M6,8:M8,10:M10]

/* [Primary-Secondary Interface] */
// Pole diameter
sec_poledia=20; // [5:0.1:50]

// Stalk/Cap Height
stalkheight=12; // [1:0.1:70]

// Pole Collet Engagement Length
pole_colletlength=20; // [1:0.1:50]

// Pole Collet screw pitch
pole_colletpitch=2; // [1:0.1:5]

// Pole Cap Length
pole_caplength=30; // [1:0.1:70]


//// FOCUSER ////
/* [General Parameters] */
// Loaded Plate Thickness
$foc_plate=3; // [0.1:0.1:10]
// Wall thickness
$foc_wall=1.8; // [0:0.1:5]
// General allowance
$foc_tol=0.25; // [0:0.01:2]

/* [Focuser Parameters] */
// Focuser inner diameter
foc_inner=32; // [15:0.1:120]
// Focuser travel
foc_maxtravel=30; // [15:0.1:120]

// Helicoid Thread pitch
helicoid_thread=2; // [0.1:0.01:4]
// Helicoid Thread starts
helicoid_tstarts=4;
// Helicoid grip length
helicoid_length=15; // [1:0.1:20]
// Locking thread pitch
baselock_thread=1; // [0.1:0.01:2]
// Locking thread length
baselock_length=3; // [1:0.1:20]

/* [Focuser Mounting Plate] */
// Clamp flange width
flange=7; // [1:0.1:20]
// Clamp flange height
fheight=10; // [1:0.1:20]
// Locking screw size
lockscrew=3; // [2:M2,3:M3,4:M4,5:M5,6:M6]


// Primary Derived Parameters
mspace = get_mspace(pri_mdia, pri_mthick, clipthick, lbump, cellfloat, fthick, bthick);
uppercell_z = get_uppercell_z(lbump,bthick);
lowercell_z = get_lowercell_z(lbump,bthick,fthick,cellfloat);
boxsize = get_boxsize(pri_mdia, mspace);
pole_x = get_pad_x(boxsize, pri_poledia, mspace);
pole_y = get_pad_y(boxsize, pri_poledia, mspace);


// Primary intergration parts

module PoleBase(
OuterDia, // Outer Diameter
InnerDia, // Inner Diameter
CapLength, // Engagement Length
PoleBolt, // Bolt Size
rdia=1.25, // Crush Rib Nub diameter
) {
  base_length = $pri_plate+get_hex_thick(PoleBolt)+1;
  full_length = CapLength+base_length;
  union() {
    difference() {
      cylinder(d=OuterDia,h=full_length);
      translate([0,0,base_length]) cylinder(d=InnerDia+$tol,h=full_length);
      translate([0,0,-1]) metric_shaft_cut(PoleBolt,$pri_plate+2);
      translate([0,0,$pri_plate]) metric_nut_cut(PoleBolt,add_depth=2);
    }
    translate([0,0,base_length+CapLength/2]) {
      rsym(12) translate([InnerDia/2+$tol/2,0,0]) {
        hull() translate_zs([0,0,-CapLength/2+$pri_plate]) sphere(d=rdia,$fn=16);
      }
    }
    translate([0,0,full_length/2]) {
      rsym(18) translate([OuterDia/2,0,0]) {
        hull() translate_zs([0,0,-full_length/2+$pri_plate*2]) sphere(d=rdia,$fn=16);
      }
    }
  }
}

module BaseKnob(
OuterDia, // Outer Diameter
PoleBolt, // Bolt Size
lobes = 6, //Number of lobes
) {
  FullHeight=ceil(max($pri_wall*2,get_hex_thick(PoleBolt)+1)*1.5+$pri_wall);
  KnobHeight=ceil(get_hex_thick(PoleBolt)+1);
  ldia=OuterDia/2.5;
  difference() {
    hull() {
      cylinder(d=OuterDia*0.8,h=1);
      translate([0,0,FullHeight-KnobHeight/2]){
        rsym(lobes) translate([OuterDia/2-ldia/2,0,0]) {
          cylinder(d=ldia,h=KnobHeight-2,center=true);
          cylinder(d=ldia-2,h=KnobHeight,center=true);
        }
      }
    }
    translate([0,0,-1]) metric_shaft_cut(PoleBolt,FullHeight+2);
    translate([0,0,$pri_wall+2]) metric_nut_cut(PoleBolt,depth=FullHeight);
  }
}

// Main Primary Assembly
module PrimaryHolder() {
  multipart("clip","pink") rsym(4) rotate(45) translate([pri_mdia/2,0,pri_mthick]) {
    topclip(cbump,clipbolt,collbolt,clipthick,clipext,pri_mdia);
  }
  translate([0,0,uppercell_z])
    mirrorcell(pri_mdia, pri_mthick,fthick,bthick,clipbolt,collbolt,lbump,cbump,rbracepos,zbracepos,cpointpos);
  translate([0,0,lowercell_z])
    lowercell(pri_mdia,mspace,fthick,bthick,clipbolt,collbolt,basebolt,cellfloat,cpointpos, pri_poledia);
  if (showmirror == true) {
    primarymirror(pri_mdia, pri_mthick);
  }
  mirror_dup_x() translate([pole_x, pole_y,lowercell_z]) PoleBase(pri_poledia, sec_poledia, pole_caplength, basebolt, $tol=$sec_tol);
  mirror_dup_x() translate([pole_x,-pole_y,lowercell_z]) BaseKnob(pri_poledia, basebolt);

  mirror_dup_y() translate([0,pole_y,0]) rocker(altmin, rail_dia, rail_tab, rail_width, rail_thick, basebolt, pole_x, boxsize, rail_height, lowercell_z-fthick);
  translate([0,0,get_arc_z(rail_dia,boxsize,lowercell_z-fthick,rail_thick)]) AzimuthBlock(rail_dia, rail_width, rail_thick, pole_x, pole_y, pri_poledia, fthick, get_fwidth(clipbolt, collbolt));
  echo ("arc_z", get_arc_z(rail_dia,boxsize,lowercell_z-fthick,rail_thick));
}

// Focuser Derived Parameters
inner_dia = get_outertube_innerdia(foc_inner, baselock_thread, helicoid_thread);
inner_outerdia = inner_dia+$sec_wall*2;
outer_innerdia = inner_outerdia+$sec_wall*2;
outer_dia = outer_innerdia+$sec_plate*2;
lower_z = outer_dia/2+stalkheight;

// Main Focuser Assembly
module focuser() {
  innertube(foc_inner, foc_maxtravel, helicoid_length, helicoid_thread, helicoid_tstarts, baselock_thread, baselock_length, fheight, flange, lockscrew);

  translate([0,0,helicoid_length+$foc_plate]) 
  Focuser_ActiveLock($foc_plate*1.5, foc_inner, helicoid_thread, helicoid_tstarts, baselock_thread, flange);
}

// Secondary Derived Parameters
dia = get_dia(secdiaauto,secondaryattachment,sec_mdia,sec_dia);
toffset = get_toffset(toffsetauto,adjustbolt,centralbolt,dia,tadjustoffset);
dz_mirror = get_dz_mirror(sec_mthick,sec_mpad_space,secondaryattachment);
dz_pad = get_dz_pad(sec_mdia, dia, cut, unibodypad);
_tspacing = get_tspacing(ball, cut, tspacing);
dz_tilt = get_dz_tilt(_tspacing, adjustbolt, unibodypad);
dz_aplate = get_dz_aplate(adjustbolt, unibodytop);
moffset = get_mirror_offset(sec_mdia,pri_fratio);
zsoffset = round(moffset);

// Secondary Clamp Bolt x-datum
function get_sec_clamp_x(
pole_x, // Pole x-datum
poledia, // pole diameter at secondary clamp
tab_x, // Clamp tab width
) = pole_x-poledia/2-$sec_plate-tab_x/2;

// Secondary clamp tab extension
function get_sec_clamp_tab(
clampbolt, // Clamp bolt size
) = get_hex_major(clampbolt)+$sec_plate;

// Secondary spider/top plate
module spider(
dia, // plate diameter
toffset, // tilt offset
cut, // ball cut depth
ball, // ball radius
adjustbolt, // Adjustment bolt
centralbolt, // Central bolt
stalkheight, // Stalk z size
unibodytop, // Is the tilt plate combined with top plate?
spiderwidth=$sec_wall, // Spider rib width
tilt_angle=30, // z-rotation adjustment angle
) {
  multipart("tiltplate", "lightgreen") union() {
    // Full Assembly mods
    dy = pole_y+moffset;
    rdiff = dia/2-sec_poledia/2-$sec_plate;
    sdiag = sqrt(dy*dy+pole_x*pole_x);
    spa = atan(pole_x/dy) - atan(rdiff/sdiag);
    drx = sqrt(rdiff*rdiff+sdiag*sdiag);
    // spider
    linear_extrude(stalkheight,convexity=10) union() {
      mirror_dup_x() difference() {
        union() {
          translate([-(dia/2)*cos(spa),-dia/2*sin(spa)]) rotate(spa) square([spiderwidth, drx]);
          translate([0,dia/2]) rotate(spa) translate([-spiderwidth,-spiderwidth]) square([spiderwidth, drx-dia/2]);
        }
        translate([-pole_x, dy]) circle(d=sec_poledia+$sec_plate);
        translate([0,dy+sec_poledia/2-spiderwidth*1.5/2]) square([pole_x*2,spiderwidth*1.5],center=true);
        circle(d=dia-$sec_wall);
      }
    }
    // Hub
    topplate(dia, toffset, cut, ball, adjustbolt, centralbolt, stalkheight, unibodytop, tilt_angle);
    // Poleclamp
    translate([0,dy,stalkheight/2]) Secondary_Poleclamp(pole_x, sec_poledia,stalkheight);
  }
}

// Spider Pole attachment
module Secondary_Poleclamp(
pole_x, // Pole x-datum
poledia, // pole diameter at secondary clamp
height, // clamp height
) {
  echo (pole_x, poledia, height);
  tab_x = get_sec_clamp_tab(clampbolt);
  clamp_x = get_sec_clamp_x(pole_x, poledia, tab_x);
  tthick = ceil(max(get_hex_thick(clampbolt),$sec_wall*1.5));
  difference() {
    linear_extrude(height,center=true,convexity=10) difference() {
      union() {
        mirror_dup_x() {
          translate([-pole_x,0]) circle(d=poledia+$sec_plate*2);
          translate([-pole_x,poledia/2]) square([poledia/2+tab_x+$sec_plate,$sec_plate]);
          translate([-pole_x+poledia/2+tab_x+$sec_plate,poledia/2+$sec_plate/2]) circle(d=$sec_plate,$fn=32);
          translate([-pole_x,poledia/2-tthick-$sec_plate*2]) square([poledia/2+tab_x+$sec_plate,tthick]);
          translate([-pole_x+poledia/2+tab_x+$sec_plate,poledia/2-$sec_plate*2]) circle(r=tthick,$fn=64);
        }
        translate([0,poledia/2-$sec_plate-$sec_plate/2]) square([pole_x*2,$sec_plate],center=true);
      }
      translate_xs([pole_x,0,0]) circle(d=poledia+$collet_tol*2);
      translate([0,poledia/2-$sec_plate/2]) square([pole_x*2,$sec_plate],center=true);
    }
    translate_xs([clamp_x,0,0]) rotate([-90,0,0]) metric_shaft_cut(clampbolt,sec_poledia);
    translate_xs([clamp_x,poledia/2-$sec_plate*2,0]) rotate([90,0,0]) metric_nut_cut(clampbolt, depth=tthick+2);
  }
}

// Secondary Lower Pole attachment
module Lower_Poleclamp(
pole_x, // Pole x-datum
poledia, // pole diameter at secondary clamp
height, // clamp height
) {
  echo (pole_x, poledia, height);
  tab_x = get_sec_clamp_tab(clampbolt);
  clamp_x = get_sec_clamp_x(pole_x, poledia, tab_x);
  pole_diff = ceil(get_hex_side(4)*1.25)/2;
  multipart("lower_poleclamp", "yellow") union() {
    difference() {
      union() {
        mirror_dup_x() linear_extrude(height,center=true) hull() {
          translate([pole_x,0,0]) circle(d=poledia+$sec_plate*2);
          translate_ys([clamp_x,(poledia/2+$sec_plate)/2,0]) circle(d=(poledia+$sec_plate*2)/2);
        }
        translate([0,(poledia/2+$sec_plate)/2,0]) cube([pole_x*2,poledia/2+$sec_plate,height],center=true);
        translate([0,poledia/2-$sec_plate/2,height]) cube([(pole_x-poledia/2)*2,$sec_plate*3,height],center=true);
        spx = ((pole_x-poledia/2)-clamp_x)*2;
        translate_xs([clamp_x,0,stalkheight/2]) hull() {
          translate([0,$sec_plate*3/2,-1]) cube([spx,$sec_plate*2,2],center=true);
          translate([0,poledia/2-$sec_plate*3/2,stalkheight-1]) cube([spx,$sec_plate,2],center=true);
        }
      }
      translate_xs([pole_x,0,0]) cylinder(d=poledia+$collet_tol*3,h=height*3+2,center=true);
      
      translate([0,poledia/2-$sec_plate/2,height]) cube([(pole_x-poledia/2+$sec_tol)*2,$sec_plate,height+2],center=true);
      cube([pole_x*2,$sec_plate,height*3+2],center=true);
      translate_xs([clamp_x,poledia/2+$sec_plate+1,height]) rotate([90,0,0]) metric_shaft_cut(clampbolt,$sec_plate*3);
      translate_xs([clamp_x,poledia/2-$sec_plate-$sec_wall,height]) rotate([90,0,0])  metric_nut_cut(clampbolt,add_depth=$sec_wall+0.5);
      translate_xs([clamp_x,poledia/2+$sec_plate+1,0]) rotate([90,0,0]) metric_shaft_cut(4,poledia+$sec_plate*3);
      translate_xs([clamp_x,-poledia/2+$sec_wall,0]) rotate([90,0,0]) metric_nut_cut(4,add_depth=$sec_wall*2);
    }

    mirror_dup_x() translate([pole_x,0,0]) rotate(180/12) rsym(12) translate([poledia/2+$collet_tol*1.5,0,]) hull() translate_zs([0,0,height/2-$sec_wall])sphere(d=1,$fn=16);
  }
}

// Secondary-Focuser mounting plate
module Focuser_Backplate(
pole_x, // Pole x-datum
poledia, // pole diameter at secondary clamp
height, // clamp height
tilt_z, // Spider mount z-datum
helicoid_length, // Thread engagement length
thread_tol=$foc_tol, // Thread tolerance
spring_wall=$sec_wall, // Spring part thickness
) {
  multipart("backplate", "green") {
    tab_x = get_sec_clamp_tab(clampbolt);
    clamp_x = get_sec_clamp_x(pole_x, poledia, tab_x);
    xdim = (pole_x-poledia/2)*2;
    zdim = tilt_z+lower_z+height;

    rotate(180) {
      difference() {
        union() {
          // Backplate
          translate([-xdim/2,0,-lower_z]) cube([xdim,$sec_plate,zdim]);
        }
        translate([0,-1,0]) rotate([-90,0,0]) difference() {
          cylinder(d=outer_innerdia,h=helicoid_length+2);
        }
        translate_xs([clamp_x,-1,0]) {
          translate([0,0,-lower_z+height/2]) rotate([-90,0,0]) metric_shaft_cut(clampbolt,$sec_plate+2);
          translate([0,0,tilt_z+height/2])
          hull() translate_zs(dz=$sec_wall/2)
          rotate([-90,0,0]) metric_shaft_cut(clampbolt,$sec_plate+2);
        }
        // Index Mark indicating lower
        translate([-1/2,-0.1,-lower_z-1]) cube([1,0.4,6]);
      }
      // Inner Ring
      rotate([-90,0,0]) difference() {
        union() {
          cylinder(d=inner_outerdia,h=helicoid_length);
          intersection() {
            // 45-(45-90/nseg) = 45-45+90/nseg = 90/nseg
            // 45+(45-90/nseg) = 45+45-90/nseg = 90-90/nseg
            union() {
              rotate(45-(90-180)/2-7.5) translate([0,0,-1]) cube(inner_outerdia);
              rotate(45+(90-180)/2+7.5) translate([0,0,-1]) cube(inner_outerdia);
            }
            cylinder(d1=outer_dia,d2=inner_outerdia,h=helicoid_length);
          }
        }
        translate([0,-outer_dia/4,helicoid_length]) cube([1, outer_dia/2+0.5, helicoid_length*2+2],center=true);
        translate([0,0,-1]) base_internal(foc_inner,helicoid_length+2,helicoid_thread,helicoid_tstarts,baselock_thread, thread_tol);
      }
    }
  }
}

// Main Secondary Assembly
module SecondaryHolder() {
  translate([0,-moffset,-zsoffset]) {
    translate([0,0,dz_mirror]) secondaryattachment(dia, toffset, unibodypad, cut, ball, adjustbolt, centralbolt, sec_mdia, sec_mthick, secondaryattachment);
    if (unibodypad==false)
      translate([0,0,dz_mirror+dz_pad]) endplate(dia, adjustbolt, centralbolt, cut, toffset);
    if (unibodytop==false) {
      translate([0,0,dz_mirror+dz_pad+dz_tilt]) tiltplate(dia, toffset, cut, ball, adjustbolt, centralbolt);
    }
    translate([0,0,dz_mirror+dz_pad+dz_tilt+dz_aplate]) topplate(dia, toffset, cut, ball, adjustbolt, centralbolt, stalkheight, unibodytop);
    translate([0,0,dz_mirror+dz_pad+dz_tilt+dz_aplate]) spider(dia, toffset,cut, ball, adjustbolt, centralbolt, stalkheight, unibodytop, spiderwidth=2.5);
    if (showmirror == true) {
      secondarymirror(sec_mdia,sec_mthick);
    }
  }
  if (showmirror==true) {
    LightCone(sec_mdia,pri_fratio);
  }
}


// Main Render
if (isStandalone) {
  // Primary Assembly
  PrimaryHolder();

  // Support Arm
  translate_xs([pole_x,pole_y,0]) cylinder(d=sec_poledia,h=400);
  
  translate([0,0,300])
  {
    // Secondary Assembly
    SecondaryHolder();
    translate([0,pole_y,-outer_dia/2-3*stalkheight/2])
    {
      Lower_Poleclamp(pole_x, sec_poledia, stalkheight);
    }
    // Focuser and Backplate
    translate([0,pole_y+sec_poledia/2,0]) Focuser_Backplate(pole_x, sec_poledia, stalkheight, dz_mirror+dz_pad+dz_tilt+dz_aplate-zsoffset, helicoid_length);
    translate([0,pole_y,0]) rotate([-90,0,0]) focuser();
  }

  // Pole Joint Collet
  translate([0,0,150]) rotate([0,180,0]) translate_xs([pole_x, pole_y,0]) {
    ColletJoint(sec_poledia, $sec_wall, pole_colletpitch, pole_colletlength, 5+pole_caplength-pole_colletlength, sec_poledia+$sec_wall*2, pole_caplength, $tol=$sec_tol);
    translate([0,0,15]) ColletClamp(sec_poledia, $sec_wall, pole_colletpitch, pole_colletlength, 5, $tol=$sec_tol);
    translate([0,0,30]) ColletLock(sec_poledia, $sec_wall, pole_colletpitch, pole_colletlength, 5, $tol=$sec_tol);
  }
}
