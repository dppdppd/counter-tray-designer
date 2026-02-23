// The Avalon Hill Game Co — Storm Over Arnhem (1981)
include <../lib/avalon_hill_constants.scad>

STORM_OVER_ARNHEM =
[
    // box dimensions 205x285
    [G_DIMENSIONS_XY, [200,258]],

    [TRAY, // print x 2 — main counters
        // large 19.5 x 19.5
        // 68 British, 47 SS, 54 German, 14 points
        // rect 19.5 x 16.5 — 14 rect
        [COUNTER_SET,
            [ROWS_N, 1],
            [COUNTER_SIZE_XYZ, [19.5, 16.5, counter_depth_standard_cardboard]],
        ],

        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [19.5, 19.5, counter_depth_standard_cardboard]],
        ],
    ],

    [TRAY, // print x 1 — dice chits
        [G_MAKE_LID_B, false],
        // small 14 x 14
        // 36 British, 36 German
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [14, 14, counter_depth_standard_cardboard]],
        ],
    ],
];

Make(STORM_OVER_ARNHEM);
