use <multipart.scad>
use <metricparts.scad>
use <symmetry.scad>


module mirrorskew() {
  multmatrix(m=[[1,0,0,0],[0,1,0,0],[0,1,1,0],[0,0,0,1]]) children();
}

// Usage: get_dia(secdiaauto,secondaryattachment,sec_mdia,sec_dia)
function get_dia(
auto, // Automatic diameter
attachment, // Attachment Type [cap, pad]
mdia=undef, // Mirror diameter
dia=undef// Manual diameter
) = auto?((attachment=="cap")?(mdia+$sec_wall*2):mdia):dia;

// Usage: get_toffset(toffsetauto,adjustbolt,centralbolt,dia,tadjustoffset)
function get_toffset(
auto, // Automatic tilt offset
adjustbolt, // Adjustment bolt
centralbolt, // Central bolt
dia, // diameter
tadjustoffset=undef // Manual offset
) = auto?max(dia/2-$sec_wall*2-adjustbolt,adjustbolt+(centralbolt+$sec_wall*4.5)/2):tadjustoffset;

// z-datum for mirrorpad
function get_dz_mirror(
mthick, // mirror thickness
mpad_space, // mirror to pad spacing
secondaryattachment, // Mirror Attachment type
) = (mthick+(secondaryattachment=="pad"?mpad_space:0))*sqrt(2);

// z-datum for top of pad
function get_dz_pad(
mdia, // Mirror minor axis diameter
pdia, // pad diameter
cut, // groove cut
unibodypad = false, // Is the pad and endplate together?
) = pdia/2+$sec_plate+(unibodypad?cut:0);

// Tilt plate spacing
function get_tspacing(
ball, // Coupling ball diameter
cut, // Positioning groove depth
tspacing, // Explicit spacing (Maxwell clamp)
) = tspacing;

// z-datum for bottom of tiltplate
function get_dz_tilt(
tspacing, // Tilt spacing
adjustbolt, // Adjustment bolt size
unibodypad = false, // Is the pad and endplate together?
) = tspacing+(unibodypad?0:$sec_wall+$sec_tol+adjustbolt);

// z-datum for bottom of topplate
function get_dz_aplate(
adjustbolt, // Adjustment bolt size
unibodytop = false // Is the tilt plate and top plate together?
) = unibodytop?0:ceil(max($sec_plate,$sec_wall+get_hex_thick(adjustbolt)));

function get_mirror_offset(
mdia, // Mirror minor axis diameter
pri_fratio, // Primary mirror focal ratio
) = mdia/(4*pri_fratio);



module endplate_topcut(
tcut, // ball cut depth
adjustbolt, // Adjustment bolt radius
toffset // tilt adjustment offset
) {
//  dx = max(adjustbolt/1.5, tcut);
  dx = adjustbolt*2/3+((adjustbolt*2/3)/tcut)*0.01;
  rsym(3) translate([0,-toffset,0]) rotate([90,0,0]) linear_extrude(adjustbolt*2,center=true) polygon([[(dx+0.01*dx/tcut),0.01],[-(dx+0.01*dx/tcut),0.01],[0,-tcut]]);
}

module endplate_boltcut(
plate, // plate thickness
adjustbolt, // Adjustment bolt
toffset // tilt adjustment offset
) {
//  toffset = get_toffset();
  translate([0,toffset,0]) metric_thread_cut(adjustbolt,$sec_plate+2);
  rotate([0,0,120]) translate([0,toffset,0]) metric_thread_cut(adjustbolt,$sec_plate+2);
  rotate([0,0,-120]) translate([0,toffset,0]) metric_thread_cut(adjustbolt,$sec_plate+2);
  translate([0,0,$sec_plate+1-$sec_tol]) {
    translate([0,toffset,0]) cylinder(d=adjustbolt*2+$sec_tol,h=adjustbolt+1);
    rotate([0,0,120]) translate([0,toffset,0]) cylinder(d=adjustbolt*2+$sec_tol,h=adjustbolt+1);
    rotate([0,0,-120]) translate([0,toffset,0]) cylinder(d=adjustbolt*2+$sec_tol,h=adjustbolt+1);
  }
}

module secplate_boltcut(
depth, // plate thickness
adjustbolt, // Adjustment bolt
toffset // tilt adjustment offset
) {
  rsym(3) translate([0,toffset,0]) metric_shaft_cut(adjustbolt,depth+2,shaft="threaded");
}

