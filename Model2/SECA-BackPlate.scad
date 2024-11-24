include <FullAssembly.scad>
/* [Hidden] */
isStandalone=false;

rotate([-90,0,0])
// Backplate/Inner Thread
Focuser_Backplate(pole_x, sec_poledia, stalkheight, dz_mirror+dz_pad+dz_tilt-zsoffset, helicoid_length,spring_wall=1.32);

