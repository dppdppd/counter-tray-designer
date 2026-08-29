// Test: preview panel metadata
// A tray is rendered once even when three copies should be printed. Its lid
// inherits the tray dimensions and counter sets, but retains its own default
// print count of one and does not inherit the tray label. In preview, both
// panels show print quantity, counter capacity and size, and tray dimensions
// 5 mm beyond their positive-Y edge; only the tray shows its label.
// One separate full-set block reports the shared footprint and stack height.

include <../../release/lib/counter_tray_designer_lib.1.scad>

TEST_PREVIEW_METADATA =
[
    [G_FLOOR_THICKNESS_N, 2],
    [G_FRAME_STYLE_N, 4],
    [G_MIN_PADDING_XY, [1, 1]],

    [TRAY,
        [NAME, "Player Aid Counters"],
        [PRINT_COUNT_N, 3],
        [G_DIMENSIONS_XY, [44, 32]],
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [10, 10, 3]],
        ],
    ],
    [LID],
];

TEST_PREVIEW_GLOBALS = get_top_level_globals(TEST_PREVIEW_METADATA);
TEST_PREVIEW_TRAY = _grid_item_effective_data(TEST_PREVIEW_METADATA, TEST_PREVIEW_GLOBALS, 0);
TEST_PREVIEW_LID = _grid_item_effective_data(TEST_PREVIEW_METADATA, TEST_PREVIEW_GLOBALS, 1);
TEST_PREVIEW_TOTAL_HEIGHT = _get_total_stack_height(TEST_PREVIEW_METADATA, TEST_PREVIEW_GLOBALS);
TEST_PREVIEW_SET_XY = _get_full_set_dimensions_xy(TEST_PREVIEW_METADATA, TEST_PREVIEW_GLOBALS);

assert(_count_grid_items(TEST_PREVIEW_METADATA, TEST_PREVIEW_GLOBALS) == 2,
    "Preview must contain one tray panel and one lid panel");
assert(find_value(TEST_PREVIEW_TRAY, PRINT_COUNT_N, default = 1) == 3,
    "Tray print quantity must remain available to its preview label");
assert(find_value(TEST_PREVIEW_TRAY, NAME, default = "") == "Player Aid Counters",
    "Tray name must remain available to its preview label");
assert(find_value(TEST_PREVIEW_LID, NAME, default = "") == "",
    "Lid preview must not inherit the preceding tray name");
assert(find_value(TEST_PREVIEW_LID, G_DIMENSIONS_XY) == [44, 32],
    "Lid must inherit dimensions from its preceding tray");
assert(find_value(TEST_PREVIEW_LID, PRINT_COUNT_N, default = 1) == 1,
    "Lid must not inherit the tray print quantity");
assert(abs(TEST_PREVIEW_TOTAL_HEIGHT - 17.6) < 0.001,
    "Total height must include three 5 mm trays and one 2.6 mm lid");
assert(TEST_PREVIEW_SET_XY == [44, 32],
    "Full-set footprint must use the widest and deepest panel dimensions");

Make(TEST_PREVIEW_METADATA);
