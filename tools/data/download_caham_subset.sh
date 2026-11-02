#!/bin/zsh
DEST="${CAHAM_DATA:-$(cd "$(dirname "$0")/../.." && pwd)/../caham_data}"
TMP="${1:-/tmp/caham_dl}"; LOG="${2:-$TMP/download.log}"; mkdir -p "$TMP"; RL="khxpbspkbo1z4kgff6uv82cqu"; BASE="https://www.dropbox.com/scl/fo/q48qxa4lkc6fmwn52j0cl"
[ -L "$DEST" ] && rm "$DEST"; mkdir -p "$DEST"
echo "$(date +%H:%M:%S) start" > "$LOG"
get(){ local rel="$1" tok="$2"; local z="$TMP/$(echo $rel | tr '/' '_').zip"; local t0=$(date +%s)
  mkdir -p "$DEST/$rel"
  code=$(curl -sL --retry 3 --max-time 1800 -A "Mozilla/5.0" -o "$z" -w "%{http_code}" "$BASE/$tok/$rel?rlkey=$RL&dl=1")
  if [ "$code" = "200" ] && unzip -qo "$z" -d "$DEST/$rel" 2>>"$LOG"; then
    echo "$(date +%H:%M:%S) ok   $(du -sh "$DEST/$rel" | cut -f1)  $(( $(date +%s)-t0 ))s  $rel" >> "$LOG"; rm -f "$z"
  else echo "$(date +%H:%M:%S) FAIL http=$code $rel" >> "$LOG"; fi
}
get AmuDarya/gunt_data AJLBNOuaWvTKCLoKn2LxPvU
get AmuDarya/17050_Gunt/GIS ACsT2WCpLnOInIY1CG51pK4
get AmuDarya/17050_Gunt/GaugeData AE2Ph-qTKfQ9sinAH-p8cdg
get central_asia_domain/glaciers/RGIv60 AKQT52QjWmWmhaVphRO5lY0
get central_asia_domain/glaciers/Farinotti ALZLacLn362yCs5imlXXm-o
get central_asia_domain/glaciers/Miles AF-_JcL6MaBv5TAt9PMbmCk
get central_asia_domain/glaciers/Hugonnet AGbwUkMaIjat0XIB6yrysjY
get student_case_study_basins/15149_ChonKemin/GIS AFyOj-QRcFgl_xkEn9mgU_4
get student_case_study_basins/15149_ChonKemin/GaugeData AGMyioHQEnT61KLoSHI-b0M
get student_case_study_basins/15149_ChonKemin/RS_MINERVE AKQbceXZmTHtxH__dbe3vxg
get SyrDarya/Atbashy/GIS ACiNDjZOwgMhVuQJMinFRZo
get SyrDarya/Atbashy/PERMAFROST AK9ULqYUwntPwr2Hw1FoO1Q
get SyrDarya/Atbashy/RSMINERVE ABpz7C334rFQAMrRUEYPhek
get SyrDarya/Atbashy/GLACIERS AHmsmEoCaJmglNUk9r32HRQ
get SyrDarya/Atbashy/SNOW AKCfokISp2J1NzdMLTRULyk
get central_asia_domain/climate/chelsa_v21 AFHzadWsAflegajdm-Mk4q0
get climate/HIST_SIM AIZlalWGcDCIcqJWqL79L_U
get climate/CHELSA ALvipX2QHS4mriGj18vGLHY
echo "$(date +%H:%M:%S) ALL DONE total $(du -sh "$DEST" | cut -f1)" >> "$LOG"
