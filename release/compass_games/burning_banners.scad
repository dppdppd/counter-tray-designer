/*
 * Counter Tray Designer
 * Version: 1.2
 * https://github.com/dppdppd/counter-tray-designer
 */

// Compass Games — Burning Banners
// Both counter layouts use the game's 284.2 x 222 mm tray footprint.
include <../lib/counter_tray_designer_lib.1.scad>

scene_1 = [
    [ G_DIMENSIONS_XY, [284.2, 222] ],
    [ TRAY, // miscellaneous 17 mm counters; print one tray and one lid
        [ NAME, "misc"],
        [ COUNTER_SET,
            [ COUNTER_SIZE_XYZ, [17, 17, 7] ],
        ],
    ],
    [ LID,
    ],
    [ TRAY, // 26 mm unit counters; print two trays
        [ NAME, "units"],
        [ COUNTER_SET,
            [ COUNTER_SIZE_XYZ, [26, 26, 7] ],
        ],
        [ PRINT_COUNT_N, 2 ],
    ],
];
Make(scene_1);
