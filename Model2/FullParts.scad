include <FullAssembly.scad>
/* [Hidden] */
isStandalone=false;

// Main Primary Assembly
    topclip(cbump,clipbolt,collbolt,clipthick,clipext,pri_mdia);
    mirrorcell(pri_mdia, pri_mthick,fthick,bthick,clipbolt,collbolt,lbump,cbump,rbracepos,zbracepos,cpointpos);
    lowercell(pri_mdia,mspace,fthick,bthick,clipbolt,collbolt,basebolt,cellfloat,cpointpos, pri_poledia);
    PoleBase(pri_poledia, sec_poledia, pole_caplength, basebolt, $tol=$sec_tol);
    BaseKnob(pri_poledia, basebolt);

    rocker(altmin, rail_dia, rail_tab, rail_width, rail_thick, basebolt, pole_x, boxsize, rail_height, lowercell_z-fthick);
    AzimuthBlock(rail_dia, rail_width, rail_thick, pole_x, pole_y, pri_poledia, fthick, get_fwidth(clipbolt, collbolt));

// Main Focuser Assembly
  innertube(foc_inner, foc_maxtravel, helicoid_length, helicoid_thread, helicoid_tstarts, baselock_thread, baselock_length, fheight, flange, lockscrew);

  Focuser_ActiveLock($foc_plate*1.5, foc_inner, helicoid_thread, helicoid_tstarts, baselock_thread, flange);

// Main Secondary Assembly
    secondaryattachment(dia, toffset, unibodypad, cut, ball, adjustbolt, centralbolt, sec_mdia, sec_mthick, secondaryattachment);
    tiltplate(dia, toffset, cut, ball, adjustbolt, centralbolt);
    topplate(dia, toffset, stalkheight, adjustbolt, centralbolt,spiderwidth=2.5);

// Connection Elements
    Lower_Poleclamp(pole_x, sec_poledia, stalkheight);
    Focuser_Backplate(pole_x, sec_poledia, stalkheight, dz_mirror+dz_pad+dz_tilt+dz_aplate-zsoffset, helicoid_length);
    ColletJoint(sec_poledia, $sec_wall, pole_colletpitch, pole_colletlength, 5+pole_caplength-pole_colletlength, sec_poledia+$sec_wall*2, pole_caplength, $tol=$sec_tol);
    ColletClamp(sec_poledia, $sec_wall, pole_colletpitch, pole_colletlength, 5, $tol=$sec_tol);
    ColletLock(sec_poledia, $sec_wall, pole_colletpitch, pole_colletlength, 5, $tol=$sec_tol);
