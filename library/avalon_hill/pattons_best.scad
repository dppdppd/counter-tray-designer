// The Avalon Hill Game Co — Patton's Best
include <avalon_hill_constants.scad>

PATTONS_BEST =
[
    // box dimensions 205x285
    [G_DIMENSIONS_XY, [190,170]],

    [TRAY, // five-eighths counters
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [five_eigths_counter, five_eigths_counter, counter_depth_standard_cardboard]],
        ],
    ],

    [TRAY, // half-inch counters
        [G_MAKE_LID_B, false],
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [half_inch_counter, half_inch_counter, counter_depth_standard_cardboard]],
        ],
    ],
];

Make(PATTONS_BEST);
