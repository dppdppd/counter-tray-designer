// Blue Panther LLC — Chipboard Halfsheet
include <../lib/counter_tray_designer_lib.1.scad>
include <../lib/blue_panther_constants.scad>

CHIPBOARD_HALFSHEET =
[
    [G_DIMENSIONS_XY, [208,156]],

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [five_eigths_counter, five_eigths_counter, blue_panther_chipboard_depth]],
    ],

];

Make(CHIPBOARD_HALFSHEET);
