#!/bin/bash
#
# Render all library game files to PNG (preview mode)
# Outputs to tests/renders/library/<publisher>/<game>_<view>.png
#
# Usage:
#   ./tests/render_library.sh              # Render all games (iso+top views)
#   ./tests/render_library.sh --csg-only   # Compile check only
#   ./tests/render_library.sh gmt/1862     # Render a specific game
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
LIBRARY_DIR="$PROJECT_DIR/release"
RENDER_DIR="$SCRIPT_DIR/renders/library"
IMGSIZE="800,600"
RENDER_TIMEOUT=120

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

ALL_VIEWS="top,0,0,0 iso,55,0,25"
CSG_ONLY=false
TARGETS=()

while [[ $# -gt 0 ]]; do
    case $1 in
        --csg-only) CSG_ONLY=true; shift ;;
        *) TARGETS+=("$1"); shift ;;
    esac
done

# Build file list
FILES=()
if [[ ${#TARGETS[@]} -eq 0 ]]; then
    while IFS= read -r f; do
        FILES+=("$f")
    done < <(find "$LIBRARY_DIR" -mindepth 2 -name '*.scad' ! -name '*_constants.scad' ! -path '*/lib/*' | sort)
else
    for t in "${TARGETS[@]}"; do
        f="$LIBRARY_DIR/${t}.scad"
        if [[ -f "$f" ]]; then
            FILES+=("$f")
        else
            echo -e "${RED}SKIP${NC} $t -- not found: $f"
        fi
    done
fi

TOTAL=${#FILES[@]}
PASS=0
FAIL=0
TOTAL_START=$(date +%s)

echo -e "${CYAN}Rendering $TOTAL game(s)...${NC}"
echo ""

for f in "${FILES[@]}"; do
    rel="${f#$LIBRARY_DIR/}"
    publisher="$(dirname "$rel")"
    game="$(basename "$rel" .scad)"
    label="$publisher/$game"

    TEST_START=$(date +%s)

    # Phase 1: CSG check
    csg_out=$(mktemp /tmp/ctd_csg_XXXXXX.csg)
    csg_err=$(timeout 60 openscad -o "$csg_out" "$f" 2>&1) || true

    has_error=false
    if echo "$csg_err" | grep -qi "ERROR"; then
        has_error=true
    fi
    rm -f "$csg_out"

    if $has_error; then
        echo -e "${RED}FAIL${NC} $label -- compile error"
        echo "$csg_err" | head -3 | sed 's/^/  /'
        FAIL=$((FAIL + 1))
        continue
    fi

    if $CSG_ONLY; then
        TEST_END=$(date +%s)
        echo -e "${GREEN}PASS${NC} $label ($((TEST_END - TEST_START))s)"
        PASS=$((PASS + 1))
        continue
    fi

    # Phase 2: Direct .scad → PNG render (preview mode)
    mkdir -p "$RENDER_DIR/$publisher"

    view_fail=false
    for v in $ALL_VIEWS; do
        IFS=',' read -r vname rx ry rz <<< "$v"
        png_out="$RENDER_DIR/$publisher/${game}_${vname}.png"

        timeout "$RENDER_TIMEOUT" xvfb-run -a openscad -o "$png_out" \
            --csglimit=500000 \
            --imgsize="$IMGSIZE" --autocenter --viewall \
            --projection=ortho --view=edges \
            --camera=0,0,0,$rx,$ry,$rz,0 \
            "$f" >/dev/null 2>&1

        if [[ ! -s "$png_out" ]]; then
            echo -e "${RED}FAIL${NC} $label -- ${vname} view failed"
            view_fail=true
            break
        fi
    done

    if $view_fail; then
        FAIL=$((FAIL + 1))
        continue
    fi

    TEST_END=$(date +%s)
    echo -e "${GREEN}PASS${NC} $label ($((TEST_END - TEST_START))s)"
    PASS=$((PASS + 1))
done

TOTAL_END=$(date +%s)
TOTAL_ELAPSED=$((TOTAL_END - TOTAL_START))

echo ""
echo -e "${CYAN}Results: $PASS passed, $FAIL failed (of $TOTAL total) in ${TOTAL_ELAPSED}s${NC}"
if ! $CSG_ONLY; then
    echo -e "${CYAN}Renders: $RENDER_DIR/${NC}"
fi

[[ $FAIL -gt 0 ]] && exit 1 || exit 0