module secondaryattachment(
pdia, // plate diameter
toffset, // tilt offset
unibodypad, // Is the pad and endplate together?
cut, // ball cut depth
ball, // ball radius
adjustbolt, // Adjustment bolt
centralbolt, // Central bolt
sec_mdia, // mirror diameter
sec_mthick, // mirror thickness
secondaryattachment, // Secondary Attachment Method
) {
  if (secondaryattachment == "cap")
    secondaryattachment_cap(pdia, toffset, unibodypad, cut, ball, adjustbolt, centralbolt, sec_mdia, sec_mthick); // cap type
  if (secondaryattachment == "pad")
    secondaryattachment_pad(pdia, toffset, unibodypad, cut, ball, adjustbolt, centralbolt, sec_mdia, sec_mthick); // glue type
}

module secondaryattachment_cap(
pdia, // plate diameter
toffset, // tilt offset
unibodypad, // Is the pad and endplate together?
cut, // ball cut depth
ball, // ball radius
adjustbolt, // Adjustment bolt
centralbolt, // Central bolt
sec_mdia, // mirror diameter
sec_mthick // mirror thickness
) {
  multipart("mirrorholder", "pink") {
    top_t=unibodypad?$sec_plate+cut:$sec_plate;
    union() {
      difference() {
        translate([0,0,-$sec_wall]) mirrorskew() cylinder(d=pdia,h=pdia+top_t+$sec_wall*2);
        translate([0,0,-$sec_wall*2]) mirrorskew() cylinder(d=pdia-$sec_wall*2+$sec_tol*2,h=$sec_wall*2);
        cylinder(d=pdia-$sec_wall*4,h=pdia,center=true);
        translate([0,0,pdia/2+top_t]) cylinder(d=pdia+2,h=pdia*2);
        if (unibodypad) {
          translate([0,0,pdia/2+top_t]) endplate_topcut(cut, adjustbolt, toffset);
        }
        else {
          translate([0,0,pdia/2-1]) secplate_boltcut(top_t, adjustbolt, toffset);
        }
        translate([0,0,pdia/2-1]) metric_shaft_cut(centralbolt,top_t+2,sfactor=1.5);
      }
    }
  }
}

module secondaryattachment_pad(
pdia, // plate diameter
toffset, // tilt offset
unibodypad, // Is the pad and endplate together?
cut, // ball cut depth
ball, // ball radius
adjustbolt, // Adjustment bolt
centralbolt, // Central bolt
sec_mdia, // mirror diameter
sec_mthick // mirror thickness
) {
  multipart("mirrorholder", "pink") {
    pwidth=sqrt(pdia*pdia-(pdia-$sec_plate*2)*(pdia-$sec_plate*2))-$sec_wall;
    top_t=unibodypad?$sec_plate+cut:$sec_plate;
    pad_profile = [[-pdia/2+$sec_wall,-pdia/2],[-pdia/2+$sec_wall,-pdia/2+$sec_wall],[pdia/2,pdia/2],[pdia/2+$sec_plate,pdia/2],[pdia/2+$sec_plate,-pdia/2]];
    
    difference() {
      union() {
        intersection() {
          rotate([0,-90,0]) linear_extrude(pdia,center=true,convexity=10) polygon(pad_profile);
          translate([0,0,-pdia/2]) cylinder(d=pdia,h=pdia+$sec_plate);
        }
        translate([0,0,pdia/2]) cylinder(d=pdia,h=top_t);
      }
      translate([0,0,-pdia/2]) cylinder(d=get_washer_side(centralbolt)*1.4,h=pdia);
      if (unibodypad) {
        translate([0,0,pdia/2+top_t]) endplate_topcut(cut, adjustbolt, toffset);
      }
      else {
        translate([0,0,pdia/2-1]) secplate_boltcut(top_t, adjustbolt, toffset);
      }
      translate([0,0,pdia/2-1]) metric_shaft_cut(centralbolt,top_t+2,sfactor=1.5);
    }    
  }
}

