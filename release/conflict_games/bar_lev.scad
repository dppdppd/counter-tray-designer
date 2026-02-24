// Conflict Games — Bar-Lev
include <../lib/counter_tray_designer_lib.1.scad>
include <../lib/conflict_games_constants.scad>

BAR_LEV =
[
    // box dimensions 205x285
    [G_DIMENSIONS_XY, [200,267]],

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [16, 16, counter_depth_standard_cardboard]],
    ],
];

Make(BAR_LEV);
