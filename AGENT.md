# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Parametric OpenSCAD generator for 3D-printable board-game counter trays with optional lids and magnet slots.

## Rendering

```bash
# Preview (fast, low-res) — use OpenSCAD GUI F5
openscad tray-library.scad   # opens GUI

# CLI render to STL
openscad -o output.stl tray-library.scad

# CLI render to SVG (set g_make_svg=1 in file first)
openscad -o output.svg tray-library.scad
```

## Testing

Test files live in `tests/scad/test_*.scad`. Two scripts in `tests/`:

```bash
# Fast compile check (CSG only, ~1s per test)
./tests/run_tests.sh --csg-only

# Full run: CSG check → STL export → PNG renders (iso+top views)
./tests/run_tests.sh

# Single test
./tests/run_tests.sh test_backward_compat

# Specific views
./tests/run_tests.sh --views iso,top,front

# Targeted eval of any .scad file (edit-render-evaluate loop)
./tests/render_eval.sh tests/scad/test_multi_tray.scad
./tests/render_eval.sh tests/scad/test_multi_tray.scad --cross-section z,3

# Inline eval (no file needed)
./tests/render_eval.sh --inline 'include <counter_tray_designer_lib.1.scad>;
  DATA=[[G_DIMENSIONS_XY,[50,50]],[G_FRAME_STYLE_N,4],
  [COUNTER_SET,[COUNTER_SIZE_XYZ,[15,15,5]]]]; Make(DATA);'
```

Pipeline: `.scad` → CSG check → STL export → PNG renders (ortho + edges via `xvfb-run`). Renders and STL outputs go to `tests/renders/` and `tests/stl/` (gitignored).

**Test files:**
- `test_backward_compat` — single-tray preset (no TRAY entries), verifies legacy format still works
- `test_multi_tray` — two trays with shared defaults, verifies TRAY hierarchy and auto-grid
- `test_multi_tray_override` — per-tray global overrides (different frame styles per tray)
- `test_multi_tray_grid` — 4 trays with `G_GRID_COLUMNS_N=2`, verifies 2x2 grid layout

**When to add tests:** Add a `test_*.scad` file for any new feature or data model change. Keep tests small (small tray dimensions, few counters) so STL export stays fast.

## Architecture

**File structure:**

- `counter_tray_designer_lib.1.scad` — The engine. Contains the `Make(DATA)` module and all geometry generation (tray base, counter walls/holes, magnet nubs/slots, lid, notches). Do not rename — external projects (BGSD) depend on this filename.
- `tray-library.scad` — Shared constants (tray sizes, counter sizes) and game presets. Includes the lib. Has an active `Make()` call at the bottom.
- `library/<publisher>.scad` — Per-publisher preset files. Each includes `../tray-library.scad` (which transitively includes the lib + shared constants), defines presets for that publisher's games, and has a `Make()` call at the bottom.

**Publisher files:** `avalon_hill`, `blue_panther`, `columbia_games`, `conflict_games`, `decision_games`, `gmt`, `hollandspiele`, `ingenioso_hidalgo`, `legion_wargames`, `mmp`, `victory_games`, `west_end_games`.

**Data model:** A `DATA_ARRAY` is a flat list of `[KEY, VALUE]` pairs. It supports two formats:

- **Single tray (legacy):** Global settings come first, followed by one or more `[COUNTER_SET, [...]]` blocks. No `TRAY` entries.
- **Multi-tray:** Top-level globals (shared defaults) come first, followed by one or more `[TRAY, ...]` entries. Each TRAY entry contains tray-local globals and COUNTER_SET blocks. Tray-local settings override shared defaults. `Make()` auto-arranges trays in a grid.

The engine uses key-based lookup (`find_value`), not positional indexing. Per-tray global resolution: tray-local entries are searched first, then top-level shared defaults.

- **Global keys:** `G_DIMENSIONS_XY`, `G_FLOOR_THICKNESS_N`, `G_MIN_PADDING_XY`, `G_LID_DEPTH_N`, `G_FRAME_STYLE_N` (1-4), `G_MAGNET_DIAMETER_N`
- **Lid keys:** `LID` (peer block to TRAY — place `[LID]` after a TRAY to give it a lid; if any LID blocks exist, trays without a following LID block get no lid)
- **Multi-tray keys:** `TRAY` (grouping marker), `PRINT_COUNT_N` (default = 1, number of copies of this tray to generate in the grid), `G_GRID_COLUMNS_N` (default = 2), `G_GRID_SPACING_N` (default = 5mm)
- **Per-set keys:** `COUNTER_SIZE_XYZ` (required), `ROWS_N` (auto-computed if omitted, but required for all sets except the last), `COUNTER_SHAPE`, `COUNTER_MARGINS_XY`, `COUNTER_HOLE_FRACTION_N`, `COUNTER_PEDESTAL_B`, `ENABLED_B`

**Frame styles:** Style 1 = border padding with corner magnets. Style 2 = side magnet nubs. Style 3 = side nubs, recentered. Style 4 = no magnets.

## Key Conventions

- All dimensions are in millimeters.
- `$fn` = 20 in preview, 50 for final render.
- Magnets auto-double when tray depth > `2 * magnet_depth + 0.2`.
- All sets except the last must specify `ROWS_N`.
- The active tray is whichever `Make()` call is uncommented at the bottom of the file. For publisher-specific work, open the file in `library/`.
- New game presets go in the appropriate `library/<publisher>.scad` file. Shared constants stay in `tray-library.scad`.
- Verify spacing via OpenSCAD `echo` output (counter counts, ideal tray size) before doing a full render.
- When modifying magnet logic or frame styles, ensure both tray and lid code paths stay consistent (`create_notches`, `create_magnet_slots`, nub mirroring).
