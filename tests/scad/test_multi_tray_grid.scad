// Test: multi-tray grid layout with G_GRID_COLUMNS_N
// Verifies that 4 trays arrange into a 2x2 grid.

include <../../release/lib/counter_tray_designer_lib.1.scad>

TEST_GRID =
[
    [G_FLOOR_THICKNESS_N, 2],
    [G_FRAME_STYLE_N, 4],
    [G_GRID_COLUMNS_N, 2],
    [G_GRID_SPACING_N, 5],

    [TRAY,
        [G_DIMENSIONS_XY, [40, 40]],
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [12, 12, 4]],
        ],
    ],

    [TRAY,
        [G_DIMENSIONS_XY, [40, 40]],
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [15, 15, 5]],
        ],
    ],

    [TRAY,
        [G_DIMENSIONS_XY, [40, 40]],
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [10, 10, 3]],
        ],
    ],

    [TRAY,
        [G_DIMENSIONS_XY, [40, 40]],
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [18, 18, 6]],
        ],
    ],
];

Make(TEST_GRID);
