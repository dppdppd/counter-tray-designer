// The Avalon Hill Game Co — Breakout: Normandy
include <../lib/avalon_hill_constants.scad>

// large 19.5 x 19.5 — 88 x 2
// small — 130 x 2

BREAKOUT_NORMANDY =
[
    // box dimensions 205x285
    [G_DIMENSIONS_XY, [200,170]],

    [TRAY, // x 2 — half-inch counters
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [half_inch_counter, half_inch_counter, counter_depth_standard_cardboard]],
        ],
    ],

    [TRAY, // x 2 — five-eighths counters
        [G_MAKE_LID_B, false],
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [five_eigths_counter, five_eigths_counter, counter_depth_standard_cardboard]],
        ],
    ],
];

Make(BREAKOUT_NORMANDY);
