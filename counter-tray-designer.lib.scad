VERSION = "1.00";
COPYRIGHT_INFO = "\tCounter Tray Designer\n\thttps://github.com/dppdppd/counter_tray_designer\n\n\tCopyright 2024 Ido Magal\n\tCreative Commons - Attribution - Non-Commercial - Share Alike.\n\thttps://creativecommons.org/licenses/by-nc-sa/4.0/legalcode";

g_make_filler = 0;

g_make_svg = 0;

// global
G_MAKE_TRAY_B = "G_MAKE_TRAY_B";
G_MAKE_LID_B = "G_MAKE_LID_B";
G_FLOOR_THICKNESS_N = "G_FLOOR_THICKNESS_N";
G_DIMENSIONS_XY = "G_DIMENSIONS_XY";
G_MIN_PADDING_XY = "G_MIN_PADDING_XY";
G_LID_DEPTH_N = "G_LID_DEPTH_N"; 
G_FRAME_STYLE_N = "G_FRAME_STYLE_N";
G_MAGNET_DIAMETER_N = "G_MAGNET_DIAMETER_N";

//either
COUNTER_SHAPE = "COUNTER_SHAPE";
COUNTER_MARGINS_XY = "COUNTER_MARGINS_XY";
COUNTER_MARGINS_POST_LENGTH_FRACTION_N = "COUNTER_MARGINS_POST_LENGTH_FRACTION_N";
COUNTER_HOLE_FRACTION_N = "COUNTER_HOLE_FRACTION_N";


//set
COUNTER_SET = "COUNTER_SET";
ROWS_N = "START_ROW";
COUNTER_SIZE_XYZ = "COUNTER_SIZE_XYZ";
ENABLED_B = "ENABLED_B";

// values
SHAPE_SQUARE = "SHAPE_SQUARE";
SHAPE_CIRCLE = "SHAPE_CIRCLE";
SHAPE_TRIANGLE = "SHAPE_TRIANGLE";

DATA = [];

// constants
KEY = 0;
VALUE = 1;

function get_element( table, i ) = table[ i ];
function get_num_elements( table ) = len( table );

function get_key( table ) = table[KEY];

function find_key( table, key ) = search( [ key ], table )[ KEY ];
function find_value( table, key, default = false ) = find_key( table, key ) == [] ? default : table[ find_key( table, key ) ][ VALUE ];

// count the number of keys matching the parm
function count_keys( table, key, start = 0, stop = -1, idx = 0, sum = 0 ) = 
	let( end = ( stop != -1 && stop < len(table) ) ? stop + 1 : len(table) )
	let( idx = start + idx )
    idx < end ? 
        count_keys( table, key, 0, stop, idx + 1, sum + ( get_key( table[idx] ) == key ? 1 : 0 )) : 
        sum;

///////////////////////////////////////////////////////////////////////

function is_preview() =  $preview;
$fn = is_preview() ? 20 : 50;

module main( DATA = DATA)
{
    echo( str( "\n\n\n", COPYRIGHT_INFO, "\n\n\tVersion ", VERSION, "\n\n" ));

    echo();
    echo( str(tray_size_3d.x," mm x ", tray_size_3d.y," mm"));
    echo( str(tray_size_3d.x/25.4," in x ", tray_size_3d.y/25.4," in"));
    echo();
    echo( str("Ideal size: ", get_max_set_size_x() + tray_padding.x * 2, "mm x ", 
    ceil(get_all_sets_size_y() + tray_padding.y * 2), "mm" ));

    function is_set( idx )  = get_key( get_element( DATA, idx) ) == COUNTER_SET;
    function get_set_idx( idx ) = count_keys( DATA, COUNTER_SET, stop = idx );
    num_sets = count_keys( DATA, COUNTER_SET );

    function get_set( set_idx, idx = 0 ) =
        idx > get_num_elements(DATA) ? [] :
    //    echo( idx=idx, is_set=is_set(idx), count_keys=count_keys( DATA, COUNTER_SET, stop = idx ) )
        is_set( idx ) && count_keys( DATA, COUNTER_SET, stop = idx ) - 1 == set_idx ?
            get_element( DATA, idx ) :
            get_set( set_idx, idx = idx + 1 );

    /////////////////////////////////////////
 
    _floor_thickness = find_value( DATA, G_FLOOR_THICKNESS_N, default = 1.5);
    make_tray = find_value( DATA, G_MAKE_TRAY_B, default = true);
    make_lid = find_value( DATA, G_MAKE_LID_B, default = true);
    frame_style = find_value( DATA, G_FRAME_STYLE_N, default = 1);
    magnet_diameter = find_value( DATA, G_MAGNET_DIAMETER_N, default = 6.2 );

    no_magnets = frame_style == 4;

