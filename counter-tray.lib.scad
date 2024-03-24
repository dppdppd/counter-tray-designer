g_make_lid = 1;
g_make_tray = 1;
g_make_filler = 0;

g_make_svg = 0;

tray_test = [60,60];
tray_max = [244,244];
tray_letter = [215,250];
tray_gmt = [ 230,250];
tray_gmt2 = [ 220,250];
tray_revolution = [211,246];
tray_whitedog = [211,246];


half_inch_counter = 13.4;
five_eigths_counter = 16.5;
block_counter = 24.7;

counter_depth_standard_cardboard = 2.6;
counter_depth_blue_panther_chipboard = 3.2;
block_depth = 12.6;

TEST = 
[
    tray_test, 
    half_inch_counter,
    counter_depth_standard_cardboard,
    true
];

/////////////////////////////////////////

module Make( TEMPLATE = TEST)
{

    max_tray_dimensions = TEMPLATE[0];
    counter_size = TEMPLATE[1];
    counter_depth = TEMPLATE[2];
    round_counters = TEMPLATE[3];

    tray_padding_min = [8,8];

    g_tray_floor_thickness = 1.5;

    g_tray_depth = counter_depth + g_tray_floor_thickness;

    g_lid_depth = 2.6; 

    counter_margin = [0.5,0.5];

    g_fill_corners = 0;

    g_tolerance = 0.1;

    counter_outer_width = counter_size + 2*counter_margin.x;
    counter_outer_height = counter_size + 2*counter_margin.y;

    g_magnet_diameter = 6.4;
    g_magnet_depth = 1.4;
    g_magnet_lid_depth = 2.4;

    g_magnet_distance_from_edge = [5,5];//[counter_outer_width/2,counter_outer_height/2];

    num_counters_x = floor(( max_tray_dimensions.x - 2* tray_padding_min.x - 4* counter_margin.y ) / counter_outer_width );
    tray_inner_width = num_counters_x * counter_outer_width + counter_margin.x * 2;
  //  tray_padding_width =  tray_padding_min.x;//( tray_outer_width - tray_inner_width ) / 2;
    tray_outer_width = max_tray_dimensions.x;//tray_inner_width + tray_padding_width * 2;
    tray_padding_width =  ( tray_outer_width - tray_inner_width ) / 2;
    tray_outer_width_ideal = tray_inner_width + tray_padding_min.x * 2 + 1;


    num_counters_y = floor((max_tray_dimensions.y - 2* tray_padding_min.y - 4* counter_margin.y ) / counter_outer_height );
    tray_inner_height = num_counters_y * counter_outer_height + counter_margin.y * 2;
  //  tray_padding_height =  tray_padding_min.y;//( tray_outer_height - tray_inner_height ) / 2;
    tray_outer_height = max_tray_dimensions.y;//tray_inner_height + 2 * tray_padding_height;
    tray_padding_height =  ( tray_outer_height - tray_inner_height ) / 2;
    tray_outer_height_ideal = tray_inner_height + 2 * tray_padding_min.y + 1;

    echo();
    echo( str(num_counters_x,"x",num_counters_y, ", total=", num_counters_x*num_counters_y));
    echo( str(tray_outer_width_ideal," mm x ", tray_outer_height_ideal," mm"));
    echo( str(tray_outer_width_ideal/25.4," in x ", tray_outer_height_ideal/25.4," in"));
    echo();

    echo( num_counters_y=num_counters_y, tray_outer_height=tray_outer_height  );

    $fn = $preview ? 12 : 72;

    function IsTrayDeep() = g_tray_depth > ( 2 * g_magnet_depth + 0.2 );

    if ( g_make_tray && !g_make_svg )
    MakeTray();

    if ( g_make_svg )
    projection(cut = false)
    MakeTray();

    if ( g_make_lid && !g_make_svg)
    PositionLid()
    MakeLid();

    if ( g_make_filler )
    translate([0,10,0]) 
    MakeFiller();

///////////////////////////////////////////

    module PositionLid ()
    {
        if (g_make_tray)
        translate( [tray_outer_width+10, 0, 0])
        children();
        else
        children();
    }

    module Recenter()
    {
        translate([0 ,-tray_outer_height, 0])
        children();
    }

    module CenterForPadding()
    {
        translate([tray_padding_width, tray_padding_height, 0])
        children();
    }

    module MakeTray()
    {
        Recenter()
        {        
            difference()
            {
                union()
                {
                    MakePadding();

                    ForEachCounterPosition()
                    MakeCounter();
                    
                    color("yellow") cube( [tray_outer_width, tray_outer_height, g_tray_floor_thickness]);

                    if ( g_fill_corners )
                    FillCorners();                
                }

                MakeMagnetSlots( body_depth = g_tray_depth, is_lid = false );

                if ( !g_make_svg )
                MakeNotches();

                ForEachCounterPosition()
                MakeCounterHole();
            }
        }
    }

