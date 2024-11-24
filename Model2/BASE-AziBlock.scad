include <FullAssembly.scad>
/* [Hidden] */
isStandalone=false;
$fa=1;

// Rocker-Base
rotate(90) AzimuthBlock(rail_dia, rail_width, rail_thick, pole_x, pole_y, pri_poledia, fthick, get_fwidth(clipbolt, collbolt));
