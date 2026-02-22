// Legion Wargames — A Glorious Chance
include <legion_wargames_constants.scad>

// 288 square 5/8
// 32 5/8 x 10/8

A_GLORIOUS_CHANCE =
[
    // box dimensions 205x285
    [G_DIMENSIONS_XY, [ 193.5, 211 ]],
    [G_FLOOR_THICKNESS_N, 2],
    [G_MIN_PADDING_XY, [0,0]],
    [COUNTER_MARGINS_POST_LENGTH_FRACTION_N, .4],
    [G_FRAME_STYLE_N, 3],

    [TRAY, // rectangular + square counters
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [five_eigths_counter, 31, counter_depth_standard_cardboard]],
            [ROWS_N, 3],
        ],

        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [five_eigths_counter, five_eigths_counter, counter_depth_standard_cardboard]],
        ],
    ],

    [TRAY, // double-depth square counters
        [G_MAKE_LID_B, false],
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [five_eigths_counter, five_eigths_counter, counter_depth_standard_cardboard*2]],
        ],
    ],
];

Make(A_GLORIOUS_CHANCE);
