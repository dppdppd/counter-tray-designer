// Test: backward compatibility with single-tray preset (no TRAY entries)
// Verifies that the new Make() module correctly delegates to _MakeSingleTray
// when no TRAY hierarchy is used.

include <../../release/lib/counter_tray_designer_lib.1.scad>

TEST_BACKWARD_COMPAT =
[
    [G_DIMENSIONS_XY, [90, 90]],
    [G_FLOOR_THICKNESS_N, 1.5],
    [COUNTER_MARGINS_XY, [0.3, 0.7]],
    [COUNTER_PEDESTAL_B, true],

    [COUNTER_SET,
        [ROWS_N, 1],
        [COUNTER_SIZE_XYZ, [20, 20, 4.6]],
        [COUNTER_SHAPE, SHAPE_CIRCLE],
    ],

    [COUNTER_SET,
        [ROWS_N, 1],
        [COUNTER_SIZE_XYZ, [16.5, 16.5, 2]],
        [COUNTER_SHAPE, SHAPE_SQUARE],
    ],

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [13.3, 13.3, 2]],
        [COUNTER_SHAPE, SHAPE_SQUARE],
    ],
];

Make(TEST_BACKWARD_COMPAT);
