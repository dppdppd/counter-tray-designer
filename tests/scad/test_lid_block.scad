// Test: LID as peer block to TRAY
// Verifies that:
//   - A TRAY followed by [LID] gets a lid
//   - A TRAY without a following [LID] does not get a lid
//   - LID block can contain overrides (e.g. custom lid depth)

include <../../release/lib/counter_tray_designer_lib.1.scad>

TEST_LID_BLOCK =
[
    [G_FLOOR_THICKNESS_N, 2],
    [G_FRAME_STYLE_N, 4],

    // Tray 1: has a lid with custom depth override
    [TRAY,
        [G_DIMENSIONS_XY, [40, 40]],
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [12, 12, 4]],
        ],
    ],
    [LID,
        [G_LID_DEPTH_N, 4],
    ],

    // Tray 2: no lid
    [TRAY,
        [G_DIMENSIONS_XY, [30, 30]],
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [10, 10, 3]],
        ],
    ],
];

Make(TEST_LID_BLOCK);
