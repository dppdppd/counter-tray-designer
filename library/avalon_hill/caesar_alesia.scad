// The Avalon Hill Game Co — Caesar: Alesia
include <avalon_hill_constants.scad>

CAESAR_ALESIA =
[
    // green: 224
    // red: 182
    // neutral: 48
    [G_DIMENSIONS_XY, [348,178]],

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [half_inch_counter, half_inch_counter, counter_depth_standard_cardboard]],
    ],

];

Make(CAESAR_ALESIA);
