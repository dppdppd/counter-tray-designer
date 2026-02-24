// GMT Games — Tomahawks and Bayonets
include <../lib/counter_tray_designer_lib.1.scad>
include <../lib/gmt_constants.scad>

TOMAHAWKS_AND_BAYONETS =
[
    // [G_DIMENSIONS_XY, [ 215, 290 ]],
    [G_DIMENSIONS_XY, [ 193, 282 ]],
    [G_FLOOR_THICKNESS_N, 2],
    [G_MIN_PADDING_XY, [0,0]],
    [COUNTER_MARGINS_POST_LENGTH_FRACTION_N, .4],
    [G_FRAME_STYLE_N, 3],
  //  [G_MAGNET_DIAMETER_N, 10.2],

    [TRAY, // British
        // 62 large square 20.5x20.5 — 46 british
        // 38 triangles 20.5x23 — 11 british, 5 either
        // 54 circle 21 — 32 british
        // 176 5/8ths

        // large square
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [20.5, 20.5, 3]],
            [ROWS_N, 6],
        ],

        // triangles
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [23, 20.5, 3]],
            [ROWS_N, 2],
        ],

        // circles
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [21, 21, 3]],
            [COUNTER_SHAPE, SHAPE_CIRCLE],
            [ROWS_N, 4],
        ],

        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [16.5, 16.5, 3]],
            [ROWS_N, 1],
        ],
    ],

    [TRAY, // French
        [G_MAKE_LID_B, false],
        // 62 large square 20.5x20.5 — 16 french
        // 38 triangles 20.5x23 — 22 french
        // 54 circle 21 — 22 french
        // 176 5/8ths

        // large squares
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [20.5, 20.5, 3]],
            [ROWS_N, 2],
        ],

        // triangles
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [23, 20.5, 3]],
            [ROWS_N, 3],
        ],

        // circles
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [21, 21, 3]],
            [COUNTER_SHAPE, SHAPE_CIRCLE],
            [ROWS_N, 3],
        ],

        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [16.5, 16.5, 3]],
        ],
    ],

    [TRAY, // Shared — 168 5/8ths
        [G_MAKE_LID_B, false],
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [16.5, 16.5, 3]],
        ],
    ],
];

Make(TOMAHAWKS_AND_BAYONETS);
