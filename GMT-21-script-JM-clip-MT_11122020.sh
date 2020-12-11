#!/bin/bash
# Purpose: Clipping of raster image using coastlines, here: Mariana Trench
# GMT modules: gmtset, gmtdefaults, grd2cpt, grdimage, pscoast, makecpt, grdcontour, psbasemap, psscale, logo, psconvert
# Unix progs: rm

# GMT set up
gmt set FORMAT_GEO_MAP=dddF \
    MAP_FRAME_PEN dimgray \
    MAP_FRAME_WIDTH 0.1c \
    MAP_TITLE_OFFSET 1.5c \
    MAP_ANNOT_OFFSET 0.1c \
    MAP_TICK_PEN_PRIMARY thinnest,dimgray \
    MAP_GRID_PEN_PRIMARY thin,dimgray \
    MAP_GRID_PEN_SECONDARY thinnest,dimgray \
    FONT_TITLE 12p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY 7p,Palatino-Roman,dimgray \
    FONT_LABEL 7p,Palatino-Roman,dimgray \

# Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults

# gmt makecpt --help
#grdcut geoid.egm96.grd -R90/130/-20/10 -Ggeoid_ST96.grd
gmt grdconvert n00e90/w001001.adf geoid_PSB1.grd
gdalinfo geoid_PSB1.grd -stats
# Minimum=-66.313, Maximum=76.565
gmt grdconvert n00e135/w001001.adf geoid_PSB2.grd
gdalinfo geoid_PSB2.grd -stats
# Minimum=-15.333, Maximum=72.740

# Generate a color palette table from grid
# gmt makecpt --help
gmt makecpt -Cwysiwyg -T-67/76/1 > colors.cpt
gmt makecpt -Cwysiwyg -T-16/73/1 > colors1.cpt
# haxby

# Generate a file
ps=GMT_clip_MT.ps

gmt grdimage geoid_PSB1.grd -Ccolors1.cpt -R120/160/5/30 -JM16c -P -I+a15+ne0.75 -Xc -K > $ps
gmt grdimage geoid_PSB2.grd -Ccolors1.cpt -R120/160/5/30 -JM16c -P -I+a15+ne0.75 -Xc -O -K >> $ps

# Use gmt pscoast to initiate clip path for land
gmt pscoast -R120/160/5/30 -J -Dh -Gc -O -K >> $ps

# Generate topography image w/shading
gmt makecpt -C150 -T-11000,2000 -N > shadeMT.cpt
gmt grdimage geoid.egm96.grd -I+a45+nt1 -R -J -CshadeMT.cpt -O -K >> $ps

# Undo clipping and overlay basemap
gmt pscoast -R -J -O -K -Q \
    --MAP_TITLE_OFFSET=0.8c \
    -B+t"Color geoid image of the Mariana Trench region based on the EGM-2008" >> $ps

# Add shorelines
gmt grdcontour geoid_PSB1.grd -R -J -C2 -A2+f6p,Helvetica,black -Wthinnest,dimgray -O -K >> $ps
gmt grdcontour geoid_PSB2.grd -R -J -C2 -A2+f6p,Helvetica,black -Wthinnest,dimgray -O -K >> $ps

# Add grid
gmt psbasemap -R -J \
    -Bpxg8f2a4 -Bpyg6f3a3 -Bsxg4 -Bsyg3 -O -K >> $ps

# Color legend on top of the land mask
gmt psscale -Dg120.0/1.1+w15.0c/0.4c+h+o0.3/0i+ml -R -J -Ccolors.cpt \
    --FONT_LABEL=7p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,black \
    --MAP_ANNOT_OFFSET=0.1c \
    -Ba10g10f1+l"Color scale 'wysiwyg': 20 well-separated RGB colors [C=RGB]" \
    -By+lm -I -O -K >> $ps
    
# Add scale, directional rose
gmt psbasemap -R -J \
    --FONT=8p,Palatino-Roman,dimgray \
    --MAP_TITLE_OFFSET=0.1c \
    -Tdx1.0c/10.0c+w0.3i+f2+l+o0.0c \
    -Lx14.0c/-2.6c+c50+w750k+l"Mercator projection. Scale (km)"+f \
    -UBL/-15p/-70p -O -K >> $ps

# Add GMT logo
gmt logo -Dx6.2/-3.4+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y4.6c -N -O \
    -F+f10p,Helvetica,black+jLB >> $ps << EOF
3.5 10.0 Gray-shaded topography of the clipped land areas
EOF

# Convert to image file using GhostScript
gmt psconvert GMT_clip_MT.ps -A0.8c -E720 -Tj -P -Z
