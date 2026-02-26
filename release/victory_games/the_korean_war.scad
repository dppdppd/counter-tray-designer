// Victory Games — The Korean War
include <../lib/counter_tray_designer_lib.1.scad>
include <../lib/victory_games_constants.scad>

THE_KOREAN_WAR = // print x2
[
    // box dimensions 205x285
    [G_DIMENSIONS_XY, [200,284]],

    [TRAY,
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, standard_cardboard_counter],
        ],
        [TRAY_PRINT_COUNT_N, 2]

    ],
    
    [LID],
];

Make(THE_KOREAN_WAR);
