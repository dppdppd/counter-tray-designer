// Test: PRINT_COUNT_N
// Verifies that a tray with print count > 1 generates multiple copies
// in the grid layout. Tray 1 (print x2) + Tray 2 (print x1) = 3 virtual trays.

include <../../release/lib/counter_tray_designer_lib.1.scad>

TEST_PRINT_COUNT =
[
    [G_FLOOR_THICKNESS_N, 2],
    [G_FRAME_STYLE_N, 4],

    [TRAY,
        [PRINT_COUNT_N, 2],
        [G_DIMENSIONS_XY, [40, 40]],
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [12, 12, 4]],
        ],
    ],
    [LID],

    [TRAY,
        [G_DIMENSIONS_XY, [30, 30]],
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [10, 10, 3]],
        ],
    ],
    [LID],
];

Make(TEST_PRINT_COUNT);
