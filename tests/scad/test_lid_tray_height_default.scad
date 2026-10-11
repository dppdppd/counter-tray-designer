// A default lid matches the entire tray, replacing the former floor-only rule.
// The deepest enabled counter set and its pedestal determine the tray height.
// Explicit lid depth overrides remain available at scene, tray, and lid levels.
include <../../release/lib/counter_tray_designer_lib.1.scad>

function near(a,b) = abs(a-b) < 0.000001;
base = [[G_FLOOR_THICKNESS_N, 0.6],
    [COUNTER_SET, [COUNTER_SIZE_XYZ, [13,13,1.2]]]];
assert(near(_get_effective_lid_depth(base), 1.8));
assert(_get_effective_lid_depth([]) == 1.5);
assert(_get_effective_lid_depth(concat([[G_LID_DEPTH_N,2]],base)) == 2);
globals = [[G_FLOOR_THICKNESS_N,0.4]];
tray = [TRAY,[G_FLOOR_THICKNESS_N,0.8],
    [COUNTER_SET,[COUNTER_SIZE_XYZ,[13,13,1.2]]]];
assert(_get_effective_lid_depth(build_effective_lid_data([LID],tray,globals)) == 2);
assert(_get_effective_lid_depth(build_effective_lid_data([LID,[G_LID_DEPTH_N,1.1]],tray,globals)) == 1.1);
assert(_get_effective_lid_depth(build_effective_lid_data([LID],tray,concat([[G_LID_DEPTH_N,1.3]],globals))) == 1.3);
assert(_get_effective_lid_depth(build_effective_lid_data([LID],[TRAY,[G_LID_DEPTH_N,1.7]],globals)) == 1.7);
// Two 2 mm trays plus their matching 2 mm lid make a 6 mm stack.
stack = concat(globals, [[TRAY,[G_FLOOR_THICKNESS_N,0.8],[PRINT_COUNT_N,2],
    [COUNTER_SET,[COUNTER_SIZE_XYZ,[13,13,1.2]]]],[LID]]);
assert(_get_total_stack_height(stack,get_top_level_globals(stack)) == 6);

// Select a case and panel for mesh checks. Each case supplies its expected
// height from these dimensions, including a disabled 80 mm counter set.
CASE = "snafu";
PART = "lid";
FRAME = 1;
sets = CASE == "mixed" ? [
    [COUNTER_SET,[COUNTER_SIZE_XYZ,[13,13,1.2]],[ROWS_N,1]],
    [COUNTER_SET,[COUNTER_SIZE_XYZ,[13,13,3]],[ROWS_N,1]],
    [COUNTER_SET,[COUNTER_SIZE_XYZ,[13,13,80]],[ENABLED_B,false]]
] : [[COUNTER_SET,[COUNTER_SIZE_XYZ,[13,13,1.2]]]];
settings = concat([[G_DIMENSIONS_XY,[50,50]],[G_FRAME_STYLE_N,FRAME],
    [G_FLOOR_THICKNESS_N,0.6]],
    CASE == "explicit" ? [[G_LID_DEPTH_N,2]] : [],
    CASE == "pedestal" || CASE == "no_pedestal" ? [[COUNTER_PEDESTAL_MIN,0.7]] : [],
    CASE == "no_pedestal" ? [[COUNTER_PEDESTAL_B,false]] : [], sets);
expected_tray = CASE == "mixed" ? 3.6 : CASE == "pedestal" ? 2.5 : 1.8;
assert(near(_get_effective_tray_height(settings),expected_tray));
assert(near(_get_effective_lid_depth(settings),CASE == "explicit" ? 2 : expected_tray));
Make(concat([[_TRAY_ENABLED_B,PART=="tray"],[_LID_ENABLED_B,PART=="lid"]],settings));
