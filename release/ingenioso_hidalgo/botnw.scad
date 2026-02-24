// Ingenioso Hidalgo — Battlefields of the Napoleonic Wars
include <../lib/counter_tray_designer_lib.1.scad>
include <../lib/ingenioso_hidalgo_constants.scad>

BotNW =
[

    [G_DIMENSIONS_XY, [ 131, 148 ]],

    [G_FLOOR_THICKNESS_N, 2],
    [G_MIN_PADDING_XY, [0,0]],
    [G_FRAME_STYLE_N, 3],
    [COUNTER_PEDESTAL_B, false],

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [17, 16, 6]],
        [ROWS_N, 1],

    ],

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [25, 15, 11]],
        [COUNTER_MARGINS_POST_LENGTH_FRACTION_N, 0.2],
    ],
];

Make(BotNW);
