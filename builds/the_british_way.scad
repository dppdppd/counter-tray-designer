include <../counter-tray.lib.scad>

g_make_lid = 1;
g_make_tray = 1;
g_make_filler = 0;

g_make_svg = 0;

tray_half = [204,119];

THE_BRITISH_WAY_HALF_INCH = 
[
    tray_half, 
    half_inch_counter,
    counter_depth_standard_cardboard,
    false
    
];

Make(THE_BRITISH_WAY_HALF_INCH);

THE_BRITISH_WAY_FIVE_EIGHTHS_HALF_SHEET = 
[
    tray_half, 
    five_eigths_counter,
    counter_depth_standard_cardboard,
    false
    
];

translate( [0, 130, 0])
Make(THE_BRITISH_WAY_FIVE_EIGHTHS_HALF_SHEET);

capsule_counter = 20;
capsule_depth = 4.6;

COIN_CAPSULES = 
[
	tray_half, 
	capsule_counter,
	capsule_depth,
	true
];

translate( [0, 260, 0])
Make(COIN_CAPSULES);