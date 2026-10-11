// Lid defaults follow the effective floor, so thin trays retain thin covers.
// Explicit depth overrides remain available. Stack dimensions use the same
// effective lid depth as the geometry.
include <../../release/lib/counter_tray_designer_lib.1.scad>

assert(_get_effective_lid_depth([]) == 1.5);
assert(_get_effective_lid_depth([[G_FLOOR_THICKNESS_N, 0.4]]) == 0.4);
assert(_get_effective_lid_depth([[G_FLOOR_THICKNESS_N, 0.4], [G_LID_DEPTH_N, 2]]) == 2);

globals = [[G_FLOOR_THICKNESS_N, 0.4]];
tray = [TRAY, [G_FLOOR_THICKNESS_N, 0.8],
    [COUNTER_SET, [COUNTER_SIZE_XYZ, [13, 13, 1.2]]]];
assert(_get_effective_lid_depth(build_effective_lid_data([LID], tray, globals)) == 0.8);
assert(_get_effective_lid_depth(build_effective_lid_data([LID, [G_LID_DEPTH_N, 1.1]], tray, globals)) == 1.1);
assert(_get_effective_lid_depth(build_effective_lid_data([LID], tray,
    concat([[G_LID_DEPTH_N, 1.3]], globals))) == 1.3);
assert(_get_effective_lid_depth(build_effective_lid_data([LID],
    [TRAY, [G_LID_DEPTH_N, 1.7]], globals)) == 1.7);

// Two 2 mm trays and one 0.8 mm lid make a 4.8 mm stack.
stack = concat(globals, [[TRAY, [G_FLOOR_THICKNESS_N, 0.8], [PRINT_COUNT_N, 2],
    [COUNTER_SET, [COUNTER_SIZE_XYZ, [13, 13, 1.2]]]], [LID]]);
assert(abs(_get_total_stack_height(stack, get_top_level_globals(stack)) - 4.8) < 0.000001);
// Select either magnet or plain frames when checking the resulting lid mesh.
FRAME = 1;
Make([[G_DIMENSIONS_XY, [29, 20]], [G_FRAME_STYLE_N, FRAME],
    [G_FLOOR_THICKNESS_N, 0.4], [_TRAY_ENABLED_B, false],
    [COUNTER_SET, [COUNTER_SIZE_XYZ, [13, 13, 1.2]]]]);
