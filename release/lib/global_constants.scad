
tray_letter = [215,250]; // @preset G_DIMENSIONS_XY "Letter size"
tray_revolution = [211,246]; // @preset G_DIMENSIONS_XY "Revolution"

half_inch_counter = 13.3;
old_half_inch_counter = 14;
five_eigths_counter = 16.5;
nine_sixteenths_counter = 15;

counter_depth_standard_cardboard = 3; // 1.6mm plus 1.4mm to prevent counters popping out.

standard_cardboard_counter = [ half_inch_counter, half_inch_counter, counter_depth_standard_cardboard]; // @preset COUNTER_SIZE_XYZ "1/2\" standard (13.3mm)"
five_eigths_cardboard_counter = [ five_eigths_counter, five_eigths_counter, counter_depth_standard_cardboard]; // @preset COUNTER_SIZE_XYZ "5/8\" standard (16.5mm)"
