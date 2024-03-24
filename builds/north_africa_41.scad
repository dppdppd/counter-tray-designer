include <../counter-tray.lib.scad>

g_make_lid = 1;
g_make_tray = 1;
g_make_filler = 0;

g_make_svg = 0;

TRAY = 
[
    tray_revolution, 
    five_eigths_counter,
    counter_depth_standard_cardboard
];

Make(TRAY);

