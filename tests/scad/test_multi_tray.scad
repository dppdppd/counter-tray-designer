// Test: multi-tray with TRAY hierarchy
// Verifies that Make() auto-arranges multiple trays in a grid.
// Two trays with shared defaults and different per-tray dimensions.

include <../../release/lib/counter_tray_designer_lib.1.scad>

TEST_MULTI_TRAY =
[
    // Shared defaults
    [G_FLOOR_THICKNESS_N, 2],
    [G_FRAME_STYLE_N, 4],

    [TRAY,
        [G_DIMENSIONS_XY, [50, 50]],
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [15, 15, 5]],
        ],
    ],

    [TRAY,
        [G_DIMENSIONS_XY, [40, 40]],
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [12, 12, 4]],
        ],
    ],
];

Make(TEST_MULTI_TRAY);
