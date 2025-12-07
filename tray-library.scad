include <counter-tray-designer.lib.scad>

tray_letter = [215,250];
tray_gmt = [ 230,250];
tray_gmt2 = [ 220,250];
tray_revolution = [211,246];

half_inch_counter = 13.3;
old_half_inch_counter = 14;
five_eigths_counter = 16.5;
nine_sixteenths_counter = 15;

counter_depth_standard_cardboard = 3; // 1.6mm plus 1.4mm to prevent counters popping out.

standard_cardboard_counter = [ half_inch_counter, half_inch_counter, counter_depth_standard_cardboard];
five_eigths_cardboard_counter = [ five_eigths_counter, five_eigths_counter, counter_depth_standard_cardboard];
gmt_nine_sixteenths_counter = [ nine_sixteenths_counter, nine_sixteenths_counter, counter_depth_standard_cardboard ];
asl_small = [ half_inch_counter, half_inch_counter, half_inch_counter * .95];
asl_large = [ five_eigths_counter, five_eigths_counter, 11];
//sqrt(8.7*8.7 + 10*10)


TEST =
[
    [G_DIMENSIONS_XY, [90, 90]], 
    [G_FLOOR_THICKNESS_N, 1.5],
    // [G_MAKE_TRAY_B, false],
    // [G_MAKE_LID_B, false],
    [COUNTER_MARGINS_XY, [0.3,0.7]],
    [COUNTER_PEDESTAL_B, true],


    [COUNTER_SET,
        // [ENABLED_B, false],
        [ROWS_N, 1],
        [COUNTER_SIZE_XYZ, [20, 20, 4.6]],
		// [COUNTER_MARGINS_XY, [2, 0.2]],
        [COUNTER_SHAPE, SHAPE_CIRCLE ]
    ],

    [COUNTER_SET,
        // [ENABLED_B, false],
        [ROWS_N, 1],
        [COUNTER_SIZE_XYZ, [five_eigths_counter, five_eigths_counter, 2]],
		// [COUNTER_MARGINS_XY, [1, 1]],

        [COUNTER_SHAPE, SHAPE_SQUARE ]
    ],


    [COUNTER_SET,
        // [ENABLED_B, false],
        [COUNTER_SIZE_XYZ, [half_inch_counter, half_inch_counter, 2]],
        [COUNTER_SHAPE, SHAPE_SQUARE ]
    ],
];

TEST_SIMPLE =
[
    [G_DIMENSIONS_XY, [57, 22]], 
    [G_FLOOR_THICKNESS_N, 3],
    [G_MIN_PADDING_XY, [0,0]],
    [COUNTER_MARGINS_POST_LENGTH_FRACTION_N, .3],

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [20, 20, 20]],
    ],

];

TEST_STYLE_1 =
[
    [G_DIMENSIONS_XY, [1 + (nine_sixteenths_counter + 1) * 4 - 2, 1 + (nine_sixteenths_counter + 1) * 4]], 
   // [G_FLOOR_THICKNESS_N, 1.5],
   // [G_MIN_PADDING_XY, [0,1]],
   [COUNTER_MARGINS_POST_LENGTH_FRACTION_N, .3],
    [G_FRAME_STYLE_N, 1],

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [nine_sixteenths_counter, nine_sixteenths_counter, counter_depth_standard_cardboard]],
    ],
];

TEST_STYLE_2 =
[
    [G_DIMENSIONS_XY, [(nine_sixteenths_counter + 1) * 4, 1 + (nine_sixteenths_counter + 1) * 5]], 
    [G_FLOOR_THICKNESS_N, 3],
    [G_MIN_PADDING_XY, [0,0]],
    [COUNTER_MARGINS_POST_LENGTH_FRACTION_N, .2],
    [G_FRAME_STYLE_N, 2],

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [nine_sixteenths_counter, nine_sixteenths_counter, nine_sixteenths_counter - 1]],
    ],
];

TEST_STYLE_3 =
[
    [G_DIMENSIONS_XY, [ 80, 80]], 
    [G_FLOOR_THICKNESS_N, 3],
    [G_MIN_PADDING_XY, [0,0]],
    [COUNTER_MARGINS_POST_LENGTH_FRACTION_N, .7],
    [G_FRAME_STYLE_N, 3],

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [half_inch_counter, half_inch_counter, half_inch_counter - 1]],
    ],
];

