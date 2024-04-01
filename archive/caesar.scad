include <../counter-tray.lib.scad>

g_make_lid = 1;
g_make_tray = 1;
g_make_filler = 0;

g_make_svg = 0;

MAX = 
[
[ 202,250], 
block_counter,
block_depth,
false
];



Make(MAX);
