// GMT Games — The U.S. Civil War
include <../lib/counter_tray_designer_lib.1.scad>
include <../lib/gmt_constants.scad>

THE_US_CIVIL_WAR = // print x6
[
    // box dimensions 205x285
        [G_DIMENSIONS_XY, [205,270]],

  //  [G_DIMENSIONS_XY, [197,282]],

    [TRAY,
        [COUNTER_SET,
            [COUNTER_SIZE_XYZ, gmt_nine_sixteenths_counter],
        ],
    ],
];

Make(THE_US_CIVIL_WAR);