    module MakeFiller()
    {
        union()
        {
            difference()
            {
                cube([counter_outer_width, counter_outer_height, g_tray_depth]);
                MakeCounter( g_tolerance );
                cube([counter_outer_width, counter_outer_height, g_tray_floor_thickness + g_tolerance]);

            }
        //   MakeCounterHole( g_tolerance );
        }
    }

    module MakeCounter( extra = 0 )
    {

        module MakeRoundCounterSide()
        {
            post_length = 4;
            post_width = 1;

            counter_margin = counter_margin + [extra,extra];
            
            post_h_length = post_length;
            
            post_v_length = post_length;

            translate([0, 0, g_tray_depth/2])
            {
                difference()
                {
                    translate([-counter_margin.x,counter_margin.y + counter_size /3,-g_tray_depth/2])
                        cube([ counter_margin.x*4, counter_size/3, g_tray_depth]);

                    translate([counter_outer_width/2, counter_outer_height/2, -g_tray_depth/2])
                    cylinder(h = g_tray_depth, d = counter_size, center=false);
                }
            }
        }


        module MakeCounterCorner()
        {
            post_length = 4;
            post_width = 1;

            counter_margin = counter_margin + [extra,extra];
            
            post_h_length = post_length;
            
            post_v_length = post_length;

            translate([0, 0, g_tray_depth/2])
            {
                color("purple") translate([0, post_h_length/2 + counter_margin.y - counter_margin.x, 0])
                cube([ counter_margin.x*2, post_h_length + counter_margin.x*2 , g_tray_depth], center = true);

                color("red") translate([post_v_length/2 + counter_margin.x - counter_margin.y, 0, 0])
                cube([ post_v_length + counter_margin.y*2, counter_margin.y*2, g_tray_depth], center = true);
            }
        }
        
  
        if( round_counters )
        {
            MakeRoundCounterSide();

            translate( [counter_size + counter_margin.x*2,0,0])
            mirror([1,0,0])
            MakeRoundCounterSide();

            translate([counter_outer_width,0,0])
            rotate([0,0,90])
            {
                MakeRoundCounterSide();

                translate( [counter_size + counter_margin.x*2,0,0])
                mirror([1,0,0])
                MakeRoundCounterSide();
            }
        }
        else
        {
            MakeCounterCorner();
            
            translate( [counter_size + counter_margin.x*2,0,0])
            mirror([1,0,0])
            MakeCounterCorner();

            translate( [0,counter_size + counter_margin.y*2,0])
            mirror([0,1,0])
            MakeCounterCorner();
            
            translate( [counter_size + counter_margin.x*2,counter_size + counter_margin.y*2,0])
            mirror([1,0,0])
            mirror([0,1,0])
            MakeCounterCorner();

            *translate(v = [counter_margin.x, counter_margin.y, 0])
                    color("red")cube([counter_size, counter_size, 2]);
        }
        
    }

    module MakeCounterHole( extra = 0)
    {
        inset = 4 + extra;
        diam = 2.5;

        dist_from_center = (counter_size - inset - diam)/2;

        translate( [counter_outer_width/2, counter_outer_height/2, g_tray_floor_thickness/2])

        if ( !round_counters)
        hull()
        {
            translate( [ -dist_from_center,-dist_from_center,0] )
            cylinder( h=g_tray_floor_thickness * 1, d=2.5, center=true );

            translate( [ dist_from_center,-dist_from_center,0] )
            cylinder( h=g_tray_floor_thickness * 1, d=2.5, center=true );

            translate( [ -dist_from_center,dist_from_center,0] )
            cylinder( h=g_tray_floor_thickness * 1, d=2.5, center=true );

            translate( [ dist_from_center,dist_from_center,0] )
            cylinder( h=g_tray_floor_thickness * 1, d=2.5, center=true );
        }
        else 
        {  
            cylinder( h=g_tray_floor_thickness * 1, d=counter_size*.8, center=true );           
        }
    }

    function skip(i,j) = num_counters_x >= 3 && num_counters_y >= 3 && 
                            (( i == 0 && j == 0 ) || 
                            ( i == num_counters_x-1 && j == 0 ) ||
                            ( i == num_counters_x-1 && j == num_counters_y-1 ) ||
                            ( i == 0 && j == num_counters_y-1 ));

    module ForEachCounterPosition()
    {

        color("green") 
        intersection()
        {
            cube([tray_outer_width, tray_outer_height, g_tray_depth]);

            
            CenterForPadding()
            for( i=[0:num_counters_x-1], j=[0:num_counters_y-1])
            {
            // if ( !skip(i,j) )
                translate([ counter_margin.x + i * counter_outer_width, counter_margin.y + j * counter_outer_height, 0])
                //cube();
                children();
            
            }
        }
    }

