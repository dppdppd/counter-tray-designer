// Victory Games — The Civil War
include <../lib/counter_tray_designer_lib.1.scad>
include <../lib/victory_games_constants.scad>

THE_CIVIL_WAR =
[
    // box dimensions 205x285
    [G_DIMENSIONS_XY, [ 196, 256 ]],
    [G_FLOOR_THICKNESS_N, 3],
    [G_MIN_PADDING_XY, [0,0]],
    [COUNTER_MARGINS_POST_LENGTH_FRACTION_N, .4],
    [G_FRAME_STYLE_N, 3],

    [TRAY,
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ,
            [ old_half_inch_counter, old_half_inch_counter, 1.8*4]],
        ],
    ],

    [LID],
];

Make(THE_CIVIL_WAR);