TEST_STYLE_3b =
[
    [G_DIMENSIONS_XY, [ 80, 80]], 
    [G_FLOOR_THICKNESS_N, 3],
    [G_MIN_PADDING_XY, [0,0]],
    // [COUNTER_MARGINS_POST_LENGTH_FRACTION_N, .5],
    [G_FRAME_STYLE_N, 3],

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [five_eigths_counter, five_eigths_counter, five_eigths_counter - 1]],
    ],
];

TESTING = false;

if ( TESTING )
{
    main(TEST_STYLE_1);

    translate( [ 0, 100, 0 ] )
    main(TEST_STYLE_2);

    translate( [ 0, 200, 0 ] )
    main(TEST_STYLE_3);

    translate( [ 0, 300, 0 ] )
    main(TEST_STYLE_3b);    

    translate( [ 0, 400, 0 ] )
    main(TEST);    

    translate( [ 0, 500, 0 ] )
    main(TEST_SIMPLE);      
}

//////////////////////////////////////
// columbia games
//////////////////////////////////////


columbia_block_large = [25, 25, 12.8];
columbia_block_small = [20.6, 20.6, 11 ];

// large block, e.g. Caesar
// for a standard printer that can print up to 250mmx250mm
COLUMBIA_GAMES_LARGE = 
[
    [G_DIMENSIONS_XY, [ 221,248]],
    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, columbia_block_large],
    ],

];

// large block, e.g. Caesar
// for a large printer
COLUMBIA_GAMES_LARGE_BLOCK_XL = 
[
    [G_DIMENSIONS_XY, [ 221,296]],
    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, columbia_block_large],
    ],

];

// small block, e.g. Victory in the Pacific
// for a standard printer that can print up to 250mmx250mm
COLUMBIA_GAMES_SMALL_BLOCK = 
[
    [G_DIMENSIONS_XY, [ 209,231]],
    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, columbia_block_small],
    ],

];

COLUMBIA_GAMES_SMALL_BLOCK_XL = 
[
    [G_DIMENSIONS_XY, [ 205,275]],
    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, columbia_block_small],
    ],

];

//////////////////////////////////////
// panther games
//////////////////////////////////////
blue_panther_chipboard_depth = 3.2;


PANTHER_GAMES_CHIPBOARD_HALFSHEET = 
[
    [G_DIMENSIONS_XY, [208,156]], 

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [five_eigths_counter, five_eigths_counter, blue_panther_chipboard_depth]],
    ],

];

//////////////////////////////////////
// Avalon Hill
//////////////////////////////////////

AVALON_HILL_CAESAR_ALESIA = 
[
    // green: 224
    // red: 182
    // neutral: 48
    [G_DIMENSIONS_XY, [348,178]], 

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [half_inch_counter, half_inch_counter, counter_depth_standard_cardboard]],
    ],

];

AVALON_HILL_SEIGE_OF_JERUSALEM = 
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

    [COUNTER_SET,
        [ROWS_N, 6],
        [COUNTER_SIZE_XYZ, [five_eigths_counter, five_eigths_counter, counter_depth_standard_cardboard]],
    ],

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [half_inch_counter, half_inch_counter, counter_depth_standard_cardboard]],
    ],
];

//////////////////////////////////////
// Hollandspiele games
//////////////////////////////////////

HOLLANDSPIELE_MELTWATER = 
[
    [G_DIMENSIONS_XY, [208,265]], 

    [COUNTER_SET,
        [ROWS_N, 6],
        [COUNTER_SIZE_XYZ, [16.7, 16.7, 5.2]],
        [COUNTER_SHAPE, SHAPE_CIRCLE ]
    ],

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [five_eigths_counter, five_eigths_counter, blue_panther_chipboard_depth]],
    ],
];

//////////////////////////////////////
// Victory Games
//////////////////////////////////////

VICTORY_GAMES_THE_KOREAN_WAR = // print x2
[
    // box dimensions 205x285
        [G_DIMENSIONS_XY, [200,284]], 

  //  [G_DIMENSIONS_XY, [197,282]], 

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, standard_cardboard_counter],
    ],
];

// print x 2
VICTORY_GAMES_STORM_OVER_ARNHEM_1 = 
[

// large 19.5 x 19.5
// 68 British
// 47 SS
// 54 German
// 14 points

// rect 19.5 x 16.5
// 14 rect

    // box dimensions 205x285
    [G_DIMENSIONS_XY, [200,258]], 

    [COUNTER_SET,
        [ROWS_N, 1],
        [COUNTER_SIZE_XYZ, [19.5, 16.5, counter_depth_standard_cardboard]],
    ],

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [19.5, 19.5, counter_depth_standard_cardboard]],
    ],
];

