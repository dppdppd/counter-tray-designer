#!/bin/bash
#
# Counter Tray Designer Render Evaluation Tool
# Renders a .scad file (or inline data) to STL and produces targeted PNG views.
# Designed for the agent's edit-render-evaluate loop.
#
# Usage:
#   ./render_eval.sh <file.scad> [options]
#   ./render_eval.sh --inline '<openscad code>' [options]
#
# Options:
#   --views LIST            Views to render (default: iso,top)
#                           Available: top,bottom,front,back,left,right,iso
#   --camera RX,RY,RZ      Add a custom camera angle
#   --cross-section AXIS,POS  Cut the model (e.g., z,10 cuts at z=10)
#   --imgsize WxH           Image size (default: 800,600)
#   --wireframe             Also render wireframe views
#   --outdir DIR            Output directory (default: tests/renders)
#   --name NAME             Base name for output files
#   --timeout N             STL timeout in seconds (default: 900)
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
RENDER_SCAD="/tmp/ctd_eval_render.scad"

IMGSIZE="800,600"
STL_TIMEOUT=900
VIEW_TIMEOUT=30
VIEWS="iso,top"
CUSTOM_CAMERA=""
CROSS_SECTION=""
WIREFRAME=false
OUTDIR="$SCRIPT_DIR/renders"
NAME=""
INLINE=""
INPUT_FILE=""

usage() {
    cat <<'EOF'
Counter Tray Designer Render Evaluation Tool

Usage:
  ./render_eval.sh <file.scad> [options]
  ./render_eval.sh --inline '<openscad code>' [options]

Options:
  --views LIST            Views to render (default: iso,top)
                          Available: top,bottom,front,back,left,right,iso
  --camera RX,RY,RZ      Add a custom camera angle
  --cross-section AXIS,POS  Cross-section cut (e.g., z,10 cuts at z=10)
  --imgsize WxH           Image size (default: 800,600)
  --wireframe             Also render wireframe views
  --outdir DIR            Output directory
  --name NAME             Base name for files
  --timeout N             STL timeout in seconds (default: 900)

Cross-Section Examples:
  --cross-section z,5     Horizontal cut at z=5 (shows counter holes)
  --cross-section x,25    Vertical cut at x=25 (shows wall thickness)
  --cross-section y,0     Vertical cut at y=0 (shows center cross-section)

Typical Evaluation Workflows:
  # Quick check after editing lib -- iso + top of a test preset
  ./render_eval.sh scad/test_backward_compat.scad

  # Check counter hole depth -- front view + cross-section
  ./render_eval.sh scad/test_multi_tray.scad --views front,iso --cross-section z,3

  # Quick inline test
  ./render_eval.sh --inline 'include <counter_tray_designer_lib.1.scad>;
    DATA=[
      [G_DIMENSIONS_XY,[50,50]],[G_FRAME_STYLE_N,4],
      [COUNTER_SET,[COUNTER_SIZE_XYZ,[15,15,5]]]
    ];
    Make(DATA);'
EOF
    exit 0
}

while [[ $# -gt 0 ]]; do
    case $1 in
        --views)          VIEWS="$2"; shift 2 ;;
        --camera)         CUSTOM_CAMERA="$2"; shift 2 ;;
        --cross-section)  CROSS_SECTION="$2"; shift 2 ;;
        --imgsize)        IMGSIZE="$2"; shift 2 ;;
        --wireframe)      WIREFRAME=true; shift ;;
        --outdir)         OUTDIR="$2"; shift 2 ;;
        --name)           NAME="$2"; shift 2 ;;
        --timeout)        STL_TIMEOUT="$2"; shift 2 ;;
        --inline)         INLINE="$2"; shift 2 ;;
        --help)           usage ;;
        *)                INPUT_FILE="$1"; shift ;;
    esac
done

# Resolve input
if [[ -n "$INLINE" ]]; then
    INPUT_FILE=$(mktemp /tmp/ctd_inline_XXXXXX.scad)
    echo "$INLINE" > "$INPUT_FILE"
    [[ -z "$NAME" ]] && NAME="inline"
    CLEANUP_INPUT=true
elif [[ -z "$INPUT_FILE" ]]; then
    echo "Error: provide a .scad file or --inline code"
    exit 1
else
    CLEANUP_INPUT=false
    [[ -z "$NAME" ]] && NAME="$(basename "$INPUT_FILE" .scad)"
fi

mkdir -p "$OUTDIR"

# Camera angle map
declare -A CAMERAS=(
    [top]="0,0,0"
    [bottom]="180,0,0"
    [front]="90,0,0"
    [back]="90,0,180"
    [left]="90,0,90"
    [right]="90,0,270"
    [iso]="55,0,25"
)

echo "=== CTD Render Eval: $NAME ==="

# Phase 1: CSG compile check
echo -n "  Compile check... "
csg_err=$(timeout 60 openscad -o /dev/null "$INPUT_FILE" 2>&1) || true
if echo "$csg_err" | grep -qi "ERROR"; then
    echo "FAILED"
    echo "$csg_err" | grep -i "ERROR" | head -5
    $CLEANUP_INPUT && rm -f "$INPUT_FILE"
    exit 1
fi
warns=$(echo "$csg_err" | grep -ci "WARNING" || true)
echo "OK ($warns warnings)"

# Phase 2: STL export
STL_FILE=$(mktemp /tmp/ctd_eval_XXXXXX.stl)
echo -n "  STL export... "
stl_exit=0
timeout "$STL_TIMEOUT" openscad -o "$STL_FILE" "$INPUT_FILE" 2>/dev/null || stl_exit=$?
if [[ $stl_exit -eq 124 ]]; then
    echo "TIMEOUT (${STL_TIMEOUT}s)"
    rm -f "$STL_FILE"
    $CLEANUP_INPUT && rm -f "$INPUT_FILE"
    exit 1