    // todo: add this to the KV
    // note that turning it on makes the tray more aesthetic but that you can't mix and match sizes because they won't line up
    MOVE_NUBS_TO_COUNTER_POSITIONS = false;

    //magnet_diameter = frame_style < 3 ? 6.2 : 10.2;
    magnet_wall_min = frame_style < 3 ? 0.2 : !MOVE_NUBS_TO_COUNTER_POSITIONS ? 1.2 : (get_counter_size_outer( 0 ).x - magnet_diameter )/2;
    magnet_outer_diameter = magnet_diameter + magnet_wall_min * 2;
    magnet_nub_max_spacing = 100;

    magnet_depth = 1.4;
    magnet_distance_from_edge = [(magnet_outer_diameter)/2, (magnet_outer_diameter)/2 ];

    // we don't allow a min y padding of less than required for a magnet, but only in styles 1 and 2
    tray_min_padding_raw = find_value( DATA, G_MIN_PADDING_XY, default = [magnet_outer_diameter,1]);
    _padding_min_x = tray_min_padding_raw.x >= magnet_outer_diameter ? tray_min_padding_raw.x : magnet_outer_diameter;
    tray_padding = [ frame_style >= 3 ? tray_min_padding_raw.x : _padding_min_x, tray_min_padding_raw.y ];

    lid_depth = find_value( DATA, G_LID_DEPTH_N, default = 2.6);
    function get_counter_margins_default() = find_value( DATA, COUNTER_MARGINS_XY, default = [0.5,0.5]);
    g_counter_shape = find_value( DATA, COUNTER_SHAPE, default = SHAPE_SQUARE);
    g_counter_margins_post_length_fraction = find_value( DATA, COUNTER_MARGINS_POST_LENGTH_FRACTION_N, default = 0.25);
    g_counter_hole_fraction = find_value( DATA, COUNTER_HOLE_FRACTION_N, default = 0.7);

    tray_size_raw = find_value(DATA, G_DIMENSIONS_XY, default = [50,50]);

    tray_size_3d = [ 
        tray_size_raw.x,
        tray_size_raw.y,
        get_tray_size_z()
    ];

     usable_area = [
        tray_size_3d.x - ( 2 * tray_padding.x ) - ( 2 * get_counter_margins().x ),
        tray_size_3d.y - ( 2 * tray_padding.y ) - ( 2 * get_counter_margins().y )
    ];    

    all_sets_y_offset = 
        ( tray_size_3d.y - get_all_sets_size_y() )/2;

    function get_tray_size_z( setidx = 0, max_z = 0 ) =
            setidx < num_sets ?
            get_tray_size_z( setidx + 1, max( max_z, get_counter_size(setidx).z + _floor_thickness)) :
            max_z;


    PER_SET_FLOOR_THICKNESS = true;
    function get_set_floor_thickness(setidx) = 
        PER_SET_FLOOR_THICKNESS ? tray_size_3d.z - get_counter_size(setidx).z :
        _floor_thickness;

    g_fill_corners = 0;
    g_tolerance = 0.1;

    function is_enabled(setidx) = find_value( get_set( setidx ), ENABLED_B, default = true);

    function get_counter_size( setidx ) = find_value( get_set( setidx ), COUNTER_SIZE_XYZ, default = [1,1,1]);
    function get_counter_shape( setidx ) = find_value( get_set( setidx ), COUNTER_SHAPE, default = g_counter_shape);

    // trigon
    function get_tri_counter_center_margins( setidx ) = [ get_counter_margins().x * cos(45), get_counter_margins().y * sin(45), 0];

    function get_counter_size_outer( setidx ) = [
        ( find_value( get_set( setidx ), COUNTER_SIZE_XYZ, default = [1,1,1]) ).x + 2 * get_counter_margins().x,
        ( find_value( get_set( setidx ), COUNTER_SIZE_XYZ, default = [1,1,1]) ).y + 2 * get_counter_margins().y,
        find_value( get_set( setidx ), COUNTER_SIZE_XYZ, default = [1,1,1]).z];

    function get_counter_margins( setidx ) = find_value( get_set(setidx), COUNTER_MARGINS_XY, default = get_counter_margins_default());
    function get_counter_margins_post_length_fraction( setidx ) = find_value( get_set(setidx), COUNTER_MARGINS_POST_LENGTH_FRACTION_N, default = g_counter_margins_post_length_fraction);
    function get_counter_hole_fraction( setidx ) = find_value( get_set(setidx), COUNTER_HOLE_FRACTION_N, default = g_counter_hole_fraction);

    function num_rows_raw( setidx ) = find_value( get_set( setidx ), ROWS_N, default = -1);

    function get_num_rows( setidx ) = 
        let( num_rows_raw = num_rows_raw( setidx ))
        num_rows_raw > 0 ?
        num_rows_raw :
        let( y_pos = get_set_y_position( setidx ))
        floor((usable_area.y - y_pos ) / get_counter_size_outer(setidx).y);

