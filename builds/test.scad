include <../counter-tray.lib.scad>

g_make_lid = 0;
g_make_tray = 1;
g_make_filler = 0;

g_make_svg = 0;

tray_half = [60,60];

THE_BRITISH_WAY_HALF_INCH = 
[
    tray_half, 
    half_inch_counter,
    counter_depth_standard_cardboard
    
];

Make(THE_BRITISH_WAY_HALF_INCH);

THE_BRITISH_WAY_FIVE_EIGHTHS_HALF_SHEET = 
[
    tray_half, 
    five_eigths_counter,
    counter_depth_standard_cardboard
    
];

*translate( [0, 130, 0])
Make(THE_BRITISH_WAY_FIVE_EIGHTHS_HALF_SHEET);