module endplate(
dia, // plate diameter
adjustbolt, // Adjustment bolt
centralbolt, // Central bolt
cut, // groove cut
toffset, // Tilt adjustment position offset
) {
  multipart("endplate","red") difference() {
    pthick = $sec_wall+$sec_tol+adjustbolt;
    cylinder(d=dia,h=pthick);
    translate([0,0,pthick]) endplate_topcut(cut, adjustbolt, toffset);
    rsym(3) translate([0,toffset,0]) {
      translate([0,0,-1]) metric_shaft_cut(adjustbolt,pthick+2);
      translate([0,0,$sec_wall]) cylinder(r=adjustbolt*1.1,h=pthick);
    }
    translate([0,0,-1]) metric_shaft_cut(centralbolt,$sec_plate+adjustbolt+2,sfactor=1.5);
  }
}

module tiltplate(
dia, // plate diameter
toffset, // tilt offset
cut, // ball cut depth
ball, // ball radius
adjustbolt, // Adjustment bolt
centralbolt // Central bolt
) {
  multipart("tiltplate", "orange") difference() {
    pthick=ceil(max($sec_plate,$sec_wall+get_hex_thick(adjustbolt)));
    union() {
      cylinder(d=dia,h=pthick);
    }
    translate([0,0,-1]) metric_shaft_cut(centralbolt,pthick+2, sfactor=1.1);
    rsym(3) translate([0,-toffset,-1]) {
      metric_shaft_cut(adjustbolt,pthick+2, sfactor=1.1);
      metric_nut_cut(adjustbolt,add_depth=1,allowance=0.4);
    }
  }
}


module zrplate(
dia, // plate diameter
toffset, // tilt offset
adjustbolt, // Adjustment bolt
centralbolt, // Central bolt
stalkheight, // Secondary stalk height
tilt_angle=30, // z-rotation adjustment angle
) {
  multipart("topplate", "yellow") difference() {
    cylinder(d=dia,h=stalkheight);
    translate([0,0,-1]) metric_shaft_cut(centralbolt,stalkheight+2,sfactor=1.1);
    cut_sa = 360*(adjustbolt*1.2)/(toffset*2*PI);
    rsym(3) {
      translate([0,0,$sec_plate/2]) {
        rotate([0,0,90-tilt_angle/2]) rotate_extrude(angle=tilt_angle) { translate([-toffset,0,0]) square([adjustbolt*1.1,$sec_plate+1],center=true); }
        mirror_dup_x() rotate(tilt_angle/2)translate([0,-toffset,0]) cylinder(d=adjustbolt*1.1,h=$sec_plate+1,center=true);
      }
      translate([0,0,$sec_plate+stalkheight/2]) {
        rotate([0,0,90-tilt_angle/2]) rotate_extrude(angle=tilt_angle) { translate([-toffset,0,0]) square([adjustbolt*2.4,stalkheight],center=true); }
        mirror_dup_x() rotate(tilt_angle/2)translate([0,-toffset,0]) cylinder(d=adjustbolt*2.4,h=stalkheight,center=true);
      }
    }
  }
}

module shaftsupport(
od, // shaft diameter
id, // hole diameter
layer=0.2, // layer thickness
) {
  dd1=max(id/sin(30),od);
  translate([0,0,-0.01]) cylinder(d=dd1,h=layer+0.01,$fn=3);
  translate([0,0,layer-0.01]) intersection() {
    cylinder(d=dd1,h=layer+0.01,$fn=3);
    rotate(60) cylinder(d=id/sin(30),h=layer+0.01,$fn=3);
  }
}

module tilttopplate(
dia, // plate diameter
toffset, // tilt offset
cut, // ball cut depth
ball, // ball radius
adjustbolt, // Adjustment bolt
centralbolt, // Central bolt
stalkheight, // Secondary stalk height
) {
  multipart("tiltplate", "orange") difference() {
    pthick=ceil(max($sec_plate,$sec_wall+get_hex_thick(adjustbolt)));
    union() {
      cylinder(d=dia,h=stalkheight);
    }
    translate([0,0,-1]) metric_shaft_cut(centralbolt,stalkheight+2);
    rsym(3) translate([0,-toffset,-1]) {
      metric_shaft_cut(adjustbolt,pthick+2,sfactor=1.1);
      metric_nut_cut(adjustbolt,add_depth=1,allowance=0.4);
      translate([0,0,pthick+1.5]) rotate([180,0,0]) shaftsupport(od=adjustbolt*2*1.15, id=adjustbolt*1.1 );
      translate([0,0,pthick+1.5]) cylinder(d=adjustbolt*2*1.15,h=stalkheight);
    }
  }
}