    function get_num_columns( setidx ) =
        floor(( usable_area.x ) / get_counter_size_outer(setidx).x );

    function get_num_counters( setidx ) = [
        get_num_columns(setidx = setidx),
        get_num_rows(setidx = setidx) ];

    function get_set_size( setidx ) = [
        get_num_counters(setidx).x * get_counter_size_outer(setidx).x + 2*get_counter_margins().x,
        get_num_counters(setidx).y * get_counter_size_outer(setidx).y + 2*get_counter_margins().y
    ];

    function get_max_set_size_x( setidx = 0, max_x = 0 ) =
        setidx < num_sets ?
        is_enabled( setidx ) ? max( max_x, get_set_size( setidx ).x ) : max_x : 
        max_x;

    function get_all_sets_size_y( setidx = 0, sum = 0) =
        setidx < num_sets ?
        let(sum_new = is_enabled(setidx) ? sum + get_set_size( setidx ).y : sum)
        get_all_sets_size_y( setidx + 1, sum_new) :
        sum;

    function get_set_x_position( setidx ) = 
        ( tray_size_3d.x - get_set_size( setidx ).x )/2;

    function get_set_y_position( stop, setidx = 0, y = 0 ) = 
        setidx < stop ?
            let( counter_size_y = get_counter_size(setidx).y)
            let( counter_size_outer_y = counter_size_y + 2 * get_counter_margins().y)
            let( num_rows = num_rows_raw(setidx))        
            let (offset = get_counter_margins().y * 2 )
            let (y_new =  is_enabled(setidx)? y + offset + ( num_rows * counter_size_outer_y) : y)
            get_set_y_position( stop, setidx + 1, y_new ) :
            y;



    // if ( g_make_filler )
    // translate([0,10,0]) 
    // create_filler();

    color_base = "white";
    color_padding = "yellow";

    if ( num_sets > 1 )
    for( i = [0:num_sets-2])
        assert(num_rows_raw(i) != -1, "All Sets (expect for the last set) must specify ROWS_N" );

    if ( make_tray && !g_make_svg )
    {

        difference() {

            union(){
                create_tray_center();

                if ( frame_style == 1 )
                    create_border_padding();
                else if ( !no_magnets )
                    create_magnet_nubs_both_sides();
            }

            union() {
                if ( frame_style == 1 )
                create_border_padding_magnet_holes();
                else if ( !no_magnets )
                create_magnet_nub_holes_both_sides();

                if ( !g_make_svg && ( frame_style < 3 ) )
                create_notches();
            }
        }
    }
    else if ( g_make_svg )
    {
        projection(cut = false)
        create_tray_center(false);
    }

    if ( make_lid && !g_make_svg)
    place_lid()
    {
        difference() {

            create_lid();

            union() {
                if ( !no_magnets && frame_style == 1 )
                create_border_padding_magnet_holes();
                else if ( !no_magnets )
                create_magnet_nub_holes_both_sides();

                if ( !g_make_svg && ( frame_style < 3 ) )
                create_notches();
            }
        }
    }

    echo();

///////////////////////////////////////////
    module place_four_mirrored_on_xy( dimensions = [0,0,0])
    {
        translate(dimensions/2)
        {
            children();

            mirror([0,1,0])
            children();

            mirror([1,0,0])
            children(); 

            mirror([1,0,0])
            mirror([0,1,0])
            children();   
        }
    }

    module create_magnet_slots( body_depth )
    {

        function IsTrayDeep() = tray_size_3d.z > ( 2 * magnet_depth + 0.2 );

        create_one_set_of_magnet_slots();

        if ( IsTrayDeep() )
        {
            translate([0, 0, tray_size_3d.z - magnet_depth])
            create_one_set_of_magnet_slots();
        }
        

        module create_one_set_of_magnet_slots()
        {
            dimensions = [tray_size_3d.x, tray_size_3d.y, 0];
            place_four_mirrored_on_xy( dimensions )
            create_single_magnet_slot();
        }
    }

    module create_single_magnet_slot()
    {
        translate( [tray_size_3d.x/2 - magnet_distance_from_edge.x, tray_size_3d.y/2 - magnet_distance_from_edge.y, magnet_depth/2])
        cylinder( h = magnet_depth, d = magnet_diameter, center = true );
    }

    module create_notches()
    {
        diam = 6;
        height = tray_size_3d.z * 2;
        
        M = [   [ 1,    0,    0,  0   ],
                [ 0.3,  1,    0,  0   ],
                [ 0,    0,    1,  0   ],
                [ 0,    0,    0,  1   ] ] ;

        module create_hook_indent()
        {
            union()
            {
                multmatrix(M)
                cube( [diam,diam,height], center=true );