fi
if [[ ! -s "$STL_FILE" ]]; then
    echo "EMPTY (no geometry)"
    rm -f "$STL_FILE"
    $CLEANUP_INPUT && rm -f "$INPUT_FILE"
    exit 1
fi
stl_size=$(stat -c%s "$STL_FILE")
echo "OK ($(( stl_size / 1024 ))KB)"

# Phase 3: Render views
echo 'import(stl_file);' > "$RENDER_SCAD"

render_view() {
    local vname="$1" rx="$2" ry="$3" rz="$4" extra_view="${5:-edges}"
    local outfile="$OUTDIR/${NAME}_${vname}.png"
    timeout "$VIEW_TIMEOUT" xvfb-run -a openscad --render -o "$outfile" \
        --imgsize="$IMGSIZE" --autocenter --viewall \
        --projection=ortho --view="$extra_view" \
        --camera=0,0,0,$rx,$ry,$rz,0 \
        -D "stl_file=\"$STL_FILE\"" \
        "$RENDER_SCAD" >/dev/null 2>&1
    if [[ -s "$outfile" ]]; then
        echo "  $vname -> $outfile"
    else
        echo "  $vname -> FAILED"
    fi
}

IFS=',' read -ra VIEW_LIST <<< "$VIEWS"
for v in "${VIEW_LIST[@]}"; do
    if [[ -n "${CAMERAS[$v]+x}" ]]; then
        IFS=',' read -r rx ry rz <<< "${CAMERAS[$v]}"
        render_view "$v" "$rx" "$ry" "$rz"
        if $WIREFRAME; then
            render_view "${v}_wire" "$rx" "$ry" "$rz" "wireframe"
        fi
    else
        echo "  Unknown view: $v (skipping)"
    fi
done

# Custom camera
if [[ -n "$CUSTOM_CAMERA" ]]; then
    IFS=',' read -r rx ry rz <<< "$CUSTOM_CAMERA"
    render_view "custom" "$rx" "$ry" "$rz"
fi

# Phase 4: Cross-section render
if [[ -n "$CROSS_SECTION" ]]; then
    IFS=',' read -r cs_axis cs_pos <<< "$CROSS_SECTION"
    CS_SCAD=$(mktemp /tmp/ctd_cs_XXXXXX.scad)

    case "$cs_axis" in
        x)
            cat > "$CS_SCAD" <<SCADEOF
difference() {
    import(stl_file);
    translate([$cs_pos, -500, -500]) cube([1000, 1000, 1000]);
}
SCADEOF
            cs_view_camera="90,0,270"
            ;;
        y)
            cat > "$CS_SCAD" <<SCADEOF
difference() {
    import(stl_file);
    translate([-500, $cs_pos, -500]) cube([1000, 1000, 1000]);
}
SCADEOF
            cs_view_camera="90,0,0"
            ;;
        z)
            cat > "$CS_SCAD" <<SCADEOF
difference() {
    import(stl_file);
    translate([-500, -500, $cs_pos]) cube([1000, 1000, 1000]);
}
SCADEOF
            cs_view_camera="0,0,0"
            ;;
        *)
            echo "  Unknown cross-section axis: $cs_axis"
            rm -f "$CS_SCAD"
            cs_axis=""
            ;;
    esac

    if [[ -n "$cs_axis" ]]; then
        CS_STL=$(mktemp /tmp/ctd_cs_XXXXXX.stl)
        echo -n "  Cross-section ($cs_axis=$cs_pos)... "
        timeout "$STL_TIMEOUT" openscad -o "$CS_STL" \
            -D "stl_file=\"$STL_FILE\"" \
            "$CS_SCAD" >/dev/null 2>&1

        if [[ -s "$CS_STL" ]]; then
            echo "OK"
            IFS=',' read -r rx ry rz <<< "$cs_view_camera"
            outfile="$OUTDIR/${NAME}_cross_${cs_axis}${cs_pos}.png"
            timeout "$VIEW_TIMEOUT" xvfb-run -a openscad --render -o "$outfile" \
                --imgsize="$IMGSIZE" --autocenter --viewall \
                --projection=ortho --view=edges \
                --camera=0,0,0,$rx,$ry,$rz,0 \
                -D "stl_file=\"$CS_STL\"" \
                "$RENDER_SCAD" >/dev/null 2>&1
            if [[ -s "$outfile" ]]; then
                echo "  cross_${cs_axis}${cs_pos} -> $outfile"
            else
                echo "  cross_${cs_axis}${cs_pos} -> FAILED"
            fi

            outfile="$OUTDIR/${NAME}_cross_${cs_axis}${cs_pos}_iso.png"
            timeout "$VIEW_TIMEOUT" xvfb-run -a openscad --render -o "$outfile" \
                --imgsize="$IMGSIZE" --autocenter --viewall \
                --projection=ortho --view=edges \
                --camera=0,0,0,55,0,25,0 \
                -D "stl_file=\"$CS_STL\"" \
                "$RENDER_SCAD" >/dev/null 2>&1
            if [[ -s "$outfile" ]]; then
                echo "  cross_${cs_axis}${cs_pos}_iso -> $outfile"
            fi
        else
            echo "FAILED"
        fi
        rm -f "$CS_STL" "$CS_SCAD"
    fi
fi

# Cleanup
rm -f "$STL_FILE" "$RENDER_SCAD"
$CLEANUP_INPUT && rm -f "$INPUT_FILE"

echo "=== Done ==="
