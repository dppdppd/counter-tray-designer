// West End Games — Tales of the Arabian Nights
include <../lib/counter_tray_designer_lib.1.scad>
include <../lib/west_end_games_constants.scad>

TALES_OF_THE_ARABIAN_NIGHTS =
[

    // 288 square 5/8
    // 32 5/8 x 10/8

    // box dimensions 205x285
    [G_DIMENSIONS_XY, [ 211, 106 ]],
    [G_FLOOR_THICKNESS_N, 2],
    [G_MIN_PADDING_XY, [0,0]],
    [COUNTER_MARGINS_POST_LENGTH_FRACTION_N, .4],
    [G_FRAME_STYLE_N, 3],
  //  [G_MAGNET_DIAMETER_N, 10.2],

    [TRAY,
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [five_eigths_counter, five_eigths_counter, 6]],
        ],
    ],
];

Make(TALES_OF_THE_ARABIAN_NIGHTS);
