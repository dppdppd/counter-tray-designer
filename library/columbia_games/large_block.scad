// Columbia Games — Large Block (e.g. Caesar)
include <columbia_games_constants.scad>

columbia_block_large = [25, 25, 12.8];

LARGE_BLOCK =
[
    [TRAY, // for a standard printer (250mm x 250mm)
        [G_DIMENSIONS_XY, [ 221,248]],
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, columbia_block_large],
        ],
    ],

    [TRAY, // for a large printer
        [G_MAKE_LID_B, false],
        [G_DIMENSIONS_XY, [ 221,296]],
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, columbia_block_large],
        ],
    ],
];

Make(LARGE_BLOCK);
