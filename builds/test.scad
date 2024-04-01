include <../counter-tray.lib.scad>

g_make_filler = 0;
g_make_svg = 0;


DATA =
[
    [G_DIMENSIONS_XY, [90, 90]], 
    [G_FLOOR_THICKNESS_N, 1.5],
    [G_MAKE_TRAY_B, true],
    [G_MAKE_LID_B, true],
    [COUNTER_MARGINS_XY, [0.4, 0.4]],

    [COUNTER_SET,
        // [ENABLED_B, false],
        [ROWS_N, 1],
        [COUNTER_SIZE_XYZ, [five_eigths_counter, five_eigths_counter, 2]],
        [COUNTER_SHAPE, SHAPE_SQUARE ]
    ],

    [COUNTER_SET,
        // [ENABLED_B, false],
        [ROWS_N, 1],
        [COUNTER_SIZE_XYZ, [20, 20, 4.6]],
        [COUNTER_SHAPE, SHAPE_CIRCLE ]
    ],

    [COUNTER_SET,
        // [ENABLED_B, false],
        [COUNTER_SIZE_XYZ, [half_inch_counter, half_inch_counter, 2]],
        [COUNTER_SHAPE, SHAPE_SQUARE ]
    ],
];

Main();

