use <threads.scad>
use <multipart.scad>
use <metricparts.scad>
use <symmetry.scad>

// Inner tube actual inner diameter
function get_innertube_innerdia(
inner, // Focuser nominal inner diameter
) = inner+$foc_tol*2;
// Nominal diameter + tolerance

// Inner tube outer diameter
function get_innertube_outerdia(
inner, // Focuser nominal inner diameter
lthread, // locking thread pitch
) = get_innertube_innerdia(inner)+$foc_wall*2+thread_depth(lthread)*2;
// Nominal wall + lockthread depth

// Helicoid female thread diameter
function get_helicoid_fdia(
inner, // Focuser nominal inner diameter
lthread, // locking thread pitch
hthread, // helicoid thread pitch
) = get_innertube_outerdia(inner, lthread)+thread_depth(hthread)*2;

// Outer tube actual inner diameter
function get_outertube_innerdia(
inner, // Focuser nominal inner diameter
lthread, // locking thread pitch
hthread, // helicoid thread pitch
) = get_helicoid_fdia(inner, lthread, hthread)+$foc_tol*2;
// Add tolerance

// Outer tube actual inner diameter
function get_outertube_outerdia(
inner, // Focuser nominal inner diameter
lthread, // locking thread pitch
hthread, // helicoid thread pitch
) = get_outertube_innerdia(inner, lthread, hthread)+$foc_wall*3;
// Add nominal wall

module mthread(diameter,length,thread,tstarts,internal=false,leadin=0) {
  metric_thread(diameter=diameter,pitch=thread,n_starts=tstarts,length=length,internal=internal,leadin=leadin,test=$preview);
}
module lthread(diameter,lockc,baselock_thread,internal=false,leadin=0) {
  metric_thread(diameter=diameter,pitch=baselock_thread,length=lockc+(internal?0.01:0),internal=internal,leadin=leadin,test=$preview);
}

module innertube(
inner, // Focuser inner diameter
maxtravel, // focuser nominal travel
helicoid_length, // Grip length
helicoid_thread, // Helical thread pitch
tstarts, // Helical thread starts
baselock_thread, // Locking thread pitch
baselock_length, // Locking thread engagement length
fheight, // Flange Height
flange, //  Flange width
lockscrew, // Eyepiece clamp screw
) {
  inner_dia = get_innertube_innerdia(inner);
  outer_dia = get_innertube_outerdia(inner, baselock_thread);
  helicoid_dia = get_helicoid_fdia(inner, baselock_thread, helicoid_thread);
  
  echo("inner inner", inner_dia);
  echo("inner outer", outer_dia);
  echo("inner heli", helicoid_dia);
  echo("hthread", thread_depth(helicoid_thread));
  
  inner_xdia = helicoid_dia-thread_depth(helicoid_thread)*2-$foc_wall*2;
  taper = inner_xdia-inner_dia;
  tube_height = helicoid_length+maxtravel+$foc_wall;
  echo("inner inner inner", inner_xdia);
  difference() {
    union() {
      metric_thread(diameter=helicoid_dia, pitch=helicoid_thread, length=tube_height, n_starts=tstarts,leadin=3,test=$test);
      translate([0,0,-baselock_length]) mirror([1,0,0]) metric_thread(diameter=outer_dia, pitch=baselock_thread, length=baselock_length,leadin=3);
      translate([0,0,tube_height]) cylinder(d=inner+flange*2,h=fheight);
    }
    translate([0,0,-$foc_wall*2-1]) cylinder(d=inner_dia,h=helicoid_length+maxtravel+$foc_wall+maxtravel+2);
    translate([inner/2,0,tube_height+fheight/2]) rotate([0,90,0]){
      metric_shaft_cut(lockscrew,flange*2);
      translate([0,0,-1]) rotate(90)metric_nut_cut(lockscrew,add_depth=2.5);
    }
    translate([0,0,fheight/2]) cylinder(d1=inner_dia, d2=inner_xdia, h=taper);
    translate([0,0,fheight/2+taper]) cylinder(d=inner_xdia,h=tube_height-fheight-taper*2);
    translate([0,0,tube_height-fheight/2-taper]) cylinder(d1=inner_xdia,d2=inner_dia,h=taper);
  }
} 

module base_internal(
inner, // Focuser inner diameter
length, // Grip length
helicoid_thread, // Helical thread pitch
tstarts, // Helical thread starts
baselock_thread, // Locking thread pitch
thread_tol=$foc_tol, // Fit tolerance for thread
) {
  helicoid_dia = get_helicoid_fdia(inner, baselock_thread, helicoid_thread);
  translate([0,0,-1]) metric_thread(diameter=helicoid_dia+thread_tol, pitch=helicoid_thread, length=length+2,n_starts=tstarts,leadin=3,internal=true,test=$test);
}

