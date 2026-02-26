// The Avalon Hill Game Co — Siege of Jerusalem
include <../lib/counter_tray_designer_lib.1.scad>
include <../lib/avalon_hill_constants.scad>

SEIGE_OF_JERUSALEM =
[
    // 220 blue small
    // 32 blue large

    // 241 red small
    // 80 red large

    // 59 neutral small
    // 67 neutral large

    // large total: 179 (90)
    // small total: 520 (260)

    [G_DIMENSIONS_XY, [280,338]],

    [TRAY,
        [COUNTER_SET,
            [ROWS_N, 6],
            [COUNTER_SIZE_XYZ, [five_eigths_counter, five_eigths_counter, counter_depth_standard_cardboard]],
        ],

        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [half_inch_counter, half_inch_counter, counter_depth_standard_cardboard]],
        ],
    ],
    
    [LID],
];

Make(SEIGE_OF_JERUSALEM);
