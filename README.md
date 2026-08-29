# Counter Tray Designer

Parametric OpenSCAD library for designing 3D-printable board game counter trays with optional lids and magnet slots.

## Need help?

Start a guided conversation with an AI assistant:

- [Help me get started with Counter Tray Designer](https://chatgpt.com/?q=I%20want%20to%20get%20started%20with%20Counter%20Tray%20Designer%20(CTD)%2C%20an%20OpenSCAD%20library%20for%20designing%203D-printable%20board%20game%20counter%20trays%20(https%3A%2F%2Fgithub.com%2Fdppdppd%2Fcounter-tray-designer).%20There%20is%20also%20a%20visual%20editor%20called%20BGSD%20(https%3A%2F%2Fgithub.com%2Fdppdppd%2FBGSD).%20Walk%20me%20through%20the%20setup%20and%20creating%20my%20first%20counter%20tray.)
- [I want to report a bug](https://chatgpt.com/?q=I%20want%20to%20report%20a%20bug%20in%20Counter%20Tray%20Designer%20(CTD)%2C%20an%20OpenSCAD%20library%20for%20designing%203D-printable%20board%20game%20counter%20trays%20(https%3A%2F%2Fgithub.com%2Fdppdppd%2Fcounter-tray-designer).%20I%20have%20no%20GitHub%20experience.%20Walk%20me%20through%20how%20to%20file%20a%20bug%20report%20as%20a%20GitHub%20issue.)
- [I want to submit a design file](https://chatgpt.com/?q=I%20want%20to%20submit%20a%20new%20design%20as%20a%20pull%20request%20to%20the%20Counter%20Tray%20Designer%20(CTD)%20github%20project%20(https%3A%2F%2Fgithub.com%2Fdppdppd%2Fcounter-tray-designer).%20This%20is%20one%20of%20two%20OpenSCAD%20libraries%20used%20by%20the%20BGSD%20editor%20%E2%80%94%20the%20other%20is%20Board%20Game%20Insert%20Toolkit%20(BIT)%20at%20https%3A%2F%2Fgithub.com%2Fdppdppd%2FThe-Boardgame-Insert-Toolkit.%20I%20have%20no%20github%20experience.%20Walk%20me%20through%20the%20process%20step%20by%20step.)

## Visual Editor

**[BGSD -- Board Game Storage Designer](https://github.com/dppdppd/BGSD)** is a desktop app for visually editing Counter Tray Designer `.scad` files -- no OpenSCAD coding required.

Download portable binaries from the [BGSD Releases](https://github.com/dppdppd/BGSD/releases) page.

## Getting Started (Text Editor)

1. Download [OpenSCAD](https://www.openscad.org)
2. Clone or download this repository
3. Copy an existing design from a publisher folder in `release/` (e.g. `release/gmt/1862.scad`) as a starting point
4. Open your copy in a text editor and in OpenSCAD
5. In OpenSCAD, enable **Design > Automatic Reload and Preview**
6. Edit, save, and iterate

### Preview metadata and print quantities

OpenSCAD preview shows metadata 5 mm beyond the positive-Y edge of every tray and lid panel: an optional centered tray-name header followed by `Print: N`, `Counters: N @ A x B mm`, and `Tray: C x D x E mm`. Set `[NAME, "Player Aid Counters"]` inside a `TRAY` block to identify that tray; the header displays `Player Aid Counters` without a field prefix. Its lid does not inherit the tray label; a lid shows a header only when its own block supplies `NAME`. Unnamed legacy trays keep the existing three-line block. A separate `Full Set: W x D x H mm` block appears once above the complete preview; its width and depth are the largest panel footprint, and its height is the complete stack of every requested tray copy plus its lids. Preview grid rows reserve room for the per-panel labels plus 20 mm of additional Y clearance between trays. The labels use Liberation Mono with padded field names so their colons and values align. For trays containing multiple counter sizes, the size pairs are separated by slashes on the Counters line. `PRINT_COUNT_N` records how many copies should be printed, but the model contains only one copy of each unique panel so repeated geometry does not clutter the preview or exported file. A lid has its own print quantity and label and otherwise inherits its dimensions and counter layout from the preceding tray.

## Repository structure

- Default branch: `master`
- Library engine: `release/lib/counter_tray_designer_lib.1.scad`
- Global constants: `release/lib/global_constants.scad`
- Publisher constants: `release/lib/<publisher>_constants.scad` (e.g. `gmt_constants.scad`)
- Design files are organized by publisher: `release/<publisher>/<game>.scad` (e.g. `release/gmt/1862.scad`)
- Each design file includes the library and its publisher constants:
  ```
  include <../lib/counter_tray_designer_lib.1.scad>
  include <../lib/gmt_constants.scad>
  ```
- Tests live in `tests/scad/test_*.scad`

### Current publishers

avalon_hill, blue_panther, columbia_games, compass_games, conflict_games, decision_games, gmt, hollandspiele, ingenioso_hidalgo, legion_wargames, mmp, victory_games, west_end_games

## Contributing

### Submitting a design

To contribute a design, fork this repo, add your `.scad` file to the appropriate publisher folder under `release/` (e.g. `release/gmt/my_game.scad`), and open a pull request against the `master` branch. If your publisher doesn't have a folder yet, create one and add a corresponding `release/lib/<publisher>_constants.scad` file (see existing ones for the pattern).

### Reporting bugs

Open an issue at https://github.com/dppdppd/counter-tray-designer/issues with a description of the problem and, if possible, the `.scad` file that reproduces it.
