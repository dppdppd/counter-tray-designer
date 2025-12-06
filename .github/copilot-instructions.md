# Copilot Instructions

- Project type: parametric OpenSCAD generator for board-game counter trays (tray + optional lid + magnets). No build scripts; render in OpenSCAD to STL/SVG.
- Key files: `counter-tray-designer.lib.scad` (engine), `tray-library.scad` (game presets + invocation), `archive/counter-tray.lib.v1.scad` (legacy; refer only for history), `archive/dimensions.lib.scad` (old constants), `.3mf` files are exported prints.
- Entry points: include `counter-tray-designer.lib.scad` then call `main(DATA_ARRAY)`; `tray-library.scad` demonstrates calling `main(BFNW);` at the bottom.
- Data model (all values are millimeters unless noted):
  - Top-level `DATA_ARRAY` is a list of `[KEY, VALUE]` pairs plus repeated `[COUNTER_SET, [...]]` blocks.
  - Global keys: `G_DIMENSIONS_XY` (tray outer X/Y), `G_FLOOR_THICKNESS_N` (default 1.5), `G_MIN_PADDING_XY` (default `[magnet_outer_diameter,1]` when using magnets), `G_LID_DEPTH_N` (default 2.6), `G_FRAME_STYLE_N` (default 1; affects magnets/notches), `G_MAGNET_DIAMETER_N` (default 6.2), `G_MAKE_TRAY_B`/`G_MAKE_LID_B` toggles.
  - Set keys inside each `COUNTER_SET`: `COUNTER_SIZE_XYZ` (w,h,depth), optional `ROWS_N` (else auto-computed), `COUNTER_SHAPE` (`SHAPE_SQUARE` default; also circle/triangle/hex), `COUNTER_MARGINS_XY` (defaults to `COUNTER_MARGINS_XY` global or `[0.5,0.5]`), `COUNTER_MARGINS_POST_LENGTH_FRACTION_N` (default 0.25), `COUNTER_HOLE_FRACTION_N` (default 0.7; set 0 to suppress holes), `ENABLED_B` to skip a set.
- Geometry/logic highlights (from `counter-tray-designer.lib.scad`):
  - `$fn` is 20 in preview, 50 when rendering; magnets auto-double if tray is deep (`tray_size_3d.z > 2*magnet_depth+0.2`).
  - `tray_padding` auto-enforces magnet clearance for frame styles 1–2; frame style 4 disables magnets. Frame styles <3 cut notches; style 3 recenters magnets; style 4 is lid-only aesthetic.
  - `usable_area` is tray size minus padding and counter margins; rows/cols auto-fill unless `ROWS_N` provided. `get_set_floor_thickness` allows per-set floors (default on via `PER_SET_FLOOR_THICKNESS`).
  - Counter holes: circles respect `COUNTER_HOLE_FRACTION_N`; hex counters get circular reliefs; setting hole fraction 0 keeps a flat floor (useful for cards/tiles).
  - Magnet nubs are mirrored on X; offsets optionally follow counter positions when `MOVE_NUBS_TO_COUNTER_POSITIONS` (currently false).
- Patterns from `tray-library.scad` you can copy:
  - `TEST_*` blocks show minimal configs and frame styles 1–3; toggle `TESTING` to preview multiple trays.
  - Game presets (e.g., `HOLLANDSPIELE_MELTWATER`, `GMT_1862_*`, `MMP_ASL_*`) illustrate mixing multiple `COUNTER_SET` entries, custom `ROWS_N`, and shape overrides; `BFNW` is the default rendered sample at file end.
- Typical workflow:
  - Edit or define a `DATA_ARRAY` in a `.scad` file, include `counter-tray-designer.lib.scad`, and call `main(DATA_ARRAY);`.
  - Use OpenSCAD GUI: preview (F5) for sizing output printed via `echo`, render (F6) to export STL. Set `g_make_svg=1` to project to 2D for laser cutting templates.
  - Toggle `G_MAKE_TRAY_B`/`G_MAKE_LID_B` when you only need one part; adjust `G_MAGNET_DIAMETER_N` if using different magnets.
- Conventions:
  - All dimensions are mm; keep arrays ordered as shown (globals before sets) for readability though lookup is key-based.
  - Prefer updating `tray-library.scad` with reusable presets; keep experimental layouts behind `TESTING` flag rather than replacing the default `main` call.
- When adding new patterns, verify spacing via `echo` outputs (`num_counters`, ideal tray size) before rendering to avoid off-by-one issues.
- If you modify magnet logic or frame styles, ensure both tray and lid paths stay consistent (`create_notches`, `create_magnet_slots`, nubs/holes mirrored).

Let me know if any sections need more detail or if additional workflows (e.g., exporting STL/SVG steps) should be clarified.