// for the "dice" chits. print x1

// small 14 x 14
// 36 British
// 36 German

VICTORY_GAMES_STORM_OVER_ARNHEM_2 = 
[
    // box dimensions 205x285
    [G_DIMENSIONS_XY, [200,258]], 

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [14, 14, counter_depth_standard_cardboard]],
    ],
];

//////////////////////////////////////
// Conflict Games
//////////////////////////////////////

CONFLICT_GAMES_BAR_LEV = 
[
    // box dimensions 205x285
    [G_DIMENSIONS_XY, [200,267]], 

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [16, 16, counter_depth_standard_cardboard]],
    ],
];

AVALON_HILL_BREAKOUT_NORMANDY_1 = // x 2
[

// large 19.5 x 19.5
// 88 x 2

// small
// 130 x 2

    // box dimensions 205x285
    [G_DIMENSIONS_XY, [200,170]], 

    // [COUNTER_SET,
    //     // [ROWS_N, 9],
    //     [COUNTER_SIZE_XYZ, [five_eigths_counter,five_eigths_counter, counter_depth_standard_cardboard]],
    // ],

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [half_inch_counter, half_inch_counter, counter_depth_standard_cardboard]],
    ],
];

AVALON_HILL_BREAKOUT_NORMANDY_2 = // x 2
[

// large 19.5 x 19.5
// 88 x 2

// small
// 130 x 2

    // box dimensions 205x285
    [G_DIMENSIONS_XY, [200,170]], 

    [COUNTER_SET,
        // [ROWS_N, 9],
        [COUNTER_SIZE_XYZ, [five_eigths_counter,five_eigths_counter, counter_depth_standard_cardboard]],
    ],

    // [COUNTER_SET,
    //     [COUNTER_SIZE_XYZ, [half_inch_counter, half_inch_counter, counter_depth_standard_cardboard]],
    // ],
];


AVALON_HILL_PATTONS_BEST_1 = 
[


    // box dimensions 205x285
    [G_DIMENSIONS_XY, [190,170]], 

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [five_eigths_counter, five_eigths_counter, counter_depth_standard_cardboard]],
    ],
];

AVALON_HILL_PATTONS_BEST_2 = 
[


    // box dimensions 205x285
    [G_DIMENSIONS_XY, [190,170]], 

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [half_inch_counter, half_inch_counter, counter_depth_standard_cardboard]],
    ],
];


GMT_THE_US_CIVIL_WAR = // print x6
[
    // box dimensions 205x285
        [G_DIMENSIONS_XY, [205,270]], 

  //  [G_DIMENSIONS_XY, [197,282]], 

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, gmt_nine_sixteenths_counter],
    ],
];

MMP_ASL_1 =
[
    // box dimensions 205x285
    [G_DIMENSIONS_XY, [ 211, 281 ]], 
    [G_FLOOR_THICKNESS_N, 3],
    [G_MIN_PADDING_XY, [0,0]],
    [COUNTER_MARGINS_POST_LENGTH_FRACTION_N, .4],
    [G_FRAME_STYLE_N, 3],

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, asl_small],
    ],
];

MMP_ASL_2 =
[
    // box dimensions 205x285
    [G_DIMENSIONS_XY, [ 
        1 + ( five_eigths_counter + 1 ) * 12 , 
        1 + ( five_eigths_counter + 1 ) * 16]], 
    [G_FLOOR_THICKNESS_N, 3],
    [G_MIN_PADDING_XY, [0,0]],
    [COUNTER_MARGINS_POST_LENGTH_FRACTION_N, .4],
    [G_FRAME_STYLE_N, 3],

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, asl_large],
    ],
];

MMP_ASL_3 =
[
    // box dimensions 205x285
    [G_DIMENSIONS_XY, [ 
        1 + ( five_eigths_counter + 1 ) * 12 , 
        1 + ( five_eigths_counter + 1 ) * 16]], 
    [G_FLOOR_THICKNESS_N, 3],
    [G_MIN_PADDING_XY, [0,0]],
    [COUNTER_MARGINS_POST_LENGTH_FRACTION_N, .4],
    [G_FRAME_STYLE_N, 3],

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, asl_large],
        [ROWS_N, 8],
    ],    

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, asl_small],
    ],    

];

