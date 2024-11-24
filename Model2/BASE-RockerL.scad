include <FullAssembly.scad>
/* [Hidden] */
isStandalone=false;
$fa=1;

rotate([90,0,0])
// Rocker-L
rocker(altmin, rail_dia, rail_tab, rail_width, rail_thick, basebolt, pole_x, boxsize, rail_height, lowercell_z-fthick);