module base(
inner, // Focuser inner diameter
helicoid_length, // Grip length
helicoid_thread, // Helical thread pitch
tstarts, // Helical thread starts
baselock_thread, // Locking thread pitch
baselock_length, // Locking thread engagement length
) {
  inner_dia = get_outertube_innerdia(inner, baselock_thread, helicoid_thread);
  outer_dia = get_outertube_outerdia(inner, baselock_thread, helicoid_thread);
  helicoid_dia = get_helicoid_fdia(inner, baselock_thread, helicoid_thread);

  echo("outer inner", inner_dia);
  echo("outer outer", outer_dia);
  echo("outer heli", helicoid_dia);
  echo("OD diff", (helicoid_dia-outer_dia)/2);
  
  base_height=helicoid_length;
  multipart("base", "orange")
  difference() {
    union() {
      translate([0,0,-$foc_wall/2]) cube([outer_dia*2, outer_dia*2, $foc_wall], center=true);
      cylinder(d=outer_dia,h=base_height);
    }
    translate([0,0,-$foc_wall]) base_internal(inner,base_height+$foc_wall,helicoid_thread,tstarts,baselock_thread);
  }
}


module lock(
inner, // Focuser inner diameter
baselock_thread, // Locking thread pitch
baselock_length, // Locking thread engagement length
) {
  baselock_dia = get_innertube_outerdia(inner, baselock_thread);
  outer_dia = baselock_dia+$foc_wall*2+$foc_tol;
  difference() {
    cylinder(d=outer_dia, h=baselock_length+$foc_wall);
    translate([0,0,-1]) mirror([1,0,0]) metric_thread(diameter=baselock_dia+$foc_tol, pitch=baselock_thread, length=baselock_length+$foc_wall+2,internal=true,test=$test);
  }
}


module Focuser_ActiveLock(
height, // lock height
inner, // Focuser inner diameter
helicoid_thread, // Helical thread pitch
tstarts, // Helical thread starts
baselock_thread, // Locking thread pitch
flange, //  Flange width
thread_tol=$foc_tol, // Thread tolerance
nb=12, // number of bumps
) {
    outer_dia = inner+2*flange+$foc_plate;
    bumpdia = round(outer_dia*PI/(nb+2));
    difference() {
      union() {
        cylinder(d=outer_dia,h=height);
        rsym(nb) rotate(180/nb) translate([outer_dia/2-bumpdia/4,0,0]) cylinder(d=bumpdia,h=height);
      }
      translate([0,0,-1]) base_internal(inner,height+2,helicoid_thread,tstarts,baselock_thread,thread_tol);
      translate([0,outer_dia/2,height/2]) cube([2,outer_dia,height*2],center=true);
    }
}


module focuser() {
  
/* [Options] */
// Test Mode
$test=false;
current_part="ALL";

/* [Hidden] */
$fa=2.5;
$fs=0.5;
isStandalone=true;

/* [General Parameters] */
// Loaded Plate Thickness
$foc_plate = 3; // [0.1:0.1:10]
// Wall thickness
$foc_wall=1.8; // [0:0.1:5]
// General allowance
$foc_tol=0.25; // [0:0.01:2]


// Focuser inner diameter
foc_inner=32; // [15:0.1:120]
// Focuser travel
foc_maxtravel=30; // [15:0.1:120]


/* [Focuser Parameters] */
// Helicoid Thread pitch
helicoid_thread=2; // [0.01:0.01:4]
// Helicoid Thread starts
helicoid_tstarts=4;
// Helicoid grip length
helicoid_length=15; // [1:0.1:20]
// Locking thread pitch
baselock_thread=1; // [0.01:0.01:2]
// Locking thread length
baselock_length=3; // [1:0.1:20]
// Locking screw size
lockscrew=3; // [2:M2,3:M3,4:M4,5:M5,6:M6]


/* [Focuser Mounting Plate] */
// Clamp flange width
flange=7; // [1:0.1:20]
// Clamp flange height
fheight=10; // [1:0.1:20]


  base(foc_inner, helicoid_length, helicoid_thread, helicoid_tstarts, baselock_thread, baselock_length);

  intersection() {
    innertube(foc_inner, foc_maxtravel, helicoid_length, helicoid_thread, helicoid_tstarts, baselock_thread, baselock_length, fheight, flange, lockscrew);
    translate([0,foc_inner*5,0]) cube(foc_inner*10,center=true);
  }

  translate([0,0,helicoid_length+5]) Focuser_ActiveLock(5, foc_inner, helicoid_thread, helicoid_tstarts, baselock_thread, flange);
  translate([0,0,-$foc_wall*5]) lock(foc_inner,baselock_thread,baselock_length);

}

focuser();