// Columbia Games — Small Block (e.g. Victory in the Pacific)
include <../lib/counter_tray_designer_lib.1.scad>
include <../lib/columbia_games_constants.scad>

columbia_block_small = [20.6, 20.6, 11 ];

SMALL_BLOCK =
[
    [TRAY, // for a standard printer (250mm x 250mm)
        [G_DIMENSIONS_XY, [ 209,231]],
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, columbia_block_small],
        ],
    ],

    [TRAY, // for a large printer
        [G_MAKE_LID_B, false],
        [G_DIMENSIONS_XY, [ 205,275]],
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, columbia_block_small],
        ],
    ],
];

Make(SMALL_BLOCK);