    module MakePadding()
    {
        difference()
        {
            cube([tray_outer_width, tray_outer_height, g_tray_depth]);
            
            translate([tray_padding_width, tray_padding_height,0])
            cube([tray_inner_width, tray_inner_height, g_tray_depth]);
        }
    }

    module FillCorners()
    {
        module CornerFiller()
        {
            translate( [tray_outer_width/2 - counter_outer_width - tray_padding_width, tray_outer_height/2 - counter_outer_height - tray_padding_height,0])
            cube([counter_outer_width, counter_outer_height, g_tray_depth]);
        }

        translate([tray_outer_width/2, tray_outer_height/2,0])
        PlaceInFourCorners()
        CornerFiller();
    }


    module MakeLid()
    {
        Recenter()
        {        

            frame = 20;

            union()
            {
                difference()
                {
                        cube( [tray_outer_width, tray_outer_height, g_lid_depth]);

                        translate([frame/2,frame/2,0])
                        cube( [tray_outer_width-frame, tray_outer_height-frame, g_lid_depth]);
                        
                        MakeMagnetSlots( body_depth=g_lid_depth, is_lid=true);

                        MakeNotches();

                }

                difference()
                {
                    intersection()
                    {
                        translate([frame/2,frame/2,0])
                        cube( [tray_outer_width-frame, tray_outer_height-frame, g_lid_depth]);


                        linear_extrude( g_lid_depth )
                        {
                            R = m_lid_pattern_radius;
                            t = m_lid_pattern_thickness;

                            Make2DPattern( x=tray_outer_width, y=tray_outer_height, R=R, t=t );
                        }
                    }
                }
            }
        }
    }

    module PlaceInFourCorners()
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

    module MakeNotches()
    {
        diam = 6;
        height = g_tray_depth * 2;
        
        M = [   [ 1 , 0,    0,  0   ],
                [ 0.3 , 1,    0,  0   ],  // The "0.7" is the skew value; pushed along the y axis as z changes.
                [ 0 , 0,    1,  0   ],
                [ 0 , 0,    0,  1   ] ] ;

        module HookIndent()
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

        module LeftHookIndent()
        {
            rotate(90,[0,0,1])
            HookIndent();

        }

        translate([tray_outer_width/2, tray_outer_height/2, g_tray_depth/2])
        {
            PlaceInFourCorners()
            {
                translate( [tray_outer_width/2, tray_outer_height/4,0])
                    HookIndent();
                    
            translate( [tray_outer_width/4, tray_outer_height/2,0])
                    LeftHookIndent();
            }
        }
    } 

    module MakeMagnetSlots( body_depth, is_lid = false )
    {
        extra = 0.01;

        if ( !is_lid )
        {
            translate( [0,0,-extra])
            MakeOneSetOfMagnetSlots( g_magnet_depth + extra );

            if ( IsTrayDeep() )
            {
                translate( [0, 0, extra])
                translate([0, 0, g_tray_depth - g_magnet_depth])
                MakeOneSetOfMagnetSlots( g_magnet_depth + extra );
            }
        }
        else
        {
            translate( [0, 0, extra])
            translate([0, 0, g_lid_depth - g_magnet_lid_depth])
            MakeOneSetOfMagnetSlots( g_magnet_lid_depth + extra );            
        }


        module MakeOneSetOfMagnetSlots( depth )
        {
            translate([tray_outer_width/2, tray_outer_height/2, 0])
            translate([0, 0, 0])
            {
                PlaceInFourCorners()
                MakeSingleMagnetSlot( depth );
            }
            

            module MakeSingleMagnetSlot( depth )
            {
                inset_depth = depth;
                translate( [tray_outer_width/2 - g_magnet_distance_from_edge.x, tray_outer_height/2 - g_magnet_distance_from_edge.y, inset_depth/2])
                    cylinder( h = inset_depth, d = g_magnet_diameter, center = true );
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


    module Make2DPattern( x = 200, y = 200, R = 1, t = 0.5 )
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
                            Make2dShape( R, t, m_lid_pattern_n1, m_lid_pattern_n2 );
                        }

        module Make2dShape( R, t, n1, n2 )
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
                base = AddPoint( R, 0, n1 );
                inset = AddPoint( R, t, n2 );

                combined = concat( base, inset );

                order = concat( [ AddOrderIndex( 0, n1)], [AddOrderIndex( n1, n1 + n2, n1 )] );

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


            function AddPoint( R, t, n, i = 0 ) = i == n ? [] : 
                concat( [[ ( R - t ) * cos( i * 2 * ( PI / n) * 180 / PI ), ( R - t ) * sin( i * 2 * ( PI / n) * 180 / PI ) ]],
                    AddPoint( R, t, n, i + 1 ) );

            function AddOrderIndex( b, e, i = 0 ) = i == e ? [] :
                concat ( i, AddOrderIndex( b, e, i + 1) );

        }       
    }



}