                mirror([1,0,0])
                multmatrix(M)
                cube( [diam,diam,height], center=true );
            }
        }

        module create_hook_indent_left()
        {
            rotate(90,[0,0,1])
            create_hook_indent();

        }

        translate([tray_size_3d.x/2, tray_size_3d.y/2, tray_size_3d.z/2])
        {
            place_four_mirrored_on_xy()
            {
                translate( [tray_size_3d.x/2, tray_size_3d.y/4,0])
                create_hook_indent();
                    
            
            *   translate( [tray_size_3d.x/4, tray_size_3d.y/2,0])
                create_hook_indent_left();
            }
        }
    } 

    module create_tray_center( make_base = true)
    {
        // base
        if ( make_base )
        {
            difference() {

                union()
                {
                    // minimum sheet
                    cube( [tray_size_3d.x, tray_size_3d.y, _floor_thickness]);

                    // per set floor
                    for( setidx = [ 0: num_sets-1 ] )
                    {	     
                        translate( [get_set_x_position(setidx), get_set_y_position(setidx) + all_sets_y_offset ,0])   
                        { 
                      //  cube( [get_set_size(setidx).x, get_set_size(setidx).y, get_set_floor_thickness(setidx)]);
                        create_set_of_counter_holes( setidx, extra = 2 );
                        }

                    }
                }

                for( setidx = [ 0: num_sets-1 ] )
                {	
                    if ( is_enabled(setidx) )
                    {
                        echo( str( get_num_counters(setidx).x,
                            " x ",
                            get_num_counters(setidx).y,
                            " ",
                            get_counter_size(setidx), 
                            ", total=",
                            get_num_counters(setidx).x * get_num_counters(setidx).y));

                        translate( [get_set_x_position(setidx), get_set_y_position(setidx) + all_sets_y_offset ,0])
                        create_set_of_counter_holes( setidx );
                        
                    }
                }
            }
        }

        // dividers
        for( setidx = [ 0: num_sets-1 ] )
        {	
            if ( is_enabled(setidx) )
            {
                translate( [get_set_x_position(setidx), get_set_y_position(setidx) + all_sets_y_offset ,0])
                {
                    color( rands(0, 1, 3) )
                    create_set_of_counters( setidx );
                }

            // cube([tray_size_3d.x, tray_size_3d.y, 1]);
            }
    
        }
    }

    function tray_requires_double_magnets() = tray_size_3d.z > ( 2 * magnet_depth + 0.2 );

    module create_magnet_nubs_both_sides()
    {
        create_one_set_magnet_nubs();

        mirror([1,0,0])
        translate( [(-tray_size_3d.x ),0])
        create_one_set_magnet_nubs();
    }

    module create_magnet_nub_holes_both_sides()
    {
        create_one_set_magnet_nub_holes();

        mirror([1,0,0])
        translate( [(-tray_size_3d.x ),0])
        create_one_set_magnet_nub_holes();
    }    


    module place_nub_children()
    {
        offset_r = frame_style == 3 ? [ get_set_x_position(0), all_sets_y_offset,0] : [0,0,0];
        offset_l = frame_style == 3 ? [ get_set_x_position(0), -all_sets_y_offset,0] : [0,0,0];

        nub_size = magnet_outer_diameter;
        nub_count = max( 2, floor(tray_size_3d.y / magnet_nub_max_spacing));
        nub_gap = ((tray_size_3d.y - (nub_count * nub_size))  / (nub_count-1));
        for( y = [ 0: nub_count-1 ] )
        {
            translate( [0, (y * (nub_gap + nub_size)), 0])
            {
                contextual_offset = MOVE_NUBS_TO_COUNTER_POSITIONS ? y == 0 ? offset_r : y == nub_count-1 ? offset_l : [0,0,0] : [0,0,0];

                translate(contextual_offset)
                children();
            }
        }   
    }


    module create_one_set_magnet_nubs()
    {
        place_nub_children()
        cube([ magnet_outer_diameter,magnet_outer_diameter,tray_size_3d.z ]);
    }
    
    module create_one_set_magnet_nub_holes()
    {
        module create_release_gap()
        {
            release_tool_fraction = 6;

            translate( [magnet_outer_diameter/2,magnet_outer_diameter/2,magnet_depth/2])
            {
                cube( [ magnet_outer_diameter, magnet_outer_diameter/release_tool_fraction, magnet_depth*3], center = true );  
            }
        }

