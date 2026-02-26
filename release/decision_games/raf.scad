// Decision Games — RAF
include <../lib/counter_tray_designer_lib.1.scad>
include <../lib/decision_games_constants.scad>

RAF =
[
    // 288 square 5/8
    // 32 5/8 x 10/8

    // box dimensions 205x285
    [G_DIMENSIONS_XY, [ 211, 281 ]],
    [G_FLOOR_THICKNESS_N, 2],
    [G_MIN_PADDING_XY, [0,0]],
    [COUNTER_MARGINS_POST_LENGTH_FRACTION_N, .4],
    [G_FRAME_STYLE_N, 3],

    [TRAY,
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [five_eigths_counter, five_eigths_counter, 2]],
        ],
    ],
    
    [LID],
];

Make(RAF);
