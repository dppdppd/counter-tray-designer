// Multi-Man Publishing — Advanced Squad Leader
include <../lib/counter_tray_designer_lib.1.scad>
include <../lib/mmp_constants.scad>

asl_small = [ half_inch_counter, half_inch_counter, half_inch_counter];
asl_large = [ five_eigths_counter, five_eigths_counter, 11];

ASL =
[
    // box dimensions 205x285
    [G_FLOOR_THICKNESS_N, 3],
    [G_MIN_PADDING_XY, [0,0]],
    [COUNTER_MARGINS_POST_LENGTH_FRACTION_N, .4],
    [G_FRAME_STYLE_N, 3],
    [G_MAGNET_DIAMETER_N, 10.2],

    [TRAY, // small counters
        [G_DIMENSIONS_XY, [ 211, 281 ]],
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, asl_small],
        ],
    ],
    [LID],

    [TRAY, // large counters
        [G_DIMENSIONS_XY, [
            1 + ( five_eigths_counter + 1 ) * 12 ,
            1 + ( five_eigths_counter + 1 ) * 16]],
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, asl_large],
        ],
    ],

    [TRAY, // mixed large + small
        [G_DIMENSIONS_XY, [
            1 + ( five_eigths_counter + 1 ) * 12 ,
            1 + ( five_eigths_counter + 1 ) * 16]],
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, asl_large],
            [ROWS_N, 8],
        ],
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, asl_small],
        ],
    ],
];

ASL_TEST =
[
    [G_FLOOR_THICKNESS_N, 3],
    [G_MIN_PADDING_XY, [0,0]],
    [COUNTER_MARGINS_POST_LENGTH_FRACTION_N, .4],

    [TRAY, // large test
        [G_DIMENSIONS_XY, [
            1 + ( five_eigths_counter + 1 ) * 4 ,
            1 + ( five_eigths_counter + 1 ) * 4]],
        [G_FRAME_STYLE_N, 3],
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, asl_large],
        ],
    ],
    [LID],

    [TRAY, // mixed test
        [G_DIMENSIONS_XY, [ 90, 90 ]],
        [G_FRAME_STYLE_N, 4],
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, asl_large],
            [ROWS_N, 1],
        ],
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, asl_small],
        ],
    ],
];

Make(ASL);