        place_nub_children()
        {
            CUT_THROUGH = false;

            translate( [magnet_outer_diameter/2,magnet_outer_diameter/2,magnet_depth/2])
            cylinder( h = magnet_depth, d = magnet_diameter, center = true );

            if ( !CUT_THROUGH )
            create_release_gap();

            if ( tray_requires_double_magnets() )
            {
                translate([0, 0, tray_size_3d.z - magnet_depth]) {
                    translate( [magnet_outer_diameter/2,magnet_outer_diameter/2,magnet_depth/2])
                    cylinder( h = magnet_depth, d = magnet_diameter, center = true );

                    if ( !CUT_THROUGH )
                    create_release_gap();
                }
            }

            if ( CUT_THROUGH )
            translate( [magnet_outer_diameter/4,magnet_outer_diameter/2,tray_size_3d.z/2])
            cube( [ magnet_outer_diameter/2, magnet_outer_diameter/release_tool_fraction, tray_size_3d.z], center = true );
        }
    }

    module create_border_padding_magnet_holes()
    {
        create_magnet_slots( body_depth = tray_size_3d.z );
    }

    module create_border_padding()
    {
        color( color_padding)
        difference()
        {
            union() // PADDING BLOCK
            {
                // left/right padding
                for( setidx = [ 0: num_sets-1 ] )
                {	
                    if ( is_enabled(setidx) )
                    {
                        translate( [get_set_x_position(setidx), get_set_y_position( setidx) + all_sets_y_offset,0])
                        {                    
                            padding_x = [get_set_x_position(setidx), get_set_size(setidx).y, tray_size_3d.z];
                            
                            translate([-padding_x.x, 0, 0])
                            cube(padding_x);

                            translate([get_set_size(setidx).x, 0, 0])
                            cube(padding_x);
                            
                        }
                    }
                }

                // top/bottom padding
            
                padding_y = [tray_size_3d.x, all_sets_y_offset, tray_size_3d.z];

                cube(padding_y);

                translate([0, tray_size_3d.y - padding_y.y,0])
                cube(padding_y);
            }
        }
    }

    module place_lid ()
    {
        if (make_tray)
            translate( [tray_size_3d.x + 50, 0, 0])
                children();
            else
                children();
    }

    module create_lid()
    {
        {        
            frame =  no_magnets ? 2 : magnet_outer_diameter * 1.7;

            difference()
            {
                    cube( [tray_size_3d.x, tray_size_3d.y, lid_depth]);

                    translate([frame/2,frame/2,0])
                        cube( [tray_size_3d.x-frame, tray_size_3d.y-frame, lid_depth]);

                    if ( frame_style < 3)
                        create_notches();
            }

            difference()
            {
                intersection()
                {
                    translate([frame/2,frame/2,0])
                        cube( [tray_size_3d.x-frame, tray_size_3d.y-frame, lid_depth]);


                    linear_extrude( lid_depth )
                    {
                        R = m_lid_pattern_radius;
                        t = m_lid_pattern_thickness;

                        create_2d_pattern( x=tray_size_3d.x, y=tray_size_3d.y, R=R, t=t );
                    }
                }
            }
                
            
        }

        m_lid_pattern_col_offset = 15;
        m_lid_pattern_row_offset = 4;
        m_lid_pattern_radius = 15;
        m_lid_pattern_thickness = 1;
        m_lid_pattern_angle = 0;
        m_lid_pattern_n1 = 4;
        m_lid_pattern_n2 = 4;


        module create_2d_pattern( x = 200, y = 200, R = 1, t = 0.5 )
        {
            r = cos( m_lid_pattern_angle ) * R;

            dx = r * ( 1 + m_lid_pattern_col_offset / 100 ) - t;
            dy = R * ( 1 + ( m_lid_pattern_row_offset / 100 ) ) - t;

            x_count = x / dx;
            y_count = y / dy;

            translate([dx*2,0,0])
            for( j = [ -1: y_count + 1 ] )
                translate( [ ( j % 2 ) * dx/2 + t, 0, 0 ] )
                    for( i = [ -3: x_count - 1 ] )
                        translate( [ i * dx, j * dy, 0 ] )
                            rotate( a = m_lid_pattern_angle, v=[ 0, 0, 1 ] )
                            {
                                create_2d_shape( R, t, m_lid_pattern_n1, m_lid_pattern_n2 );
                            }

            module create_2d_shape( R, t, n1, n2 )
            {

                if ( n1 == 3 && n2 == 3 )
                    Tri( R, t );
                else if ( n1 == 4 && n2 == 4 )
                    Quad( R, t );                
                else if ( n1 == 5 && n2 == 5 )
                    Pent( R, t );
                else if ( n1 == 6 && n2 == 6 )
                    Hex( R, t );
                else if ( n1 == 7 && n2 == 7 )
                    Sept( R, t );                
                else if ( n1 == 8 && n2 == 8 )
                    Oct( R, t );
                else
                {
                    base = add_point( R, 0, n1 );
                    inset = add_point( R, t, n2 );

                    combined = concat( base, inset );

                    order = concat( [ add_order_index( 0, n1)], [add_order_index( n1, n1 + n2, n1 )] );

                    polygon( combined, order );     
                }

