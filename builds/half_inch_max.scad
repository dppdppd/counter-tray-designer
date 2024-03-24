include <../counter-tray.lib.scad>

g_make_lid = 1;
g_make_tray = 1;
g_make_filler = 0;

g_make_svg = 0;

MAX = 
[
[250,250], 
half_inch_counter,
counter_depth_standard_cardboard,
false
];



Make(MAX);
