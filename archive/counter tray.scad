g_make_lid = 1;
g_make_tray = 0;

// counter_size = 13.3;
counter_size = 16.5;

/////////////////////////////////////////

// letter sized
g_tray_width = 215;
g_tray_height = 250;


g_tray_depth = 2.6;
tray_floor_thickness = 0.6; // 3 layers

counter_margin_x = 0.5;
counter_margin_y = 2;

g_magnet_diameter = 6 + 0.3;
g_magnet_depth = 1 + 0.3;
g_magnet_distance_from_edge = 6;

g_fill_margin = 1;

tray_min_padding = 1;
//counter_padding_width = 2;
//counter_padding_height = 2 + counter_size/4;

counter_outer_width = counter_size + 2*counter_margin_x;
counter_outer_height = counter_size + 2*counter_margin_y;

num_counters_x = floor(( g_tray_width - 2 * tray_min_padding- 2*counter_margin_y ) / counter_outer_width );
tray_inner_width = num_counters_x * counter_outer_width + counter_margin_x*2;
tray_padding_width =  ( g_tray_width - tray_inner_width ) / 2;

num_counters_y = floor((g_tray_height - 2 * tray_min_padding - 2*counter_margin_y ) / counter_outer_height );
tray_inner_height = num_counters_y * counter_outer_height + counter_margin_y*2;
tray_padding_height =  ( g_tray_height - tray_inner_height ) / 2;

echo( num_counters_x=num_counters_x,num_counters_y=num_counters_y );

module PositionLid ()
{
    if (g_make_tray)
    translate( [g_tray_width+10, 0, 0])
    children();
    else
    children();
}


if ( g_make_tray )
MakeTray();

if ( g_make_lid)
PositionLid()
MakeLid();

module Recenter()
{
    translate([0 ,-g_tray_height, 0])
    children();
}

module CenterForPadding()
{
    translate([tray_padding_width, tray_padding_height, 0])
    children();
}

module MakeCounter()
{
    module MakeCorner()
    {
        post_length = 4;
        post_width = 1;
        
        post_h_length = post_length;
        
        post_v_length = post_length;

        translate([0, 0, g_tray_depth/2])
        {
        
            if ( g_fill_margin )
            {
                color("purple") translate([counter_margin_x - post_width/2, counter_size/2,0])
                cube([ post_width, counter_size , g_tray_depth], center = true);

                color("blue") translate([post_v_length/2 + counter_margin_x - post_width/2, counter_margin_y/2, 0])
                cube([ post_v_length + post_width, counter_margin_y,g_tray_depth], center = true);
            }
            else
            {
                color("purple") translate([counter_margin_x - post_width/2, post_h_length/2 + counter_margin_y - post_width/2,0])
                cube([ post_width, post_h_length + post_width , g_tray_depth], center = true);

                color("red") translate([post_v_length/2 + counter_margin_x - post_width/2, counter_margin_y - post_width/2, 0])
                cube([ post_v_length + post_width, post_width,g_tray_depth], center = true);
            }
            
        
        
        }   
    }
    
    MakeCorner();
    
    translate( [counter_size + counter_margin_x*2,0,0])
    mirror([1,0,0])
    MakeCorner();

    translate( [0,counter_size + counter_margin_y*2,0])
    mirror([0,1,0])
    MakeCorner();
    
    translate( [counter_size + counter_margin_x*2,counter_size + counter_margin_y*2,0])
    mirror([1,0,0])
    mirror([0,1,0])
    MakeCorner();
    
    
    

    *difference()
    {
        color("green")
        cube([counter_outer_width, counter_outer_height, g_tray_depth]);

        color("red")
        translate( [0, counter_border, 1])
        cube([counter_outer_width, counter_size - 3,10]);
        
        color("red")
        translate( [counter_border, 0, 1])
        cube([counter_size - 3,counter_outer_height, 10]);
        
    }
}

module MakeAllCounters()
{

    color("green") 
    intersection()
    {
        cube([g_tray_width, g_tray_height, g_tray_depth]);

        CenterForPadding()
        for( i=[-1:num_counters_x], j=[-1:num_counters_y])
        {
            translate([ counter_margin_x + i * counter_outer_width, counter_margin_y + j * counter_outer_height, 0])
            //cube();
            MakeCounter();
        
        }
    }
}

module MakePadding()
{
    difference()
    {
        cube([g_tray_width, g_tray_height, g_tray_depth]);
        
        translate([tray_padding_width, tray_padding_height,0])
        cube([tray_inner_width, tray_inner_height, g_tray_depth]);

    }
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

                MakeAllCounters();
                
                color("yellow") cube( [g_tray_width, g_tray_height, tray_floor_thickness]);
            }

            MakeMagnetSlots();

            MakeTrayNotches();
        }
    }

}

module MakeLid()
{
    Recenter()
    {        
        difference()
        {
 
            color("yellow") cube( [g_tray_width, g_tray_height, g_tray_depth]);
            
            MakeMagnetSlots();

            MakeTrayNotches();
        }
    }

}

module MakeInFourCorners()
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

module MakeTrayNotches()
{
    diam = 5;
    height = 10;
    
    translate([g_tray_width/2, g_tray_height/2,0])
    {
        MakeInFourCorners()
        {
            translate( [g_tray_width/2, g_tray_height/2 - g_tray_height/4,0])
                cube( [diam,diam,height], center = true ); 
                
            translate( [g_tray_width/2 - g_tray_height/4, g_tray_height/2,0])
                cube( [diam,diam,height], center = true );
        }
    }
} 

module MakeMagnetSlots()
{

    translate([g_tray_width/2, g_tray_height/2,0])
    translate([0, 0, g_magnet_depth/2])
    {
        MakeInFourCorners()
        MakeSingleMagnetSlot();
    }
    

    module MakeSingleMagnetSlot()
    {
        extra_to_poke_through_bottom = 0.1;
        translate( [0,0,-extra_to_poke_through_bottom])
        translate( [g_tray_width/2 - g_magnet_distance_from_edge, g_tray_height/2 - g_magnet_distance_from_edge,0])
            cylinder( h = g_magnet_depth + 2*extra_to_poke_through_bottom, d = g_magnet_diameter, center = true );
    }
}