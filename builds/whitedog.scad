include <../counter-tray.lib.scad>

g_make_lid = 1;
g_make_tray = 1;
g_make_filler = 0;

g_make_svg = 0;

WHITEDOG = 
[
tray_whitedog, 
five_eigths_counter,
counter_depth_blue_panther_chipboard
];

HALF_SHEET = 
[
[tray_whitedog.x, tray_whitedog.y*2/3], 
five_eigths_counter,
counter_depth_blue_panther_chipboard,
false
];

Make(HALF_SHEET);

FULL_SHEET = 
[
[tray_whitedog.x, tray_whitedog.y*3/4], 
five_eigths_counter,
counter_depth_blue_panther_chipboard,
false
];

*translate([0,-200,0])
Make(FULL_SHEET);