MMP_ASL_2_TEST =
[
    // box dimensions 205x285
    [G_DIMENSIONS_XY, [ 
        1 + ( five_eigths_counter + 1 ) * 4 , 
        1 + ( five_eigths_counter + 1 ) * 4]], 
    [G_FLOOR_THICKNESS_N, 3],
    [G_MIN_PADDING_XY, [0,0]],
    [COUNTER_MARGINS_POST_LENGTH_FRACTION_N, .4],
    [G_FRAME_STYLE_N, 3],

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, asl_large],
    ],
];

MMP_ASL_1_TEST =
[
    // box dimensions 205x285
    [G_DIMENSIONS_XY, [ 90, 90 ]], 
    [G_FLOOR_THICKNESS_N, 3],
    [G_MIN_PADDING_XY, [0,0]],
    [COUNTER_MARGINS_POST_LENGTH_FRACTION_N, .4],
    [G_FRAME_STYLE_N, 4],

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, asl_large],
        [ROWS_N, 1],
    ],

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, asl_small],
    ],

];

VG_THE_CIVIL_WAR =
[
    // box dimensions 205x285
    [G_DIMENSIONS_XY, [ 196, 256 ]], 
    [G_FLOOR_THICKNESS_N, 3],
    [G_MIN_PADDING_XY, [0,0]],
    [COUNTER_MARGINS_POST_LENGTH_FRACTION_N, .4],
    [G_FRAME_STYLE_N, 3],

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, 
        [ old_half_inch_counter, old_half_inch_counter, 1.8*4]],
    ],
];

LEGION_A_GLORIOUS_CHANCE_1 =
[

    // 288 square 5/8
    // 32 5/8 x 10/8

    // box dimensions 205x285
    [G_DIMENSIONS_XY, [ 193.5, 211 ]], 
    [G_FLOOR_THICKNESS_N, 2],
    [G_MIN_PADDING_XY, [0,0]],
    [COUNTER_MARGINS_POST_LENGTH_FRACTION_N, .4],
    [G_FRAME_STYLE_N, 3],


    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [five_eigths_counter, 31, counter_depth_standard_cardboard]],
        [ROWS_N, 3],
    ],

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [five_eigths_counter, five_eigths_counter, counter_depth_standard_cardboard]],
    ],    
];

LEGION_A_GLORIOUS_CHANCE_2 =
[

    // 288 square 5/8
    // 32 5/8 x 10/8

    // box dimensions 205x285
    [G_DIMENSIONS_XY, [ 193.5, 211 ]], 
    [G_FLOOR_THICKNESS_N, 2],
    [G_MIN_PADDING_XY, [0,0]],
    [COUNTER_MARGINS_POST_LENGTH_FRACTION_N, .4],
    [G_FRAME_STYLE_N, 3],

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [five_eigths_counter, five_eigths_counter, counter_depth_standard_cardboard*2]],
    ],    
];

WEG_TALES_OF_THE_ARABIAN_NIGHTS =
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

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [five_eigths_counter, five_eigths_counter, 6]],
    ],    
];

DG_RAF =
[

    // 288 square 5/8
    // 32 5/8 x 10/8

    // box dimensions 205x285
    [G_DIMENSIONS_XY, [ 211, 281 ]], 
    [G_FLOOR_THICKNESS_N, 2],
    [G_MIN_PADDING_XY, [0,0]],
    [COUNTER_MARGINS_POST_LENGTH_FRACTION_N, .4],
    [G_FRAME_STYLE_N, 3],
  //  [G_MAGNET_DIAMETER_N, 10.2],

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [five_eigths_counter, five_eigths_counter, 2]],
    ],    
];

GMT_TOMAHAWKS_AND_BAYONETS_BRITISH =
[

// 38 triangles: 20.5x23
//      11 british
//      5 either

// 54 circle    21
//      32 british

// 62 large square  20.5x20.5
//      46 british

// 176 5/8ths

    // [G_DIMENSIONS_XY, [ 215, 290 ]], 
    [G_DIMENSIONS_XY, [ 193, 282 ]], 
    [G_FLOOR_THICKNESS_N, 2],
    [G_MIN_PADDING_XY, [0,0]],
    [COUNTER_MARGINS_POST_LENGTH_FRACTION_N, .4],
    [G_FRAME_STYLE_N, 3],
    
  //  [G_MAGNET_DIAMETER_N, 10.2],

    // large square
    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [20.5, 20.5, 3]],
        [ROWS_N, 6],
    ], 

    // triangles
    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [23, 20.5, 3]],
        [ROWS_N, 2],
    ],   

    // circles
    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [21, 21, 3]],
        [COUNTER_SHAPE, SHAPE_CIRCLE],
        [ROWS_N, 4],
    ],  

     

    [COUNTER_SET,
        // [ENABLED_B, false],
        [COUNTER_SIZE_XYZ, [16.5, 16.5, 3]],
        [ROWS_N, 1],
    ],   
];

