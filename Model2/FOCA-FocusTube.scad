include <FullAssembly.scad>
/* [Hidden] */
isStandalone=false;

rotate([180,0,0]) 
// Focuser Tube
innertube(foc_inner, foc_maxtravel, helicoid_length, helicoid_thread, helicoid_tstarts, baselock_thread, baselock_length, fheight, flange, lockscrew);
