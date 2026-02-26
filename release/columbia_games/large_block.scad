// Columbia Games — Large Block (e.g. Caesar)
include <../lib/counter_tray_designer_lib.1.scad>
include <../lib/columbia_games_constants.scad>

columbia_block_large = [25, 25, 12.8];

LARGE_BLOCK_250MM = // for a standard printer (250mm x 250mm)
[
    [TRAY, 
        [G_DIMENSIONS_XY, [ 221,248]],
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, columbia_block_large],
        ],
    ],

    [LID]
];

LARGE_BLOCK_300MM = // for a large printer
[
    [TRAY,
        [G_DIMENSIONS_XY, [ 221,296]],
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, columbia_block_large],
        ],
    ],
    
    [LID]
];

Make(LARGE_BLOCK_300MM);
