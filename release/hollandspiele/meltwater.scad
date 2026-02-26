// Hollandspiele — Meltwater
include <../lib/counter_tray_designer_lib.1.scad>
include <../lib/blue_panther_constants.scad>

MELTWATER =
[
    [G_DIMENSIONS_XY, [208,265]],

    [TRAY,
        [COUNTER_SET,
            [ROWS_N, 6],
            [COUNTER_SIZE_XYZ, [16.7, 16.7, 5.2]],
            [COUNTER_SHAPE, SHAPE_CIRCLE ]
        ],

        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [five_eigths_counter, five_eigths_counter, blue_panther_chipboard_depth]],
        ],
    ],
    
    [LID],
];

Make(MELTWATER);