                module Tri( R = 1, t = 0.2 )
                {
                    n = 3;
                    a = 2 * ( PI / n) * 180 / PI;
        
                    polygon([
                                [ R * cos(0 * a), R * sin(0 * a) ],
                                [ R * cos(1 * a), R * sin(1 * a) ],
                                [ R * cos(2 * a), R * sin(2 * a) ],

                                [ ( R - t ) * cos(0 * a), ( R - t ) * sin(0 * a) ],
                                [ ( R - t ) * cos(1 * a), ( R - t ) * sin(1 * a) ],
                                [ ( R - t ) * cos(2 * a), ( R - t ) * sin(2 * a) ],
                            ],
                        
                            [
                                [0,1,2],[3,4,5]
                            ]
                        );     
                };   

                module Quad( R = 1, t = 0.2 )
                {
                    n = 4;
                    a = 2 * ( PI / n) * 180 / PI;
        
                    polygon([
                                [ R * cos(0 * a), R * sin(0 * a) ],
                                [ R * cos(1 * a), R * sin(1 * a) ],
                                [ R * cos(2 * a), R * sin(2 * a) ],
                                [ R * cos(3 * a), R * sin(3 * a) ],

                                [ ( R - t ) * cos(0 * a), ( R - t ) * sin(0 * a) ],
                                [ ( R - t ) * cos(1 * a), ( R - t ) * sin(1 * a) ],
                                [ ( R - t ) * cos(2 * a), ( R - t ) * sin(2 * a) ],
                                [ ( R - t ) * cos(3 * a), ( R - t ) * sin(3 * a) ],
                            ],
                        
                            [
                                [0,1,2,3],[4,5,6,7]
                            ]
                        );     
                }   

                module Pent( R = 1, t = 0.2 )
                {
                    n = 5;
                    a = 2 * ( PI / n) * 180 / PI;
        
                    polygon([
                                [ R * cos(0 * a), R * sin(0 * a) ],
                                [ R * cos(1 * a), R * sin(1 * a) ],
                                [ R * cos(2 * a), R * sin(2 * a) ],
                                [ R * cos(3 * a), R * sin(3 * a) ],
                                [ R * cos(4 * a), R * sin(4 * a) ],

                                [ ( R - t ) * cos(0 * a), ( R - t ) * sin(0 * a) ],
                                [ ( R - t ) * cos(1 * a), ( R - t ) * sin(1 * a) ],
                                [ ( R - t ) * cos(2 * a), ( R - t ) * sin(2 * a) ],
                                [ ( R - t ) * cos(3 * a), ( R - t ) * sin(3 * a) ],
                                [ ( R - t ) * cos(4 * a), ( R - t ) * sin(4 * a) ],
                            ],
                        
                            [
                                [0,1,2,3,4],[5,6,7,8,9]
                            ]
                        );     
                }   

                module Hex( R = 1, t = 0.2 )
                {
                    n = 6;
                    a = 2 * ( PI / n) * 180 / PI;

                    polygon([
                                [ R * cos(0 * a), R * sin(0 * a) ],
                                [ R * cos(1 * a), R * sin(1 * a) ],
                                [ R * cos(2 * a), R * sin(2 * a) ],
                                [ R * cos(3 * a), R * sin(3 * a) ],
                                [ R * cos(4 * a), R * sin(4 * a) ],
                                [ R * cos(5 * a), R * sin(5 * a) ],

                                [ ( R - t ) * cos(0 * a), ( R - t ) * sin(0 * a) ],
                                [ ( R - t ) * cos(1 * a), ( R - t ) * sin(1 * a) ],
                                [ ( R - t ) * cos(2 * a), ( R - t ) * sin(2 * a) ],
                                [ ( R - t ) * cos(3 * a), ( R - t ) * sin(3 * a) ],
                                [ ( R - t ) * cos(4 * a), ( R - t ) * sin(4 * a) ],
                                [ ( R - t ) * cos(5 * a), ( R - t ) * sin(5 * a) ]
                            ],
                        
                            [
                                [0,1,2,3,4,5],[6,7,8,9,10,11]
                            ]
                        );
                    
                            
                }     

                module Sept( R = 1, t = 0.2 )
                {
                    n = 7;
                    a = 2 * ( PI / n) * 180 / PI;
        