GMT_TOMAHAWKS_AND_BAYONETS_FRENCH =
[

// 38 triangles: 20.5x23
//      22 french

// 54 circle    21
//      22 french

// 62 large square  20.5x20.5
//      16 french

// 176 5/8ths


    // [G_DIMENSIONS_XY, [ 215, 290 ]], 
    [G_DIMENSIONS_XY, [ 193, 282 ]], 

    [G_FLOOR_THICKNESS_N, 2],
    [G_MIN_PADDING_XY, [0,0]],
    [COUNTER_MARGINS_POST_LENGTH_FRACTION_N, .4],
    [G_FRAME_STYLE_N, 3],
    
  //  [G_MAGNET_DIAMETER_N, 10.2],

    // large squares
    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [20.5, 20.5, 3]],
        [ROWS_N, 2],
    ],      
    
    
    // triangles
    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [23, 20.5, 3]],
        [ROWS_N, 3],
    ],   

    // circles
    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [21, 21, 3]],
        [COUNTER_SHAPE, SHAPE_CIRCLE],
        [ROWS_N, 3],
    ],  


    [COUNTER_SET,
        // [ENABLED_B, false],
        [COUNTER_SIZE_XYZ, [16.5, 16.5, 3]],
        // [ROWS_N, 1],
    ],   
];

GMT_TOMAHAWKS_AND_BAYONETS_SHARED =
[

// 168 5/8ths


    // [G_DIMENSIONS_XY, [ 215, 290 ]], 
    [G_DIMENSIONS_XY, [ 193, 282 ]], 

    [G_FLOOR_THICKNESS_N, 2],
    [G_MIN_PADDING_XY, [0,0]],
    [COUNTER_MARGINS_POST_LENGTH_FRACTION_N, .4],
    [G_FRAME_STYLE_N, 3],

    [COUNTER_SET,
        // [ENABLED_B, false],
        [COUNTER_SIZE_XYZ, [16.5, 16.5, 3]],
        // [ROWS_N, 1],
    ],   
];


tile_depth = 2.8;

GMT_1862_1 =
[

    [G_DIMENSIONS_XY, [ 231, 210 ]], 

    [G_FLOOR_THICKNESS_N, 2],
    [G_MIN_PADDING_XY, [0,0]],
    [G_FRAME_STYLE_N, 3],

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [45, 39, tile_depth * 5]],
        [COUNTER_SHAPE, SHAPE_HEX],
    ],   
];

GMT_1862_2 =
[

    [G_DIMENSIONS_XY, [ 231, 210 ]], 

    [G_FLOOR_THICKNESS_N, 2],
    [G_MIN_PADDING_XY, [0,0]],
    [G_FRAME_STYLE_N, 3],

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [33, 33, 8]],
    ],   
];

// need 2 of these:
GMT_1862_3 =
[
    // cards

    [G_DIMENSIONS_XY, [ 231, 210 ]], 

    [G_FLOOR_THICKNESS_N, 2],
    [G_MIN_PADDING_XY, [0,0]],
    [G_FRAME_STYLE_N, 3],
    [COUNTER_MARGINS_POST_LENGTH_FRACTION_N, .6],

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [45, 33.83, 12]],
        [COUNTER_HOLE_FRACTION_N, 0],

    ],   
];


// Battlefields of the Napoleonic Wars
BFNW =
[

    [G_DIMENSIONS_XY, [ 131, 148 ]], 

    [G_FLOOR_THICKNESS_N, 2],
    [G_MIN_PADDING_XY, [0,0]],
    [G_FRAME_STYLE_N, 3],
    [COUNTER_PEDESTAL_B, false],

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [17, 16, 6]],
        [ROWS_N, 1],

    ],

    [COUNTER_SET,
        [COUNTER_SIZE_XYZ, [25, 15, 11]],
        [COUNTER_MARGINS_POST_LENGTH_FRACTION_N, 0.2],





    ],   
];

main(BFNW);


g_make_svg = 0;


