// GMT Games — 1862: Railway Mania in the Eastern Counties
include <../lib/gmt_constants.scad>

tile_depth = 2.8;

GMT_1862 =
[
    [G_DIMENSIONS_XY, [ 231, 210 ]],
    [G_FLOOR_THICKNESS_N, 2],
    [G_MIN_PADDING_XY, [0,0]],
    [G_FRAME_STYLE_N, 3],

    [TRAY, // hex tiles
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [45, 39, tile_depth * 5]],
            [COUNTER_SHAPE, SHAPE_HEX],
        ],
    ],

    [TRAY, // square tokens
        [G_MAKE_LID_B, false],
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [33, 33, 8]],
        ],
    ],

    [TRAY, // cards — need 2 of these
        [G_MAKE_LID_B, false],
        [COUNTER_MARGINS_POST_LENGTH_FRACTION_N, .6],
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [45, 33.83, 12]],
            [COUNTER_HOLE_FRACTION_N, 0],
        ],
    ],
];

Make(GMT_1862);