                    polygon([
                                [ R * cos(0 * a), R * sin(0 * a) ],
                                [ R * cos(1 * a), R * sin(1 * a) ],
                                [ R * cos(2 * a), R * sin(2 * a) ],
                                [ R * cos(3 * a), R * sin(3 * a) ],
                                [ R * cos(4 * a), R * sin(4 * a) ],
                                [ R * cos(5 * a), R * sin(5 * a) ],
                                [ R * cos(6 * a), R * sin(6 * a) ],  

                                [ ( R - t ) * cos(0 * a), ( R - t ) * sin(0 * a) ],
                                [ ( R - t ) * cos(1 * a), ( R - t ) * sin(1 * a) ],
                                [ ( R - t ) * cos(2 * a), ( R - t ) * sin(2 * a) ],
                                [ ( R - t ) * cos(3 * a), ( R - t ) * sin(3 * a) ],
                                [ ( R - t ) * cos(4 * a), ( R - t ) * sin(4 * a) ],
                                [ ( R - t ) * cos(5 * a), ( R - t ) * sin(5 * a) ],
                                [ ( R - t ) * cos(6 * a), ( R - t ) * sin(6 * a) ],
                            ],
                        
                            [
                                [0,1,2,3,4,5,6],[7,8,9,10,11,12,13]
                            ]
                        );   
                }    

                module Oct( R = 1, t = 0.2 )
                {
                    n = 8;
                    a = 2 * ( PI / n) * 180 / PI;
        
                    polygon([
                                [ R * cos(0 * a), R * sin(0 * a) ],
                                [ R * cos(1 * a), R * sin(1 * a) ],
                                [ R * cos(2 * a), R * sin(2 * a) ],
                                [ R * cos(3 * a), R * sin(3 * a) ],
                                [ R * cos(4 * a), R * sin(4 * a) ],
                                [ R * cos(5 * a), R * sin(5 * a) ],
                                [ R * cos(6 * a), R * sin(6 * a) ],  
                                [ R * cos(7 * a), R * sin(7 * a) ],                                                

                                [ ( R - t ) * cos(0 * a), ( R - t ) * sin(0 * a) ],
                                [ ( R - t ) * cos(1 * a), ( R - t ) * sin(1 * a) ],
                                [ ( R - t ) * cos(2 * a), ( R - t ) * sin(2 * a) ],
                                [ ( R - t ) * cos(3 * a), ( R - t ) * sin(3 * a) ],
                                [ ( R - t ) * cos(4 * a), ( R - t ) * sin(4 * a) ],
                                [ ( R - t ) * cos(5 * a), ( R - t ) * sin(5 * a) ],
                                [ ( R - t ) * cos(6 * a), ( R - t ) * sin(6 * a) ],
                                [ ( R - t ) * cos(7 * a), ( R - t ) * sin(7 * a) ],                                                                        
                            ],
                        
                            [
                                [0,1,2,3,4,5,6,7],[8,9,10,11,12,13,14,15]
                            ]
                        );   
                }


                function add_point( R, t, n, i = 0 ) = i == n ? [] : 
                    concat( [[ ( R - t ) * cos( i * 2 * ( PI / n) * 180 / PI ), ( R - t ) * sin( i * 2 * ( PI / n) * 180 / PI ) ]],
                        add_point( R, t, n, i + 1 ) );

                function add_order_index( b, e, i = 0 ) = i == e ? [] :
                    concat ( i, add_order_index( b, e, i + 1) );

            }       
        }
    }


    module for_each_counter(setidx)
    {

        num_counters = get_num_counters( setidx );
        counter_size = get_counter_size(setidx);
        counter_size_outer = get_counter_size_outer( setidx );

      //  intersection()
        {
        //    cube([tray_size_3d.x, tray_size_3d.y, tray_size_3d.z]);

            
            for( i=[0:num_counters.x-1], j=[0:num_counters.y-1])
            {
            // if ( !skip(i,j) )
                pos = [
                    get_counter_margins().x + i * counter_size_outer.x,
                    get_counter_margins().y + j * counter_size_outer.y, 
                    0
                ];

                translate(pos)
                {
                //    cube();
                    children();
                }
            }
        }
    }
        
    module create_set_of_counter_holes( setidx, extra = 0 )
    {
        set = get_set( setidx );

        num_counters = get_num_counters( setidx );
        counter_size = get_counter_size(setidx) + [ extra, extra ];
        counter_size_outer = get_counter_size_outer( setidx );

        round_counters = get_counter_shape(setidx) == SHAPE_CIRCLE;
        triangle_counters = get_counter_shape(setidx) == SHAPE_TRIANGLE;

        for_each_counter(setidx)
        create_single_counter_hole();

        module create_single_counter_hole( extra = 0)
        {
            inset = [ 
                counter_size.x - ( get_counter_hole_fraction(setidx) * counter_size.x) + extra,
                counter_size.y - ( get_counter_hole_fraction(setidx) * counter_size.y) + extra 
                ];

            diam = 2.5;

            dist_from_center = [
                (counter_size.x - inset.x - diam)/2,
                (counter_size.y - inset.y - diam)/2
            ];

            thickness = get_set_floor_thickness(setidx);

