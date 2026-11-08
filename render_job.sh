#!/bin/sh
# render_job.sh IN OUT: render every .blend in IN to OUT/*.png on the GPU, log to OUT/render.log,
# then write Blender's exit code to OUT/done (poll for that file; do not pgrep).
IN="$1"; OUT="$2"; mkdir -p "$OUT"; rm -f "$OUT/done"
blender -b --factory-startup -P /opt/render_all.py -- "$IN" "$OUT" > "$OUT/render.log" 2>&1
echo $? > "$OUT/done"
