include <../counter-tray.lib.scad>

g_make_lid = 1;
g_make_tray = 1;
g_make_filler = 0;

g_make_svg = 0;

STONEWALLS_SWORD_FIVE_EIGHTHS = 
[
    tray_revolution, 
    five_eigths_counter,
    counter_depth_standard_cardboard
];

Make(STONEWALLS_SWORD_FIVE_EIGHTHS);



capsule_counter = 26.5;
capsule_depth = 4.6;

COIN_CAPSULES = 
[
	tray_revolution, 
	capsule_counter,
	capsule_depth,
	true
];

translate([0,250,0])
Make(COIN_CAPSULES);
