#!/usr/bin/env bash
set -e
cd "$(dirname "$0")/.."

SUSC_SRC="processing_the_layers/step_2/Susceptibility_Map_map.img"
DTM_SRC="processing_the_layers/step_1/dtm.tif"
OUT_TILES="data/tiles"
OUT_HILL="data/hillshade"
OUT_COG="data/susceptibility_cog.tif"
OUT_DTM_COG="data/dtm_cog.tif"

mkdir -p "$OUT_TILES" "$OUT_HILL" data

echo "▶ 1/6  Reprojecting susceptibility to EPSG:3857 ..."
gdalwarp -t_srs EPSG:3857 -r bilinear -of GTiff -overwrite \
  "$SUSC_SRC" /tmp/_susc_3857.tif

echo "▶ 2/6  Classifying into 4 classes ..."
gdal_calc.py -A /tmp/_susc_3857.tif --outfile=/tmp/_susc_class.tif \
  --calc="where(A<0.25,1,where(A<0.5,2,where(A<0.75,3,4)))" \
  --type=Byte --NoDataValue=0 --overwrite

echo "▶ 3/6  Applying colour table (green→yellow→orange→red) ..."
cat > /tmp/_ct.txt << CT
1 22 163 74 220
2 234 179 8 220
3 249 115 22 220
4 220 38 38 220
nv 0 0 0 0
CT
gdaldem color-relief /tmp/_susc_class.tif /tmp/_ct.txt /tmp/_susc_rgb.tif -alpha -of GTiff

echo "▶ 4/6  Generating XYZ tiles (zoom 8–17) ..."
rm -rf "$OUT_TILES"/*
gdal2tiles.py --xyz --zoom=8-17 --webviewer=none -r near \
  /tmp/_susc_rgb.tif "$OUT_TILES"

echo "▶ 5/6  Hillshade from DTM ..."
gdalwarp -t_srs EPSG:3857 -r bilinear -of GTiff -overwrite "$DTM_SRC" /tmp/_dtm_3857.tif
gdaldem hillshade /tmp/_dtm_3857.tif /tmp/_hs.tif -compute_edges -z 2 -az 315 -alt 45
rm -rf "$OUT_HILL"/*
gdal2tiles.py --xyz --zoom=8-17 --webviewer=none /tmp/_hs.tif "$OUT_HILL"

echo "▶ 6/6  Creating COGs for click-identify ..."
if command -v rio >/dev/null 2>&1; then
  rio cogeo create "$SUSC_SRC" "$OUT_COG" --resampling bilinear || cp "$SUSC_SRC" "$OUT_COG"
  rio cogeo create "$DTM_SRC"  "$OUT_DTM_COG" --resampling bilinear || cp "$DTM_SRC" "$OUT_DTM_COG"
else
  cp "$SUSC_SRC" "$OUT_COG"
  cp "$DTM_SRC"  "$OUT_DTM_COG"
fi

echo "✅ Done."
du -sh data/tiles data/hillshade data/*.tif
