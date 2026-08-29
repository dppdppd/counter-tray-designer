// Test: PRINT_COUNT_N
// Verifies that print count remains panel metadata instead of generating
// duplicate geometry. Two trays and two lids produce four unique panels.

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

TEST_PRINT_COUNT_GLOBALS = get_top_level_globals(TEST_PRINT_COUNT);
assert(_count_grid_items(TEST_PRINT_COUNT, TEST_PRINT_COUNT_GLOBALS) == 4,
    "PRINT_COUNT_N must not duplicate tray or lid geometry");

Make(TEST_PRINT_COUNT);