module topplate(
dia, // plate diameter
toffset, // tilt offset
cut, // ball cut depth
ball, // ball radius
adjustbolt, // Adjustment bolt
centralbolt, // Central bolt
stalkheight, // Secondary stalk height
unibodytop, // Is the tilt plate combined with top plate?
tilt_angle=30, // z-rotation adjustment angle
) {
  if (unibodytop==false) {
    zrplate(dia, toffset, adjustbolt, centralbolt, stalkheight, tilt_angle);
  } else {
    tilttopplate(dia, toffset, cut, ball, adjustbolt, centralbolt,stalkheight);
  }
}

module secondarymirror(mdia, mthick) {
//  multipart("mirror", "lightblue",0.5) 
  %mirrorskew() cylinder(d=mdia,h=mthick*sqrt(2));
}

module LightCone(mdia, fratio) {
//  multipart("LightCone","yellow",0.25) 
  %union() {
    mirror([0,-1,1]) intersection() {
      translate([0,0,-mdia*fratio]) cylinder(d1=mdia*2,d2=0,h=mdia*fratio*2);
      mirrorskew() cylinder(d=mdia*1.5,h=mdia*fratio*1.1);
    }
    difference() {
      translate([0,0,-mdia*fratio]) cylinder(d1=mdia*2,d2=0,h=mdia*fratio*2);
      mirrorskew() cylinder(d=mdia*1.5,h=mdia*fratio*1.1);
    }
  }
}


module SecondaryHolder() {
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
// Loaded Plate Thickness
$sec_plate = 4; // [0.1:0.1:10]
// General Wall Thickness
$sec_wall = 1.8; // [0.1:0.1:10]
// Tolerance Allowance
$sec_tol = 0.25; // [0.1:0.1:10]
// General Fillet
$sec_fil = 1.2; // [0.1:0.1:10]

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
tspacing = 4; // [1:0.1:30]

// Mirror pad is combined with endplate?
unibodypad=true;

// Tilt plate is combined with topplate?
unibodytop=false;

// Secondary holder auto diameter
secdiaauto=true;
// Secondary holder diameter
sec_dia=28; // [10:0.1:120]

// Adjustment ball diameter (unused for Maxwell clamp)
ball=5; // [1:0.05:30]
// Adjustment notch depth
cut=0.5; // [0.1:0.05:10]

// Adjustment Bolt size
adjustbolt=3; // [2:M2,3:M3,4:M4,5:M5,6:M6,8:M8,10:M10]
// Central Bolt size
centralbolt=4; // [2:M2,3:M3,4:M4,5:M5,6:M6,8:M8,10:M10]

/* [Primary-Secondary Interface] */

// Stalk/Cap Height
stalkheight=12; // [1:0.1:70]


  dia = get_dia(secdiaauto,secondaryattachment,sec_mdia,sec_dia);
  toffset = get_toffset(toffsetauto,adjustbolt,centralbolt,dia,tadjustoffset);
  dz_mirror = get_dz_mirror(sec_mthick,sec_mpad_space, secondaryattachment);
  dz_pad = get_dz_pad(sec_mdia, dia, cut, unibodypad);
  _tspacing = get_tspacing(ball, cut, tspacing);
  dz_tilt = get_dz_tilt(_tspacing, adjustbolt, unibodypad);
  dz_aplate = get_dz_aplate(adjustbolt, unibodytop);
  moffset = get_mirror_offset(sec_mdia,pri_fratio);
  zsoffset = round(moffset);
  
  translate([0,-moffset,-zsoffset]) {
    translate([0,0,dz_mirror]) secondaryattachment(dia, toffset, unibodypad, cut, ball, adjustbolt, centralbolt, sec_mdia, sec_mthick, secondaryattachment);
    if (unibodypad==false)
      translate([0,0,dz_mirror+dz_pad]) endplate(dia, adjustbolt, centralbolt, cut, toffset);
    if (unibodytop==false) {
      translate([0,0,dz_mirror+dz_pad+dz_tilt]) tiltplate(dia, toffset, cut, ball, adjustbolt, centralbolt);
    }
    translate([0,0,dz_mirror+dz_pad+dz_tilt+dz_aplate]) topplate(dia, toffset, cut, ball, adjustbolt, centralbolt, stalkheight, unibodytop);
    if (showmirror == true) {
      secondarymirror(sec_mdia,sec_mthick);
    }
  }
  if (showmirror==true) {
    LightCone(sec_mdia,pri_fratio);
  }
}

SecondaryHolder();
