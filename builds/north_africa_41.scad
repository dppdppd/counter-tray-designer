include <../counter-tray.lib.scad>

g_make_lid = 1;
g_make_tray = 1;
g_make_filler = 0;

g_make_svg = 0;

DATA =
[
    [G_DIMENSIONS_XY, [211, 246, counter_depth_standard_cardboard + 1.5]], 

    [COUNTER_SET,
        [ROWS_N, 0],
        [COUNTER_SIZE_XYZ, [five_eigths_counter, five_eigths_counter, counter_depth_standard_cardboard]],
        [COUNTER_SHAPE, SHAPE_SQUARE ]
    ],

    // [COUNTER_SET,
    //     [ROWS_N, 20],
    //     [COUNTER_SIZE_XYZ, [1, 1, counter_depth_standard_cardboard]],
    //     [COUNTER_SHAPE, SHAPE_SQUARE ]
    // ]
];

Main();

