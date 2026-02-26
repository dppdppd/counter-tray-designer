// Test: per-tray global overrides
// Verifies that tray-local settings override shared defaults.
// Two trays: one with style 3 (override), one using shared style 4.

include <../../release/lib/counter_tray_designer_lib.1.scad>

TEST_MULTI_TRAY_OVERRIDE =
[
    // Shared defaults
    [G_FLOOR_THICKNESS_N, 2],
    [G_FRAME_STYLE_N, 4],
    [G_MIN_PADDING_XY, [0, 0]],

    [TRAY,
        [G_DIMENSIONS_XY, [60, 60]],
        [G_FRAME_STYLE_N, 3],  // override: style 3 (side nubs)
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [15, 15, 5]],
        ],
    ],
    [LID],

    [TRAY,
        [G_DIMENSIONS_XY, [50, 50]],
        // inherits G_FRAME_STYLE_N = 4 (no magnets)
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [12, 12, 4]],
        ],
    ],
    [LID],
];

Make(TEST_MULTI_TRAY_OVERRIDE);