            translate( [counter_size_outer.x/2, counter_size_outer.y/2, thickness/2])
            if ( round_counters)
            {  
                cylinder( h=thickness * 1, d=counter_size.x - inset.x, center=true );           
            }
            else if ( triangle_counters)
            {

            }
            else
            {
                hull()
                {
                    translate( [ -dist_from_center.x, -dist_from_center.y, 0] )
                    cylinder( h=thickness * 1, d=2.5, center=true );

                    translate( [ dist_from_center.x, -dist_from_center.y, 0] )
                    cylinder( h=thickness * 1, d=2.5, center=true );

                    translate( [ -dist_from_center.x, dist_from_center.y, 0] )
                    cylinder( h=thickness * 1, d=2.5, center=true );

                    translate( [ dist_from_center.x, dist_from_center.y, 0] )
                    cylinder( h=thickness * 1, d=2.5, center=true );
                }
            }
   
        }
    }

    module create_set_of_counters( setidx )
    {
        set = get_set( setidx );

        num_counters = get_num_counters( setidx );
        counter_size = get_counter_size(setidx);
        counter_size_outer = get_counter_size_outer( setidx );

        round_counters = get_counter_shape(setidx) == SHAPE_CIRCLE;
        triangle_counters = get_counter_shape(setidx) == SHAPE_TRIANGLE;

               
        difference()
        {
            union()
            {
                for_each_counter(setidx)
                {
        *         # cube(counter_size_outer);

        *         # translate(get_counter_margins())
                    cube(counter_size);

                    create_counter();
                }
                
                if ( 0 )
                FillCorners();                
            }
        }
    

        module create_counter( extra = 0 )
        {

            margins = get_counter_margins(setidx) + [extra,extra];


            module create_counter_wall_round()
            {
                translate([0, 0, tray_size_3d.z/2])
                {
                    difference()
                    {
                        translate([-margins.x, margins.y + counter_size.x /3,-tray_size_3d.z/2])
                            cube([ margins.x*4, counter_size.x/3, tray_size_3d.z]);

                        translate([counter_size_outer.x/2, counter_size_outer.y/2, -tray_size_3d.z/2])
                        cylinder(h = tray_size_3d.z, d = counter_size.x, center=false);
                    }
                }
            }

            module create_counter_corner_square()
            {
                margins = get_counter_margins() + [extra,extra];
                post_length = get_counter_margins_post_length_fraction() * counter_size.x;
                
                translate([0, 0, tray_size_3d.z/2])
                {
                    vert_cube = [ 
                        margins.x * 2, 
                        post_length, 
                        tray_size_3d.z];

                    hor_cube = [
                        post_length, 
                        margins.y * 2, 
                        tray_size_3d.z
                    ];

                    translate([0, vert_cube.y/2 - margins.y, 0])
                    cube(vert_cube, center = true);

                    translate([hor_cube.x/2 - margins.x, 0, 0])
                    cube(hor_cube, center = true);
                }
            }
    
            if( round_counters )
            {
                create_counter_wall_round();

                translate( [counter_size.x + margins.x*2,0,0])
                mirror([1,0,0])
                create_counter_wall_round();

                translate([counter_size_outer.x,0,0])
                rotate([0,0,90])
                {
                    create_counter_wall_round();

                    translate( [counter_size.x + margins.x*2,0,0])
                    mirror([1,0,0])
                    create_counter_wall_round();
                }
            }
            else
            {
                create_counter_corner_square();
                
                union()
                {
                    translate( [counter_size.x + margins.x*2,0,0])
                    mirror([1,0,0])
                    create_counter_corner_square();

                    translate( [0,counter_size.y + margins.y*2,0])
                    mirror([0,1,0])
                    create_counter_corner_square();
                    
                    translate( [counter_size.x + margins.x *2, counter_size.y + margins.y *2, 0])
                    mirror([1,0,0])
                    mirror([0,1,0])
                    create_counter_corner_square();
                }

                *translate(v = [margins.x, margins.y, 0])
                        color("red")cube([counter_size.x, counter_size.y, 2]);
            }
            
        }            
    

        module create_filler()
        {
            union()
            {
                difference()
                {
                    cube([counter_size_outer.x, counter_size_outer.y, tray_size_3d.z]);
                    create_counter( g_tolerance );
                    cube([counter_size_outer.x, counter_size_outer.y, floor_thickness + g_tolerance]);

                }
            //   create_single_counter_hole( g_tolerance );
            }
        }

        function skip(i,j) = 
        num_counters.x >= 3 && num_counters.y >= 3 && 
                                (( i == 0 && j == 0 ) || 
                                ( i == num_counters.x-1 && j == 0 ) ||
                                ( i == num_counters.x-1 && j == num_counters.y-1 ) ||
                                ( i == 0 && j == num_counters.y-1 ));

    }
}