// The Avalon Hill Game Co — Caesar: Alesia
include <../lib/counter_tray_designer_lib.1.scad>
include <../lib/avalon_hill_constants.scad>

CAESAR_ALESIA =
[
    // green: 224
    // red: 182
    // neutral: 48
    [G_DIMENSIONS_XY, [348,178]],

    [TRAY,
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, [half_inch_counter, half_inch_counter, counter_depth_standard_cardboard]],
        ],

    ],
];

Make(CAESAR_ALESIA);
